package WebService::Audioscrobbler::Track;
use warnings;
use strict;
use CLASS;

use base 'WebService::Audioscrobbler::Base';

=head1 NAME

WebService::Audioscrobbler::Track - An object-oriented interface to the Audioscrobbler WebService API

=cut

our $VERSION = '0.01';

# url related accessors
CLASS->mk_classaccessor("base_url_postfix"  => "track");
CLASS->mk_classaccessor("base_resource_url" => URI->new_abs(CLASS->base_url_postfix, CLASS->base_url));

# requiring stuff
CLASS->tags_class->require or die($@);

# object accessors
CLASS->mk_accessors(qw/artist name mbid url streamable/);

*title = \&name;

=head1 SYNOPSIS

This module implements an object oriented abstraction of a track within the
Audioscrobbler database.

    use WebService::Audioscrobbler::Track;

    my $ws = WebService::Audioscrobbler->new;
    
    # get a track object for the track titled 'bar' by 'foo'
    my $track = $ws->track('foo', 'bar');

    # retrieves the track's tags
    my @tags = $track->tags;

    # prints url for viewing aditional tag info
    print $track->url;

    # prints the tag's artist name
    print $track->artist->name;

This module inherits from L<WebService::Audioscrobbler::Base>.

=head1 FIELDS

=head2 C<artist>

The track's performing artist.

=head2 C<name>
=head2 C<title>

The name (title) of a given track.

=head2 C<mbid>

MusicBrainz ID as provided by the Audioscrobbler database.

=head2 C<url>

URL for aditional info about the track.

=cut

=head1 METHODS

=cut

=head2 C<new($artist, $title)>

=head2 C<new(\%fields)>

Creates a new object using either the given C<$artist> and C<$title> or the 
C<\%fields> hashref.

=cut

sub new {
    my $class = shift;
    my ($artist_or_fields, $title) = @_;

    my $self = $class->SUPER::new( 
        ref $artist_or_fields eq 'HASH' ? $artist_or_fields : { artist => $artist_or_fields, name => $title } 
    );

    return $self;
}

=head2 C<tags>

Retrieves the track's top tags as available on Audioscrobbler's database.

Returns either a list of tags or a reference to an array of tags when called 
in list context or scalar context, respectively. The tags are returned as 
L<WebService::Audioscrobbler::Tag> objects by default.

=cut

sub tracks {
    die "Audioscrobbler doesn't provide data regarding tracks which are related to other tracks";
}

=head2 C<resource_url>

Returns the URL from which other URLs used for fetching track info will be 
derived from.

=cut

sub resource_url {
    my $self = shift;
    URI->new_abs($self->artist->name . '/' . $self->name, $self->base_resource_url . '/');
}

=head1 AUTHOR

Nilson Santos Figueiredo Junior, C<< <nilsonsfj at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2006 Nilson Santos Figueiredo Junior, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of WebService::Audioscrobbler::Track
