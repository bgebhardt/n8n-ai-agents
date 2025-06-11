
# TODOs

- cloudflare - set up subdomain - n8n.bryan4schools.com
- reconfigure in ansible config
- remember you opened port on ionos firewall 
- fix inventory.yml to work
- split up deployment script more granularly
- create ansible commands for other things
- move secrets to more secure storage



https://n8n.bryan4schools.com/signup?inviterId=221a2cc8-04ef-4ef1-8588-fa6d3b26069a&inviteeId=23f26233-3806-412f-91dc-f83dedd1fa28

http://66.179.94.62:5678/signup?inviterId=221a2cc8-04ef-4ef1-8588-fa6d3b26069a&inviteeId=23f26233-3806-412f-91dc-f83dedd1fa28

http://66.179.94.62:5678/settings/users

# How to Use
1. Setup Ansible Environment
bash# Install Ansible
pip3 install ansible

# Create project directory
mkdir n8n-ansible && cd n8n-ansible

# Create directory structure
mkdir templates

# Save the playbook as deploy-n8n.yml
# Save the templates in the templates/ directory
# Create inventory.yml and ansible.cfg files
2. Configure Your Settings
Edit inventory.yml:
yamlall:
  hosts:
    ionos_vps:
      ansible_host: YOUR_ACTUAL_SERVER_IP  # Replace with your VPS IP
      ansible_user: root
  vars:
    domain_name: "yourdomain.com"  # Replace with your domain
    use_gpu: false                 # Set to true if you have NVIDIA GPU
    expose_qdrant: false          # Set to true to expose Qdrant externally
    expose_ollama: false          # Set to true to expose Ollama externally
3. Run the Playbook
bash# Install required collections
ansible-galaxy install -r requirements.yml

# Test connection
ansible all -m ping

# Deploy n8n (this will take 15-30 minutes)
ansible-playbook deploy-n8n.yml

# Or deploy with specific variables
ansible-playbook deploy-n8n.yml -e "domain_name=yourdomain.com use_gpu=true"
Key Features
Automated Setup:

System updates and Docker installation
User creation and security configuration
Firewall setup with UFW
SSL certificate generation with Let's Encrypt

AI Stack Deployment:

n8n with AI capabilities
Ollama for local LLMs
Qdrant vector database
PostgreSQL database

Production Ready:

Nginx reverse proxy with SSL
Automatic backups with cron
Log rotation
Security hardening

Flexible Configuration:

GPU support (NVIDIA)
Domain/SSL setup
Optional service exposure
Resource optimization

Variables You Can Customize
yaml# In your inventory.yml or as command line args
domain_name: "your-domain.com"     # Your domain for SSL
use_gpu: false                     # Enable GPU support
expose_qdrant: false              # Expose Qdrant API
expose_ollama: false              # Expose Ollama API
n8n_data_dir: "/opt/n8n-ai-starter" # Installation directory
After Deployment
The playbook will:

Install and configure everything
Start the AI stack
Download common AI models (llama3.2:3b, mistral:7b)
Set up daily backups
Configure SSL if you provided a domain

Access your n8n instance at:

With domain: https://yourdomain.com
Without domain: http://your-server-ip:5678

The automation handles all the manual steps and makes the deployment repeatable and reliable!