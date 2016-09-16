#!/usr/bin/env perl

$sizee=$ARGV[0];
open(my $fh, '>', 'test_huge');

for (1 .. $sizee) {
	print $fh "1000";
	for (2 .. $sizee) {
		print $fh "\t1000";
	}
	print $fh "\n";
}

