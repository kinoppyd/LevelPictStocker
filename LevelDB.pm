package LevelDB;
BEGIN{ push  @INC, 'local/lib/perl5' }

use 5.10.0;
use Tie::LevelDB;
use File::Slurp;
use Digest::SHA1 qw/sha1_hex/;

my $db_key = 'db';
my $db_loc = 'db/files';

sub new {
    my $self = shift;
    return bless {
        $db_key => new Tie::LevelDB::DB($db_loc)
    }, $self;
}

sub store {
    my $self = shift;
    my ($data) = @_;

    my $digest = sha1_hex($data);

    $data_hex = unpack("H*", $data);
    $self->{$db_key}->Put($digest, $data_hex);
    $digest;
}

sub store_from_file {
    my $self = shift;
    my ($file) = @_;

    my $file_bin = read_file($file, binmode => ':raw');
    $self->{$db_key}->store($file_bin);
}

sub fetch {
    my $self = shift;
    my ($digest) = @_;

    my $file_hex = $self->{$db_key}->Get($digest);
    pack("H*", $file_hex);
}

1;
