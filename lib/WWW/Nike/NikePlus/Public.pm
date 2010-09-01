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

use version; our $VERSION = qv('0.0.1');

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

0.01

=head1 DESCRIPTION

=head1 SUBROUTINES AND METHODS

=head2 USAGE

In order to make proper use of this class, you can either just use it as
described in the L</SYNOPSIS> or you can subclass it and implement your own
L</processor> method.

=head1 DEPENDENCIES

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

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

=head1 BUG REPORTING

=head1 TEST AND QUALITY

=head1 TODO

=over

=item *

=back

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

=head1 LICENSE

=cut
