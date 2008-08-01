#!/usr/bin/perl -w
# --
# bin/cgi-bin/opennms.pl - Dispatcher script for OpenNMS Integration module
# Copyright (C) (Jonathan Sartin) (Jonathan@opennms.org)
# --
# $Id: opennms.pl 18 2008-05-08 17:59:48Z user $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --
 
use strict;
use warnings;

# use ../../ as lib location
# This is OTRS specific and will need changing.
#use FindBin qw($Bin);
#use lib "$Bin/../..";
#use lib "$Bin/../../Kernel/cpan-lib";
use lib ("/usr/local/share/request-tracker3.6/lib","/usr/share/request-tracker3.6/lib","/etc/request-tracker-3.6");

 
use SOAP::Transport::HTTP;

my $ClassMap = {'http://opennms.org/integration/rt/ticketservice' => 'opennms::TicketService'};

SOAP::Transport::HTTP::CGI->dispatch_with($ClassMap)->handle;