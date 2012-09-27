package DB;
use Fcntl qw(:flock);
use strict;

my $DBfilename = "db.json";

sub readDB {
	open(my $fd, "<", $DBfilename) or die "Can't open file: $!";
	flock($fd, LOCK_SH) or die "Cannot lock database - $!\n";
	local $/;
	my $json_text   = <$fd>;
        my $perl_scalar = decode_json( $json_text );
	flock($fd, LOCK_UN) or die "Cannot unlock database - $!\n";
	close($fd);
	return $json_text;
}

sub writeDB {
	my $data = shift;
	open(my $fd, ">", $DBfilename) or die "Can't open file: $!";
	flock($fd, LOCK_EX) or die "Cannot lock database - $!\n";
	print $fd encode_json( $data );
	flock($fd, LOCK_UN) or die "Cannot unlock database - $!\n";
	close($fd);
}

1;
