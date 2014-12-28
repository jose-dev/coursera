#!/usr/bin/perl -w
 
use strict;
use warnings;

use DBI;
use Data::Dumper;
use IO::File;

my $outfile = 'predicted_combined.csv';
my $rh_filein = {
    female => 'predicted_female.csv',
    male   => 'predicted_male.csv',
};
my $rh_data = {};
foreach my $type ( keys %$rh_filein ) {
    my $filein = $rh_filein->{$type};
    my $fh = IO::File->new( "< $filein" ) or die "cannot open file to read: $!";
    die "undefined file" unless defined $fh;
    
    while ( my $line = $fh->getline ) {
        chomp( $line );
        push @{ $rh_data->{$type} }, ( split(",",$line) )[0];
    }
}


my $dbh = DBI->connect('dbi:mysql:titanic','root','letmein') or die "Connection Error: $DBI::errstr\n";
my $sql = qq( SELECT sex FROM titanic_test ORDER BY id );
my $sth = $dbh->prepare( $sql );
$sth->execute;

my $fh = IO::File->new( "> $outfile" ) or die "cannot open file to write: $!";
die "undefined file" unless defined $fh;

while ( my $rh_row = $sth->fetchrow_hashref ) {
    my $sex      = $rh_row->{sex};
    my $value = pop( @{ $rh_data->{$sex} } );
    $fh->print( "$value\n" ) || die "cannot print: $!";
}

