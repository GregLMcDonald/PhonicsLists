#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;

my $x; 
my $i;


my $showMisses = '';
my $showHitPronunciation = '';
my $showBoth = '';
my $distinguish = '';
my $help = '';
my $level = 1;
GetOptions ( 'misses' => \$showMisses, 
	'verbose' => \$showHitPronunciation, 
	'both' => \$showBoth, 
	'diff=s' => \$distinguish,
	'level=i' => \$level,
	'help' => \$help, );

if ($help){
	print "\n\nBy default, outputs hits for fully decodable words (each letter is pronounced,\n";
	print   "hard c and g, short vowel sounds only).";
	print "\nOptions for checkAgainstPronouncing are:\n\n";
	print "--verbose     Print the pronunciation string for hits\n";
	print "--level=N     If N is greater than 1, check for level 2 digraphs and ending sounds\n";
	print "--diff=VAL    Print the string VAL before misses to help distinguish them from hits\n";
	print "--both        Print hits and misses (overrides --misses)\n";
	print "--help        Prints this message\n";
	print "\n";
	exit;
}

my $pronouncingDico;
{
	my $filename = "cmudico";
	open( FILE, $filename) or die "Can't open $filename";
	local $/ = undef;
	$pronouncingDico = <FILE>;
	close(FILE);
}


my %phonemeLookup = (
	'A' => 'AE1',
	'B' => 'B',
	'C' => 'K',
	'CH' => 'CH',
	'CK' => 'K',
	'D' => 'D',
	'E' => 'EH1',
	'F' => 'F',
	'G' => 'G',
	'H' => 'HH',
	'I' => 'IH1',
	'J' => 'JH',
	'K' => 'K',
	'L' => 'L',
	'M' => 'M',
	'N' => 'N',
	'NG' => 'NG',
	'NK' => 'NG K',
	'O' => 'AA1',
	'P' => 'P',
	'Q'	=> 'K',
	'QU' => 'K W',
	'R' => 'R',
	'S' => 'S',
	'SH' => 'SH',
	'T' => 'T',
	'TH' => 'TH',
	'U' => 'AH1',
	'V' => 'V',
	'W' => 'W',
	'WH' => 'W',
	'X' => 'K S',
	'Y' => 'Y',
	'Z' => 'Z',
	);

my %possibleDigraph = ();
if ( $level gt 1 ){
	$possibleDigraph{ 'C' } = 1;
	$possibleDigraph{ 'N' } = 1;
	$possibleDigraph{ 'Q' } = 1;
	$possibleDigraph{ 'S' } = 1;
	$possibleDigraph{ 'T' } = 1;
	$possibleDigraph{ 'W' } = 1;
}


while( <> ) {

# Using <> means the file specified on the command line line-by-line or STDIN line-by-line


	


	$_ =~ s/\n//; #strips the newline off the line

	my $upper = uc $_; #converts to upper case

	my ($pronunciation)= $pronouncingDico =~ /^($upper\ +[\ \w]*$)/mg;  #looks up word in pronouncing dictionary

	my @pieces;

	if ($pronunciation){

		@pieces = split /\ /, $pronunciation;

		shift @pieces; #remove element from beginning, which is the target word
		shift @pieces; #remove spacer between target word and pronunciation


		#for my $piece (@pieces){
		#	print $piece . "\n";
		#}

		$pronunciation = join " " , @pieces;


		my $cvcPronunciation = '';

		my @targetLetters = split //, $upper;

		my $letterCounter = 0;
		my $letterBuffer = '';
		my $combo = '';
		my $phoneme = '';
		for my $letter (@targetLetters){

			$letterCounter = $letterCounter + 1;

			if ( $letterBuffer ) {

				$combo = $letterBuffer . $letter;

				if ( $phonemeLookup{ $combo } ){

					$phoneme = $phonemeLookup{ $combo } or '';
					$cvcPronunciation = $cvcPronunciation . $phoneme;

				} else {

					$phoneme = $phonemeLookup{ $letterBuffer } or '';
					$cvcPronunciation = $cvcPronunciation . $phoneme . ' ';
					$phoneme = $phonemeLookup{ $letter } or '';
					$cvcPronunciation = $cvcPronunciation . $phoneme;

				}

				$letterBuffer = '';

			} else {

				if ( $possibleDigraph{ $letter } ){

					$letterBuffer = $letter;
				
				} else {

					$cvcPronunciation = $cvcPronunciation . $phonemeLookup{ $letter };

				}

			}

			if ($letterCounter < length( $upper ) and not $letterBuffer ){
				$cvcPronunciation = $cvcPronunciation . ' ';
			}
		}

		if ( $letterBuffer ){
			$cvcPronunciation = $cvcPronunciation . $phonemeLookup{ $letterBuffer };
			$letterBuffer = '';
		}

		if ( $cvcPronunciation eq $pronunciation ){

			if ($showBoth or not $showMisses){

				if ($showHitPronunciation){ 
					print $upper .' (' . $pronunciation . ', ' . $cvcPronunciation . ')' . "\n";
				} else {
					print $upper . "\n";
				}
			}

			
		} else {
			if ($showMisses or $showBoth){


				print $distinguish . $upper . "(" . $pronunciation . ', ' . $cvcPronunciation . ")\n";
			}
		}



	}

}

