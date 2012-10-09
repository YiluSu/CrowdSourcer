package Lock;
use Moose;
use Fcntl qw(:flock);
has 'locktype' => (is => 'rw');
has 'locked' => (is => 'rw');
has 'fd' => (is => 'rw');

sub unlock {
    my ($self) = @_;
    if ($self->locked) {
        my $fd = $self->fd;
        $self->locked(0);
        flock($fd, LOCK_UN);
    }
}
sub lock {
    my ($self) = @_;
    if ($self->locked) {
        return;
    }
    my $fd = $self->fd;
    flock($fd, $self->locktype) or die "Cannot lock file - $!\n";
    $self->locked(1);
}

sub DEMOLISH {
    my ($self) = @_;
    $self->unlock();
}
1;
