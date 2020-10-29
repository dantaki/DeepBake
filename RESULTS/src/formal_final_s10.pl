#!/usr/bin/perl
use strict; use warnings;
undef my %probs;
my @files = glob("/Users/tacitus/research/DeepBake/RESULTS/gbbo.techinical.s10.week*.final2.keras.preditions.txt");

#glob("/Users/tacitus/research/DeepBake/RESULTS/gbbo.techinical.s10.e*.keras.preditions.txt");
foreach my $f (@files){
	open IN, $f;
	undef my %col;
	chomp(my $h = <IN>);
	my @h = split /\t/, $h;
	for(my $i=0; $i<scalar(@h); $i++){ $col{$h[$i]}=$i; } 
	while(<IN>){
		chomp;
		my @r = split /\t/, $_;
		#season	baker	episode	place	tech_mean	tech	mean_star	star	mean_good	good	mean_bad	bad	preds	bottom	finalist	top3	fifthseventh	thirdforth
		my $k = join "\t", @r[1..2];
		my $win = $r[$col{"finalist"}];
		my $fin = $r[$col{"top3"}];
		my $thirdforth = $r[$col{"thirdforth"}];
		my $fifthseventh = $r[$col{"fifthseventh"}];
		my $bottom = $r[$col{"bottom"}];
		my $pred = -9;
		$pred=0 if($win > $fin && $win > $thirdforth && $win > $fifthseventh && $win > $bottom);
		$pred=1 if($fin > $win && $fin > $thirdforth && $fin > $fifthseventh && $fin > $bottom);
		$pred=2 if($thirdforth > $win && $thirdforth > $fin && $thirdforth > $fifthseventh && $thirdforth > $bottom);
		$pred=3 if($fifthseventh > $win && $fifthseventh > $fin && $fifthseventh > $thirdforth && $fifthseventh > $bottom);
		$pred=4 if($bottom > $win && $bottom > $fin && $bottom > $thirdforth && $bottom > $fifthseventh);

		my $v = join "\t", $pred,$win,$fin,$thirdforth,$fifthseventh,$bottom;

		$probs{$k}=$v;
	}close IN;
}

my %week = (
    "David"=>10,
    "Alice"=>10,
    "Steph"=>10,
    "Rosie"=>9,
    "Henry"=>8,
    "Michael"=>7,
    "Priya"=>6,
    "Helena"=>5,
    "Michelle"=>5,
    "Phil"=>4,
    "Amelia"=>3,
    "Jamie"=>2,
    "Dan"=>1
);


my %places = (
    "David"=>1,
    "Alice"=>2,
    "Steph"=>2,
    "Rosie"=>3,
    "Henry"=>4,
    "Michael"=>5,
    "Priya"=>6,
    "Helena"=>7,
    "Michelle"=>7,
    "Phil"=>8,
    "Amelia"=>9,
    "Jamie"=>10,
    "Dan"=>11
);

my %pred  = (
	"David"=>0,
    "Alice"=>1,
    "Steph"=>1,
    "Rosie"=>2,
    "Henry"=>2,
    "Michael"=>3,
    "Priya"=>3,
    "Helena"=>3,
    "Michelle"=>3,
    "Phil"=>4,
    "Amelia"=>4,
    "Jamie"=>4,
    "Dan"=>4
);

open IN, "/Users/tacitus/research/DeepBake/RESULTS/gbbo.features.s10.final.tsv";
#"/Users/tacitus/research/DeepBake/RESULTS/gbbo.features.s10.e10.20191104.tsv";
#season	baker	episode	place	tech_mean	tech	mean_star	star	mean_good	good	mean_bad	bad
<IN>;
print "season\tbaker\tweek\ttech_mean\ttech\tstarbaker_mean\tstarbaker\tjudge_fav_mean\tjudge_fav\tjudge_unfav_mean\tjudge_unfav\tplace\tdeepbake_tier\tweek_eliminated\tdeepbake_prediction\twinner_prob\tfinalist_prob\tthird_fourth_prob\tfifth_seventh_prob\teighth_below_prob\n";

while(<IN>)	{
	chomp;
	my @r=  split /\t/, $_;
	my $pre = join "\t", @r[0 ..2, 4 ..11];
	my $k = join "\t", @r[1..2];
	my $place = $places{$r[1]};
	my $pred = $pred{$r[1]};
	my $week = $week{$r[1]};
	my $v = $probs{$k};
	
	print "$pre\t$place\t$pred\t$week\t$v\n";
}close IN;