#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'MooseX::Types::Date::Piece' ) || print "Bail out!\n";
}

diag( "Testing MooseX::Types::Date::Piece $MooseX::Types::Date::Piece::VERSION, Perl $], $^X" );
