#!/usr/bin/perl -w

use strict;

binmode(STDIN,":utf8");
binmode(STDOUT,":utf8");

while(<STDIN>) {
    if (/<seg[^>]+>\s*(.*?)\s*<\/seg/) {
	print $1."\n";
    }

}
