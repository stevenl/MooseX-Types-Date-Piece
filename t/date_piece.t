#!perl -T

package Foo;

use Moose;
use MooseX::Types::Date::Piece;

has 'date_from_str1' => (
    is  => 'ro',
    isa => 'Date::Piece',
    coerce => 1,
);

has 'date_from_str2' => (
    is  => 'ro',
    isa => 'Date::Piece',
    coerce => 1,
);

has 'date_from_arrayref' => (
    is  => 'ro',
    isa => 'Date::Piece',
    coerce => 1,
);

package main;

use Test::More;
use Test::Fatal;

my $f;

$f = Foo->new(
    date_from_str1 => '2012-07-09',
    date_from_str2 => '20120709',
    date_from_arrayref => [2012, 7, 9],
);

ok( $f->date_from_str1->isa('Date::Piece') );
ok( $f->date_from_str1 eq '2012-07-09' );

ok( $f->date_from_str2->isa('Date::Piece') );
ok( $f->date_from_str2 eq '2012-07-09' );

ok( $f->date_from_arrayref->isa('Date::Piece') );
ok( $f->date_from_arrayref eq '2012-07-09' );

# invalid arg format
like( exception { Foo->new( date_from_str1 => 'apocalypse' ) },     qr/^invalid date/ );
like( exception { Foo->new( date_from_str1 => '09-07-2012' ) },     qr/^invalid date/ );
like( exception { Foo->new( date_from_arrayref => [9, 7, 2012] ) }, qr/^invalid date/ );

# invalid date
like( exception { Foo->new( date_from_str1 => '2012-13-09' ) },     qr/^invalid date/ );
like( exception { Foo->new( date_from_str2 => '20121232' ) },       qr/^invalid date/ );
like( exception { Foo->new( date_from_arrayref => [2013, 0, 9] ) }, qr/^invalid date/ );

done_testing();
