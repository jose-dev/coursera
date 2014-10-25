#!/usr/bin/perl

=head1 NAME

=head1 DESCRIPTION

=head1 USAGE

=cut


use strict;
use warnings;


use Data::Dumper;
use Text::CSV;
use List::Util qw( sum );



#######################################################################
#######################################################################
#######################################################################


## collect data
my $rh_data = {};
while (<>) {
    chomp;
    my @a_line = split(/\t/,$_);
    my @a_fields = map{ $a_line[$_] } 0 .. 2;
    if ( $a_fields[1] =~ /^(\d+)-(\d+)/ ) {
        next unless $1 >= 2012;
        my $y  = $1;
        my $ym = join("-", $1, $2);
        push @{ $rh_data->{$a_fields[0]}->{y}->{$y} }, $a_fields[2];
        push @{ $rh_data->{$a_fields[0]}->{ym}->{$ym} }, $a_fields[2];
    }
}



## calculate average rating and print
{
    my $o_csv = Text::CSV->new( { binary => 1 } ) || die "Cannot use CSV: " . Text::CSV->error_diag();
 
    if ( $o_csv->combine( qw( agent type period yyyy avg_rating ) ) ) {
        my $line = $o_csv->string;
        print $line,"\n"; 
    }
    else {
        die "could not format into CSV";
    }
   
    foreach my $agent ( sort keys %{ $rh_data } ) {
        foreach my $type ( qw( y ym ) ) {
            foreach my $period ( sort keys %{ $rh_data->{$agent}->{$type} } ) {
                my $yyyy = ( $period =~ /^(\d+)/ ) ? $1 : '';
                my $s   = sum( @{ $rh_data->{$agent}->{$type}->{$period} } );
                my $avg = $s / scalar @{ $rh_data->{$agent}->{$type}->{$period} };
                
                if ( $o_csv->combine( ( $agent, $type, $period, $yyyy, $avg ) ) ) {
                    my $line = $o_csv->string;
                    print $line,"\n"; 
                }
                else {
                    die "could not format into CSV";
                }
            }
        }
    }
}



