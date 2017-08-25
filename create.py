# encoding: utf-8
from otrs.ticket.template import GenericTicketConnectorSOAP
from otrs.client import GenericInterfaceClient
from otrs.ticket.objects import Ticket, Article, DynamicField, Attachment

import mimetypes
import base64
import argparse
import time
import re

# Opções
parser = argparse.ArgumentParser(description='Criar chamado.')
parser.add_argument('--otrs', dest='server', help='IP OTRS')
parser.add_argument('--webservice', dest='webservice', default='ZabbixOTRS', help='OTRS Web Servcice')
parser.add_argument('--user', dest='user', default='zabbix', help='OTRS user')
parser.add_argument('--pass', dest='password', default='zabbixpass', help='OTRS pass')
parser.add_argument('--customer', dest='customer', help='Cliente')
parser.add_argument('--title', dest='title', help='Titulo do chamado')
parser.add_argument('--desc', dest='descricao', help='Descricao do chamado')
parser.add_argument('--fila', dest='fila', help='Fila de atendimento')
parser.add_argument('--servico', dest='servico', help='Servico de abertura')
parser.add_argument('--sla', dest='sla', help='SLA a ser utilizado')
args = parser.parse_args()

#print(args)

# Conectando com o OTRS
server_uri = 'http://'+args.server+'/'
webservice_name = args.webservice
client = GenericInterfaceClient(server_uri, tc=GenericTicketConnectorSOAP(webservice_name))
client.tc.SessionCreate(user_login=args.user, password=args.password)

# Criando o chamado
t = Ticket(State='Aberto', Priority='3 normal', Queue=args.fila,
           Title=args.title.decode('utf8'), CustomerUser=args.customer,
           Type='Incidente', Service=args.servico, SLA=args.sla)
a = Article(Subject=args.title.decode('utf8'), Body=args.descricao.decode('utf8'), Charset='UTF8',
            MimeType='text/plain')
t_id, t_number = client.tc.TicketCreate(t, a, None, None)
print('Ticket criado: '+str(t_number))
print('Ticket criado: '+str(t_number)+'::'+args.title)


# Chamado em andamento
t_upd = Ticket(State='Aberto')

new_article = Article(Subject='Em andamento', Body='Analisando o incidente', Charset='UTF8',
                      MimeType='text/plain')
client.tc.TicketUpdate(t_id, ticket=t_upd,article=new_article, attachments=None)