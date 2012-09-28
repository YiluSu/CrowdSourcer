use strict;
use Test::More tests => 9;
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

use_ok('Database');
use Database;
my $database = Database->new();

my @tasks = $database->get_tasks();
ok(@tasks == 0);

use_ok('Task');
use Task;
for (1..10) {
	$database->insert_task( Task->new( summary => "Test $_", description => "Desc of Test $_" ) );
}

