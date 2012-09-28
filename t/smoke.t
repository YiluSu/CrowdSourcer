use strict;
use Test::More tests => 6;
### database tests
chdir($ENV{TMP} || $ENV{TMPDIR} || "/tmp");
unlink('db.json');


use_ok( 'DBLock');
use DBLock;

use MyDB;
use_ok( 'MyDB' );

my $data = MyDB::readDB();
ok($data);
$data->{__test__} = "".rand();
MyDB::writeDB($data);
my $newdata = MyDB::readDB();
ok($data->{__test__} eq $newdata->{__test__});
my $newval = "".rand();
MyDB::readWriteDB( sub {
	my ($data) = @_;
	$data->{_readWriteDB_test_} = $newval;
	return (1,$data);
});
$newdata = MyDB::readDB();
ok($newdata->{_readWriteDB_test_} eq $newval);
MyDB::readWriteDB( sub {
	my ($data) = @_;
	delete $data->{_readWriteDB_test_};
	return (1,$data);
});
$newdata = MyDB::readDB();
ok(! exists $newdata->{_readWriteDB_test_});


