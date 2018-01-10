#!/usr/bin/perl -w

use strict;
use warnings;
use Data::Dumper;

my $tab       = " ";
my $hash      = {};

sub average
{
  my($data) = @_;
  if (not @$data) { die("Empty arrayn"); }
  my $total = 0;
  foreach (@$data) {
    $total += $_;
  }
  my $average = $total / @$data;
  return $average;
}

sub stdev
{
  my($data) = @_;
  if(@$data == 1) { return 0; }
  my $average = &average($data);
  my $sqtotal = 0;
  foreach(@$data) 
  {
    $sqtotal += ($average-$_) ** 2;
  }
  my $std = ($sqtotal / (@$data-1)) ** 0.5;
  return $std;
}


sub main()
{
  my $ficDados  = $ARGV[0];
  my $ficFinal  = $ARGV[1];
  
  open(DADOS, $ficDados) or die("Could not open  file.");
  
  foreach my $line (<DADOS>)
  {
    my @tmp = split(' ', $line);
    if ( exists($hash->{$tmp[2]}->{"data"}) )
    {
      push(@{$hash->{$tmp[2]}->{"data"}}, $tmp[1]);
    }
    else { $hash->{$tmp[2]}->{"data"} = [ $tmp[1] ] ; }
  }
  #print Data::Dumper->Dump([$hash], [qw(hash)]);
  
  close(DADOS);
  
  open(my $fh, '>', $ficFinal);
  foreach my $key (sort {$a <=> $b} keys %$hash)
  {
    $hash->{$key}->{"avg"}    = average( \@{$hash->{$key}->{"data"}} );
    $hash->{$key}->{"stdev"}  = stdev( \@{$hash->{$key}->{"data"}} );
    
    print $fh $key . $tab . $hash->{$key}->{"avg"} . $tab . $hash->{$key}->{"stdev"} . "\n";
  }
  close $fh;
  #print Data::Dumper->Dump([$hash], [qw(hash)]);
  
  
}
main();
