package Database;
use Moose;
use DB;

sub get_tasks {
	my ($self) = @_;
	return $self->get_last_tasks();
}
sub get_single_task {
	my ($self, $id) = @_;
	my $db = DB::readDB();
	return Task->new($db->{id});
}
sub get_last_tasks {
	my ($self, $n) = @_;
	my $db = DB::readDB();
	my @tasklist = @{ ($db->{_tasklist_} || []) };
	$n = $n || scalar(@tasklist);
	my @ids = @tasklist[max(0,$#tasklist - $n) .. $#tasklist];
	my @tasks = map { my $id = $_; Task->new( $db->{$id} ) } @ids;
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
