package MooseX::Types::Date::Piece;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.03';

use Carp 'croak';
use Date::Piece qw( date years months weeks days );
use MooseX::Types::Moose qw( ArrayRef Int Str );

my %DATE_DURATION = (
    days   => \&days,
    weeks  => \&weeks,
    months => \&months,
    years  => \&years,
);

use MooseX::Types -declare => [qw( Date Duration )];

class_type 'Date::Piece';
class_type 'Date::Piece::Duration', { class => 'Date::Piece::unit_base' };

subtype Date,     as 'Date::Piece';
subtype Duration, as 'Date::Piece::Duration';

for my $type ('Date::Piece', Date) {
    coerce $type,
        from Str,      via { date($_) },
        from ArrayRef, via { date($_) };
}

for my $type ('Date::Piece::Duration', Duration) {
    coerce $type,
        from Int, via { $_ * days },
        from Str, via {
            my $str = lc $_;
            $str =~ s/([^s])$/$1s/; # ensure there is an 's' at the end

            my ( $val, $unit ) = $str =~ m/^([+-]*\d+)\s*(\w+)$/;

            ( defined $val && defined $unit && defined $DATE_DURATION{$unit} )
                || croak "invalid duration '$str'";

            return $val * $DATE_DURATION{$unit}->();
        };
}

1;

__END__

=head1 NAME

MooseX::Types::Date::Piece - Date::Piece type and coercions for Moose.

=head1 SYNOPSIS

    package Foo;

    use Moose;
    use MooseX::Types::Date::Piece qw( Date Duration );

    has 'date' => (
        is      => 'ro',
        isa     => Date,
        coerce  => 1,
    );

    has 'duration' => (
        is      => 'ro',
        isa     => Duration,
        coerce  => 1,
    );

    # ...

    my $f = Foo->new(
        date     => '2012-07-09',
        duration => '1day',
    );

=head1 DESCRIPTION

This module provides L<Moose> type constraints and coercions for using
L<Date::Piece> objects as Moose attributes.

=head1 EXPORTS

The following type constants provided by L<MooseX::Types> must be explicitly
imported. The full class name may also be used (as strings with quotes) without
importing the constant declarations.

=over

=item Date

A class type for L<Date::Piece>.

=over

=item coerce from C<Str>

Uses L<Date::Piece/date>, where the string is formatted as C<'2012-12-31'> or C<'20121231'>.

=item coerce from C<ArrayRef>

Uses L<Date::Piece/date>, where the array is formatted as C<[2012, 12, 31]>.

=back

An exception is thrown if the value to be coerced is not in a valid format
or if the date is invalid.

=item Duration

A class type for C<Date::Piece::Duration>. Subtypes include C<day_unit>,
C<week_unit>, C<month_unit> and C<year_unit>.
These objects are normally created using the C<days>, C<weeks>, C<months>
and C<years> constants and may be multiplied by an integer. They may also be
used for date math by adding (or subtracting) them to C<Date::Piece> objects.
See L<Date::Piece/Year-Month-and-etc-units> for more information.

=over

=item coerce from C<Str>

The string must specify the number and unit,
e.g. C<'1day'>, C<'2weeks'>, C<'3 months'>, C<'4 YEARS'>.

=item coerce from C<Int>

The integer value will be interpreted as the number of C<days>.

=back

=back

=head1 SEE ALSO

L<Date::Piece>, L<Moose::Util::TypeConstraints>, L<MooseX::Types>

=head1 AUTHOR

Steven Lee, C<< <stevenl at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright E<copy> 2012 Steven Lee. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
