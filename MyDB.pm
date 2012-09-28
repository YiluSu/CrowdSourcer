package MyDB;
use Fcntl qw(:flock);
use strict;
use Lock;
use JSON qw(decode_json encode_json);
use Data::Dumper;

my $DBfilename = "db.json";

sub readDB {
	my $lock = DBLock::SHARED();
	if (!-f $DBfilename) {
		return {};
	}
	open(my $fd, "<", $DBfilename) or die "Can't open file: $! $DBfilename";
	local $/;
	my $json_text   = <$fd>;
        my $perl_scalar = decode_json( $json_text );
	close($fd);
	$lock->unlock();
	return $perl_scalar;
}
sub writeDB {
	my $data = shift;
	my $lock = DBLock::EXCLUSIVE();
	open(my $fd, ">", $DBfilename) or die "Can't open file: $!";
	print $fd encode_json( $data );
	close($fd);
	$lock->unlock();
}
# like write but with a callback
# exclusive
sub readWriteDB {
	my ($callback) = @_;
	my $lock = DBLock::EXCLUSIVE();
	open(my $fd, "<", $DBfilename) or die "Can't open file: $!";
	# read the file
	local $/;
	my $json_text   = <$fd>;
	close($fd);
        my $perl_scalar = decode_json( $json_text );
	
	my ($ret, $data) = &$callback($perl_scalar);
	if ($ret) {
		open(my $fd, ">", $DBfilename) or die "Can't open file: $!";
		print Dumper($data);
		print $fd encode_json( $data );
		close($fd);
	}
	$lock->unlock();
	
}

1;
