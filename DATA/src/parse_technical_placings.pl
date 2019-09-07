#!/usr/bin/perl
use strict; use warnings;
use Statistics::Basic qw/median mean/; 

undef my %iid; undef my %place;
open IN, "../RESULTS/sample.manifest.20190907.tsv";
<IN>;
while(<IN>){
	chomp;
	my @r = split /\t/, $_;
	$iid{$r[0]}{$r[2]}=$r[-1];
	$place{$r[0]}{$r[2]}=$r[-2];
}close IN;

undef my %tech;
undef my %episode;

my @files = glob("episodes.s*.txt");

foreach my $f (@files) { 
my $season = $f; $season =~ s/episodes\.s//; $season =~ s/\.txt//;
warn "[$season]\n"; 
my $episode=0;
open IN, $f;
while(<IN>){
	chomp;
	if($_ =~ /=== Episode [1-9]/){
		my @a = split /:/, $_;
		$episode = $a[0]; 
		$episode =~ s/=== Episode //;
	}
	next unless($_ =~ /\|\|/);
	$_ =~ s/^\| //;
	my @r = split /\|\|/, $_;
	my $iid = $r[0]; 
	$iid =~ s/\s//g; 	
	next unless(exists $iid{$iid}{$season});
      	next if(! defined $r[2]);
	my $tech = $r[2];
	$tech =~ s/\s//g; $tech =~ s/[a-z]//g;
	$tech =~ s/[\=\-\:\;\"\"\|\{\}]//g; $tech =~ s/N\/A/0/;
	$episode{$season}{$episode}++; 
	$tech{$season}{$iid}{$episode}=$tech;

}close IN;
}

my $ts = timestamp();
my $o = "../RESULTS/gbbo.techinical.data.${ts}.tsv";
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
		#print "$iid\t$epi\t$len\n"; 
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

