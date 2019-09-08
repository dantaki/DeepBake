#!/usr/bin/perl
use strict; use warnings;
open IN, $ARGV[0];
my $switch=0;
my $buff="";
while(<IN>){
	chomp;
	if($_ !~ /^\|/) { print $_,"\n";}
	else {
		$buff = "${buff}|$_ ";
		if($_ =~ /\|\-/ || $_ =~ /\|\}/ ){ $switch++;}

		if($switch==2){
			$buff =~ s/align="left"\|/ /;
			$buff =~ s/align="center"\|/ /;
			$buff =~ s/^\|\|/\|/;
			print "$buff\n";
			$buff="";
			$switch=1;
		}

	}

}close IN;