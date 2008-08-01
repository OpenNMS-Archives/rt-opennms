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

@ISA = ("opennms::WebService");

use strict;
use warnings;

use opennms::WebService;
use SOAP::DateTime;
use Data::Dumper;
use integer;
use constant URI => "http://opennms.org/integration/rt/TicketService";


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

	# Fake RT Ticket information here
	
	$Ticket{TicketID} = 123456789;
	$Ticket{Subject} = "Fake Ticket Subject";
	$Ticket{Contents} = "Fake Ticket Contents";
	$Ticket{Requestor} = "jonathan.sartin";
	$Ticket{LastUpdated} = "31/07/2008"
	
	print STDERR "Called TicketGetByID";
	print STDERR Dumper{$TicketID};
	
	my $LastUpdated = ConvertDate( $Ticket{LastUpdated} );
	
	my @TicketResponse = 
	(
		SOAP::Data->name("TicketID" => $Ticket{TicketID})->type("long"),
		SOAP::Data->name("Subject" => $Ticket{Subject})->type("string"),
		SOAP::Data->name("Contents" => $Ticket{Contents})->type("string"),
		SOAP::Data->name("Requestor" => $Ticket{Requestor})->type("string"),
		SOAP::Data->name("LastUpdated" => $LastUpdated)->type(""dateTime""),
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
	
	my $TicketID = 123456789;
	
	print STDERR "Called TicketCreate";
	print STDERR Dumper{$TicketID};
	
	# Your fields should be available in
	# $TicketReq->{TicketID} (but not used)
	# $TicketReq->{Subject}
	# $TicketReq->{Contents}
	# $TicketReq->{Requestor}
	# $TicketReq->{LastUpdated}
	
	# I think we can prolly avoid the fancy formatting in this one
	
	return $TicketID;
	
}
1;
