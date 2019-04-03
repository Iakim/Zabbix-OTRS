from zabbix_api import ZabbixAPI
import sys
import os

server = 'http://localhost/zabbix'
username = 'Admin'
password = 'zabbix'

conexao = ZabbixAPI(server = server)
conexao.login(username, password)

conexao.event.acknowledge({'eventids': sys.argv[1], 'action': 2, 'message': 'Ticket ' + str(sys.argv[2]) + ' criado no OTRS.'})
