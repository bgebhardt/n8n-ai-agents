
# n8n AI Starter Kit Setup for IONOS VPS

## What You Get

The Self-hosted AI Starter Kit includes:
- **n8n** - Low-code automation platform with 400+ integrations
- **Ollama** - Local LLM platform (Llama, Mistral, etc.)
- **Qdrant** - Vector database for AI embeddings
- **PostgreSQL** - Database for n8n and data storage

## Prerequisites

### IONOS VPS Requirements
- **Minimum**: 8GB RAM, 4 CPU cores, 100GB storage
- **Recommended**: 16GB RAM, 6 CPU cores, 200GB storage
- **GPU**: Optional but recommended for faster AI inference

The AI starter kit is more resource-intensive than basic n8n due to local LLMs.

## Setup Instructions

### 1. Initial Server Setup
```bash
# SSH into your IONOS VPS
ssh root@your-server-ip

# Update system
apt update && apt upgrade -y

# Create user
adduser n8nuser
usermod -aG sudo n8nuser
su - n8nuser

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
sudo apt install docker-compose-plugin -y

# Logout and back in for group changes
exit
```

### 2. Clone and Setup the Starter Kit
```bash
# SSH back in as n8nuser
ssh n8nuser@your-server-ip

# Clone the repository
git clone https://github.com/n8n-io/self-hosted-ai-starter-kit.git
cd self-hosted-ai-starter-kit

# Check available profiles
ls -la
cat docker-compose.yml | grep -A 5 profiles
```

### 3. Choose Your Setup Profile

#### For CPU-only (Most IONOS VPS)
```bash
# Start with CPU profile
docker compose --profile cpu up -d

# Check status
docker compose ps
docker compose logs -f
```

#### For NVIDIA GPU (if your VPS has GPU)
```bash
# Install NVIDIA Docker runtime first
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt update && sudo apt install -y nvidia-docker2
sudo systemctl restart docker

# Start with GPU profile
docker compose --profile gpu-nvidia up -d
```

### 4. Configure for External Access

The starter kit defaults to localhost. For VPS access, you need to modify the configuration:

```bash
# Stop the services
docker compose down

# Create override file for external access
cat > docker-compose.override.yml << 'EOF'
version: '3.8'

services:
  n8n:
    ports:
      - "0.0.0.0:5678:5678"  # Allow external access
    environment:
      - N8N_HOST=0.0.0.0
      - WEBHOOK_URL=http://your-server-ip:5678/
      # Add these for production
      - N8N_PROTOCOL=http
      - NODE_ENV=production
      
  # Optional: Expose other services if needed
  qdrant:
    ports:
      - "6333:6333"  # Qdrant API
      - "6334:6334"  # Qdrant gRPC
      
  ollama:
    ports:
      - "11434:11434"  # Ollama API
EOF

# Replace your-server-ip with actual IP
sed -i 's/your-server-ip/YOUR_ACTUAL_SERVER_IP/g' docker-compose.override.yml
```

### 5. Start the Full Stack
```bash
# Start all services
docker compose --profile cpu up -d

# Monitor startup (especially Ollama downloading models)
docker compose logs -f ollama
docker compose logs -f n8n
```

## Firewall Configuration

```bash
# Configure UFW firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 5678/tcp   # n8n
sudo ufw allow 6333/tcp   # Qdrant (optional)
sudo ufw allow 11434/tcp  # Ollama (optional)

sudo ufw enable
sudo ufw status
```

## SSL Setup for Production

### Option 1: Nginx Reverse Proxy
```bash
# Create nginx directory
mkdir nginx-config

# Create nginx.conf
cat > nginx-config/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream n8n {
        server n8n:5678;
    }

    server {
        listen 80;
        server_name your-domain.com;
        
        location / {
            proxy_pass http://n8n;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF

# Add nginx to docker-compose.override.yml
cat >> docker-compose.override.yml << 'EOF'

  nginx:
    image: nginx:alpine
    container_name: n8n-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx-config/nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - n8n
EOF
```

## Access Your AI Stack

1. **n8n Interface**: `http://your-server-ip:5678`
2. **Qdrant Dashboard**: `http://your-server-ip:6333/dashboard`
3. **Ollama API**: `http://your-server-ip:11434`

## First Steps

### 1. Setup n8n
- Go to `http://your-server-ip:5678`
- Create your admin account
- Import the included AI workflow

### 2. Download AI Models
```bash
# Check Ollama status
docker compose exec ollama ollama list

# Pull common models (these will take time to download)
docker compose exec ollama ollama pull llama3.2:3b
docker compose exec ollama ollama pull mistral:7b
docker compose exec ollama ollama pull codellama:7b

# Check available models
docker compose exec ollama ollama list
```

### 3. Test the AI Workflow
- Navigate to the included workflow
- Click the "Chat" button
- Start chatting with the AI

## Resource Management

### Monitor Resource Usage
```bash
# Check Docker resource usage
docker stats

# Check system resources
htop
df -h
free -h

# Check individual container logs
docker compose logs n8n
docker compose logs ollama
docker compose logs qdrant
```

### Optimize for Your VPS
```bash
# Limit Ollama memory usage (add to docker-compose.override.yml)
cat >> docker-compose.override.yml << 'EOF'
  ollama:
    environment:
      - OLLAMA_MAX_LOADED_MODELS=1
      - OLLAMA_MAX_VRAM=4096M  # Adjust based on your RAM
EOF
```

## Maintenance Commands

```bash
# Update all images
docker compose pull
docker compose --profile cpu up -d

# Backup n8n data
docker compose exec n8n n8n export:workflow --backup --output=/home/node/.n8n/backups/

# Check disk usage
docker system df
docker system prune  # Clean up unused images/containers

# Restart specific service
docker compose restart n8n
docker compose restart ollama
```

## Troubleshooting

### Common Issues:

1. **Out of Memory**: 
   - Reduce number of loaded models in Ollama
   - Use smaller models (3B instead of 7B parameters)

2. **Slow AI Responses**:
   - CPU-only inference is slower than GPU
   - Consider using smaller models
   - Monitor with `docker stats`

3. **Models Not Loading**:
   ```bash
   # Check Ollama logs
   docker compose logs ollama
   
   # Manually pull models
   docker compose exec ollama ollama pull llama3.2:3b
   ```

4. **Can't Access Externally**:
   - Check firewall settings
   - Verify docker-compose.override.yml configuration
   - Check IONOS firewall in web console

## IONOS-Specific Considerations

- **Resource Monitoring**: Use IONOS dashboard to monitor CPU/RAM usage
- **Backup Strategy**: Consider IONOS backup service for the entire VPS
- **Scaling**: You can upgrade VPS resources if needed for larger models
- **Network**: IONOS provides good bandwidth for model downloads
- **Cost**: Monitor usage to avoid unexpected charges

## Security Notes

- The starter kit is designed for development/testing
- For production, add authentication and SSL
- Consider restricting access to AI API endpoints
- Regular security updates are important
- Monitor logs for unusual activity