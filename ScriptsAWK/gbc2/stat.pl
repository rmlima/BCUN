use strict;
use warnings;

# Import stdev, average, mean and other statistical functions
# A copy of http://search.cpan.org/~brianl/Statistics-Lite-3.2/Lite.pm
do('stats.pl');

my %page_runtimes;
my $delimitor = ';';
my @columns = ("page", "samples", "min", "max", "mean", "mode", "median", "stddev\n");
my $line;
my $first_timestamp, my $last_timestamp;

# ==========================================
# Parse log file
# ==========================================

#
# Don't use foreach as it reads the whole file into memory: foreach $line (<>) { 
#
while ($line=<>) {
  # remove the newline from $line, otherwise the report will be corrupted.
  chomp($line);

  my @columns               = split(';', $line);
  my $timestamp             = $columns[0];
  my $page_name             = $columns[1];
  my $page_runtime          = $columns[2];

  if(!defined($first_timestamp))
  {
    $first_timestamp = $timestamp;
  }

  # print what we find
  if(!defined(@{$page_runtimes{$page_name}}))
  {
    print "Found page '$page_name'\n";
  }
 
  # add page runtimes to one hash
  push(@{$page_runtimes{$page_name}}, $page_runtime);
 
  $last_timestamp = $timestamp;
}

# ==========================================
# Calculate and print page statistics
# ==========================================
open(PAGE_REPORT, ">report.csv") or die("Could not open report.csv.");

print PAGE_REPORT "First sample\n".$first_timestamp."\nLast sample\n".$last_timestamp."\n\n";
print PAGE_REPORT join($delimitor, @columns);

for my $page_name (keys %page_runtimes )
{
  my @runtimes = @{$page_runtimes{$page_name}};
 
  my $samples = @runtimes;
  my $min     = min(@runtimes);
  my $max     = max(@runtimes);
  my $mean    = mean(@runtimes);
  my $mode    = mode(@runtimes);
  my $median  = median(@runtimes);
  my $stddev  = stddev(@runtimes);
 
  my @data = ($page_name, $samples, $min, $max, $mean, $mode, $median, $stddev);
 
  my $line = join($delimitor, @data);
 
  # Use comma instead of decimal
  $line =~ s/\./\,/g;
 
  print PAGE_REPORT "$line\n";
}
close(PAGE_REPORT);
