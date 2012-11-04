#!/usr/bin/perl
use Cwd;
$dir = shift;
$dir = "$ENV{HOME}/Perl/" if not defined $dir;
opendir(DIR, "$dir");
chdir "$dir";
#print getcwd;
my @returnarray;
$returnarray[0] = "$dir";
my $i = 1;
foreach(readdir(DIR)) {
	#print "Inspecting element: $_\n";
	if ($_ =~ /^\./) {
		next;
	}
	if ( -d $_) {
#		print "Is a directory.\n";
		if ( -e "$_/.nopath"  ) {
			#		print "Been told not to touch\n";
			next;
		}
		else {
			$returnarray[$i] = $dir . $_;
			#print "returnarray[$i] = $_;\n";
			#print "Added to returnarray. Returnarray contents: ", join(',', @returnarray);
			#print "\n";
			$i = $i + 1;
		}
		next;
	}
	next;
}
print join(':', @returnarray);

	
