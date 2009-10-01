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
