#!/bin/bash
read -p "Please enter server ip: " server_ip
read -p "Please enter the root password: " -s root_password
echo
read -p "Please enter the username you want: " user_name

cat << EOF > tmp_hosts
[server]
tmp ansible_host=$server_ip ansible_ssh_pass=$root_password ansible_ssh_user=root ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

if [ -d playbooks/files_or_configs ]; then
mkdir playbooks/files_or_configs
fi
ansible-playbook playbooks/basicsetup.yml -i tmp_hosts -e user_name=$user_name -e server_status='new'

mv playbooks/hosts .
rm tmp_hosts

ansible-playbook playbooks/redhat_python_last.yml -i hosts
