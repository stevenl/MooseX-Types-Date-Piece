use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'MooseX::Types::Date::Piece',
    license             => 'perl',
    dist_author         => q{Steven Lee <stevenl@cpan.org>},
    dist_version_from   => 'lib/MooseX/Types/Date/Piece.pm',
    configure_requires  => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
        'Test::Fatal' => 0,
    },
    requires => {
        'perl' => 5.006,
        'Date::Piece' => 'v0.0.3',
        'namespace::autoclean' => 0,
        'Moose' => 0,
        'MooseX::Types' => 0,
        'MooseX::Types::Moose' => 0,
    },
    add_to_cleanup      => [ 'MooseX-Types-Date-Piece-*' ],
);

$builder->create_build_script();
