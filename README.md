# Zabbix + OTRS integration

### This document is intended to perform the integration of Zabbix with OTRS.

### Prerequisites:

1. Server with OTRS 5 installed (Already tested in version 6)
2. Server with zabbix 3.2.7 or higher installed (Already tested in version 3.4.1)
3. Be sure to use the Epel repository

        # yum install epel-release

### The walkthrough is in the document zabbix-otrs-XX.pdf.

### Commands

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

### Scripts

## Test
        python criar_chamado_zabbix.py --otrs {IP_OTRS} --webservice ZabbixOTRS --user {USER} --pass {PASSWORD} --customer {COSTUMER} --title "Test of ticket" --desc "Description of ticket" --queue "{QUEUE}" --service "{SERVICE}" --sla "{SLA}"

## Action on Zabbix for create
        /bin/python /usr/lib/zabbix/alertscripts/criar_chamado_zabbix.py --otrs 10.20.19.47 --webservice ZabbixOTRS --user otrs.isaac --pass pass.isaac --customer alexander --title "PROBLEM: {TRIGGER.SEVERITY} - {TRIGGER.NAME} - {TRIGGER.STATUS}" --desc "The host below is having problems.
        Name of host: {HOST.HOST}
        Name of item: {ITEM.NAME}
        Name of trigger: {TRIGGER.NAME}
        Status of trigger: {TRIGGER.STATUS}
        Severity of trigger: {TRIGGER.SEVERITY}
        Event date: {EVENT.DATE} {EVENT.TIME}
        Actual date: {DATE} {TIME}
        Trigger ID: {TRIGGER.ID}
        Event ID: {EVENT.ID}
        Total time of event: {EVENT.AGE}" --queue "Infra" --service "INFRASTRUCTURE::SERVER::LINUX" --sla "HIGH::2" --triggerid {TRIGGER.ID} --host {HOST.NAME} --status Incident --eventid {EVENT.ID}

## Action on Zabbix for close
        perl /usr/lib/zabbix/alertscripts/fechar_chamado_zabbix.pl -subject 'Standard Incident' -body 'The incident was standardized' -triggerid {TRIGGER.ID}

### Telegram: @iakim
