# ansible_lab
Ansible Lab with Docker containers

## Setup

This repo does not include the `resources/` folder — it contains SSH keys 
and an inventory file that are excluded from git for security reasons.

Before running `docker compose up`, create it manually:

1. Generate an SSH key pair (if you don't already have one):
   \`\`\`bash
   ssh-keygen -t ed25519 -f ~/.ssh/ansible_lab -N ""
   \`\`\`

2. Create the `resources/` folder and copy the keys and inventory into it:
   \`\`\`bash
   mkdir resources
   cp ~/.ssh/ansible_lab ~/.ssh/ansible_lab.pub resources/
   cp inventory.example resources/inventory   # see below
   \`\`\`

3. Build and start the lab:
   \`\`\`bash
   docker compose up -d --build
   \`\`\`

### Expected `resources/` structure
\`\`\`
resources/
├── ansible_lab       # private key (never committed)
├── ansible_lab.pub   # public key
└── inventory          # Ansible inventory file
\`\`\`