package WebService::Audioscrobbler::SimilarUser;
use warnings;
use strict;
use CLASS;

use base 'WebService::Audioscrobbler::User';

=head1 NAME

WebService::Audioscrobbler::SimilarUser - An object-oriented interface to the Audioscrobbler WebService API

=cut

our $VERSION = '0.04';

# object accessors
CLASS->mk_accessors(qw/match related_to/);

=head1 SYNOPSIS

This is a subclass of L<WebService::Audioscrobbler::User> which implements some
aditional fields that cover similarity aspects between two users.

    use WebService::Audioscrobbler;

    my $user = WebService::Audiocrobbler->user('Foo');

    for my $neighbour ($user->neighbours) {
        print $neighbour->name . ": " . $neighbour->match . "\% similar\n";
    }

=head1 FIELDS

=head2 C<related_to>

The related user from which this C<SimilarUser> object has been constructed from.

=head2 C<match>

The similarity index between this user and the related user. It's returned 
as a number between 0 (not similar) and 100 (very similar).

=cut

=head1 AUTHOR

Nilson Santos Figueiredo J�nior, C<< <nilsonsfj at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2006 Nilson Santos Figueiredo J�nior, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of WebService::Audioscrobbler::SimilarUser
