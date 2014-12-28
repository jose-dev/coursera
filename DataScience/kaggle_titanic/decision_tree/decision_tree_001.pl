#!/usr/bin/perl -w
 
use strict;
use warnings;

use DBI;
use Data::Dumper;

my @a_header = ( "PARENT_VARIABLE", "PARENT_CLASS", "VARIABLE", "CLASS", "TOTAL", "SURVIVED", "DIED", "ENTROPY" );
my $dbh = DBI->connect('dbi:mysql:titanic','root','letmein') or die "Connection Error: $DBI::errstr\n";

my $parent_variable = 'sex';
my $parent_sql      = qq( SELECT sex AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train GROUP BY sex );

my $sth = $dbh->prepare( $parent_sql );
$sth->execute;

while ( my $rh_parent_row = $sth->fetchrow_hashref ) {
    my $parent_class = $rh_parent_row->{v};
    my $total        = $rh_parent_row->{no};
    my $survived     = $rh_parent_row->{s};
    my $died         = $total - $survived;
    my $entropy      = entropy( { total => $total, values => [ $survived, $died ] } );

    print join( "\t", @a_header ),"\n";
    print
        join(
            "\t",
            $parent_variable,
            $parent_class,
            "SURVIVAL",
            "ALL",
            $total,
            $survived,
            $died,
            sprintf( "%.03f", $entropy ),
        ),"\n";
    print "\n";
    
    my $rah_todo = [
        {
            variable => 'pclass',
            sql      => qq( SELECT pclass AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train WHERE sex = ? GROUP BY pclass )
        },
        {
            variable => 'family',
            sql      => qq( SELECT family AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train WHERE sex = ? GROUP BY family )
        },
        {
            variable => 'under_5s',
            sql      => qq( SELECT under_5s AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train WHERE sex = ? GROUP BY under_5s )
        },
        {
            variable => 'embarked',
            sql      => qq( SELECT embarked AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train WHERE sex = ? AND embarked <> '' GROUP BY embarked )
        },
        {
            variable => 'fare_range',
            sql      => qq( SELECT fare_range AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train WHERE sex = ? GROUP BY fare_range )
        },
        {
            variable => 'known_cabin',
            sql      => qq( SELECT known_cabin AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train WHERE sex = ? GROUP BY known_cabin )
        },
    ];
    
    foreach my $rh_variable ( @$rah_todo ) {
        print join( "\t", @a_header ),"\n";
        my $sth = $dbh->prepare( $rh_variable->{sql} );
        $sth->execute( $parent_class );
        
        my $sub_entropy = 0;
        while ( my $rh_row = $sth->fetchrow_hashref ) {
            my $class        = $rh_row->{v};
            my $sub_total    = $rh_row->{no};
            my $sub_survived = $rh_row->{s};
            my $sub_died     = $sub_total - $sub_survived;
            next if $sub_total == 0;
            
            $sub_entropy += ( $sub_total / $total ) * entropy( { total => $sub_total, values => [ $sub_survived, $sub_died ] } );
            
            print
                join(
                    "\t",
                    $parent_variable,
                    $parent_class,
                    $rh_variable->{variable},
                    $class,
                    $sub_total,
                    $sub_survived,
                    $sub_died,
                    sprintf( "%.03f", $sub_entropy ),
                ),"\n";
        }
        
        my $ne = sprintf( "%.03f", $sub_entropy );
        my $ig = sprintf( "%.03f", $entropy - $sub_entropy );
    
        print
            join(
                "\t",
                "",
                "",
                "",
                "Overall Entropy",
                $ne,
            ),"\n";
    
        print
            join(
                "\t",
                "",
                "Information Gain",
                $ig,
            ),"\n";
    
        print "\n";
    }
}



############################
############################
############################

sub entropy {
    my $args    = shift;
    my $total   = $args->{total};
    my $ra_vals = $args->{values};
    
    my $sum = 0;
    foreach my $val ( @$ra_vals ) {
        next unless $val;
        $sum += ( $val / $total ) * log2( $val / $total );
    }
    return sprintf( "%2f", -1 * $sum );
}

sub log2 {
    return log($_[0])/log(2);
}