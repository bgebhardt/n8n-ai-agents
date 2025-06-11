
# Ansible Root Login Setup for IONOS VPS

## Method 1: SSH Key Authentication (Recommended)

### Step 1: Generate SSH Key Pair (if you don't have one)
```bash
# On your local machine (where Ansible runs)
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"

# Accept default location (~/.ssh/id_rsa)
# Set a passphrase or leave empty for automation
```

### Step 2: Copy SSH Key to IONOS VPS
```bash
# Copy your public key to the VPS
ssh-copy-id root@YOUR_VPS_IP

# Or manually copy the key
cat ~/.ssh/id_rsa.pub | ssh root@YOUR_VPS_IP "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### Step 3: Test SSH Connection
```bash
# Test that you can login without password
ssh root@YOUR_VPS_IP

# You should login without being prompted for password
```

### Step 4: Configure Ansible Inventory
```yaml
# inventory.yml
all:
  hosts:
    ionos_vps:
      ansible_host: YOUR_VPS_IP
      ansible_user: root
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
```

### Step 5: Configure ansible.cfg
```ini
# ansible.cfg
[defaults]
host_key_checking = False
inventory = inventory.yml
remote_user = root
private_key_file = ~/.ssh/id_rsa

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no
```

## Method 2: Password Authentication (Less Secure)

### Step 1: Install sshpass
```bash
# Ubuntu/Debian
sudo apt install sshpass

# macOS
brew install hudochenkov/sshpass/sshpass

# CentOS/RHEL
sudo yum install sshpass
```

### Step 2: Configure Inventory with Password
```yaml
# inventory.yml
all:
  hosts:
    ionos_vps:
      ansible_host: YOUR_VPS_IP
      ansible_user: root
      ansible_ssh_pass: YOUR_ROOT_PASSWORD
```

### Step 3: Configure ansible.cfg
```ini
# ansible.cfg
[defaults]
host_key_checking = False
inventory = inventory.yml
remote_user = root

[ssh_connection]
ssh_args = -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no
```

## Method 3: Environment Variables (Secure for CI/CD)

### Step 1: Set Environment Variables
```bash
# Set variables in your shell
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_REMOTE_USER=root
export ANSIBLE_PRIVATE_KEY_FILE=~/.ssh/id_rsa

# For password auth (not recommended)
export ANSIBLE_SSH_PASS=your_password
```

### Step 2: Simple Inventory
```yaml
# inventory.yml
all:
  hosts:
    ionos_vps:
      ansible_host: YOUR_VPS_IP
```

## Method 4: Ansible Vault for Sensitive Data

### Step 1: Create Encrypted Password File
```bash
# Create vault file for sensitive data
ansible-vault create secrets.yml

# Add content:
---
ansible_ssh_pass: your_root_password
ansible_become_pass: your_sudo_password
```

### Step 2: Configure Inventory to Use Vault
```yaml
# inventory.yml
all:
  hosts:
    ionos_vps:
      ansible_host: YOUR_VPS_IP
      ansible_user: root
  vars_files:
    - secrets.yml
```

### Step 3: Run with Vault Password
```bash
# Run playbook with vault password
ansible-playbook deploy-n8n.yml --ask-vault-pass

# Or use password file
echo "vault_password" > .vault_pass
ansible-playbook deploy-n8n.yml --vault-password-file .vault_pass
```

## IONOS VPS Specific Setup

### Initial Access Methods

IONOS typically provides several ways to access your VPS:

#### Option A: Console/VNC Access
1. Login to IONOS Cloud Console
2. Go to your VPS instance
3. Use "Console" or "VNC" access
4. Login as root with provided password
5. Set up SSH key from there

#### Option B: SSH with Initial Password
```bash
# IONOS usually provides initial root password
# Check your email or IONOS dashboard for credentials
ssh root@YOUR_VPS_IP

# Enter the provided password
# Then set up SSH keys
```

### Setting Up SSH Keys via IONOS Console

```bash
# Once logged in via console or initial SSH
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Add your public key (copy from your local machine)
echo "ssh-rsa AAAAB3NzaC1yc2EAAAA... your-email@example.com" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Optional: Disable password authentication for security
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd
```

## Testing Your Ansible Connection

### Test Basic Connectivity
```bash
# Test ping module
ansible all -m ping

# Expected output:
# ionos_vps | SUCCESS => {
#     "ansible_facts": {
#         "discovered_interpreter_python": "/usr/bin/python3"
#     },
#     "changed": false,
#     "ping": "pong"
# }
```

### Test with Commands
```bash
# Run a simple command
ansible all -m shell -a "whoami"

# Check system info
ansible all -m setup -a "filter=ansible_distribution*"

# Test sudo access (if needed)
ansible all -m shell -a "id" --become
```

## Troubleshooting Common Issues

### Issue 1: Permission Denied (publickey)
```bash
# Solution: Ensure SSH key is properly configured
ssh-add ~/.ssh/id_rsa  # Add key to agent
ssh -v root@YOUR_VPS_IP  # Verbose output for debugging
```

### Issue 2: Host Key Verification Failed
```bash
# Solution: Remove old host key
ssh-keygen -R YOUR_VPS_IP

# Or disable host key checking (less secure)
export ANSIBLE_HOST_KEY_CHECKING=False
```

### Issue 3: Connection Timeout
```bash
# Check if SSH service is running on VPS
# Check IONOS firewall settings
# Verify VPS IP address is correct
```

### Issue 4: Root Login Not Allowed
```bash
# Check SSH configuration on VPS
grep PermitRootLogin /etc/ssh/sshd_config

# Should be: PermitRootLogin yes
# If not, change it and restart SSH
```

## Complete Working Example

### Directory Structure
```
n8n-ansible/
├── ansible.cfg
├── inventory.yml
├── deploy-n8n.yml
└── templates/
    └── (template files)
```

### ansible.cfg
```ini
[defaults]
host_key_checking = False
inventory = inventory.yml
remote_user = root
private_key_file = ~/.ssh/id_rsa
stdout_callback = yaml
timeout = 30

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
pipelining = True
```

### inventory.yml
```yaml
all:
  hosts:
    ionos_vps:
      ansible_host: 1.2.3.4  # Your actual VPS IP
      ansible_user: root
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
  vars:
    domain_name: "yourdomain.com"
    use_gpu: false
```

### Test Connection
```bash
# Test everything is working
ansible all -m ping -v

# Run the deployment
ansible-playbook deploy-n8n.yml -v
```

## Security Best Practices

1. **Use SSH Keys**: More secure than passwords
2. **Disable Password Auth**: After SSH keys are working
3. **Use Non-Root User**: Create dedicated user after initial setup
4. **Firewall Rules**: Restrict SSH access to specific IPs
5. **SSH Key Rotation**: Regularly update SSH keys
6. **Ansible Vault**: For any sensitive variables

The SSH key method is strongly recommended for production use!