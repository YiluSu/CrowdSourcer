package TaskLite;
use Moose;

has 'id' => 'r', isa => 'String';
has 'summary' => 'r', isa => 'String';

sub get_task {
	my ($self) = @_;
	Database::get_database()->get_single_task($self->id);
}

sub from_task {
	my ($copy) = @_;
	return TaskLite->new( id => $copy->id, summary => $copy->summary );
}
1;
