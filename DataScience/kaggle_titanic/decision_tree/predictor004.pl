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
    my $sex      = $rh_row->{sex};
    my $pclass   = $rh_row->{pclass};
    my $embarked = $rh_row->{embarked};
    my $age      = $rh_row->{under_5s};
    my $survived = 0;
    if ( $sex eq 'female' ) {
        if ( $pclass == 3 ) {
            $survived = 1 if $embarked eq 'C' || $embarked eq 'Q';
        }
        else {
            $survived = 1; 
        }
    }
    else {
        unless ( $pclass == 3 ) {
            $survived = 1 if $age;
        }
    }
    
    print $survived,"\n";
}

