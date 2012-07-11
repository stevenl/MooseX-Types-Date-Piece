#!perl -T

package Foo;
{
    use Moose;
    use MooseX::Types::Date::Piece;

    has 'date_from_str' => (
        is  => 'rw',
        isa => 'Date::Piece',
        coerce => 1,
    );
    has 'date_from_arrayref' => (
        is  => 'rw',
        isa => 'Date::Piece',
        coerce => 1,
    );
}

package Foo::Declared;
{
    use Moose;
    use MooseX::Types::Date::Piece 'Date';

    has 'date_from_str' => (
        is  => 'rw',
        isa => Date,
        coerce => 1,
    );
    has 'date_from_arrayref' => (
        is  => 'rw',
        isa => Date,
        coerce => 1,
    );
}

package main;

use Date::Piece ();
use Test::More;
use Test::Fatal;

for my $class ('Foo', 'Foo::Declared') {
    my $f;
    $f = $class->new(
        date_from_str => '2012-12-31',
        date_from_arrayref => [2012, 12, 31],
    );

    ok( $f->date_from_str->isa('Date::Piece') );
    ok( $f->date_from_str eq '2012-12-31' );

    ok( $f->date_from_arrayref->isa('Date::Piece') );
    ok( $f->date_from_arrayref eq '2012-12-31' );


    $f->date_from_str('20121231');
    ok( $f->date_from_str->isa('Date::Piece') );
    ok( $f->date_from_str eq '2012-12-31' );

    # invalid arg format
    like( exception { $class->new( date_from_str => 'apocalypse' ) },        qr/^invalid date/ );
    like( exception { $class->new( date_from_str => '31-12-2012' ) },        qr/^invalid date/ );
    like( exception { $class->new( date_from_arrayref => [31, 12, 2012] ) }, qr/^invalid date/ );

    # invalid date
    like( exception { $class->new( date_from_str => '2012-13-09' ) },      qr/^invalid date/ );
    like( exception { $class->new( date_from_str => '20121232' ) },        qr/^invalid date/ );
    like( exception { $class->new( date_from_arrayref => [2013, 0, 9] ) }, qr/^invalid date/ );
}

done_testing();
