use strict;
use Test::More; 
use Cwd qw(abs_path);

my $abs_path = abs_path("./html");

### database tests
my $tmp = $ENV{TMP} || $ENV{TMPDIR} || "/tmp";

chdir();
`cp -r $abs_path .`;

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
my @tasks = map {
	$database->insert_task( Task->new( summary => "Test $_", description => "Desc of Test $_" ) );
} (1..10);
foreach my $task (@tasks) {
	ok($task->id,"tasks id");
	my $newtask = $database->get_single_task( $task->id);
	ok($newtask->equals($task),"task equals");
}
my @tasks = $database->get_tasks();
ok(@tasks == 10, "Get tasks");
my ($task) = $database->get_last_tasks(1);
ok($tasks[$#tasks]->id eq $task->id, "last task equal last task ");
use_ok('TaskLite');
my @summaries1 = map { $_->summary } $database->get_task_summaries();
my @summaries2 = map { $_->summary } @tasks;
ok(join("\n", @summaries1) eq join("\n", @summaries2), "Summaries are the same");

# test if we can save hashes and stuff
my $task = Task->new(content=>{a=>'b','c'=>[1,2,3]});
$database->insert_task( $task );
my $newtask = $database->get_single_task( $task->id );
ok($newtask->content()->{a} eq 'b');
ok($newtask->content()->{c}->[1] == 2);

# command factory tests
use CommandFactory;
use_ok('CommandFactory');
ok(CommandFactory::defaultCommand()->isa("DefaultCommand"));
ok(CommandFactory::getCommand("")->isa("DefaultCommand"));
ok(CommandFactory::getCommand("")->execute()->{name} eq 'default');
use DefaultCommand;
use_ok('DefaultCommand');
use PostCommand;
use_ok('PostCommand');
use RemoveCommand;
use_ok('RemoveCommand');
use UpdateCommand;
use_ok('UpdateCommand');
use ListCommand;
use_ok('ListCommand');
for my $type (qw( default list )) {
	ok(CommandFactory::getCommand($type)->execute()->{name} eq $type, "Looking for type $type" );
}
ok(CommandFactory::getCommand('post')->execute({
	summary     => "Summary1",
	description => "Description",
        content => '{ "hmmm":"junk", "huh":{ "a":"b", "b":"c" } }' #json

})->{name} eq 'post', "Looking for type POST" );
# post
# update
# remove


use HTMLPresenter;
use_ok('HTMLPresenter');

my $presenter = HTMLPresenter->new( 
    params => {},
    result => CommandFactory::getCommand("default")->execute() 
);

my $html = $presenter->present();
ok( $html =~ /<\/html>/i, "HTML tag" );

# Post content test
my $result = CommandFactory::getCommand('post')->execute(
    {
        summary     => "Summary1",
        description => "Description",
        content => '{ "hmmm":"junk", "huh":{ "a":"b", "b":"c" } }' #json
    }
);

$presenter = HTMLPresenter->new( 
    params => {
        summary     => "Summary1",
        description => "Description",
        content => '{ "hmmm":"junk", "huh":{ "a":"b", "b":"c" } }' #json
    },
    result => $result,
);

my ($type,$html) = $presenter->present();

ok( $html =~ /hmmm/i, "JSON" );

my $presenter = HTMLPresenter->new( 
    params => {},
    result => CommandFactory::getCommand('list')->execute( {} )
);


my ($type, $html) = $presenter->present();
# warn $type;
# warn $html;
ok( $type =~ /json/, "JSON type for list");
ok( $html =~ /"id"/, "ID in the json");

my $presenter = HTMLPresenter->new( 
    params => { n=>3 },
    result => CommandFactory::getCommand('list')->execute( { n=>3 } )
);

my ($type, $html) = $presenter->present();

use JSON;
my $json = decode_json( $html );
# use Data::Dumper;
# warn Dumper($json);
ok( scalar( @$json ) == 3, "JSON decoding");

my ($task) = @tasks;
$task->summary("update");

my $params = $task->hashify;
my $presenter = HTMLPresenter->new( 
    params => $params,
    result => CommandFactory::getCommand('update')->execute( $params  )
);
my ($type, $html) = $presenter->present();
ok(decode_json($html)->{summary} eq "update", "Updated");

use_ok("GetCommand");

$params = { id => $task->id };
my $presenter = HTMLPresenter->new( 
    params => $params,
    result => CommandFactory::getCommand('get')->execute( $params  )
);
my ($type, $html) = $presenter->present();
ok(decode_json($html)->{summary} eq "update", "retrieved");
ok(decode_json($html)->{id} eq $task->id, "id retrieved");

$params = { id => $task->id };
my $presenter = HTMLPresenter->new( 
    params => $params,
    result => CommandFactory::getCommand('remove')->execute( $params  )
);
my ($type, $html) = $presenter->present();
ok(decode_json($html)->{message} =~ /remove/i, "check if removed remove");
ok(decode_json($html)->{id} eq $task->id, "id removed");




END {
    done_testing();
}
