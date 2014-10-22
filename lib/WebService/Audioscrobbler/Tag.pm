package WebService::Audioscrobbler::Tag;
use warnings;
use strict;
use CLASS;

use base 'WebService::Audioscrobbler::Base';

=head1 NAME

WebService::Audioscrobbler::Tag - An object-oriented interface to the Audioscrobbler WebService API

=cut

our $VERSION = '0.03';

# url related accessors
CLASS->mk_classaccessor("base_url_postfix"  => "tag");
CLASS->mk_classaccessor("base_resource_url" => URI->new_abs(CLASS->base_url_postfix, CLASS->base_url));

# requering stuff
CLASS->tracks_class->require or die($@);

# object accessors
CLASS->mk_accessors(qw/name url/);

*title = \&name;

=head1 SYNOPSIS

This module implements an object oriented abstraction of a tag within the
Audioscrobbler database.

    use WebService::Audioscrobbler::Tag;

    my $ws = WebService::Audioscrobbler->new;
    
    # get an object for the tag named 'foo'
    my $tag = $ws->tag('foo');

    # retrieves tracks tagged with 'foo'
    my @tracks = $tag->tracks;

    # prints url for viewing aditional tag info
    print $tag->url;

This module inherits from L<WebService::Audioscrobbler::Base>.

=head1 FIELDS

=head2 C<name>

=head2 C<title>

The name (title) of a given tag.

=head2 C<url>

URL for aditional info about the tag.

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
    my ($name_or_fields) = @_;

    my $self = $class->SUPER::new( 
        ref $name_or_fields eq 'HASH' ? $name_or_fields : { name => $name_or_fields } 
    );

    return $self;
}

=head2 C<tracks>

Retrieves the tags's top tracks as available on Audioscrobbler's database.

Returns either a list of tracks or a reference to an array of tracks when called 
in list context or scalar context, respectively. The tracks are returned as 
L<WebService::Audioscrobbler::Track> objects by default.

=cut

=head2 C<artists>

Retrieves the tag's top artists as available on Audioscrobbler's database.

Returns either a list of artists or a reference to an array of artists when called 
in list context or scalar context, respectively. The tags are returned as 
L<WebService::Audioscrobbler::Artist> objects by default.

=cut

sub tags {
    die "Audioscrobbler doesn't provide data regarding tags which are related to other tags";
}

=head2 C<resource_url>

Returns the URL from which other URLs used for fetching tag info will be 
derived from.

=cut

sub resource_url {
    my $self = shift;
    URI->new_abs($self->name, $self->base_resource_url . '/');
}

=head1 AUTHOR

Nilson Santos Figueiredo J�nior, C<< <nilsonsfj at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2006 Nilson Santos Figueiredo J�nior, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of WebService::Audioscrobbler::Tag
