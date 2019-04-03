# Zabbix-OTRS integration

## Este documento tem como objetivo realizar a integração do Zabbix com o OTRS.

## This document is intended to perform the integration of Zabbix with OTRS.

### Pré-requisitos:

1. Servidor com o OTRS 5 instalado (Testado já na versão 6)
2. Servidor com o zabbix 3.2.7 ou superior instalado (Testado já na versão 3.4.1)
3. Certifique-se de usar o repositório Epel

### Prerequisites:

1. Server with OTRS 5 installed (Already tested in version 6)
2. Server with zabbix 3.2.7 or higher installed (Already tested in version 3.4.1)
3. Be sure to use the Epel repository

        # yum install epel-release

## O passo a passo está no documento zabbix-otrs-br.pdf.

## The walkthrough is in the document zabbix-otrs-en.pdf.

## Comandos

## Commands

        # yum install python python-pip -y

        # pip install python-otrs
        
        # pip install zabbix-api

        # yum install cpan -y

        # scp /opt/otrs/bin/otrs.CheckModules.pl root@zabbix:/tmp/

        # perl -MCPAN -e otrs.CheckModules.pl

        # yum install "perl(ExtUtils::MakeMaker)" "perl(Sys::Syslog)" -y

        # yum install "perl(Archive::Tar)" "perl(Archive::Zip)" "perl(Crypt::Eksblowfish::Bcrypt)" "perl(Crypt::SSLeay)" "perl(Date::Format)" "perl(DBD::Pg)" "perl(Encode::HanExtra)" "perl(IO::Socket::SSL)" "perl(JSON::XS)" "perl(Mail::IMAPClient)" "perl(IO::Socket::SSL)" "perl(ModPerl::Util)" "perl(Net::DNS)" "perl(Net::LDAP)" "perl(Template)" "perl(Template::Stash::XS)" "perl(Text::CSV_XS)" "perl(Time::Piece)" "perl(XML::LibXML)" "perl(XML::LibXSLT)" "perl(XML::Parser)" "perl(YAML::XS)" -y

        # yum install perl-SOAP-Lite -y

        # cp /tmp/criar_chamado_zabbix.py /usr/lib/zabbix/alertscripts/

        # cp /tmp/fechar_chamado_zabbix.pl /usr/lib/zabbix/alertscripts/

## Scripts

python criar_chamado_zabbix.py --otrs {IP_OTRS} --webservice ZabbixOTRS --user {USUARIO} --pass {SENHA} --customer {CLIENTE} --title "Teste de chamado" --desc "Descrição do Chamado" --fila "{FILA}" --servico "{SERVICO}" --sla "{SLA}"

/bin/python /usr/lib/zabbix/alertscripts/criar_chamado_zabbix.py --otrs 10.20.19.47 --webservice ZabbixOTRS --user otrs.isaac --pass pass.isaac --customer cliente --title "PROBLEMA: {TRIGGER.SEVERITY} - {TRIGGER.NAME} - {TRIGGER.STATUS}" --desc "O host abaixo esta com problemas.
Nome do host: {HOST.HOST}
Nome do item: {ITEM.NAME}
Nome da trigger: {TRIGGER.NAME}
Status da trigger: {TRIGGER.STATUS}
Severidade da trigger: {TRIGGER.SEVERITY}
Data do evento: {EVENT.DATE} {EVENT.TIME}
Data atual: {DATE} {TIME}
Trigger ID: {TRIGGER.ID}
Event ID: {EVENT.ID}
Total de tempo com problema: {EVENT.AGE}" --fila "Infra" --servico "INFRAESTRUTURA::SERVIDORES::LINUX" --sla "ALTA::24" --triggerid {TRIGGER.ID} --host {HOST.NAME} --status INDISPONIBILIDADE --eventid {EVENT.ID}

perl /usr/lib/zabbix/alertscripts/fechar_chamado_zabbix.pl -subject 'Incidente normalizado' -body 'O incidente foi normalizado' -triggerid {TRIGGER.ID}

### Telegram: @iakim
