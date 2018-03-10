#!/usr/bin/perl
use strict;
use warnings;
use open ':std', ':encoding(UTF-8)';
use LWP::Simple;
use JSON::PP 'decode_json';
use Data::Dumper;


while( <> ){

	$_ =~ s/\n//;

	my $s = lc $_ ;

	my $url = 'http://api.datamuse.com/words?sp=' . $s . '&md=pf';

	my $content = get $url;
	
	my $parsed = decode_json $content;

	my $tagLabel = '';

	for my $item( @{ $parsed } ){
		if ( $item->{'word'} eq $s ){

			my @tags = @{ $item->{'tags'} };

			$tagLabel = ',';

			while (@tags){
				my $thing = shift @tags;
				$tagLabel = $tagLabel . $thing . ',';
			}


			

    	}
	}


	my $result = $s . $tagLabel ;

	print "$result\n";


	open( MYFILE, ">>datamuse_results_LEVEL_1.txt");
	print MYFILE "$result\n";
	close( MYFILE );




}