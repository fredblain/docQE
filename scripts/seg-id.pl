#! /usr/bin/env perl -w
#
# seg-id.pl
#
# Copyright (C) 2020 Frederic Blain (feedoo) <f.blain@sheffield.ac.uk>
#
# Licensed under the "THE BEER-WARE LICENSE" (Revision 42):
# Fred (feedoo) Blain wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a tomato juice or coffee in return
#

use strict;
use warnings;

open FI, "<", $ARGV[0] or die $!;
open FO, ">", "$ARGV[0].seg" or die $!;

my $i=1;
while (<FI>)
{
	chomp $_;
	print FO "$_ ($i)\n";
	$i++;
}
close FI;
close FO;

