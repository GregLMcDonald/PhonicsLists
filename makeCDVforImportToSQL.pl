#!/usr/bin/perl
use strict;
use warnings;


print "word,noun,verb,adverb,adjective,other,frequency\n";

my @pieces;
my $word = '';
my $noun = 0;
my $verb = 0;
my $adverb = 0;
my $adjective = 0;
my $other = 0;
my $frequency = 0;

while ( <> ){

 	$_ =~ s/\n//; #strips the newline off the line



 	@pieces = split /,/ , $_ ;


 	$word = shift @pieces;

	foreach my $piece (@pieces){

 		if ($piece eq 'n') {
 			$noun = 1;
 		}
		if ($piece eq 'v') {
			$verb = 1;
		}
		if ($piece eq 'adj') {
			$adjective = 1;
		}
		if ($piece eq 'adv') {
			$adverb = 1;
		}

		if (substr( $piece, 0, 2 ) eq 'f:') {
			$piece = substr $piece, 2;
			$frequency = $piece;
		}

 	} 

	print "$word,$noun,$verb,$adverb,$adjective,$other,$frequency\n";

	$noun = 0;
	$verb = 0;
	$adverb = 0;
	$adjective = 0;
	$other = 0;
	$frequency = 0;


}