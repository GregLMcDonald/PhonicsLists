#!/usr/bin/perl
use strict;
use warnings;

my $previous = '';
while (<>){

	if ( $_ ne $previous ){
		print "$_";
		$previous = $_;
	}

}