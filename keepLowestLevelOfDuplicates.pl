#!/usr/bin/perl

use strict;
use warnings;
use 5.010;


my %lines;

while (<>){

	$_ =~ s/\n//; #strips the newline off the line

	my ($word, $level) = split ',', $_;

	my $existingLevel = $lines{ $word };
	if ( $existingLevel ){

		if ( $level < $existingLevel ){
			$lines{ $word } = $level;
			print STDERR "Discarding level $existingLevel copy of $word in favour of $level\n";
		} else {
			print STDERR "Discarding level $level copy of $word in favour of $existingLevel\n";
		}

	} else {
		$lines{ $word } = $level;
	}

}

keys %lines;
while( my($word, $level) = each %lines) { 
 	print("$word,$level\n");
}
