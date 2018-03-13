#!/usr/bin/perl

use strict;
use warnings;
use 5.010;


my %lines;

while (<>){

	$_ =~ s/\n//; #strips the newline off the line

	my $line = $lines{ $_ };
	if ( $line ){
	} else {
		$lines{ $_ } = 1;
	}

}

foreach my $line ( keys %lines ){
	print("$line\n");
}