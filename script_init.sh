#!/bin/bash
set -e

mkdir -p /home/ansible/.ssh/ansible
cp /home/ansible/resources/ssh_conf/ansible_lab.pub /home/ansible/.ssh/authorized_keys
cp /home/ansible/resources/ssh_conf/ansible_lab.pub /home/ansible/.ssh/ansible/ansible_lab.pub
cp /home/ansible/resources/ssh_conf/ansible_lab /home/ansible/.ssh/ansible/ansible_lab
cp /home/ansible/resources/inventory /home/ansible/inventory
cp /home/ansible/resources/ansible.cfg /home/ansible/ansible.cfg

chmod 700 /home/ansible/.ssh
chmod 700 /home/ansible/.ssh/ansible
chmod 600 /home/ansible/.ssh/authorized_keys
chmod 600 /home/ansible/.ssh/ansible/ansible_lab
chmod 644 /home/ansible/.ssh/ansible/ansible_lab.pub
chown -R ansible:ansible /home/ansible/.ssh /home/ansible/inventory

exec /usr/sbin/sshd -D
