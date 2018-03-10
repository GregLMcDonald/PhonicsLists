#!/usr/bin/perl

my $htmlOutput = '';

while( <> ){

	$_ =~ s/\n//;
	my $line  = uc $_;

	my @letters = split //, $line;

	my $token = '';
	my $isWord;

	my $letterCounter = 0;

	while( $letterCounter <= $#letters ){

		my $letter = $letters[ $letterCounter ];

		if ( $letter =~ /[[:alpha:]]/ ){

			if ($token){

				if ( $isWord ){

					$token = $token . $letter;

				} else {

					print("|$token|\n");  

					$htmlOutput = $htmlOutput . $token;

					$token = $letter;
					$isWord = 1;

				}

			} else {

				$token = $letter;
				$isWord = 1;

			}



		} else {


			#check for apostrophe special case
			
			# if ( $letter ~= /’\'/ and $letterCounter < $#letters ){ 

			# 	if ($token){

			# 		if ( $isWord ){

			# 			my $nextLetter = $letters[ $letterCounter + 1];
			# 			if ( $nextLetter =~ /[STD]/ ){

			# 				$token = $token . $letter . $nextLetter;
			# 				$letterCounter = $letterCounter + 1;

			# 			} else {


			# 				print("")


			# 			}

			# 		} else {

			# 			$token = $token . $letter;

			# 		}


			# 	} else {

			# 		$token = $letter;
			# 		$isWord = 0;

			# 	}



			# } else {




			# }

			if ($token){

				if ( $isWord ){

					print("--------- $token\n");

					$htmlOutput = $htmlOutput . '<span>' . $token . '</span>';

					$token = $letter;
					$isWord = 0;


				} else {

					$token = $token . $letter;

				}


			} else {

				$token = $letter;
				$isWord = 0;

			}

		}

		$letterCounter = $letterCounter + 1;

	}

	if ($token){

		if ($isWord){
			$htmlOutput = $htmlOutput . '<span>' . $token . '</span>';
			print("--------- $token\n");
		} else {
			$htmlOutput = $htmlOutput . $token ;
			print("|$token|\n");
		}
	}

	$htmlOutput = $htmlOutput . "\n";
	#print( $htmlOutput );

}


