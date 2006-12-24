package WebService::Audioscrobbler::User;
use warnings;
use strict;
use CLASS;

use base 'WebService::Audioscrobbler::Base';

=head1 NAME

WebService::Audioscrobbler::User - An object-oriented interface to the Audioscrobbler WebService API

=cut

our $VERSION = '0.02';

# url related accessors
CLASS->mk_classaccessor("base_url_postfix"   => "user");
CLASS->mk_classaccessor("base_resource_url"  => URI->new_abs(CLASS->base_url_postfix, CLASS->base_url));

# neighbours related accessors
CLASS->mk_classaccessor("neighbours_postfix" => "neighbours.xml");
CLASS->mk_classaccessor("neighbours_class"   => "WebService::Audioscrobbler::SimilarUser");

# different postfix
CLASS->tags_postfix('tags.xml');

# requiring stuff
CLASS->artists_class->require or die($@);
CLASS->tracks_class->require or die($@);
CLASS->tags_class->require or die($@);
CLASS->neighbours_class->require or die($@);

# object accessors
CLASS->mk_accessors(qw/name picture_url url/);

=head1 SYNOPSIS

This module implements an object oriented abstraction of an user within the
Audioscrobbler database.

    use WebService::Audioscrobbler;

    my $ws = WebService::Audioscrobbler->new;

    # get an object for user named 'foo'
    my $user  = $ws->user('foo');

    # get user's top artists
    my @artists = $user->artists;
    
    # get user's top tags
    my @tags = $user->tags;

    # get user's top tracks
    my @tracks = $user->tracks;
    
    # get user's neighbours
    my @neighbours = $user->neighbours; 


This module inherits from L<WebService::Audioscrobbler::Base>.

=head1 FIELDS

=head2 C<name>

The name of a given user as provided when constructing the object.

=head2 C<picture_url>

URI object pointing to the location of the users's picture, if available.

=head2 C<url>

URI object pointing to the location where's additional info might be available
about the user.

=cut

=head1 METHODS

=cut

=head2 C<new($user_name)>

=head2 C<new(\%fields)>

Creates a new object using either the given C<$user_name> or the C<\%fields> 
hashref. Usually only used internally, since 
C<<WebService::Audioscrobbler->user($user_name)>> is provided as an external
interface.

=cut

sub new {
    my $class = shift;
    my ($name_or_fields) = @_;

    my $self = $class->SUPER::new( 
        ref $name_or_fields eq 'HASH' ? $name_or_fields : { name => $name_or_fields } 
    );

    unless (defined $self->name) {
        if (defined $self->{username}) {
            $self->name($self->{username})
        }
        else {
            die "Can't create user without a name";
        }
    }

    return $self;
}

=head2 C<artists>

Retrieves the user's top artists as available on Audioscrobbler's database.

Returns either a list of artists or a reference to an array of artists when called 
in list context or scalar context, respectively. The artists are returned as 
L<WebService::Audioscrobbler::Artist> objects by default.

=cut

=head2 C<tracks>

Retrieves the user's top tracks as available on Audioscrobbler's database.

Returns either a list of tracks or a reference to an array of tracks when called 
in list context or scalar context, respectively. The tracks are returned as 
L<WebService::Audioscrobbler::Track> objects by default.

=cut

=head2 C<tags>

Retrieves the user's top tags as available on Audioscrobbler's database.

Returns either a list of tags or a reference to an array of tags when called 
in list context or scalar context, respectively. The tags are returned as 
L<WebService::Audioscrobbler::Tag> objects by default.

=cut

=head2 C<neighbours([$filter])>

Retrieves musical neighbours from the Audioscrobbler database. $filter can be used
as a constraint for neighbours with a low similarity index (ie. users which have a 
similarity index lower than $filter won't be returned).

Returns either a list of users or a reference to an array of users when called 
in list context or scalar context, respectively. The users are returned as 
L<WebService::Audioscrobbler::SimilarUser> objects by default.

=cut

sub neighbours {
    my $self = shift;
    my $filter = shift || 1;

    my $data = $self->fetch_data($self->neighbours_postfix);

    my @neighbours;

    # check if we've got any neighbours
    if (ref $data->{user} eq 'ARRAY') {

        shift @{$data->{user}};

        @neighbours = map {
            my $neighbour = $_;
            $self->neighbours_class->new({
                map {$_ => $neighbour->{$_}} qw/username match/,
                url         => URI->new($_->{url}),
                picture_url => URI->new($_->{image}),
                related_to  => $self
            })
        } grep { $_->{match} >= $filter } @{$data->{user}};

    }

    return wantarray ? @neighbours : \@neighbours;
}

=head2 C<resource_url>

Returns the URL from which other URLs used for fetching user info will be 
derived from.

=cut

sub resource_url {
    my $self = shift;
    URI->new_abs($self->name, $self->base_resource_url . '/');
}

=head1 AUTHOR

Nilson Santos Figueiredo Junior, C<< <nilsonsfj at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2006 Nilson Santos Figueiredo Junior, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of WebService::Audioscrobbler::User
