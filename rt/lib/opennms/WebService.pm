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
# Copyright (C) for the RT Parts Alexander Finger (af@opennms.org)
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

# opennms/WebService.pm - Super Class for Ticket interface for OpenNMS Integration
use lib ("/usr/local/share/request-tracker3.6/lib","/usr/share/request-tracker3.6/lib","/etc/request-tracker-3.6");

package opennms::WebService;
use Data::Dumper;
use strict;
use warnings;
use RT;
use RT::CurrentUser;
RT::LoadConfig();
RT::Init();

use SOAP::Lite;

use base qw( SOAP::Server::Parameters );

use vars qw($VERSION);
$VERSION = qw($Revision: 18 $) [1];

sub new {
	
	
	my $Class = shift;
	my $Self = {};
	my $som = pop();
	
	# don't change this hash dereferencing or you will burn in hell
	my $header = $som->header();
	my $user=$$header{'request_header'}{'User'};
	my $pass=$$header{'request_header'}{'Pass'};
	# print STDERR "User $user, password $pass\n";
	my $RequiredUser = "user";
 	my $RequiredPassword = "user";
 	my $RTUser = new RT::CurrentUser;
 	unless ($RTUser->LoadByName($user)) {die "Failed to Load RT User"};
 	my $auth = $RTUser->IsPassword($pass);
 	# print STDERR "IsPassword said $auth";
 	
	if ($auth ne 1) {
		die SOAP::Fault
			->faultcode('Server.RequestError')
			->faultstring("Authentication Failure");
		
	}	

	# At this moment we have a soap request and have successfully authenticated the
	# user/pass in the header element.

	# Commented out OTRS-style logging, need a replacement that's better than print STDERR "blah";

 	#$Self->{CommonObject}->{LogObject}->Log(
	#	Priority => 'debug',
	#	Message  => "user: (required) $RequiredUser - (request) $header->{request_header}->{User}",
	#);
 
    #if ( !defined $RequiredUser || !length( $RequiredUser )
    #    || !defined $RequiredPassword || !length( $RequiredPassword )
    #) {
    #    #$Self->{CommonObject}->{LogObject}->Log(
    #    #    Priority => 'notice',
    #    #    Message  => "SOAP::User or SOAP::Password is empty, SOAP access denied!",
    #    #);
    #    die SOAP::Fault
    #    	->faultcode('Server.RequestError')
    #    	->faultstring("Authentication Failure");
    #}
    #if ( $header->{request_header}->{User} ne $RequiredUser || $header->{request_header}->{Pass} ne $RequiredPassword ) {
    #    #$Self->{CommonObject}->{LogObject}->Log(
    #    #    Priority => 'notice',
    #    #    Message  => "Auth for user $header->{request_header}->{User} failed!",
    #    #);
    #    die SOAP::Fault
    #    	->faultcode('Server.RequestError')
    #    	->faultstring("Authentication Failure");
    #}
    
    bless($Self, $Class);
	
	return $Self;
  
}


1;