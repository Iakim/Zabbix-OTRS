# Encoding: utf-8
from otrs.ticket.template import GenericTicketConnectorSOAP
from otrs.client import GenericInterfaceClient
from otrs.ticket.objects import Ticket, Article, DynamicField, Attachment

import mimetypes
import base64
import argparse
import time
import re
import os
import sys

# Parse command line options
parser = argparse.ArgumentParser(description='Criar um ticket.')
parser.add_argument('--otrs', dest='server', help='OTRS server address, ex: 10.20.19.47')
parser.add_argument('--webservice', dest='webservice', default='ZabbixOTRS', help='OTRS Web Servcice')
parser.add_argument('--user', dest='user', default='otrs.isaac', help='OTRS user')
parser.add_argument('--pass', dest='password', default='pass.isaac', help='OTRS pass')
parser.add_argument('--customer', dest='customer', help='Customer')
parser.add_argument('--title', dest='title', help='Title of ticket')
parser.add_argument('--desc', dest='description', help='Description')
parser.add_argument('--queue', dest='queue', help='Queue')
parser.add_argument('--service', dest='service', help='Service of ticket')
parser.add_argument('--sla', dest='sla', help='SLA')
parser.add_argument('--triggerid', dest='triggerid', help='Trigger ID do zabbix')
parser.add_argument('--eventid', dest='eventid', help='Event ID do zabbix')
parser.add_argument('--host', dest='host', help='Nome do host no zabbix')
parser.add_argument('--status', dest='status', help='Indisponibilidade')
args = parser.parse_args()

#print(args)

# Connecting to the OTRS
server_uri = 'http://'+args.server+'/'
webservice_name = args.webservice
client = GenericInterfaceClient(server_uri, tc=GenericTicketConnectorSOAP(webservice_name))
client.tc.SessionCreate(user_login=args.user, password=args.password)

# Create of ticket
t = Ticket(State='Aberto', Priority='3 normal', Queue=args.queue,
           Title=args.title.decode('UTF8'), CustomerUser=args.customer,
           Type='Incidente', Service=args.service, SLA=args.sla)
a = Article(Subject=args.title.decode('UTF8'), Body=args.description.decode('UTF8'), Charset='UTF8',
            MimeType='text/plain')

t_id, t_number = client.tc.TicketCreate(t, a, None, None)
print('Ticket criado: '+str(t_number))
print('Ticket criado: '+str(t_number)+'::'+args.title)

# ACK
ack = "python /usr/lib/zabbix/alertscripts/ack_zabbix.py" + args.eventid + " " + str(t_number)
os.system(ack)

# Ticket em atendimento
# Ticket in attendance
t_upd = Ticket(State='Aberto')

new_article = Article(Subject='Em atendimento', Body='Analisando o incidente.', Charset='UTF8',
                      MimeType='text/plain')
client.tc.TicketUpdate(t_id, ticket=t_upd,article=new_article, attachments=None)
