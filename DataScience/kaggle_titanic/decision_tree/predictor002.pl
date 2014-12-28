#!/usr/bin/perl -w
 
use strict;
use warnings;

use DBI;
use Data::Dumper;

my $dbh = DBI->connect('dbi:mysql:titanic','root','letmein') or die "Connection Error: $DBI::errstr\n";

my $sql = qq( SELECT * FROM titanic_test ORDER BY id );
my $sth = $dbh->prepare( $sql );
$sth->execute;

while ( my $rh_row = $sth->fetchrow_hashref ) {
    my $sex    = $rh_row->{sex};
    my $pclass = $rh_row->{pclass};
    my $family = $rh_row->{family};
    my $age    = $rh_row->{under_5s};
    my $survived = 0;
    if ( $sex eq 'female' ) {
        unless ( $pclass == 3 ) {
            $survived = 1; 
        }
    }
    else {
        $survived = 1 if $age;
    }
    
    print $survived,"\n";
}

