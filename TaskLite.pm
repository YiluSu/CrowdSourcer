package TaskLite;
use Moose;
use Database;

# unique identifier
has 'id' => (is => 'rw', isa => 'Str');
# one line summary
has 'summary' => ( is => 'rw', isa => 'Str', default=>'');

sub get_task {
    my ($self) = @_;
    Database::get_database()->get_single_task($self->id);
}

sub from_task {
    my ($copy) = @_;
    return TaskLite->new( id => $copy->id, summary => $copy->summary );
}

sub hashify {
    my ($self) = @_;
    my $out = {};
    $out->{id} = $self->id() if ($self->id());
    $out->{summary} = $self->summary() if ($self->summary());
    return $out;
}


1;
