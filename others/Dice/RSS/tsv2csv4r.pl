#!/usr/bin/perl

=head1 NAME

=head1 DESCRIPTION

=head1 USAGE

=cut


use strict;
use warnings;


use Data::Dumper;
use Text::CSV;



#######################################################################
#######################################################################
#######################################################################

my $o_csv = Text::CSV->new( { binary => 1 } ) || die "Cannot use CSV: " . Text::CSV->error_diag();


while (<>) {
    chomp;
    my @a_line = split(/\t/,$_);
    my @a_fields = map{ $a_line[$_] } 0 .. 2;
    if ( $a_fields[1] =~ /^(\d+)-(\d+)/ ) {
        push @a_fields, $1, join("-", $1, $2);
    }
    else {
        push @a_fields, 'yyyy', 'yyyymm';
    }
    
    
    if ( $o_csv->combine( @a_fields ) ) {
        my $line = $o_csv->string;
        print $line,"\n"; 
    }
    else {
        die "could not format into CSV";
    }
}




