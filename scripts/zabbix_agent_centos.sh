#!/bin/bash

#############################################################
#                                                           #
# NOME: zabbix_agent_centos.sh                              #
#                                                           #
# AUTOR: Amaury B. Souza (amaurybsouza@gmail.com)           #
#                                                           #
# DESCRIÇÃO: O script faz a instalação do Zabbix Agent 4.0  #
#            em sistema Centos                              #
#                                                           #
# USO: ./zabbix_agent_centos.sh                             #
#############################################################

echo "Digite o nome da Host: "
read HOSTNAME
echo "Digite o IP Zabbix Server: "
read SERVER

yum install -y wget
wget https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
rpm -i zabbix-release-4.0-1.el7.noarch.rpm
yum install -y zabbix-agent


echo "
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=20
Include=/etc/zabbix/zabbix_agentd.d/
Hostname=$HOSTNAME
EnableRemoteCommands=1
LogRemoteCommands=1
Server=$SERVER
ServerActive=$SERVER
RefreshActiveChecks=120
ListenPort=10050
StartAgents=10
Timeout=3
DebugLevel=3
" > /etc/zabbix/zabbix_agentd.conf
 
systemctl restart zabbix-agent
systemctl enable zabbix-agent
exit
