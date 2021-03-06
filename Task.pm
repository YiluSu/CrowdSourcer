package Task;
use Moose;
use Digest::SHA1 qw(sha1_hex);

# unique identifier
has 'id' => (is => 'rw', isa => 'Str');
# one line summary
has 'summary' => ( is => 'rw', isa => 'Str', default => '');
# long form description
has 'description' => (is => 'rw', isa => 'Str');
# content will be free text like json
has 'content' => ( is => 'rw');


sub hashify {
    my ($self) = @_;
    my $out = {};
    $out->{id} = $self->id() if ($self->id());
    $out->{description} = $self->description() if ($self->description());
    $out->{summary} = $self->summary() if ($self->summary());
    $out->{content} = $self->content() if ($self->content());
    return $out;
}
sub new_from_hash {
    my ($class, $h) = @_;
    return Task->new(%$h);
}
sub suggestid {
    my ($self) = @_;
    my $digest = sha1_hex(join("\n",($self->summary()||""), ($self->content()||""), ($self->description()||""), "".rand()));
    return $digest;
}
sub equals {
    my ($self, $other) = @_;
    return 0 if $self->id ne $other->id;
    return 0 if $self->description ne $other->description;
    return 0 if $self->summary ne $other->summary;
    return 1;
}
1;
