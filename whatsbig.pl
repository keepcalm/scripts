#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
#use re 'debug';
use Getopt::Long;

my $path = ".";
$path = $ARGV[0] if defined $ARGV[0];
#my $res = GetOptions ("path=s", \$path);
print "Using path: $path\n";

my @out = split/\n/, my $tmp = `du -s -h $path/* 2>$ENV{HOME}/.du-err`;

#my $debug = 1;
my $debug;
my @big;
my @MB;

my $big1=0;
my $MB1=0;
foreach my $doc (@out) {
	if ($doc =~ /^\d+.?\d+G/) {
		print "Found a gigabyte-size file, output of du is $doc\n" if $debug;
		my @stuff = split/\t/, $doc;
		my $i=0;
		#print "Found a biggie: (size is $stuff[0])";
		#print $stuff[1], "\n";;
		$big[$big1]{size} = $stuff[0];
		$big[$big1]{name} = $stuff[1];
		$big1++;
		
	}
	elsif ($doc =~ /^\d\d+.?\d+M/) {
		print "Found a multi-meg file, du's output is $doc\n" if $debug;
		my @stuff = split/\t/, $doc;
		#print "Found something which is 10MB or larger: (size: $stuff[0])";
		#print " $stuff[1]\n";
		$MB[$MB1]{size} = $stuff[0];
		$MB[$MB1]{name} = $stuff[1];
		$MB1++;
	}
	elsif ($doc =~ /\d\d+M/ ) {
		print "Found a multi-meg file, du's output is $doc\n" if $debug;
		my @stuff = split/\t/, $doc;
		#print "Found something which is 10MB or larger: (size: $stuff[0])";
		#print " $stuff[1]\n";
		$MB[$MB1]{size} = $stuff[0];
		$MB[$MB1]{name} = $stuff[1];
		$MB1++;
	}
	else {
		
		# It's small
		next;
	}
}
my $gb = $#big;
my $mb = $#MB;
$gb++;
$mb++;
print "Number of GIGABYTE or larger files: $gb; number of 10.0MB+ files: $mb\n";
if (!@big) {
	print "[No gigabyte or larger files in $path]\n";
}
else {
	print "--------GIGABYTE OR LARGER FILES------------\n";
	foreach my $gig (@big) {
		print "(size: $gig->{size}) $gig->{name}\n";
	}
}
if (!@MB) {
	print "[No 10.0 megabyte or larger files in $path]\n";
}
else {
	print "-------10.0MB OR LARGER FILES--------------\n";
	foreach my $mb (@MB) {
		print "(size: $mb->{size}) $mb->{name}\n";
	}
}	
if (not @MB and not @big) {
	print "No BIG files found. Here's the information we got:\n";
	print $tmp;
}
