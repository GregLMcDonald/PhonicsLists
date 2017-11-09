#!/usr/bin/perl


use strict;    # safety net
use warnings;  # safety net
use open ':std', ':encoding(UTF-8)';
use LWP::Simple;




my $word = $ARGV[0];




if (defined $word){

	my $url = 'http://dictionary.cambridge.org/dictionary/english/'.$word;
	
	my $content = get $url;


	my $count = 0;
	my $uk;
	my $us;
	for (split /^/, $content) {
		
		if ( /span class=\"ipa\"/ ){

			$count = $count + 1;


			s/.*span class=\"ipa\"\>(.*?)\<\/span\>.*/$1/g ;

			s/\n//;
		
			if ($count == 1){
				$uk = $_;
			}
			if ($count == 2){
				$us = $_;
				last;
			}
		}
	}


	my $result = $word.",".$us.",".$uk."\n";

	print $result;

	open( MYFILE, ">>pronunciation_results.txt");
	print MYFILE $result;
	close( MYFILE );

}