# 	my $w = $_;  #store original line (word) of input in another variable so I can digest it
	
# 	my @phonograms = (); 

# 	my $matchFound = 0;

# 	while( length($w) > 0  and $w =~ /\w/ ){
# 		$matchFound = 0;
# 		for my $phonogram (@wordTerminalConstrained){
# 			if ( $w =~ /^$phonogram$/){

# 				if ($phonogram =~ "ed"){
# 					#exclude the case where "ed" follows a single consonant or c-blend
# 					if ( scalar @phonograms > 1 ){
# 						push @phonograms, $phonogram;
# 						$w = "";
# 						$matchFound = 1;
# 					}
# 				} else {
# 					push @phonograms, $phonogram;
# 					$w = "";
# 					$matchFound = 1;
# 				}
# 			}
# 		}

# 		if ($matchFound == 0){
# 			if ($w =~ /^[aeiou][bcdfghjklmnprstvwxz]e/ ){
# 				push @phonograms, substr($w,0,1)."-e";
# 				$w = substr( $w, 1 );
# 				push @phonograms, substr($w,0,1);
# 				$w = substr( $w, 2 );
# 				$matchFound = 1;
# 			}
# 		}

# 		if ( $matchFound == 0 ){
# 			for my $phonogram (@phonogramList){
# 				if ( $w =~ /^$phonogram/ ){
# 					$w = substr( $w, length($phonogram) );
# 					push @phonograms, $phonogram;	
# 					$matchFound = 1;
# 					last;
# 				} 
# 			}
# 		}
# 		if ( $matchFound == 0){
# 			$w = "!!! ".$w;
# 			push @phonograms, $w;
# 			$w = ""
# 		}
# 	}

# 	if ( scalar @phonograms == scalar @pieces ){
# 		for (my $i=0; $i < scalar @phonograms; $i++){
# 			my $phonogram = $phonograms[ $i ];
# 			my $sound = $pieces[ $i ];

# 			$gpc{ $phonogram }{ $sound  } = ( defined($gpc{ $phonogram }{ $sound }) ? $gpc{$phonogram}{$sound} : 0 ) + 1;
# 			$gpc{ $phonogram }{ "total" } = ( defined($gpc{ $phonogram }{ "total" }) ? $gpc{$phonogram}{ "total" } : 0 ) + 1;

# 		}
# 	} else {
# 		my $result = "";
# 		for my $phonogram (@phonograms){
# 			$result = $result . "|" . $phonogram;
# 		}
# 		print "REJECTED " . $_ . "(". $result.") (".$pronunciation.")\n" ;
# 	}

	

# 	my $result = "";
# 	for my $phonogram (@phonograms){
# 		$result = $result . "|" . $phonogram;
# 	}
# 	$result = $result."|";
# 	print $_ . " ----> " . $result . "   (". $pronunciation. ")\n" ;

				
# }

# while( my ($phonogram,$correspondence) = each(%gpc) ){
# 		#my $total = $correspondence{ " total " };
# 		my $total = 0;
# 		while( my ($key,$count) = each( $correspondence ) ){
# 			if ($key ne "total"){
# 				print join(" ",$phonogram,$key,$count,$total)."\n";				
# 			}
# 		}
# }




#Perl string manipulation
#http://web.cs.iastate.edu/~cs596/notes/perl_string_manipulations.html
