package Task;
use Moose;

# unique identifier
has 'id' => 'r', isa => 'String';
# one line summary
has 'summary' => 'r', isa => 'String';
# long form description
has 'description' => 'r', isa => 'String';
# content will be free text like json
has 'content' => 'r', isa => 'String';

1;
