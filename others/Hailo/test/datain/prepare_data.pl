=comment

    Removed two dates for which there were no jobs recorded (missing data):
    
        2013-01-22,0,"Dry",5
        2013-07-09,0,"Dry",18
        
    
    Renamed rainfall into three consitent categorical values:
    
        'Dry'        => 1,
        'Light Rain' => 2,
        'Heavy Rain' => 3,




=cut




use warnings;
use strict;

use DateTime;
use Text::CSV;
use DateTime::Format::HTTP;


my $rh_rainfall = {
    'Dry'        => 1,
    'Light Rain' => 2,
    'Heavy Rain' => 3,
};



my $o_csv = Text::CSV->new();

my @a_header =
    qw(
        day_of_week
        week
        week_year
        month
        quarter
        rain_code
        temp_code
    );
my $header = 1;
while(<>) {
    chomp;
    if ( $o_csv->parse($_) ) {
        my @a_line = $o_csv->fields();
        
        my @a_line2print = ();
        if ( $header ) {
            @a_line2print = ( @a_line, @a_header );
            $header = 0;
        }
        else {
            ## parse date
            my $o_dt = DateTime::Format::HTTP->parse_datetime( $a_line[0] );
            my $dw = $o_dt->day_of_week();
            my $w  = $o_dt->week();
            my $wy = $o_dt->week_year();
            my $mm = $o_dt->month();
            my $q  = $o_dt->quarter();
            
            ## number of jobs
            my $no_jobs = $a_line[1];
            next unless $no_jobs > 0;
            
            # rainfall data
            my $rainfall = $a_line[2];
            $rainfall = "Light Rain" if ( $rainfall eq "LightRain" );
            $rainfall = "Heavy Rain" if ( $rainfall eq "Very Heavy Rain" );
            my $rain_code = $rh_rainfall->{$rainfall};
            
            # temperature
            my $T = $a_line[3];
            my $tc = 'Mild';
            if ( $T > 20 ) {
                $tc = 'Warm';
            }
            elsif ( $T < 5 ) {
                $tc = 'Cold';
            }
             
            @a_line2print =
                (
                    $o_dt->ymd,
                    $no_jobs,
                    $rainfall,
                    $T,
                    $dw,
                    $w ,
                    $wy,
                    $mm,
                    $q,
                    $rain_code,
                    $tc
                );

        }
        
        if ( $o_csv->combine(@a_line2print) ) {
            print $o_csv->string(),"\n";
        }
        else {
            die "cannot print";
        }
    }
    else {
        die "file has wrong format: $_"
    }
}


