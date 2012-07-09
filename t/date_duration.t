#!perl -T

package Foo;

use Moose;
use MooseX::Types::Date::Piece;

has 'duration_days' => (
    is  => 'ro',
    isa => 'Date::Piece::Duration',
    coerce => 1,
);

has 'duration_weeks' => (
    is  => 'ro',
    isa => 'Date::Piece::Duration',
    coerce => 1,
);

has 'duration_months' => (
    is  => 'ro',
    isa => 'Date::Piece::Duration',
    coerce => 1,
);

has 'duration_years' => (
    is  => 'ro',
    isa => 'Date::Piece::Duration',
    coerce => 1,
);

package main;

use Test::More;
use Test::Fatal;

my $f;

$f = Foo->new(
    duration_days   => '1day',
    duration_weeks  => '2weeks',
    duration_months => '3 month',
    duration_years  => '4 YEAR',
);

ok( $f->duration_days->isa('Date::Piece::day_unit') );
ok( $f->duration_weeks->isa('Date::Piece::week_unit') );
ok( $f->duration_months->isa('Date::Piece::month_unit') );
ok( $f->duration_years->isa('Date::Piece::year_unit') );

ok( ${$f->duration_days}    == 1 );
ok( ${$f->duration_weeks}   == 2 );
ok( ${$f->duration_months}  == 3 );
ok( ${$f->duration_years}   == 4 );


$f = Foo->new( duration_days => '10' );
ok( $f->duration_days->isa('Date::Piece::day_unit') );
ok( ${$f->duration_days} == 10 );


$f = Foo->new(
    duration_days   => 0,
    duration_weeks  => '0week',
    duration_months => '0months',
    duration_years  => '0years',
);

ok( $f->duration_days->isa('Date::Piece::day_unit') );
ok( $f->duration_weeks->isa('Date::Piece::week_unit') );
ok( $f->duration_months->isa('Date::Piece::month_unit') );
ok( $f->duration_years->isa('Date::Piece::year_unit') );

ok( ${$f->duration_days}    == 0 );
ok( ${$f->duration_weeks}   == 0 );
ok( ${$f->duration_months}  == 0 );
ok( ${$f->duration_years}   == 0 );


$f = Foo->new(
    duration_days   => -1,
    duration_weeks  => '-2week',
    duration_months => '-3months',
    duration_years  => '-4years',
);

ok( $f->duration_days->isa('Date::Piece::day_unit') );
ok( $f->duration_weeks->isa('Date::Piece::week_unit') );
ok( $f->duration_months->isa('Date::Piece::month_unit') );
ok( $f->duration_years->isa('Date::Piece::year_unit') );

ok( ${$f->duration_days}    == -1 );
ok( ${$f->duration_weeks}   == -2 );
ok( ${$f->duration_months}  == -3 );
ok( ${$f->duration_years}   == -4 );


like( exception { Foo->new(duration_weeks => 'week') }, qr/invalid duration/ );

done_testing();
