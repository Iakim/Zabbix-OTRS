#!/usr/bin/perl -w
use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

use SOAP::Lite;
use Data::Dumper;
use Getopt::Long;

use XML::Simple;

my $TicketSearchID;
my $Operation 		= 0;
my $body 			= '';
my $triggerid 		= 0;
my $subject 		= '';

my $UserLogin 	= "otrs.isaac";
my $Password    = "pass.isaac";
my $system      = 'zabbix';

GetOptions (
			"subject=s"     => \$subject,
			"body=s"        => \$body,
			"triggerid=s"   => \$triggerid
			);

			
# #---
# Variables to be defined.
$Operation = "TicketUpdate";
# this is the URL for the web service
# the format is
# <HTTP_TYPE>:://<OTRS_FQDN>/nph-genericinterface.pl/Webservice/<WEB_SERVICE_NAME>
# or
# <HTTP_TYPE>:://<OTRS_FQDN>/nph-genericinterface.pl/WebserviceID/<WEB_SERVICE_ID>

my $URL = "http://10.20.19.47/otrs/nph-genericinterface.pl/Webservice/ZabbixOTRS";

# this name space should match the specified name space in the SOAP transport for the web service.
my $NameSpace = 'http://www.otrs.org/TicketConnector/';

# this is operation to execute, it could be TicketCreate, TicketUpdate, TicketGet, TicketSearch
# or SessionCreate. and they must to be defined in the web service.
my $OperationSearch = 'TicketSearch';

# this variable is used to store all the parameters to be included on a request in XML format, each
# operation has a determined set of mandatory and non mandatory parameters to work correctly, please
# check OTRS Admin Manual in order to get the complete list.
my $XMLDataSearch = "
			<UserLogin>$UserLogin</UserLogin>
			<Password>$Password</Password>
			<States>aberto</States>
			<DynamicField_triggerid>
				<Equals>$triggerid</Equals>
			</DynamicField_triggerid>
			";

			print $XMLDataSearch."\n";

# create a SOAP::Lite data structure from the provided XML data structure.
my $SOAPData = SOAP::Data
    ->type( 'xml' => $XMLDataSearch );
	


my $SOAPObject = SOAP::Lite
    ->uri($NameSpace)
    ->proxy($URL)
    ->$OperationSearch($SOAPData);

# check for a fault in the soap code.
if ( $SOAPObject->fault ) {
    print $SOAPObject->faultcode, " ", $SOAPObject->faultstring, "\n";
}


# otherwise print the results.
else {

    # get the XML response part from the SOAP message.
    my $XMLResponse = $SOAPObject->context()->transport()->proxy()->http_response()->content();

    # deserialize response (convert it into a perl structure).
    my $Deserialized = eval {
        SOAP::Deserializer->deserialize($XMLResponse);
    };

		
	print "debug \n";
	
    # remove all the headers and other not needed parts of the SOAP message.
    my $Body = $Deserialized->body();
	
    # just output relevant data and no the operation name key (like TicketCreateResponse).
    for my $ResponseKey ( keys %{$Body} ) {
		my @TicketNumberId;
		my $result = Dumper( $Body->{$ResponseKey} );
		print $result;
		my @TicketNumberIdParser = split(/\n/, $result);
		my $aux = 0;
		my $NumberTickeLimit = $#TicketNumberIdParser - 1;
		
		
		
		foreach(@TicketNumberIdParser){
			
			if ($_ =~ /TicketID/ and $#TicketNumberIdParser == '2')
				{
						@TicketNumberId = split(/\'/, $_);
								
						# UPDATE TICKET
						# create a SOAP::Lite data structure from the provided XML data structure.
						
						print "ticketNumber: $TicketNumberId[3]\n";
						
						my $XMLDataUpdate = "
						<UserLogin>$UserLogin</UserLogin>
						<Password>$Password</Password>
						<TicketID>$TicketNumberId[3]</TicketID>
						<Ticket>
							<State>resolvido</State>
						</Ticket>
						<Article>
							<Subject>$subject</Subject>
							<Body>$body</Body>
							<TimeUnit>100</TimeUnit>
							<ContentType>text/plain; charset=utf8</ContentType>
						</Article>
						
						";
						
						# PARA DEBUG
						print $XMLDataUpdate;
						
						my $SOAPDataUpdate = SOAP::Data
							->type( 'xml' => $XMLDataUpdate );

						my $SOAPObjectUpdate = SOAP::Lite
							->uri($NameSpace)
							->proxy($URL)
							->$Operation($SOAPDataUpdate);

						# check for a fault in the soap code.
						if ( $SOAPObjectUpdate->fault ) {
							print $SOAPObjectUpdate->faultcode, " ", $SOAPObjectUpdate->faultstring, "\n";
						}

						# otherwise print the results.
						else {

							# get the XML response part from the SOAP message.
							my $XMLResponseUpdate = $SOAPObjectUpdate->context()->transport()->proxy()->http_response()->content();

							# deserialize response (convert it into a perl structure).
							my $DeserializedUpdate = eval {
								SOAP::Deserializer->deserialize($XMLResponseUpdate);
							};

							# remove all the headers and other not needed parts of the SOAP message.
							my $Body = $DeserializedUpdate->body();

							# just output relevant data and no the operation name key (like TicketCreateResponse).
							for my $ResponseKey ( keys %{$Body} ) {
								print Dumper( $Body->{$ResponseKey} );
							
							}
						}
				}
			
			### Fechando varios chamados de uma vez...
			if ($#TicketNumberIdParser > '2' and ($aux > 1 and $NumberTickeLimit > $aux))
				{
				if($TicketNumberIdParser[$aux] =~ m/(\d+)/) {
					
					
							#UPDATE TICKET
							# create a SOAP::Lite data structure from the provided XML data structure.
							
							my $XMLDataUpdate = "
							<UserLogin>$UserLogin</UserLogin>
							<Password>$Password</Password>
							<TicketID>$1</TicketID>
							<Ticket>
								<State>resolvido</State>
							</Ticket>
							<Article>
								<Subject>$subject</Subject>
								<Body>$body</Body>
								<TimeUnit>100</TimeUnit>                        
								<ContentType>text/plain; charset=utf8</ContentType>
							</Article>
							
							";
							
							# PARA DEBUG
							#print $XMLDataUpdate;
							
							my $SOAPDataUpdate = SOAP::Data
								->type( 'xml' => $XMLDataUpdate );

							my $SOAPObjectUpdate = SOAP::Lite
								->uri($NameSpace)
								->proxy($URL)
								->$Operation($SOAPDataUpdate);

							# check for a fault in the soap code.
							if ( $SOAPObjectUpdate->fault ) {
								print $SOAPObjectUpdate->faultcode, " ", $SOAPObjectUpdate->faultstring, "\n";
							}

							# otherwise print the results.
							else {

								# get the XML response part from the SOAP message.
								my $XMLResponseUpdate = $SOAPObjectUpdate->context()->transport()->proxy()->http_response()->content();

								# deserialize response (convert it into a perl structure).
								my $DeserializedUpdate = eval {
									SOAP::Deserializer->deserialize($XMLResponseUpdate);
								};

								# remove all the headers and other not needed parts of the SOAP message.
								my $Body = $DeserializedUpdate->body();

								# just output relevant data and no the operation name key (like TicketCreateResponse).
								for my $ResponseKey ( keys %{$Body} ) {
									print Dumper( $Body->{$ResponseKey} );
								
								}
							}
				}
				
				}
			$aux = $aux + 1; 	
		}
	}
	}