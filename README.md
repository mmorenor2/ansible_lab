# ansible_lab
Ansible Lab with Docker containers:
   3 containers as administrated servers : node1, node2, node3
   1 contianer for ansible server: server_ans

the Dockerfile.server image is adjusted with all ansible requirements for the playbook execution

## Setup

This repo does not include the `resources/ssh_conf`  — it contains SSH keys 
for remote access from ansible server to node servers

Before running `docker compose up`, create it manually:

1. Generate an SSH key pair (if you don't already have one):
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/ansible_lab -N ""
   ```

2. Create the `resources/ssh_conf` folder and copy the keys and inventory into it:
   ```bash
   mkdir  resources/ssh_conf
   cp ~/.ssh/ansible_lab ~/.ssh/ansible_lab.pub resources/ssh_conf
   cp inventory.example resources/inventory   # see below
   ```

3. Build and start the lab:
   ```bash
   docker compose up -d --build
   ```

### Expected `resources/ssh_conf` structure
```bash
resources/ssh_conf
├── ansible_lab       # private key (never committed)
├── ansible_lab.pub   # public key
```

### playbooks

All playbooks live in [resources/playbooks/](resources/playbooks/) and are run from the `server_ans` container, e.g.:
```bash
docker exec -it server_ans bash
ansible-playbook resources/playbooks/bootstrap.yml
```
