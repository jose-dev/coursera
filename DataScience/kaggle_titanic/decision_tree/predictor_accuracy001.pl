#!/usr/bin/perl -w
 
use strict;
use warnings;

use DBI;
use Data::Dumper;

my $dbh = DBI->connect('dbi:mysql:titanic','root','letmein') or die "Connection Error: $DBI::errstr\n";

my $sql = qq( SELECT * FROM titanic_train ORDER BY id );
my $sth = $dbh->prepare( $sql );
$sth->execute;

my ( $A, $B, $C, $D ) = ( 0, 0, 0, 0 );
while ( my $rh_row = $sth->fetchrow_hashref ) {
    my $sex    = $rh_row->{sex};
    my $pclass = $rh_row->{pclass};
    my $family = $rh_row->{family};
    my $age    = $rh_row->{under_5s};
    my $survived = 0;
    if ( $sex eq 'female' ) {
        if ( $pclass == 3 ) {
            $survived = 1 unless $family;
        }
        else {
            $survived = 1; 
        }
    }
    else {
        $survived = 1 if $age;
    }
    
    if ( $survived == $rh_row->{survived} ) {
        if ( $survived ) {
            $A++;
        }
        else {
            $D++;
        }
    }
    else {
        if ( $survived ) {
            $C++;
        }
        else {
            $B++;
        }
    }
}


print
    Dumper
        {
            A => $A,
            B => $B,
            C => $C,
            D => $D,
            accuracy => sprintf( "%.01f", 100 * ( $A + $D ) / ( $A + $B + $C + $D ) )
        };
