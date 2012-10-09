package Model;
use Moose;

sub get_tasks {
    my ($self) = @_;
    return $self->get_database()->get_tasks();
}

sub get_last_n_tasks {
    my ($self, $n) = @_;
    return $self->get_database()->get_last_tasks($n);
}
sub get_task_summaries {
    my ($self, $n) = @_;
    return $self->get_database()->get_task_summaries($n);
}

sub get_database {
    
}

1;
