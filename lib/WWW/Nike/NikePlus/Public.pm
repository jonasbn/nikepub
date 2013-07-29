package WWW::Nike::NikePlus::Public;

# $Id$

use strict;
use warnings;
use WWW::Mechanize;
use Carp qw(croak);
use Params::Validate qw(:all);    #validate
use English qw( -no_match_vars );

use base qw(Class::Accessor);
__PACKAGE__->mk_accessors(qw(base_url verbose mech userid));

use constant TRUE => 1;
my $base_url
    = 'http://nikerunning.nike.com/nikeplus/v1/services/widget/get_public_run_list.jsp';

our $VERSION = '0.01';

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
    my $xml = $nike->retrieve();
        

    my $nike = WWW::Nike::NikePlus::Public->new({});
    my $xml = $nike->retrieve({
        userid => 1755202461,
    });

=head1 VERSION

This documentation describes version 0.01

=head1 DESCRIPTION

NikePlus is a service provided by Nike. It gives you online access to your workout
data recorded using a Nike+ enabled devices (Apple iPod, iPhone etc.).

The data are returned in XML format. All this module provides is the actual
retrieval mechanism. Processing of the data is left up to you imagination.

In order to make proper use of this class, you can either just use it as
described in the L</SYNOPSIS> or you can subclass it and implement your own
L</processor> method.

=head1 SUBROUTINES AND METHODS

=head2 new

This is the constructor, it returns an object on which you can call the
L</retrieve> method. It takes a reference to a hash as parameter. Please see
the descriptions below on mandatory and optional parameters.

=head3 Mandatory Parameters

=over

=item * userid, a NikePlus public id

=back

=head3 Optional Parameters

=over

=item * verbose, a flag enabling verbosity

=item * mech, a L<WWW::Mechanize> object if you do not want to use the one
constructed internally. Please note that you should mimic a L<WWW::Mechanize>
object since this class relies on the methods get and content.

=item * base_url, the URL with the Nike service from where the data is retrieved.
You can overwrite this value, but you might render the object useless. An
interesting candidate for this parameter could be L<WWW::Mechanize::Cached>.

=back 

Accessors and mutators of the parameters mentioned above are also available.

=head2 retrieve

Takes no parameters, returns an XML string.

=head2 processor

This is sort of an abstract method. It should be overwritten, by subclassing the
class and implementing your own processor method.

If you instantiate the object or later set the verbose attribute the built in
accessor will output the retrieved data to STDERR.

=head1 PRIVATE METHODS

=head2 _validate_parameters

This method is used internally to validate the parameters provided to the
constructor (L</new>). Please see the constructor for more specific details.

=head1 DIAGNOSTICS

=over

=item * The constructor dies, if the mandatory userid parameter is not provided.

=item * L<WWW::Mechanize> might provide special errors, please refer
to L<WWW::Mechanize>. This might however also relate to the availability to the Nike site providing the service acting as back-end for the module.

=back

=head1 CONFIGURATION AND ENVIRONMENT

Apart from the listed dependencies and requirements listed in the following section. All which is needed is HTTP access to the Internet
and access to the Nike site.

=head1 DEPENDENCIES AND REQUIREMENTS

=over

=item * L<Carp>

=item * L<WWW::Mechanize>, by Andy Lester (PETDANCE)

=item * L<Params::Validate>

=item * L<Class::Accessor>

=item * L<English>

=back

Apart from software components, your need a NikePlus public ID of a user, who
have made their workout data publically available. The test suite currently
uses the ID of the author.

Please use this with discretion, since this is the ID I also use for development
and analyzing my own running data. The data are not secret, but I do not want to
have my account abused, so it will be closed due to overuse or similar, hence
the mock in the test suite.

=head1 INCOMPATIBILITIES

No known incompatibilities at this time.

=head1 BUGS AND LIMITATIONS

No known bugs at this time.

=head1 BUG REPORTING

=head1 TEST AND QUALITY

=head2 INTEGRATION TEST

If you want to call the actual NikePlus API, you must enable the integration
test, this is done using the environment variable.

    TEST_INTEGRATION=1 ./Build test

=head1 TODO

Please see distribution TODO file.

=head1 SEE ALSO

=over

=item * L<http://nikerunning.nike.com/nikeos/p/nikeplus/en_EMEA/plus/#//dashboard/>, Nike site

=item * L<http://www.apple.com/ipod/nike/>, Apple site

=item * L<http://en.wikipedia.org/wiki/Nike%2BiPod>, Wikipedia

=item * L<WWW::Nike::NikePlus>, by Alex Lomas (ALEXLOMAS)

=item * L<WWW::Mechanize::Cached>, by Iain Truskett and others

=back

=head1 AUTHOR

=over

=item * Jonas B. Nielsen (jonasbn) C<< <jonasbn@cpan.org> >>

=back

=head1 ACKNOWLEDGEMENTS

=over

=item * Andy Lester (PETDANCE), author of: L<WWW::Mechanize> a great utility

=back

=head1 COPYRIGHT

Nike and Nikeplus/Nike+ are trademarks owned by Nike.

iPod, iPod touch, iPhone and Apple are trademarks owned by Apple.

Copyright 2009-2011 Jonas B. Nielsen (jonasbn), All Rights Reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
