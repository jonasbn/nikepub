package WWW::Nike::NikePlus::Public;

# $Id$

use strict;
use warnings;
use WWW::Mechanize;
use Carp qw(croak);

our $VERSION = '0.01';

sub new {
    my ( $class, $param ) = @_;

    my $mech;
    my $agent = __PACKAGE__ . "-$VERSION";
    if ( $param->{mech} ) {
        $mech = $param->{mech};
    } else {
        $mech = WWW::Mechanize->new( agent => $agent );
    }

    my $self = bless {
        base_url =>
            'http://nikerunning.nike.com/nikeplus/v1/services/widget/get_public_run_list.jsp?userID=',
        verbose => $param->{verbose} || 0,
        mech    => $mech,
        userid  => $param->{userid},
    }, $class;

    return $self;
}

sub retrieve {
    my ( $self, $param ) = @_;

    my $url = $self->{base_url};
    if ( $param->{userid} ) {
        $url = $self->{base_url} . $param->{userid};
    }

    $self->{mech}->get($url)
        or croak "Unable to retrieve base URL: $@";

    my $content = $self->{mech}->content();

    return $self->processor( \$content );
}

sub processor {
    my ( $self, $content ) = @_;

    if ( $self->{verbose} ) {
        print STDERR "Content: \n${$content}.\n";
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

=head1 SUBROUTINES/METHODS

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

=head1 LICENSE AND COPYRIGHT

=cut
