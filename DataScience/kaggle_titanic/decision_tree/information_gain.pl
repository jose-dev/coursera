#!/usr/bin/perl -w
 
use strict;
use warnings;

use DBI;
use Data::Dumper;

my @a_header = ( "VARIABLE", "CLASS", "TOTAL", "SURVIVED", "DIED", "ENTROPY" );
my $dbh = DBI->connect('dbi:mysql:titanic','root','letmein') or die "Connection Error: $DBI::errstr\n";

my ( $total, $survived ) = $dbh->selectrow_array( qq( SELECT COUNT(*), SUM(survived) FROM titanic_train ) );
my $died    = $total - $survived;
my $entropy = entropy( { total => $total, values => [ $survived, $died ] } );

print join( "\t", @a_header ),"\n";
print
    join(
        "\t",
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
        variable => 'sex',
        sql      => qq( SELECT sex AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train GROUP BY sex )
    },
    {
        variable => 'pclass',
        sql      => qq( SELECT pclass AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train GROUP BY pclass )
    },
    {
        variable => 'family',
        sql      => qq( SELECT family AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train GROUP BY family )
    },
    {
        variable => 'under_5s',
        sql      => qq( SELECT under_5s AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train GROUP BY under_5s )
    },
    {
        variable => 'embarked',
        sql      => qq( SELECT embarked AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train WHERE embarked <> '' GROUP BY embarked )
    },
    {
        variable => 'fare_range',
        sql      => qq( SELECT fare_range AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train GROUP BY fare_range )
    },
    {
        variable => 'known_cabin',
        sql      => qq( SELECT known_cabin AS v, COUNT(*) AS no, SUM(survived) AS s FROM titanic_train GROUP BY known_cabin )
    },
];

foreach my $rh_variable ( @$rah_todo ) {
    print join( "\t", @a_header ),"\n";
    my $sth = $dbh->prepare( $rh_variable->{sql} );
    $sth->execute;
    
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

#my $sql = "select * from samples";
#my $sth = $dbh->prepare($sql);
#
#$sth->execute or die "SQL Error: $DBI::errstr\n";
#while (@row = $sth->fetchrow_array) {
#print "@row\n";
#}



############################
############################
############################

sub entropy {
    my $args    = shift;
    my $total   = $args->{total};
    my $ra_vals = $args->{values};
    
    my $sum = 0;
    foreach my $val ( @$ra_vals ) {
        $sum += ( $val / $total ) * log2( $val / $total );
    }
    return sprintf( "%2f", -1 * $sum );
}

sub log2 {
    return log($_[0])/log(2);
}