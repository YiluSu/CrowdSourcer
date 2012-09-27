use strict;
use DB;
my $pid = $$;
while(1) {
	print "[$pid] Reading DB!";
	my $db = DB::readDB() || {};
	my $key = join("",map { ("a".."z")[rand(26)] } (1..8));
	$db->{$key} = $key;
	print "[$pid] Writing DB!";
	DB::writeDB($db);
}
