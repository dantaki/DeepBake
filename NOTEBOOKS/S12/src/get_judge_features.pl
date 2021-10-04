#!/usr/bin/perl
use strict; use warnings;
use Statistics::Basic qw/median mean/; 

my $WEEK=$ARGV[0]; 

undef my %iid; undef my %place;
open IN, "sample_manifest_s12.tsv";
<IN>;
while(<IN>){
	chomp;
	my @r = split /\t/, $_;
	$iid{$r[0]}{$r[2]}=$r[-1];
	$place{$r[0]}{$r[2]}=$r[-2];
}close IN;

undef my %star; undef my %good; undef my %bad;
undef my %episode;

my @files = ("starbaker_s12_e${WEEK}.csv");

foreach my $f (@files) { 
my $episode=0;
open IN, $f; <IN>;
while(<IN>){
	chomp;
	my ($season,$iid,$index,$episode,$star,$bad,$good) = split /,/, $_;
	next unless(exists $iid{$iid}{$season});
	$star{$season}{$iid}{$episode}=$star;
	$bad{$season}{$iid}{$episode}=$bad;
	$good{$season}{$iid}{$episode}=$good;
	$episode{$season}{$episode}++;
}close IN;
}

undef my %out; 
foreach my $season (sort {$a<=>$b} keys %star){
foreach my $iid (sort keys %{$star{$season}}) {
	undef my %stats; undef my @tot;
	
	foreach my $epi (sort {$a<=>$b} keys %{$episode{$season}}) {
		my $tech = 0;
		$tech  = $star{$season}{$iid}{$epi} if(exists $star{$season}{$iid}{$epi}); 
		push @tot, $tech;
		my @t = @tot; 
		$stats{$epi} = \@t; 
	}
	
	foreach my $epi (sort {$a<=>$b} keys %stats){ 
		my $mean = mean($stats{$epi});
		my $last = ${$stats{$epi}}[-1];
		$mean =~ s/,//g;
		my $k  = join "\t", $season,$iid,$iid{$iid}{$season},$epi;
		$out{$k}{"STAR"}="${mean}\t$last";
	}
}

foreach my $iid (sort keys %{$bad{$season}}) {
	undef my %stats; undef my @tot;
	
	foreach my $epi (sort {$a<=>$b} keys %{$episode{$season}}) {
		my $tech = 0;
		$tech  = $bad{$season}{$iid}{$epi} if(exists $bad{$season}{$iid}{$epi}); 
		push @tot, $tech;
		my @t = @tot; 
		$stats{$epi} = \@t; 
	}
	
	foreach my $epi (sort {$a<=>$b} keys %stats){ 
		my $mean = mean($stats{$epi});
		my $last = ${$stats{$epi}}[-1];
		$mean =~ s/,//g;
		my $k  = join "\t", $season,$iid,$iid{$iid}{$season},$epi;
		$out{$k}{"BAD"}="${mean}\t$last";
	}
}

foreach my $iid (sort keys %{$good{$season}}) {
	undef my %stats; undef my @tot;
	
	foreach my $epi (sort {$a<=>$b} keys %{$episode{$season}}) {
		my $tech = 0;
		$tech  = $good{$season}{$iid}{$epi} if(exists $good{$season}{$iid}{$epi}); 
		push @tot, $tech;
		my @t = @tot; 
		$stats{$epi} = \@t; 
	}
	
	foreach my $epi (sort {$a<=>$b} keys %stats){ 
		my $mean = mean($stats{$epi});
		my $last = ${$stats{$epi}}[-1];
		$mean =~ s/,//g;
		my $k  = join "\t", $season,$iid,$iid{$iid}{$season},$epi;
		$out{$k}{"GOOD"}="${mean}\t$last";
	}
}

}

my $ts = timestamp();
my $o = "deepbake_judge_features_s12_e${WEEK}.tsv";
open OUT, ">$o";
my $feats = "mean_star\tstar\tmean_good\tgood\tmean_bad\tbad";
print OUT "season\tbaker\tindex\tepisode\t${feats}\tplace\n"; 
foreach my $k (sort keys %out){
	my ($season,$iid,$index,$epi)  = split /\t/, $k;
	my $place = $place{$iid}{$season};
	my $star = $out{$k}{"STAR"};
	my $good = $out{$k}{"GOOD"};
	my $bad = $out{$k}{"BAD"};
	print OUT "$k\t$star\t$good\t$bad\t$place\n";

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

