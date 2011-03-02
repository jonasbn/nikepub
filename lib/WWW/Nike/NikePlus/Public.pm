package WWW::Nike::NikePlus::Public;

# $Id$

use strict;
use warnings;
use WWW::Mechanize;
use Carp qw(croak);
use Params::Validate qw(:all);    #validate
use Data::Dumper;
use English qw( -no_match_vars );

use base qw(Class::Accessor);
__PACKAGE__->mk_accessors(qw(base_url verbose mech userid));

use constant TRUE => 1;
my $base_url
    = 'http://nikerunning.nike.com/nikeplus/v1/services/widget/get_public_run_list.jsp';

use version; our $VERSION = qv('0.01');

sub new {
    my ( $class, $param ) = @_;

    my $self = bless {}, $class;

    $self->_validate_parameters($param);

    my $agent = __PACKAGE__ . "-$VERSION";

    if ( $param->{mech} ) {
        $self->mech( $param->{mech} );
    } else {
        $self->mech( WWW::Mechanize->new( agent => $agent ) );
    }

    $self->base_url( $param->{base_url} || $base_url );

    $self->verbose( $param->{verbose} );
    $self->userid( $param->{userid} );

    return $self;
}

sub _validate_parameters {
    my ( $self, $param ) = @_;

    my @parameters;
    while ( my @pair = each %{$param} ) {
        push @parameters, @pair;
    }

    validate(
        @parameters,
        {   mech => { can => [ 'get', 'content' ], optional => TRUE },
            verbose => { type => SCALAR, default => 0, optional => TRUE },
            userid => { type => SCALAR, optional => TRUE },
            base_url =>
                { type => SCALAR, default => $base_url, optional => TRUE },
        }
    );

    return 1;
}

sub retrieve {
    my ( $self, $param ) = @_;

    $self->_validate_parameters($param);

    my $url = $self->base_url;

    if ( defined $param->{userid} ) {
        $url = $self->base_url . $param->{userid};
    }

    if ( defined $param->{verbose} ) {
        $self->verbose( $param->{verbose} );
    }

    $self->mech->get($url)
        or croak "Unable to retrieve base URL: $EVAL_ERROR";

    my $content = $self->mech->content();

    return $self->processor( \$content );
}

sub processor {
    my ( $self, $content ) = @_;

    if ( $self->verbose ) {
        print {*STDERR} "Content: \n${$content}.\n";
    }

    return $content;
}

1;

__END__

=pod

=head1 NAME

WWW::Nike::NikePlus::Public - retrieve data from Nike+ public interface

=head1 SYNOPSIS

    use WWW::Nike::NikePlus::Public;
    
    my $nike = WWW::Nike::NikePlus::Public->new({
        userid  => 1755202461,
        verbose => 1,
    });
    $xml = $nike->retrieve();
        

    my $nike = WWW::Nike::NikePlus::Public->new({});
    $xml = $nike->retrieve({
        userid => 1755202461,
    });

=head1 VERSION

This documentation describes version 0.01

=head1 DESCRIPTION

Nikeplus is a service provided by Nike. It gives you online access to your workout
data recorded using the Nike+ enabled devices (Apple iPod, iPhone etc.).



=head1 SUBROUTINES AND METHODS

=head2 USAGE

In order to make proper use of this class, you can either just use it as
described in the L</SYNOPSIS> or you can subclass it and implement your own
L</processor> method.

=head1 DIAGNOSTICS

=over

=item * 

=back

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES AND REQUIREMENTS

=over

=item * L<Carp>

=item * L<WWW::Mechanize>

=back

Apart from software components, your need a Nikeplus public ID of a user, who
have made their workout data publically available. The test suite currently
uses the ID of the author. Please use this with descretion, since this is the
ID I also use for development and analyzing my own running data. The data are
not secret, but I do not want to have my account abused, so it will be closed
due to overuse or similar, hence the mock in the test suite.

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 BUG REPORTING

=head1 TEST AND QUALITY

=head1 TODO

Please see distribution TODO file.

=head1 SEE ALSO

=over

=item * L<Carp>

=item * L<WWW::Mechanize>

=back

=head1 AUTHOR

=over

=item Jonas B. Nielsen (jonasbn) C<< <jonasbn@cpan.org> >>

=back

=head1 COPYRIGHT

Nike and Nikeplus/Nike+ are trademarks owned by Nike.

iPod, iPod touch, iPhone and Apple are trademarks owned by Apple.

Copyright 2009-2010 Jonas B. Nielsen (jonasbn), All Rights Reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
