package Task;
use Moose;

# unique identifier
has 'id' => (is => 'rw', isa => 'Str');
# one line summary
has 'summary' => ( is => 'rw', isa => 'Str');
# long form description
has 'description' => (is => 'rw', isa => 'Str');
# content will be free text like json
has 'content' => ( is => 'rw', isa => 'Str');


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
1;
