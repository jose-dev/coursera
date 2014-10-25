#!/usr/bin/perl

=head1 NAME

=head1 DESCRIPTION

=head1 USAGE

=cut


use strict;
use warnings;


use Data::Dumper;


my @TO_REMOVE = qw( property person use );

#######################################################################
#######################################################################
#######################################################################


## collect data
my $reviews  = '';
my $rh_names = {};
while (<>) {
    chomp;
    my @a_line  = split(/\t/,$_);
    my $agent   = $a_line[0];
    my $rating  = $a_line[2];
    my $summary = $a_line[4];
    
    next unless $rating > 3;
    
    $reviews .= $summary . "\n";
    $rh_names->{$agent}++;;
}
my $ra_names = [ @TO_REMOVE, map { split(/-/, $_) } keys %{ $rh_names } ];


## remove strings matching the agent names
## and print
foreach my $remove ( @$ra_names ) {
    my $c = () = $reviews =~ /$remove/gi;
    $reviews =~ s/$remove//gi;
}

print $reviews;
