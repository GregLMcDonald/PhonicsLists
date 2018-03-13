#!/usr/bin/perl

use strict;
use warnings;
use 5.010;

use Getopt::Long;
use Data::Dumper;
$Data::Dumper::Indent   = 1;
#use feature 'switch';
#use experimental;




my $x; 
my $i;

my $verbose = '';
my $help = '';
my $maxLevel = 0;
my $ignore = '';
my $debugFlag = '';
GetOptions ( 'verbose' => \$verbose, 
	'help' => \$help,
	'debug' => \$debugFlag,
	'max=i' => \$maxLevel,
	'ignore=s' => \$ignore,
 );

if ($help){
	print "\nOptions for checkAgainstPronouncing are:\n\n";
	print "--verbose\n";
	print "--help        Prints this message\n";
	print "\n";
	exit;
}

my %wordsToIgnore;
if ($ignore){


	my $filename = $ignore;
	open(my $fh, '<:encoding(UTF-8)', $filename)
  		or die "Could not open file '$filename' $!";
 
	while (my $row = <$fh>) {
  		chomp $row;
  		$wordsToIgnore{ uc $row } = 1;
	}

	# foreach my $word ( @wordsToIgnore ){
	# 	print("--- $word \n");
	# }


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
my @pgcTables;

#Level 1
push @gpcTables, {
	'A' => [ 'AE0', 'AE1', 'AE2'], # APPLE; ADHERE
	'B' => 'B',
	'BB' => 'B',
	'C' => 'K',
	'CC' => 'K',
	'D' => 'D',
	'DD' => 'D',
	'E' => ['EH0','EH1','EH2'], # EGG
	'F' => 'F',
	'FF' => 'F',
	'G' => 'G',
	'GG' => 'G',
	'H' => 'HH',
	'I' => [ 'IH1', 'IH2', 'IH0' ], #IGLOO
	'J' => 'JH',
	'K' => 'K',
	'L' => 'L',
	'LL' => 'L',
	'M' => 'M',
	'MM' => 'M',
	'N' => 'N',
	'NN' => 'N',
	'O' => [ 'AA1', 'AO1' ], #ON
	'P' => 'P',
	'PP' => 'P',
	'R' => 'R',
	'RR' => 'R',
	'S' => 'S',
	'SS' => 'S',
	'T' => 'T',
	'TT' => 'T',
	'U' => ['AH0', 'AH1', 'AH2'], #UP
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
	'S' => 'Z', #PALS
	};

#Level 3
push @gpcTables, {
	'PH' => 'F',
	'ABE' => ['EY0 B','EY1 B','EY2 B'],
	'ADE' => ['EY0 D','EY1 D','EY2 D'],
	'AFE' => ['EY0 F','EY1 F','EY2 F'],
	'AKE' => ['EY0 K','EY1 K','EY2 K'],
	'ALE' => ['EY0 L','EY1 L','EY2 L'],
	'AME' => ['EY0 M','EY1 M','EY2 M'],
	'ANE' => ['EY0 N','EY1 N','EY2 N'],
	'APE' => ['EY0 P','EY1 P','EY2 P'],
	'ASE' => ['EY0 S','EY1 S','EY2 S'],
	'ATE' => ['EY0 T','EY1 T','EY2 T'],
	'AVE' => ['EY0 V','EY1 V','EY2 V'],
	'AZE' => ['EY0 Z','EY1 Z','EY2 Z'],
	'IBE' => ['AY0 B','AY1 B','AY2 B',],
	'IDE' => ['AY0 D','AY1 D','AY2 D',],
	'IFE' => ['AY0 F','AY1 F','AY2 F',],
	'IKE' => ['AY0 K','AY1 K','AY2 K',],
	'ILE' => ['AY0 L','AY1 L','AY2 L',],
	'IME' => ['AY0 M','AY1 M','AY2 M',],
	'INE' => ['AY0 N','AY1 N','AY2 N',],
	'IPE' => ['AY0 P','AY1 P','AY2 P',],
	'IRE' => 'AY1 ER0',
	'ITE' => ['AY0 T','AY1 T','AY2 T',],
	'IVE' => ['AY0 V','AY1 V','AY2 V',],
	'IZE' => ['AY0 Z','AY1 Z','AY2 Z',],
	'EDE' => 'IY1 D',
	'EME' => 'IY1 M',
	'ENE' => 'IY1 N',
	'ERE' => ['IH1 R', 'IY1 R'], # ADHERE, 
	'ETE' => 'IY1 T', #DEPLETE
	'EZE' => 'IY1 Z', #TRAPEZE	
	'OBE' => 'OW1 B',
	'ODE' => 'OW1 D',
	'OKE' => 'OW1 K',
	'OLE' => 'OW1 L',
	'OME' => 'OW1 M',
	'ONE' => 'OW1 N',
	'OPE' => 'OW1 P',
	'ORE' => [ 'OW1 R', 'AO1 R' ], # ?; BEFORE
	'OSE' => 'OW1 S', # CLOSE as in 'That was a close call!'
	'OTE' => 'OW1 T',
	'OVE' => 'OW1 V',
	'OZE' => 'OW1 Z',
	'UBE' => 'UW1 B',
	'UDE' => 'UW1 D',
	'UKE' => 'Y UW1 K',
	'ULE' => 'Y UW1 L',
	'UME' => ['Y UW1 M','UW1 M'],
	'UNE' => 'UW1 N',
	'UPE' => 'UW1 P',
	'URE' => ['Y UW1 R', 'Y UH1 R' ],
	'UTE' => [ 'Y UW1 T', 'UW1 T' ],  #CUTE, LUTE
	};

#Level 4
push @gpcTables, {
	'ALL' => 'AO1 L',
	'ULL' => 'UH1 L', #must add to level 4 on website  ADD?
	'OLL' => 'OW1 L', #must add to level 4 on website  ADD?
	'ING' => 'IH1 NG G', #FINGER
	'ER' => [ 'ER1', 'ER0', 'ER2' ],  # all R-controlled vowels?  ADD?
	'ERR' => [ 'ER1', 'ER0', 'ER2' ],
	'AR' => ['AA0 R','AA1 R','AA2 R'],
	'ARR' => ['AA0 R','AA1 R','AA2 R'],
	'OR' => ['AO0 R','AO1 R','AO2 R'],
	'ORR' => ['AO0 R','AO1 R','AO2 R'],
	'IR' => ['ER0','ER1','ER2',],
	'IRR' => ['ER0','ER1','ER2',],
	'UR' => ['ER0','ER1','ER2',],
	'URR' => ['ER0','ER1','ER2',],
	'WAR' => 'W AO1 R',
	'WARR' => 'W AO1 R',
	'WOR' => 'W ER1',
	'WORR' => 'W ER1',
	'WA' => ['W AA1', 'W AO1'],
	
	};

#Level 5
push @gpcTables, {
	
	'EE' => ['IY0','IY1','IY2'],   # SEEN
	'EA' => ['IY0', 'IY1','IY2','IH1'], # ?; NEAR
	'EY' => ['IY0','IY1','IY2'],    # KEY   ADD?
	'AI' => ['EY0','EY1','EY2'],
	'AY' => ['EY0','EY1','EY2'],
	'OA' => ['OW0','OW1','OW2'],
	'OW' => ['OW1', 'OW0','OW2'],
	'IGH' => ['AY0','AY1','AY2'],
	'IE' => ['AY0','AY1','AY2'], #PIE
	'EW' => ['UW0','UW1','UW2'],
	'UE' => ['UW0','UW1','UW2'],
	};

#Level 6
push @gpcTables, {
	'Y' => [ 'AY0','AY1','AY2', 'IY0','IY1','IY2', 'IH0', 'IH1', 'IH2'  ], # FLY; HAPPY; SYLLABLE
	'OU' => ['AW0','AW1','AW2'],
	'OW' => ['AW0','AW1','AW2'],
	'OO' => [ 'UW0','UW1','UW2', 'UH0','UH1','UH2' ], # TOO; BOOK
	'OI' => ['OY0','OY1','OY2'],
	'OY' => ['OY0','OY1','OY2'],
	'AY' => ['EY0','EY1','EY2'],    # DAY   ADD?
	'UY' => ['AY0','AY1','AY2'],    # BUY   ADD?
	'AU' => ['AO0','AO1','AO2'],
	'AW' => ['AO0','AO1','AO2'],
	'LE' => 'AH0 L',
	'A' => ['EY0','EY1','EY2'], #TABLE  ADD? --- open syllable
	'I' => ['AY0','AY1','AY2'], #TINY  ADD?  --- open syllable
	'E' => [ 'IY0', 'IY1', 'IY2' ], # CREATE, DETAIL, BE  ADD? ---- open syllable
	'O' => ['OW0','OW1','OW2'], # SO (open syllable)    ADD?
	'U' => ['Y UW1'],
	};

#Level 7
# soft s, g; air, are, ear, oar, tch, dge
push @gpcTables, {
	'C' => 'S',
	'ACE' => ['EY0 S','EY1 S','EY2 S'],
	'ICE' => ['AY0 S','AY1 S','AY2 S'],
	'UCE' => ['UW0 S','UW1 S','UW2 S'],
	'G' => 'JH', # RAGE
	'AGE' => ['EY0 JH','EY1 JH','EY2 JH'],
	'UGE' => ['Y UW0 JH','Y UW1 JH','Y UW2 JH'],
	'IGE' => ['AY0 JH','AY1 JH','AY2 JH'],
	'AIR' => ['AH0 R', 'AH1 R','AH2 R', 'EH0 R','EH1 R','EH2 R'],
	'ARE' => 'AH1 R',
	'ARE' => ['EH0 R','EH1 R','EH2 R'], # BARE  ADD?
	'EAR' => ['EH0 R','EH1 R','EH2 R', 'ER0','ER1','ER2'], # BEAR; LEARN  
	'OAR' => ['AO0 R','AO1 R','AO2 R'],
	'EA' => ['EH0','EH1','EH2'],
	'TCH' => 'CH',
	'DGE' => 'JH',
	};

#Level MORPH  (8)     ------------- WHERE DO THESE GO????
push @gpcTables, {
	'OULD' => 'UH1 D',
	'AUGH' => 'AE1 F', # LAUGH
	'OUGH' => [ 'AH1 F', 'OW1', 'UW1', 'AO1'], # TOUGH, ROUGH; THOUGH; THROUGH; BROUGHT
	'FUL' => 'F AH0 L', # PEACEFUL
	'ED' => [ 'T', 'D', 'AH0 D', 'IH0 D' ], # ASKED; FIRED; STARTED; DECIDED
	'ENT' => 'AH0 N T', # DIFFERENT
	'IGN' => 'AY1 N', # SIGN
	'TION' => ['CH AH0 N','SH AH0 N'], #QUESTION; STATION
	'SION' => ['ZH AH0 N'], #VISION, INVASION
	
};

#Level COSMIC (9)    ------------- WHERE DO THESE GO????
push @gpcTables, {
	'A' => ['AA1', 'AO1', 'EH1','AH0','AH1','AH2'], # FATHER; WATER; MANY; ADHERE
	'AI' => ['AH0','AH1','AH2'], #CERTAIN schwa
	'CE' => 'S', # PEACE
	'CH' => 'K', # SCHOOL, CHASM, CHRISTMAS
	'CQU' => 'K W', #ACQUIRE
	'E' => [ 'AH0','AH1','AH2', 'IH0' ] , #TRAVEL schwa; DESIGN
	'EA' => 'EY1', # GREAT
	'EE' => 'IH1', # BEEN (rhymes with SIN )
	'EIR' => 'EH1 R', # THEIR
	'EN' => 'AH0 N', # CHILDREN, OFTEN
	'EO' => 'IY1', # PEOPLE
	'ERE' => 'EH1 R', #WHERE, THERE
	'EW' => 'Y UW1', #PEW, FEW
	'EY' => 'EY1', # THEY
	'FRO' => 'F R AH1', # for FROM
	'GE' => 'JH', # STOOGE, --- soft g is level 7
	'GH' => 'G', # GHOST
	'GU' => 'G', # GUIDE'OSE' => 'OW1 Z', # CLOSE as in 'Close the door, please.'
	# 'H' => '', # HOUR, HERB   -------- silent initial H
	'I' => ['AH0','AH1','AH2'],
	'IE' => ['IY0','IY1','IY2'], #ACTIVITIES, BUNNIES
	'IND' => 'AY1 N D', # KIND, MIND, WIND ("wind the clock", not "who has seen the wind?")
	'ISE' => 'AY1 Z',
	'IVE' => 'IH1 V', # GIVE
	'KN' => 'N',
	'O' => [ 'AH0','AH1','AH2' ], #MOTHER, #PERSON schwa
	'OE' => [ 'OW1', 'UW1' ], # TOE, FOE; SHOE
	'OME' => 'AH1 M', # COME, SOME
	'OO' => ['UW1','UW1','UW1','AH0','AH1','AH2'], # TOO; BLOOD
	'OOR' => 'AO1 R', #FLOOR, DOOR
	'OU' => 'UW1', # YOU
	'OUR' => ['AW1 ER0', 'AO1 R'], #OUR, SOUR; YOUR, FOUR
	'OUS' => ['AH0 S','AH1 S','AH2 S'], #ACRIMONIOUS
	'OVE' => ['UW1 V','AH1 V'], # MOVE; LOVE
	'SC' => 'S', #SCENE
	'SE' => ['Z', 'S'], # PLEASE; HOUSE
	'SM' => 'Z AH0 M',
	'ST' => 'S', # LISTEN
	'TU' => ['CH UW0'], #ACCENTUATE
	'U' => 'UH1', # PUT
	'USE' => [ 'Y UW1 Z', 'Y UW1 S' ], 
	'WR' => 'R',
};

#Level SPECIAL (10)
push @gpcTables, {
	'TO' => 'T UW1',
	'THE' => 'DH AH0',
	'AND' => 'AH0 N D',
	'A' => 'AH0',
	'AS' => 'AE1 Z',
	'WAS' => 'W AA1 Z',
	#'SHE' => 'SH IY1',
	#'HE' => 'HH IY1',
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

my %wordShapes = (
	'VC' => 1,
	'VCC' => 1,
	'CVC' => 1,
	'CCVC' => 1, # lookup tables will exclude digraphs 
	'CVCC' => 1,
	'CV' => 2, #open syllable
	'CCVCC' => 2,
	'CCCVC' => 2,
	'CCCVCC' => 2,
	'CCCVCCC' => 2,
	'CVVC' => 2, #for QU--
	);



sub buildPGC {

	my $startIndex = 0;
	my $endIndex = 9;

	for (my $i = $startIndex; $i <= $endIndex; $i++) {

		my %pgc;

		my %gpcTable = %{ $gpcTables[ $i ] };

		keys %gpcTable; # reset the internal iterator so a prior each() doesn't affect the loop

		#Loop over all graphemes to create empty array in PGC hash table for each phoneme
		while( my($grapheme, $phonemes) = each %gpcTable) {

			if (ref( $phonemes ) eq 'ARRAY'){

				for my $phoneme ( @$phonemes ){
					
					$pgc{ $phoneme } = [];
					
				}

			} else {

				$pgc{ $phonemes } = [];
				
			}
		}

		#Loop over all graphemes again to add grapheme to grapheme set for all the phonemes to
		#which it corresponds
		while( my($grapheme, $phonemes) = each %gpcTable) {

			if (ref( $phonemes ) eq 'ARRAY'){

				for my $phoneme ( @$phonemes ){
					
					push $pgc{ $phoneme }, $grapheme;
					
				}

			} else {

				push $pgc{ $phonemes }, $grapheme;
				
			}


		}

		# print Dumper \%pgc;


		# while( my($p, $gSet) = each %pgc) {

		# 	my $gString = join ",", @$gSet;
		# 	print("$p:    $gString\n");


		# }

		push @pgcTables, { %pgc };

		# if ($i == 9){
		# 	print Dumper $pgcTables[$i];	
		# }
		

		# print( ref $pgcTables[ 0 ] . "\n");


	}



}
buildPGC();

my $wordCount = 0;

while( <> ) {

	$_ =~ s/\n//; #strips the newline off the line

	if ( $_ =~ /\@\@\@\@(.*)/ ){
		#print("$1\n");
		next;
	}



	my $targetWord = uc $_; #converts to upper case, this is the TARGET WORD


	if ( $wordsToIgnore{ $targetWord } and $wordsToIgnore{ $targetWord } == 1 ){
		#print("ignoring $targetWord\n");
		next;
	}

	$wordCount = $wordCount + 1;
	if (( $wordCount % 1000 ) == 0){
		print STDERR '.';
	}


	my @letters = split("", $targetWord );
	my $wordShape = "";
	for my $letter ( @letters ){
		my $letterType = $letterTypeLookup{ $letter };
		if ( $letterType ){
			$wordShape = $wordShape . $letterType;
		}
	}
	my $levelByWordShape;
	if ( $wordShapes{ $wordShape } ){
		$levelByWordShape = $wordShapes{ $wordShape };
	} else {

		$levelByWordShape = 3;
	}


	my ($pronunciation)= $pronouncingDico =~ /^($targetWord\ +[\ \w]*$)/mg;  #looks up word in pronouncing dictionary

	if ($pronunciation){

		#In the CMU pronunciation dictionary, entries are formatted as word followed by a list of phonemes: WORD AA AA AA AA...
		my @pieces;
		@pieces = split /\ /, $pronunciation;

		shift @pieces; #remove element from beginning, which is the target word (already have it in $upper)
		shift @pieces; #remove spacer between target word and pronunciation

		my $s = join " " , @pieces;
		my $nPieces = scalar @pieces;

		#Now we have:
		#  1) the $targetWord 
		#  2) the $pronunciation of that word in standard American English from the CMU pronunciation dictionary
		#  3) @pieces, an array containing the individual phoneme codes from the pronunciation

		my $level = lookupSpelling( '', $targetWord, @pieces );

		if ( $level > 0 ){
			# found a level
			if ($levelByWordShape > $level){
				$level = $levelByWordShape;
			}

		}


		if ( $maxLevel > 0){


			my $prefix = "";
			my $postfix = "";

			my $levelName = "$level";

			if ( $level > 0 ){
				if ($level > $maxLevel){

					if ($level == 10){
						$prefix = ".......... ";
						$levelName = "SPECIAL";
					}
					if ($level == 9){
						$prefix = "~~~~~~~~~~~~~~~~~ ";
						$levelName = " CLARIFY";
						#$postfix = "  $pronunciation";
					}
					print("$prefix$targetWord,$levelName$postfix\n");

				}
				
			} else {
				my $p = join " ", @pieces;
				print("------------------------------ $targetWord,  $p\n");
			}



		} else {

			my $prefix = "";
			my $postfix = "";

			my $levelName = "$level";

			if ( $level > 0 ){
				if ($level == 10){
					$prefix = ".......... ";
					$levelName = "SPECIAL";
				}
				if ($level == 9){
					$prefix = "~~~~~~~~~~~~~~~~~ ";
					$levelName = "CLARIFY";
					#$postfix = "  $pronunciation";
				}
				print("$prefix$targetWord,$levelName$postfix\n");
			} else {
				my $p = join " ", @pieces;
				print("------------------------------ $targetWord,  $p\n");
			}

		}

	} else {
		print("****************************** NOT IN DICTIONARY: $targetWord\n");
	}
}


sub lookupSpelling {

	my $debug = $debugFlag;

	my ( $partialSpelling, $targetWord, @pieces ) = @_;   #  LEARNING PERL all the args to the subroutine are in internal var @_ and each sub has its own

	my $result = -1 ; # if -1, then no spellings found, otherwise is the lowest level from which spellings were used to build the $targetWord with this pronunciation

	
	my $MAX_NB_PHONEMES_PER_SPELLING = 4;
	my $maxNbPhonemesToExamine = $MAX_NB_PHONEMES_PER_SPELLING;
	
	if ( scalar @pieces < $maxNbPhonemesToExamine ){  # LEARNING PERL an array in SCALAR context returns its number of elements
		$maxNbPhonemesToExamine = scalar @pieces;
	}

	for ( my $nPhonemes = 1; $nPhonemes <= $maxNbPhonemesToExamine; $nPhonemes++ ){

		my $levelForThisPhonemeSetLength = -1;

		my @piecesCopy = @pieces; # LEARNING PERL: in Perl, this copies the array (in other language it would be a pointer/reference)
		
		# Build the phoneme set of length #nPhonemes
		# @piecesCopy will be left with remaining, unused phonemes
		my $phonemeSet = '';
		for (my $i=1; $i <= $nPhonemes; $i++){

			my $phoneme = shift @piecesCopy; # LEARNING PERL shift takes off first element and shortens remaining array by one; pop takes from the back
			$phonemeSet = $phonemeSet . $phoneme;
			if ($i < $nPhonemes){
				$phonemeSet = $phonemeSet . ' ';
			}
		}

		if ( $debug ) { print( "|$phonemeSet|\n"); }


		my $startIndex = 0;
		my $endIndex = 9;

		for (my $pgcTableIndex = $startIndex; $pgcTableIndex <= $endIndex; $pgcTableIndex++){

			my $levelOfThisTable = $pgcTableIndex + 1;
			my %table = %{ $pgcTables[ $pgcTableIndex ] };

			my $pgcCandidates = $table{ $phonemeSet };
			if ( $pgcCandidates ) {

				if ( $debug ) { print( ($levelOfThisTable) . "       " . ( join " ",@$pgcCandidates ) . "\n"); }

				#Loop over these candidate spellings for the current phoneme set
				my $skipRemainingCandidates = 0;
				for my $candidate ( @$pgcCandidates ){

					if ( $skipRemainingCandidates ){  next; }

					if ( $debug ) { print("candidate  $candidate\n"); }

					my $testSpelling = $partialSpelling . $candidate;

					if ( $debug ) { print("test spelling $testSpelling\n")};

					if ( $targetWord =~ /\A$testSpelling/ ){ #target word begins with test spelling


						if ( $debug ) { print("Test spelling OK: $testSpelling\n"); }

						if ( ( $testSpelling eq $targetWord ) and ( scalar @piecesCopy == 0 ) ){

							if ( $debug ) { print( "------ STOP CONDITIONS SATISFIED\n") }

							$levelForThisPhonemeSetLength = $levelOfThisTable; 
							$pgcTableIndex = $endIndex + 1; #don't bother looking at higher level tables for this phonemeSet length
							$skipRemainingCandidates = 1;

						} else {

							my $sublevel = lookupSpelling( $testSpelling, $targetWord, @piecesCopy );
							
							if ($sublevel > 0){

								# a spelling that completed the word and used the remaining sounds was found

								$pgcTableIndex = $endIndex + 1; #don't bother looking at higher level tables for this phonemeSet length

								if ($sublevel > $levelOfThisTable){

									if ($levelForThisPhonemeSetLength == -1){
										$levelForThisPhonemeSetLength = $sublevel;

									} else {
										if ($sublevel < $levelForThisPhonemeSetLength){
											$levelForThisPhonemeSetLength = $sublevel;
										}
									}

								} else {

									if ($levelForThisPhonemeSetLength == -1){
										$levelForThisPhonemeSetLength = $levelOfThisTable;
									} else {
										if ($levelOfThisTable < $levelForThisPhonemeSetLength){
											#print(" SET result to $level (sublevel <= level)\n");
											$levelForThisPhonemeSetLength = $levelOfThisTable;
										}
									}

								}

							}

						}
					}
				}
			}
		}


		if ($levelForThisPhonemeSetLength > 0){

			# A solution was for this phoneme set length

			if ( $result < 0 ){
				$result = $levelForThisPhonemeSetLength;
			} else {
				if ( $levelForThisPhonemeSetLength < $result ){
					$result = $levelForThisPhonemeSetLength;
				}
			}
		}

	}



	return $result;
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
