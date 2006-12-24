package WebService::Audioscrobbler;
use warnings;
use strict;
use CLASS;

use base 'Class::Data::Accessor';

use NEXT;
use UNIVERSAL::require;

use URI;

=head1 NAME

WebService::Audioscrobbler - An object-oriented interface to the Audioscrobbler WebService API

=cut

our $VERSION = '0.02';

CLASS->mk_classaccessor("base_url"     => URI->new("http://ws.audioscrobbler.com/1.0/"));

# defining default classes
CLASS->mk_classaccessor("artist_class" => CLASS . '::Artist');
CLASS->mk_classaccessor("track_class" => CLASS . '::Track');
CLASS->mk_classaccessor("tag_class" => CLASS . '::Tag');
CLASS->mk_classaccessor("user_class" => CLASS . '::User');

# requiring stuff
CLASS->artist_class->require or die $@;
CLASS->track_class->require or die $@;
CLASS->tag_class->require or die $@;
CLASS->user_class->require or die $@;

=head1 SYNOPSIS

This module aims to be a full implementation of a an object-oriented interface 
to the Audioscrobbler WebService API (as available on L<http://www.audioscrobbler.net/data/webservices/>).

    use WebService::Audioscrobbler;

    my $ws = WebService::Audioscrobbler->new;

    # get an object for artist named 'foo'
    my $artist  = $ws->artist('foo');

    # retrieves tracks from 'foo'
    my @tracks = $artist->tracks;

    # retrieves tags associated with 'foo'
    my @tags = #artist->tags;

    # fetch artists similar to 'foo'
    my @similar = $artist->similar_artists;

    # prints each one of their names
    for my $similar (@similar) {
        print $similar->name . "\n";
    }

    ...

    # get an object for tag 'bar'
    my $tag = $ws->tag('bar');

    # fetch tracks tagged with 'bar'
    my @bar_tracks = $tag->tracks;

    ...

    my $user = $ws->user('baz');

    my @baz_neighbours = $user->neighbours;

Audioscrobbler is a great service for tracking musical data of various sorts,
and its integration with the LastFM service (L<http://www.last.fm>) makes it
work even better. Audioscrobbler provides data regarding similarity between
artists, artists discography, tracks by musical genre (actually, by tags), 
top artists / tracks / albums / tags and how all of that related to your own
musical taste.

Currently, only of subset of these data feeds are implemented, which can be 
viewed as the core part of the service: artists, tags, tracks and users. Since 
this module was developed as part of a automatic playlist building application 
(still in development) these functions were more than enough for its initial 
purposes but a (nearly) full WebServices API is planned. 

In any case, code or documentation patches are welcome.

=head1 METHODS

=cut

=head2 C<new>

Creates a new C<WebService::Audioscrobbler> object. This object can then be used
to retrieve various bits of information from the Audioscrobbler database.

=cut

sub new {
    my $class = shift;
    bless {}, $class;
}

=head2 C<artist($name)>

Returns an L<WebService::Audioscrobbler::Artist> object constructed using the given
C<$name>. Note that this call doesn't actually check if the artist exists since no
remote calls are dispatched - the object is only constructed.

=cut

sub artist {
    my ($self, $artist) = @_;
    return $self->artist_class->new($artist);
}

=head2 C<track($artist, $title)>

Returns an L<WebService::Audioscrobbler::Track> object constructed used the given
C<$artist> and C<$title>. The C<$artist> parameter can either be a L<WebService::Audioscrobbler::Artist>
object or a string (in this case, a L<WebService::Audioscrobbler::Artist> will be created
behind the scenes). Note that this call doesn't actually check if the track exists since no
remote calls are dispatched - the object is only constructed.

=cut

sub track {
    my ($self, $artist, $title) = @_;

    $artist = $self->artist($artist) 
        unless ref $artist; # assume the user knows what he's doing if we got a reference

    return $self->track_class->new($artist, $title);
}

=head2 C<tag($name)>

Returns an L<WebService::Audioscrobbler::Tag> object constructed using the given
C<$name>. Note that this call doesn't actually check if the tag exists since no
remote calls are dispatched - the object is only constructed.

=cut

sub tag {
    my ($self, $tag) = @_;
    return $self->tag_class->new($tag);
}

=head2 C<user($name)>

Returns an L<WebService::Audioscrobbler::User> object constructed using the given
C<$name>. Note that this call doesn't actually check if the user exists since no
remote calls are dispatched - the object is only constructed.

=cut

sub user {
    my ($self, $user) = @_;
    return $self->user_class->new($user);
}

=head1 AUTHOR

Nilson Santos Figueiredo Junior, C<< <nilsonsfj at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-webservice-audioscrobbler at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-Audioscrobbler>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::Audioscrobbler

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-Audioscrobbler>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-Audioscrobbler>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-Audioscrobbler>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-Audioscrobbler>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2006 Nilson Santos Figueiredo Junior, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of WebService::Audioscrobbler
