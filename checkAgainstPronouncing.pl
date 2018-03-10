#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Getopt::Long;
#use feature 'switch';
#use experimental;




my $x; 
my $i;

my $verbose = '';
my $help = '';
my $level = 1;
GetOptions ( 'verbose' => \$verbose, 
	'help' => \$help,
 );

if ($help){
	print "\nOptions for checkAgainstPronouncing are:\n\n";
	print "--verbose\n";
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


my @gpcTables;

#Level 1
push @gpcTables, {
	'A' => [ 'AE1', 'AH0' ], # APPLE; ADHERE
	'B' => 'B',
	'BB' => 'B',
	'C' => 'K',
	'CC' => 'K',
	'D' => 'D',
	'DD' => 'D',
	'E' => 'EH1',
	'F' => 'F',
	'FF' => 'F',
	'G' => 'G',
	'GG' => 'G',
	'H' => 'HH',
	'I' => [ 'IH1', 'IH2', 'IH0' ],
	'J' => 'JH',
	'K' => 'K',
	'L' => 'L',
	'LL' => 'L',
	'M' => 'M',
	'MM' => 'M',
	'N' => 'N',
	'NN' => 'N',
	'O' => [ 'AA1', 'AO1' ],
	'P' => 'P',
	'PP' => 'P',
	'Q'	=> 'K',
	'R' => 'R',
	'RR' => 'R',
	'S' => 'S',
	'SS' => 'S',
	'T' => 'T',
	'TT' => 'T',
	'U' => 'AH1',
	'V' => 'V',
	'VV' => 'V',
	'W' => 'W',
	'X' => 'K S',
	'Y' => 'Y',
	'Z' => 'Z',
	'ZZ' => 'Z',
	};

#Level 2
push @gpcTables, {
	'CH' => 'CH',
	'SH' => 'SH',
	'TH' => [ 'TH', 'DH' ],  # THIN, THEN
	'WH' => 'W',
	'CK' => 'K',
	'NG' => 'NG',
	'NK' => 'NG K',
	'QU' => 'K W',
	};

#Level 3
push @gpcTables, {
	'PH' => 'F',
	'ABE' => 'EY1 B',
	'ADE' => 'EY1 D',
	'AKE' => 'EY1 K',
	'ALE' => 'EY1 L',
	'AME' => 'EY1 M',
	'ANE' => 'EY1 N',
	'APE' => 'EY1 P',
	'ASE' => 'EY1 S',
	'ATE' => 'EY1 T',
	'AVE' => 'EY1 V',
	'AZE' => 'EY1 Z',
	'IBE' => 'AY1 B',
	'IDE' => 'AY1 D',
	'IFE' => 'AY1 F',
	'IKE' => 'AY1 K',
	'ILE' => 'AY1 L',
	'IME' => 'AY1 M',
	'INE' => 'AY1 N',
	'IPE' => 'AY1 P',
	'IRE' => 'AY1 ER0',
	'ITE' => 'AY1 T',
	'IVE' => 'AY1 V',
	'IZE' => 'AY1 Z',
	'EME' => 'IY1 M',
	'ENE' => 'IY1 N',
	'ERE' => ['IH1 R', 'IY1 R'], # ADHERE, 
	'OBE' => 'OW1 B',
	'ODE' => 'OW1 D',
	'OLE' => 'OW1 L',
	'OME' => 'OW1 M',
	'ONE' => 'OW1 N',
	'OPE' => 'OW1 P',
	'ORE' => [ 'OW1 R', 'AO1 R' ], # ?; BEFORE
	'OSE' => 'OW1 S', # CLOSE as in 'That was a close call!'
	'OTE' => 'OW1 T',
	'OZE' => 'OW1 Z',
	'UBE' => 'UW1 B',
	'UDE' => 'UW1 D',
	'UKE' => 'Y UW1 K',
	'ULE' => 'Y UW1 L',
	'UME' => 'Y UW1 M',
	'UNE' => 'UW1 N',
	'URE' => ['Y UW1 R', 'Y UH1 R' ],
	'UTE' => [ 'Y UW1 T', 'UW1 T' ],  #CUTE, LUTE
	};

#Level 4
push @gpcTables, {
	'ALL' => 'AO1 L',
	'ULL' => 'UH1 L', #must add to level 4 on website  ADD?
	'OLL' => 'OW1 L', #must add to level 4 on website  ADD?
	'ING' => 'IH1 NG G',
	'ER' => [ 'ER1', 'ER0' ],
	'ERR' => [ 'ER1', 'ER0' ],
	'AR' => 'AA1 R',
	'ARR' => 'AA1 R',
	'OR' => 'AO1 R',
	'ORR' => 'AO1 R',
	'IR' => 'ER1',
	'IRR' => 'ER1',
	'UR' => 'ER1',
	'URR' => 'ER1',
	'WAR' => 'W AO1 R',
	'WOR' => 'W ER1',
	'WA' => 'W AA1',
	
	};

#Level 5
push @gpcTables, {
	'E' => 'IY1', # BE (open syllables)   ADD?
	'O' => 'OW1', # SO (open syllable)    ADD?
	'EE' => 'IY1',   # SEEN
	'EA' => ['IY1', 'IH1'], # ?; NEAR
	'EY' => 'IY1',
	'AI' => 'EY1',
	'AY' => 'EY1',
	'OA' => 'OW1',
	'OW' => ['OW1', 'OW0'],
	'IGH' => 'AY1',
	'IE' => 'AY1',
	'EW' => 'UW1',
	'UE' => 'UW1',
	};

#Level 6
push @gpcTables, {
	'Y' => [ 'AY1', 'IY0', 'IH1'  ],
	'OU' => 'AW1',
	'OW' => 'AW1',
	'OO' => [ 'UW1', 'UH1' ], # TOO; BOOK
	'OI' => 'OY1',
	'OY' => 'OY1',
	'AY' => 'EY1',    # DAY   ADD?
	'EY' => 'IY1',    # KEY   ADD?
	'UY' => 'AY1',    # BUY   ADD?
	'AU' => 'AO1',
	'AW' => 'AO1',
	'LE' => 'AH0 L',
	'A' => 'EY1', #TABLE  ADD? --- open syllable
	'I' => 'AY1', #TINY  ADD?  --- open syllable
	'E' => [ 'IY0', 'IY1' ], # CREATE, DESIGN   ADD? ---- open syllable
	};

#Level 7
# soft s, g; air, are, ear, oar, tch, dge
push @gpcTables, {
	'C' => 'S',
	'ACE' => 'EY1 S',
	'ICE' => 'AY1 S',
	'UCE' => 'UW1 S',
	'G' => 'JH',
	'AGE' => 'EY1 JH',
	'UGE' => 'Y UW1 JH',
	'IGE' => 'AY1 JH',
	'AIR' => ['AH1 R', 'EH1 R'],
	'ARE' => 'AH1 R',
	'ARE' => 'EH1 R', # BARE  ADD?
	'EAR' => 'EH1 R', # BEAR  
	'OAR' => 'AO1 R',
	'EA' => 'EH1',
	'TCH' => 'CH',
	'DGE' => 'JH',
	};

#Level MORPH  (8)     ------------- WHERE DO THESE GO????
push @gpcTables, {
	'OULD' => 'UH1 D',
	'AUGH' => 'AE1 F', # LAUGH
	'OUGH' => [ 'AH1 F', 'OW1', 'UW1', 'AO1'], # TOUGH, ROUGH; THOUGH; THROUGH; BROUGHT
	'FUL' => 'F AH0 L', # PEACEFUL
	'ED' => [ 'T', 'D', 'AH0 D' ], # ASKED; FIRED; STARTED
	'ENT' => 'AH0 N T', # DIFFERENT
	'IGN' => 'AY1 N', # SIGN
	
};

#Level COSMIC (9)    ------------- WHERE DO THESE GO????
push @gpcTables, {
	'OSE' => 'OW1 Z', # CLOSE as in 'Close the door, please.'
	'ISE' => 'AY1 Z',
	'USE' => [ 'Y UW1 Z', 'Y UW1 S' ], 
	'KN' => 'N',
	'WR' => 'R',
	'S' => 'Z',
	'EIR' => 'EH1 R', # THEIR
	'OME' => 'AH1 M', # COME, SOME
	'CE' => 'S', # PEACE
	'SE' => ['Z', 'S'], # PLEASE; HOUSE
	'EE' => 'IH1', # BEEN (rhymes with SIN )
	'EA' => 'EY1', # GREAT
	'OO' => 'UW1', # TOO
	'OVE' => 'UW1 V', # MOVE
	'IND' => 'AY1 N D', # KIND, MIND, WIND ("wind the clock", not "who has seen the wind?")
	'OE' => [ 'OW1', 'UW1' ], # TOE, FOE; SHOE
	'ERE' => 'EH1 R', #WHERE, THERE
	'FRO' => 'F R AH1', # for FROM
	'CH' => 'K', # SCHOOL, CHASM, CHRISTMAS
	'SM' => 'Z AH0 M',
	'E' => 'IH0', # DESIGN ---- open syllable
	'A' => 'AO1', # WATER
	'SC' => 'S', #SCENE
	'OUR' => 'AW1 ER0', #OUR, SOUR
	'OOR' => 'AO1 R', #FLOOR, DOOR
	'EW' => 'Y UW1', #PEW, FEW
	'OU' => 'UW1', # YOU
	'EY' => 'EY1', # THEY
	'OUR' => 'AO1 R', #YOUR, FOUR
	'H' => '', # HOUR, HERB   -------- silent initial H
	'GU' => 'G', # GUIDE
	'GE' => 'JH', # STOOGE, --- soft g is level 7
	'A' => ['AA1', 'AO1'], # FATHER; WATER
	'O' => 'AH1', # MOTHER,
	'EN' => 'AH0 N', # CHILDREN, OFTEN
};

#Level SPECIAL (10)
push @gpcTables, {
	'TO' => 'T UW1',
	'THE' => 'DH AH0',
	'AND' => 'AH0 N D',
	'A' => 'AH0',
	'AS' => 'AE1 Z',
	'WAS' => 'W AA1 Z',
	'SHE' => 'SH IY1',
	'HE' => 'HH IY1',
	'OF' => 'AH1 V',
	'ARE' => 'AA1 R',
	'WHAT' => 'W AH1 T',  # WHAT
	'SAID' => 'S EH1 D',  # SAID 
	'HAVE' => 'HH AE1 V', # HAVE
	'TWO' => 'T UW1', # TWO
	'ONE' => 'W AH1 N', # ONE
	'WERE' => 'W ER1', #WERE
	'INTO' => 'IH1 N T UW0', #INTO
	'DO' => 'D UW1', #DO
	'WHO' => 'HH UW1', # WHO
};


my %letterTypeLookup = (
	'A' => 'V',
	'B' => 'C',
	'C' => 'C',
	'D' => 'C',
	'E' => 'V',
	'F' => 'C',
	'G' => 'C',
	'H' => 'C',
	'I' => 'V',
	'J' => 'C',
	'K' => 'C',
	'L' => 'C',
	'M' => 'C',
	'N' => 'C',
	'O' => 'V',
	'P' => 'C',
	'Q' => 'C',
	'R' => 'C',
	'S' => 'C',
	'T' => 'C',
	'U' => 'V',
	'V' => 'C',
	'W' => 'C',
	'X' => 'C',
	'Y' => 'C',
	'Z' => 'C',
	);

my %levelByWordTemplate = (
	'VC' => 1,
	'CV' => 2,
	'CVC' => 1,
	'CCVC' => 1,
	'CCVCC' => 2,
	'CVCC' => 2,
	);



while( <> ) {

	# while( 0 ) {

	# Using <> means the file specified on the command line line-by-line or STDIN line-by-line or wait for user input


	$_ =~ s/\n//; #strips the newline off the line

	my $upper = uc $_; #converts to upper case, this is the TARGET WORD

	my ($pronunciation)= $pronouncingDico =~ /^($upper\ +[\ \w]*$)/mg;  #looks up word in pronouncing dictionary

	my @pieces;

	if ($pronunciation){

		#In the CMU pronunciation dictionary, entries are formatted as word followed by a list of phonemes: WORD AA AA AA AA...

		@pieces = split /\ /, $pronunciation;

		shift @pieces; #remove element from beginning, which is the target word (already have it in $upper)
		shift @pieces; #remove spacer between target word and pronunciation

		$pronunciation = join " " , @pieces; #reconnects the pieces of pronunciation
		my $partialPronunciation = '';
		my $highestLevelUsed = 1;


		#Check the table of special words first
		my $lookupSpecials = 1;
		my $specialFound = 0;
		my @matches = lookupGPC( $upper, $lookupSpecials );
		if ( @matches ){
			my $res = $matches[ 0 ];
		 	$partialPronunciation = $res->[0];
		 	$highestLevelUsed = 10;
		 	$specialFound = 1;

		 	if ($verbose){
		 		print(" ++++ $upper is special: $partialPronunciation\n");
		 	}
		}





		my @targetLetters = split //, $upper; #splits the target word into an array of letters
		my $i = 0;
		my $doNotLookupSpecial = 0;
		while ( $specialFound == 0 and $i <= $#targetLetters ){# $#ARRAYNAME gives index of last element of array

			my $matchFound = 0;


			#check for FOUR letter matches starting here (eg W + OULD )
			if ( $i + 3 <= $#targetLetters ){

				my $s = $targetLetters[$i] . $targetLetters[ $i + 1 ] . $targetLetters[ $i + 2] . $targetLetters[ $i + 3];
				
				if ($verbose){
					print( "4  $s\n");
				}

				my @matches = lookupGPC( $s, $doNotLookupSpecial );
				if ( @matches ){

					for my $j ( 0 .. $#matches ) {
	

						if (not $matchFound) {

							my $res = $matches[ $j ];
		 					my $pronunciationFrag = $res->[0];
		 					if ($verbose){
		 							print("   4 $pronunciationFrag\n");
		 						}
		 					my $level = $res->[1];

		 					my $testPronunciation = $partialPronunciation . $pronunciationFrag;

		 					if ($verbose){
		 							print("       |$testPronunciation|   |$pronunciation|\n");
		 					}



		 					if ( $pronunciation =~ /\A$testPronunciation/ ){

		 						if ($pronunciation eq $testPronunciation) {
		 							$partialPronunciation = $testPronunciation;
		 						} else {
		 							$partialPronunciation = $testPronunciation . ' ';
		 						}

		 						if ($verbose){
		 							print("$partialPronunciation\n");
		 						}

		 						$matchFound = 1;
		 						$i = $i + 4;
		 						if ($level > $highestLevelUsed){
		 							$highestLevelUsed = $level;
		 						}

		 					}

						}


					} 

				}
			}


			#check for THREE letter matches starting here
			if ( $i + 2 <= $#targetLetters ){

				my $s = $targetLetters[$i] . $targetLetters[ $i + 1 ] . $targetLetters[ $i + 2];
				
				if ($verbose){
					print( "3  $s\n");
				}

				my @matches = lookupGPC( $s, $doNotLookupSpecial  );
				if ( @matches ){

					for my $j ( 0 .. $#matches ) {
	

						if (not $matchFound) {

							my $res = $matches[ $j ];
		 					my $pronunciationFrag = $res->[0];
		 					if ($verbose){
		 							print("   3 $pronunciationFrag\n");
		 						}
		 					my $level = $res->[1];

		 					my $testPronunciation = $partialPronunciation . $pronunciationFrag;

		 					if ($verbose){
		 							print("       |$testPronunciation|   |$pronunciation|\n");
		 					}



		 					if ( $pronunciation =~ /\A$testPronunciation/ ){

		 						if ($pronunciation eq $testPronunciation) {
		 							$partialPronunciation = $testPronunciation;
		 						} else {
		 							$partialPronunciation = $testPronunciation . ' ';
		 						}

		 						if ($verbose){
		 							print("$partialPronunciation\n");
		 						}

		 						$matchFound = 1;
		 						$i = $i + 3;
		 						if ($level > $highestLevelUsed){
		 							$highestLevelUsed = $level;
		 						}

		 					}

						}


					} 

				}
			}

			#check for TWO letter matches starting here
			if ( $matchFound == 0  and $i + 1 <= $#targetLetters ){

				my $s = $targetLetters[$i] . $targetLetters[ $i + 1 ];

				if ($verbose){
					print( "2  $s\n");
				}

				my @matches = lookupGPC( $s, $doNotLookupSpecial  );
				if ( @matches ){

					for my $j ( 0 .. $#matches ) {
	

						if ( not $matchFound) {

							my $res = $matches[ $j ];
		 					my $pronunciationFrag = $res->[0];
		 					if ($verbose){
		 							print("   2 $pronunciationFrag\n");
		 						}
		 					
		 					my $level = $res->[1];

		 					my $testPronunciation = $partialPronunciation . $pronunciationFrag;
		 					if ( $pronunciation =~ /\A$testPronunciation/ ){

		 						if ($pronunciation eq $testPronunciation) {
		 							$partialPronunciation = $testPronunciation;
		 						} else {
		 							$partialPronunciation = $testPronunciation . ' ';
		 						}

								if ($verbose){
		 							print("$partialPronunciation\n");
		 						}


		 						$matchFound = 1;
		 						$i = $i + 2;
		 						if ($level > $highestLevelUsed){
		 							$highestLevelUsed = $level;
		 						}

		 					}

						}


					} 

				}
			}

			#check for match on current letter
			if ( $matchFound == 0 	){

				my $s = $targetLetters[$i];

				if ($verbose){
					print( "1  $s\n");
				}

				my @matches = lookupGPC( $s, $doNotLookupSpecial  );
				if ( @matches ){

					for my $j ( 0 .. $#matches ) {
	

						if (not $matchFound) {

							my $res = $matches[ $j ];
		 					my $pronunciationFrag = $res->[0];
		 					if ($verbose){
		 							print("   1 $pronunciationFrag\n");
		 						}
		 					
		 					my $level = $res->[1];

		 					my $testPronunciation = $partialPronunciation . $pronunciationFrag;
		 					if ( $pronunciation =~ /\A$testPronunciation/ ){

		 						if ($pronunciation eq $testPronunciation) {
		 							$partialPronunciation = $testPronunciation;
		 						} else {
		 							$partialPronunciation = $testPronunciation . ' ';
		 						}


		 						if ($verbose){
		 							print("$partialPronunciation\n");
		 						}

		 						$matchFound = 1;
		 						$i = $i + 1;
		 						if ($level > $highestLevelUsed){
		 							$highestLevelUsed = $level;
		 						}

		 					}

						}


					} 

				}
			}

			if ( not $matchFound ){

				$partialPronunciation = '';
				$i = $#targetLetters + 1;
			}

		}

		if ($partialPronunciation){
			#print( "$upper    $pronunciation     $partialPronunciation  $highestLevelUsed\n");
			my $levelLabel = $highestLevelUsed;

			# for( $highestLevelUsed ){

			# 	when ( 10 ) { $levelLabel = 'SPECIAL' }
			# 	when ( 9 )  { $levelLabel = 'MORPH' }
			# 	when ( 8 ) { $levelLabel = 'COSMIC???' }
			# 	default { $levelLabel = $highestLevelUsed }
			# }
			if ( $highestLevelUsed == 10 ){
				$levelLabel = 'SPECIAL';
			}
			if ( $highestLevelUsed == 9 ){
				$levelLabel = 'COSMIC???';
			}
			if ( $highestLevelUsed == 8 ){
				$levelLabel = 'MORPH';
			}



			print( "$upper   #$levelLabel\n");
		} else {
			print( "---------------------------  $upper   $pronunciation\n");
		}
		#print( "$upper   $highestLevelUsed\n");
	} else {
		print( "///////////////////////////  pronunciation of $upper not found\n");
	}


}


# Takes a GRAPHEME as sole argument and returns PHONEME or ARRAY OR PHONEMES and LEVEL or nil and -1 if not found
sub lookupGPC {
	
	my ( $grapheme, $lookupSpecials ) = @_; #all the args to the subroutine are in internal var @_ and each sub has its own

	my @phonemes;
	my $gpcResults = '';
	my $level = 0;

	my $startIndex = 0;
	my $endIndex = 8;

	if ($lookupSpecials == 1){
		$startIndex = 9;
		$endIndex = 9;
	}

	for (my $i = $startIndex; $i <= $endIndex; $i++) {
		
		$level = $i + 1;
		my %table = %{ $gpcTables[ $i ] };


		$gpcResults = $table{ $grapheme };
		if ( $gpcResults ){

			if (ref( $gpcResults ) eq 'ARRAY'){

				for my $result ( @$gpcResults ){
					my @tempArray = ( $result, $level );
					push @phonemes, [ @tempArray ] ;
				}

			} else {

				my @result = ( $gpcResults, $level );
				push @phonemes, [ @result ];
			}
		}
		$gpcResults = '';

	}

	return ( @phonemes );
}




#Perl string manipulation
#http://web.cs.iastate.edu/~cs596/notes/perl_string_manipulations.html
