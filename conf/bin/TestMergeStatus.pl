# Copyright 1998-2006, Quazal Technologies.
#
# TagOfficialBuild.pl
#
# Sets the build number in various files and/or modules.
#
require 5.005;

use strict;
use warnings qw(all);

my $verbose = 0;

my $redirectToNul = ">nul 1>nul";
if ($verbose) {$redirectToNul = "";}

sub TestMergeStatus {
	my $source = shift;
	my $target = shift;
	system("cvs co -d jade.source -r $source jade/src/version $redirectToNul");
	if ($target eq "HEAD") {
		system("cvs co -d jade.target -A jade/src/version $redirectToNul");
	} else {
		system("cvs co -d jade.target -r $target jade/src/version $redirectToNul");
	}
	if (system("diff jade.source/tag.$source.log jade.target/tag.$source.log $redirectToNul")) {
		printf("\nBranch $source into $target: ** NOT MERGED **\n");
		printf("The differences between $source and $target follows:\n");
		system("diff jade.source/tag.$source.log jade.target/tag.$source.log");
		printf("\n");
	} else {
		printf("Branch $source into $target: merged\n");
	}
	system("rm -rf jade.target");
	system("rm -rf jade.source");
}

# NOTE - this could be ready from a DB or a file, elsewhere.

TestMergeStatus("coh_besp","r12sp");
TestMergeStatus("r12sp","r13sp");
TestMergeStatus("r13sp","r14sp");
TestMergeStatus("r14sp","HEAD");

# Shorter lived branches...
TestMergeStatus("bug4140","HEAD");
