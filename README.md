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

| Playbook | Description |
|---|---|
| [bootstrap.yml](resources/playbooks/bootstrap.yml) | First-run setup for a fresh node: updates the package cache, creates the `simone` user, adds their SSH key, and installs a passwordless-sudo file for them. |
| [install_apache.yml](resources/playbooks/install_apache.yml) | Installs Apache2 and PHP support (`libapache2-mod-php`) on Ubuntu hosts. No OS guard — assumes every targeted host is Ubuntu. |
| [install_apache_v1.yml](resources/playbooks/install_apache_v1.yml) | Same as `install_apache.yml`, but each task is guarded with `when: ansible_distribution == "Ubuntu"` so it skips cleanly on non-Ubuntu hosts instead of failing. |
| [remove_apache.yml](resources/playbooks/remove_apache.yml) | Uninstalls Apache2 and its PHP module (`state: absent`) — the inverse of the install playbooks. |
| [site.yml](resources/playbooks/site.yml) | The full multi-role site playbook, written as plain tasks (not roles). Updates repo caches, adds the `simone` SSH key everywhere, installs Terraform on `workstation` hosts, sets up Apache/httpd + a custom Timeout + default site on `web_servers`, MariaDB on `db_servers`, and Samba on `file_servers`. Supports both Ubuntu (`apt`) and CentOS (`dnf`) per task. |
| [site_roles.yml](resources/playbooks/site_roles.yml) | The role-based equivalent of `site.yml`: refreshes the repo cache, then applies the `base` role to all hosts and the `workstations`, `web_servers`, `db_servers`, and `file_servers` roles to their matching inventory groups. |
