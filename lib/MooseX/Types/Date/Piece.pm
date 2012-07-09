package MooseX::Types::Date::Piece;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.01';

use Carp 'croak';
use Date::Piece qw( date years months weeks days );
use MooseX::Types;
use MooseX::Types::Moose qw( ArrayRef Int Str );

my %DATE_DURATION = (
    days   => \&days,
    weeks  => \&weeks,
    months => \&months,
    years  => \&years,
);

class_type 'Date::Piece';

coerce 'Date::Piece',
    from Str,      via { date($_) },
    from ArrayRef, via { date($_) };

class_type 'Date::Piece::Duration', { class => 'Date::Piece::unit_base' };

coerce 'Date::Piece::Duration',
    from Int, via { $_ * days },
    from Str, via {
        my $str = lc $_;
        $str =~ s/([^s])$/$1s/; # ensure there is an 's' at the end

        my ( $val, $unit ) = $str =~ m/^([+-]*\d+)\s*(\w+)$/;

        ( defined $val && defined $unit )
            || croak "invalid duration '$str'";
        ( defined $DATE_DURATION{$unit} )
            || croak "invalid duration '$str'";

        return $val * $DATE_DURATION{$unit}->();
    };

1;

__END__

=head1 NAME

MooseX::Types::Date::Piece - Date::Piece type and coercions for Moose.

=head1 SYNOPSIS

    package Foo;

    use Moose;
    use MooseX::Types::Date::Piece;

    has 'date' => (
        is      => 'ro',
        isa     => 'Date::Piece',
        coerce  => 1,
    );

    has 'duration' => (
        is      => 'ro',
        isa     => 'Date::Piece::Duration',
        coerce  => 1,
    );

    # ...

    my $f = Foo->new(
        date     => '2012-07-09', # or '20120709'
        duration => '1day',       # or '2weeks', '3 months', '4 YEARS'
    );

=head1 DESCRIPTION

This module provides a Moose type constraint for Date::Piece.

=head1 TYPES

=over

=item Date::Piece

A subtype of C<Object> that isa L<Date::Piece>.

It includes coercions from C<Str> and C<ArrayRef> in the same format as those
accepted by the Date::Piece constructor. An exception will be thrown if the
coercion fails due to an invalid argument format or invalid dates.

=item Date::Piece::Duration

A subtype of C<Object> that isa C<Date::Piece::unit_base>. Subtypes of
C<unit_base> include C<day_unit>, C<week_unit>, C<month_unit> and C<year_unit>.
Though these types are not explicitly documented, they may be created by the
C<days>, C<weeks>, C<months> and C<years> functions, respectively, and are
useful for math on the date objects.

=back

=head1 SEE ALSO

L<Date::Piece>, L<Moose::Util::TypeConstraints>, L<MooseX::Types>

=head1 AUTHOR

Steven Lee, C<< <stevenl at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright E<copy> 2012 Steven Lee.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
