#!/usr/bin/perl
use strict; use warnings;
use Statistics::Basic qw/median mean/; 

undef my %iid; undef my %place;
open IN, "sample_manifest_s13.tsv";
<IN>;
while(<IN>){
	chomp;
	my @r = split /\t/, $_;
	$iid{$r[0]}{$r[2]}=$r[-1];
	$place{$r[0]}{$r[2]}=$r[-2];
}close IN;

undef my %tech;
undef my %episode;

my @files = qw/episodes_s13.txt/;

foreach my $f (@files) { 
my $season = $f; $season =~ s/episodes\_s//; $season =~ s/\.txt//;
warn "[$season]\n"; 
my $episode=0;
my $baker=0;
open IN, $f;
while(<IN>){
	chomp;
	if($_ =~ /=== Episode [1-9]/){
		my @a = split /:/, $_;
		$episode = $a[0]; 
		$episode =~ s/=== Episode //;
	}
	if ($_ =~ /! scope="row"/){ #($_ =~ /^\|align=\"left\"/){
		my @row = split /\|/, $_;
		my $iid = $row[-1];
		$iid =~ s/[ '\.]//g;
		$baker = $iid if (exists $iid{$iid});
		#print "$iid\t$baker\n";
	}
	if ($_ =~ /align="center"/ && $baker ne "0") { #{($_ =~ /^\|\d+[a-z]/ && $baker ne "0"){
		my $tech = $_;
		my @row = split /\|/, $_;
		$tech = $row[-1];
		#$tech =~ s/\|//;
		$tech =~ s/[a-z]//g;
		
		$tech = 0 if ($_ =~ /Did not compete/); 

		$episode{$season}{$episode}++; 
		$tech{$season}{$baker}{$episode}=$tech;
	}
	
}close IN;
}


my $ts = timestamp();
my $o = "deepbake_s13_technical_features.tsv";
open OUT, ">$o";
print OUT "season\tbaker\tindex\tepisode\ttech_mean\ttech_med\ttech\tplace\n"; 
foreach my $season (sort {$a<=>$b} keys %tech){
foreach my $iid (sort keys %{$tech{$season}}) {
	undef my %stats; undef my @tot;
	
	foreach my $epi (sort {$a<=>$b} keys %{$episode{$season}}) {
		my $tech = 0;
		$tech  = $tech{$season}{$iid}{$epi} if(exists $tech{$season}{$iid}{$epi}); 
		push @tot, $tech;
		my @t = @tot; 
		$stats{$epi} = \@t; 
	}
	
	foreach my $epi (sort {$a<=>$b} keys %stats){ 
		#my $len = scalar(@{$stats{$epi}});
		my $mean = mean($stats{$epi});
		my $med = median($stats{$epi});
		my $last = ${$stats{$epi}}[-1];
		$mean =~ s/,//g; $med =~ s/,//g;

		print OUT "$season\t$iid\t$iid{$iid}{$season}\t$epi\t$mean\t$med\t$last\t$place{$iid}{$season}\n"; 
	}
}
}
close OUT; 
warn "   output ---> $o\n"; 
##################################
use Time::localtime qw(localtime);
sub timestamp {
  my $t = localtime;
  return sprintf( "%04d%02d%02d",
                  $t->year + 1900, $t->mon + 1, $t->mday);
}

