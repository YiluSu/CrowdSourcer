package TaskLite;
use Moose;
use Database;

# unique identifier
has 'id' => (is => 'rw', isa => 'Str');
# one line summary
has 'summary' => ( is => 'rw', isa => 'Str');

sub get_task {
	my ($self) = @_;
	Database::get_database()->get_single_task($self->id);
}

sub from_task {
	my ($copy) = @_;
	return TaskLite->new( id => $copy->id, summary => $copy->summary );
}
1;
