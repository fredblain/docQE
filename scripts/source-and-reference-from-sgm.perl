#!/usr/bin/env perl
#
# This file is part of moses.  Its use is licensed under the GNU Lesser General
# Public License version 2.1 or, at your option, any later version.

use warnings;
use strict;

die("ERROR syntax: reference-from-sgm.perl ref src out")
unless scalar @ARGV == 4;
my ($ref,$src,$txt,$txt2) = @ARGV;

# get order of the documents
my @ORDER;
my %DOC_SRC;
my $system_from_srcset = 0;
my ($src_doc,$src_system);
open(SRC,$src) || die("ERROR not found: $src");
# while(<ORDER>) {
  # next unless /docid="([^\"]+)"/;
  # push @ORDER,$1;
# }
while(my $line = <SRC>) {
  if ($line =~ /<srcset/ && $line =~ /srcid="([^\"]+)"/i) {
    $src_system = $1;
    $system_from_srcset = 1;
  }
  if ($line =~ /<doc/i) {
    # die unless $line =~ /sysid="([^\"]+)"/i || $system_from_srcset;
    $src_system = $1 unless $system_from_srcset;
    die unless $line =~ /docid="([^\"]+)"/i;
    $src_doc = $1;
    push @ORDER,$src_doc;
  }
  while ($line =~ /<seg[^>]+>\s*(.*)\s*$/i &&
    $line !~ /<seg[^>]+>\s*(.*)\s*<\/seg>/i) {
    my $next_line = <SRC>;
    $line .= $next_line;
    chop($line);
  }
  if ($line =~ /<seg[^>]+>\s*(.+)\s*<\/seg>/i) {
    push @{$DOC_SRC{'ref'}{$src_doc}},$1;
  }
}
close(SRC);

# get from sgm file which lines belong to which system
my %DOC_REF;
my $system_from_refset = 0;
my ($doc,$system);
open(REF,$ref) or die "Cannot open: $!";
while(my $line = <REF>) {
  if ($line =~ /<refset/ && $line =~ /refid="([^\"]+)"/i) {
    $system = $1;
    $system_from_refset = 1;
  }
  if ($line =~ /<doc/i) {
    die unless $line =~ /sysid="([^\"]+)"/i || $system_from_refset;
    $system = $1 unless $system_from_refset;
    die unless $line =~ /docid="([^\"]+)"/i;
    $doc = $1;
  }
  while ($line =~ /<seg[^>]+>\s*(.*)\s*$/i &&
    $line !~ /<seg[^>]+>\s*(.*)\s*<\/seg>/i) {
    my $next_line = <REF>;
    $line .= $next_line;
    chop($line);
  }
  if ($line =~ /<seg[^>]+>\s*(.+)\s*<\/seg>/i) {
    push @{$DOC_REF{$system}{$doc}},$1;
  }
}
close(REF);

my $i=0;
foreach my $system (keys %DOC_REF) {
  my $out_src_file = $txt;
  my $outfile = $txt2;
  if (scalar keys %DOC_REF > 1) {
    if ($outfile =~ /\.\d+$/) {
      $outfile .= ".ref$i";
    }
    else {
      $outfile .= $i;
    }
  }
  foreach my $doc (@ORDER) {
    open(TXT_SRC,">".$doc =~ s/\//_/gr.".".$out_src_file) || die($out_src_file);
    open(TXT_REF,">".$doc =~ s/\//_/gr.".".$outfile) || die($outfile);
    die("can't find '$doc' for src '$system'") unless defined $DOC_SRC{$system}{$doc};
    die("can't find '$doc' for ref '$system'") unless defined $DOC_REF{$system}{$doc};
    foreach my $line (@{$DOC_SRC{$system}{$doc}}) {
      print TXT_SRC $line."\n";
    }
    foreach my $line (@{$DOC_REF{$system}{$doc}}) {
      print TXT_REF $line."\n";
    }
    close(TXT_SRC);
    close(TXT_REF);
  }
  $i++;
}
