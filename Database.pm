package Database;
use Moose;
use MyDB;
use List::Util qw(max);
use Task;
use TaskLite;

sub get_tasks {
    my ($self) = @_;
    return $self->get_last_tasks();
}

sub get_single_task {
    my ($self, $id) = @_;
    my $db = MyDB::readDB();
    return Task->new_from_hash($db->{$id});
}

sub get_last_tasks {
    my ($self, $n) = @_;
    my $db = MyDB::readDB();
    my @tasklist = @{ ($db->{_tasklist_} || []) };
    $n = $n || scalar(@tasklist);
    my @ids = @tasklist[max(0,scalar(@tasklist) - $n) .. $#tasklist];
    my @tasks = map { my $id = $_; Task->new_from_hash( $db->{$id} ) } @ids;
    return @tasks;
}

sub get_task_summaries {
    my ($self,$n) = @_;
    my @tasks = $self->get_last_tasks($n);
    my @summaries = map { TaskLite->new( id => $_->id(), summary => $_->summary()) } @tasks;
    return @summaries;
}

my $singleton = undef;
sub get_database {
    if (!$singleton) {
        $singleton = Database->new();
    }
    return $singleton;
}

sub insert_task {
    my ($self, $task) = @_;
    MyDB::readWriteDB( 
                      sub {
                          my ($db) = @_;
                          my $id = undef;
                          do {
                              $id = $task->suggestid();
                              if ($db->{$id}) {
                                  $id = undef;
                              }
                          } until (defined($id));
                          $task->id($id);
                          $db->{$id} = $task->hashify();
                          my $tl = $db->{_tasklist_} || [];
                          push @$tl, $id;
                          $db->{_tasklist_} = $tl;
                           return (1, $db);
                      });
    return $task;
}
sub update_task {
    my ($self, $task) = @_;
    MyDB::readWriteDB( sub {
                           my ($db) = @_;
                           $db->{$task->id} = $task->hashify();
                           return (1, $db);
                       });
}
1;
