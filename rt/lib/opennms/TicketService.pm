# This file is part of the OpenNMS(R) Application.
#
# OpenNMS(R) is Copyright (C) 2002-2008 The OpenNMS Group, Inc. All rights
# reserved.  OpenNMS(R) is a derivative work, containing both original code,
# included code and modified code that was published under the GNU General
# Public License. Copyrights for modified and included code are below.
#
# OpenNMS(R) is a registered trademark of The OpenNMS Group, Inc.
#
# Copyright (C) Jonathan Sartin (Jonathan@opennms.org)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# For more information contact:
# OpenNMS Licensing <license@opennms.org>
# http://www.opennms.org/
# http://www.opennms.com/

package opennms::TicketService;
use lib ("/usr/local/share/request-tracker3.6/lib","/usr/share/request-tracker3.6/lib","/etc/request-tracker-3.6");
@ISA = ("opennms::WebService");

use strict;
use warnings;

use opennms::WebService;
use SOAP::DateTime;
use Data::Dumper;
use integer;
use constant URI => "http://opennms.org/integration/rt/TicketService";
use RT;

sub new {
 
    my $class = shift;
    
    return $class if ref($class);
    
    my $Self = $class->SUPER::new(@_);
 
    return $Self;

}

sub TicketGetByID() {

	my $Self = shift->new(@_);
	my $TicketID = shift;
	my %Ticket;
	RT::LoadConfig();
	RT::Init();
	my $RTUser = $RT::SystemUser;
	my $Ticket = RT::Ticket->new( $RTUser );
    $Ticket->Load($TicketID);
    unless ( $Ticket->id ) {
        Abort("Could not load ticket $TicketID");
    	}
	
	# Fake RT Ticket information here
	
	
	print STDERR "Called TicketGetByID $TicketID";
	print STDERR Dumper{$TicketID};
	
	#my $LastUpdated = ConvertDate( $Ticket{LastUpdated} );
	
	my @TicketResponse = 
	(
		SOAP::Data->name("TicketID" => $Ticket->id())->type("long"),
		SOAP::Data->name("Subject" => $Ticket->Subject())->type("string"),
		SOAP::Data->name("Contents" => "")->type("string"),
		SOAP::Data->name("Requestor" => $Ticket->Creator())->type("string"),
		SOAP::Data->name("Status" => $Ticket->Status())->type("string"),
		SOAP::Data->name("LastUpdated" => $Ticket->LastUpdated())->type("dateTime"),
	);
    
    return SOAP::Data->name( "Ticket" )
			->attr( {"xmlns:tns" => URI } )
			->type( "tns:Ticket" )
			->value( \SOAP::Data->value(@TicketResponse) );
	
}

sub TicketCreate() {
	
	my $Self = shift->new(@_);
	
	
	my $TicketReq = shift;
	my $UserID = shift;
	
	print STDERR "Called TicketCreate";
	# Your fields should be available in
	# $TicketReq->{TicketID} (but not used)
	my $Subject=$TicketReq->{Subject};
	my $Content=$TicketReq->{Contents};
	my $Requestor=$TicketReq->{Requestor};
	# $TicketReq->{LastUpdated}
	
	# Do the RT Stuff
	RT::LoadConfig();
	RT::Init();
	my $RTUser = $RT::SystemUser;
	
	# Encode the Content Part for the Ticket
	my $ticket_content = MIME::Entity->build(	Data => $Content,
						 Type => 'text/plain');
	
	my $ticket = new RT::Ticket($RTUser);
	my $queue = 'opennms';
	my %ticketValues = (	
				Queue 		=> $queue,
				Subject		=> $Subject,
				#'CustomField-1' => $data{'$whatyouwanthere'},				
				Requestor	=> $Requestor,
				MIMEObj		=> $ticket_content
				);
	my ($TicketId, $transaction, $err) = $ticket->Create(%ticketValues);
	unless ($TicketId && $transaction) {die("Ticket Creation failed")}
		
	print STDERR "$Subject - $Content - $Requestor - $TicketId\n";
	# I think we can prolly avoid the fancy formatting in this one
	
	return $TicketId;
	
}
1;
