=head1 NAME

 AddNewProjectType.pm

=head1 SYNOPSIS

mx-run ThisPackageName [options] -H hostname -D dbname -u username [-F]

this is a subclass of L<CXGN::Metadata::Dbpatch>
see the perldoc of parent class for more details.

=head1 DESCRIPTION
This patch adds the necessary cvterms that are used for genetic gain, storage, heterosis and health status project types


This subclass uses L<Moose>. The parent class uses L<MooseX::Runnable>

=head1 AUTHOR

 chris simoes <ccs263@cornell.edu>

=head1 COPYRIGHT & LICENSE

Copyright 2010 Boyce Thompson Institute for Plant Research

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


package AddNewProjectType;

use Moose;
use Bio::Chado::Schema;
use Try::Tiny;
extends 'CXGN::Metadata::Dbpatch';


has '+description' => ( default => <<'' );
Add new cvterms for Genetic Gain, Storage, Heterosis and Health Status project types

has '+prereq' => (
	default => sub {
        [],
    },

  );

sub patch {
    my $self=shift;

    print STDOUT "Executing the patch:\n " .   $self->name . ".\n\nDescription:\n  ".  $self->description . ".\n\nExecuted by:\n " .  $self->username . " .";

    print STDOUT "\nChecking if this db_patch was executed before or if previous db_patches have been executed.\n";

    print STDOUT "\nExecuting the SQL commands.\n";
    my $schema = Bio::Chado::Schema->connect( sub { $self->dbh->clone } );


    print STDERR "INSERTING CVTERMS...\n";

    my $terms = {
	    'project_type'     => [
		'Stage 1',
		'Stage 2',
		'Stage 3',
        'First Clonal',
        'Second Clonal'
	    ],
	};

    foreach my $t (keys %$terms){
	foreach (@{$terms->{$t}}){
	    $schema->resultset("Cv::Cvterm")->create_with({
		name => $_,
		cv => $t
							  });
	}
    }


    print "You're done!\n";
}


####
1; #
####