#!/usr/bin/perl -w
 
use strict;
use warnings;

use DBI;
use Data::Dumper;
use Text::CSV;
use IO::File;

my $dbh = DBI->connect('dbi:mysql:titanic','root','letmein') or die "Connection Error: $DBI::errstr\n";

my @a_header = ( "sex", "pclass", "family", "under_5s", "embarked", "fare_range" );
my $basesql =
    qq(
        SELECT __SURVIVED__
               CASE
                  WHEN sex = 'female' THEN '0'
                  ELSE '1'
                END AS sex,
               pclass,
               family,
               under_5s,
               CASE
                  WHEN embarked = 'C' THEN '1'
                  WHEN embarked = 'C' THEN '2'
                  ELSE '3'
                END AS embarked,
               CASE
                  WHEN fare_range = 'cheap'   THEN '1'
                  WHEN fare_range = 'regular' THEN '2'
                  ELSE '3'
                END AS fare_range
          FROM __TABLENAME__
          ORDER BY id
    );

my $rah_outputs = [
    {
        outfile     => 'train.csv',
        survived    => "survived,",
        table_name  => 'titanic_train',
        params      => [ "survived", @a_header ],
    },
    {
        outfile     => 'test.csv',
        survived    => "",
        table_name  => 'titanic_test',
        params      => [ @a_header ],
    },
];

my $csv = Text::CSV->new ( { binary => 1 } ) || die "Cannot use CSV: ".Text::CSV->error_diag ();
                 
foreach my $rh_in ( @$rah_outputs ) {
    my $outfile     = $rh_in->{outfile};
    my $survived    = $rh_in->{survived};
    my $table_name  = $rh_in->{table_name};
    my $ra_params   = $rh_in->{params};
    
    my $sql = $basesql;
    $sql =~ s/__TABLENAME__/$table_name/;
    $sql =~ s/__SURVIVED__/$survived/;
    
    my $fh = IO::File->new( "> $outfile" ) or die "cannot open file to write: $!";
    die "undefined file" unless defined $fh;
    
    $csv->combine( @$ra_params );    
    $fh->print( $csv->string(),"\n" ) || die "failed printing: $!";
 
    my $sth = $dbh->prepare( $sql );
    $sth->execute;
    while ( my $rh_row = $sth->fetchrow_hashref ) {
        $csv->combine(  @{ $rh_row }{ @$ra_params } );    
        $fh->print( $csv->string(),"\n" ) || die "failed printing: $!";
    }
    
    $fh->close || die "can close: $!";
}
