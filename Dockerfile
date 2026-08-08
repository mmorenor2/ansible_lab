FROM ubuntu:22.04

# Install SSH server, sudo, and Python (required for Ansible modules)
RUN apt-get update && apt-get install -y openssh-server sudo python3 \
    && mkdir /var/run/sshd

# Create the ansible user with a real login shell and passwordless sudo
RUN useradd -m -s /bin/bash ansible \
    && adduser ansible sudo \
    && echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up .ssh directory with correct permissions
RUN mkdir -p /home/ansible/.ssh \
    && chmod 700 /home/ansible/.ssh

# Copy in the public key only (never the private key)
COPY ./resources/ansible_lab.pub /home/ansible/.ssh/authorized_keys

RUN chmod 600 /home/ansible/.ssh/authorized_keys \
    && chown -R ansible:ansible /home/ansible/.ssh

# Harden sshd: key-only auth, no root login
# (appending instead of sed — sed depends on exact default text matching,
# appended lines always win since sshd honors the last occurrence)
RUN { echo "PasswordAuthentication no"; \
      echo "PermitRootLogin no"; \
      echo "PubkeyAuthentication yes"; } >> /etc/ssh/sshd_config

# Ensure host keys exist (normally auto-generated on install, but explicit
# here so the container never fails to boot sshd due to missing keys)
# RUN ssh-keygen -A

EXPOSE 22

# Run sshd in the foreground so it becomes PID 1 and keeps the container alive
CMD ["/usr/sbin/sshd", "-D"]