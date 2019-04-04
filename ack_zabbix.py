from zabbix_api import ZabbixAPI
import sys

server = 'http://localhost/zabbix'
username = 'Admin'
password = 'zabbix'

conn = ZabbixAPI(server = server)
conn.login(username, password)

conn.event.acknowledge({"eventids": sys.argv[1], "message": "Ticket " + str(sys.argv[2]) + " criado no OTRS."})

### FOR ZABBIX 4.x uncomment two lines, and comment the line above
#conn.event.acknowledge({"eventids": sys.argv[1], "action": 2, "message": "Ticket " + str(sys.argv[2]) + " criado no OTRS."})
#conn.event.acknowledge({"eventids": sys.argv[1], "action": 4, "message": "Ticket " + str(sys.argv[2]) + " criado no OTRS."})
