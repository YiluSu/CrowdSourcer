package DBLock;
use Moose;
use Fcntl qw(:flock);
extends 'Lock';

my $lockFilename = "db.lock";

sub BUILD {
    my ($self) = @_;
    $self->lock();
}
sub SHARED {
    return DBLock->new(locktype=> LOCK_SH);
}
sub EXCLUSIVE {
    return DBLock->new(locktype=> LOCK_EX);
}


sub lock {
    my ($self) = @_;
    open(my $fd, ">", $lockFilename) or die "Could not lock $!";
    $self->SUPER::fd( $fd );
    $self->SUPER::lock();
}
sub unlock {
    my ($self) = @_;
    $self->SUPER::unlock();
    my $fd = $self->fd;
    close($fd) if $fd;
    $self->fd(undef);
}
1;
