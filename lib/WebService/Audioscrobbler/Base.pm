package WebService::Audioscrobbler::Base;
use warnings FATAL => 'all';
use strict;
use CLASS;

use base 'Class::Data::Accessor';
use base 'Class::Accessor::Fast';

require LWP::Simple;
require XML::Simple;

use WebService::Audioscrobbler;

=head1 NAME

WebService::Audioscrobbler::Base - An object-oriented interface to the Audioscrobbler WebService API

=cut

our $VERSION = '0.03';

# url related accessors
CLASS->mk_classaccessor("base_url"     => WebService::Audioscrobbler->base_url );

# artists related
CLASS->mk_classaccessor("artists_postfix"    => "topartists.xml");
CLASS->mk_classaccessor("artists_class"      => WebService::Audioscrobbler->artist_class );
CLASS->mk_classaccessor("artists_sort_field" => "count");

# tracks related
CLASS->mk_classaccessor("tracks_postfix"    => "toptracks.xml");
CLASS->mk_classaccessor("tracks_class"      => WebService::Audioscrobbler->track_class );
CLASS->mk_classaccessor("tracks_sort_field" => "count");

# tags related
CLASS->mk_classaccessor("tags_postfix"    => "toptags.xml");
CLASS->mk_classaccessor("tags_class"      => WebService::Audioscrobbler->tag_class );
CLASS->mk_classaccessor("tags_sort_field" => "count");

=head1 SYNOPSIS

This module implements the base class for all other L<WebService::Audioscrobbler> modules.

    package WebService::Audioscrobbler::Subclass;
    use base 'WebService::Audioscrobbler::Base';

    ...

    my $self = WebService::Audioscrobbler::Subclass->new;
    
    # retrieves tracks
    my @tracks = $self->tracks;

    # retrieves tags
    my @tags = $self->tags;

    # retrieves arbitrary XML data as a hashref, using XML::Simple
    my $data = $self->fetch_data('resource.xml');


=head1 METHODS

=cut

=head2 C<tracks>

Retrieves the tracks related to the current resource as available on Audioscrobbler's database.

Returns either a list of tracks or a reference to an array of tracks when called 
in list context or scalar context, respectively. The tracks are returned as 
L<WebService::Audioscrobbler::Track> objects by default.

=cut

sub tracks {
    my $self = shift;

    my $data = $self->fetch_data($self->tracks_postfix);

    my @tracks;

    if (ref $data->{track} eq 'HASH') {
        my $tracks = $data->{track};
        my $sort_field = $self->tracks_sort_field;

        @tracks = map {
            my $title = $_;

            my $info = $tracks->{$title};
            $info->{name}   = $title;
            
            if (defined $info->{artist}) {
                $info->{artist} = $self->artists_class->new($info->{artist});
            }
            elsif ($self->isa($self->artists_class)) {
                $info->{artist} = $self;
            }
            else {
                die "Couldn't determine artist for track";
            }

            $self->tracks_class->new($info);

        } sort {$tracks->{$b}->{$sort_field} <=> $tracks->{$a}->{$sort_field}} keys %$tracks;
    }

    return wantarray ? @tracks : \@tracks;

}

=head2 C<tags>

Retrieves the tags related to the current resource as available on Audioscrobbler's database.

Returns either a list of tags or a reference to an array of tags when called 
in list context or scalar context, respectively. The tags are returned as 
L<WebService::Audioscrobbler::Tag> objects by default.

=cut

sub tags {
    my $self = shift;

    my $data = $self->fetch_data($self->tags_postfix);

    my @tags;

    if (ref $data->{tag} eq 'HASH') {
        my $tags = $data->{tag};
        my $sort_field = $self->tags_sort_field;
        @tags = map {
            my $name = $_;

            my $info = $tags->{$name};
            $info->{name} = $name;

            $self->tags_class->new($info);

        } sort {$tags->{$b}->{$sort_field} <=> $tags->{$a}->{$sort_field}} keys %$tags;
    }

    return wantarray ? @tags : \@tags;

}

=head2 C<artists>

Retrieves the artists related to the current resource as available on Audioscrobbler's database.

Returns either a list of artists or a reference to an array of artists when called 
in list context or scalar context, respectively. The tags are returned as 
L<WebService::Audioscrobbler::Artist> objects by default.

=cut

sub artists {
    my $self = shift;

    my $data = $self->fetch_data($self->artists_postfix);

    my @artists;

    if (ref $data->{artist} eq 'HASH') {
        my $artists = $data->{artist};
        my $sort_field = $self->artists_sort_field;
        @artists = map {
            my $name = $_;

            my $info = $artists->{$name};
            $info->{name} = $name;

            $self->artists_class->new($info);

        } sort {$artists->{$b}->{$sort_field} <=> $artists->{$a}->{$sort_field}} keys %$artists;
    }

    return wantarray ? @artists : \@artists;

}

=head2 C<fetch_data($postfix)>

This method retrieves arbitrary XML data as hashref (using L<XML::Simple> for
processing) constructing the URL from the provided postfix appended to the 
base resource URL (as returned from the C<resource_url> method).

=cut

sub fetch_data {
    my ($self, $postfix) = @_;

    my $uri = URI->new_abs($postfix, $self->resource_url . '/');

    # warn "\nFetching data from $uri...\n";
    
    my $resp = LWP::Simple::get($uri) 
        or die "Error while fetching information from '$uri'";

    utf8::upgrade($resp);

    my $data = XML::Simple::XMLin($resp);

    return $data;
}

=head2 C<resource_url>

This method must be overriden by classes which inherit from C<Base>. It should 
return the base URL for the given entity, to which aditional resource 
postfixes can be appended to and thus forming a full URL used for fetching XML 
data.

=cut

sub resource_url {
    my $class = ref shift;
    die "$class must override the 'resource_url' method";
}

=head1 AUTHOR

Nilson Santos Figueiredo Júnior, C<< <nilsonsfj at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2006 Nilson Santos Figueiredo Júnior, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of WebService::Audioscrobbler::Base
