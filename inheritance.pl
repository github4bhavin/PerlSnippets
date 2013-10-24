
# reference : http://www.perlmonks.org/?node_id=339131

package dog; 

sub new {
    my $proto=shift;
    my $class=ref($proto)||$class;
    my $self={};   # We should be overriding this...
    my %def_attrs = (
        color => "brown",
        loves_children => "yes",
        voice => "woof"
    );
    my $breed=shift;  # OK... so what kind of doggie are we?
    if ( $breed ) { # if not nill...
      $breed = "dog::" . $breed;
      eval " use $breed; " ;
      die $@ if $@;
      $self= new $breed;
      foreach my $key{keys %def_attrs){
        $self->{$key} = $def_attrs{$key} if not $self->{$key};
      }
      bless $self,$breed;
    } else {
      bless $self,$class; # kinda useless but we have to.
      return $self;
    }
}
sub bark { 
    my $self=shift;
    print "Woof\n" if not $self->{voice};
    printf "%s\n",$self->{voice} if $self->{voice};
}

#
# Late addition
sub wag_tail {
   print "tail wagging\n";
}
1;
[download]
and a simple test script:
use dog;
use Data::Dumper;
use strict;

my $frosty = new dog('samoyed');
my $cosette= new dog('cattle_dog');
my $moose= new dog('cocker');

print Dumper($frosty,$cosette,$moose);

$moose->bark; $moose->wag_tail;
$cosette->bark; $cosette->wag_tail;
$frosty->bark; $frosty->wag_tail;
[download]
Which when run yields:
$VAR1 = bless( {
                 'voice' => 'yarf',
                 'color' => 'brown',
                 'habits' => 'does not even look  at strangers',
                 'loves_children' => 'yes',
                 'temperment' => 'lazy',
                 'size' => 'large'
               }, 'dog::samoyed' );
$VAR2 = bless( {
                 'voice' => 'shreik',
                 'color' => 'brown',
                 'habits' => 'bites strangers',
                 'loves_children' => 'slathered in barbeque sauce',
                 'temperment' => 'fiercely loyal',
                 'size' => 'medium'
               }, 'dog::cattle_dog' );
$VAR3 = bless( {
                 'voice' => 'harf',
                 'color' => 'brown',
                 'habits' => 'bark at strangers',
                 'loves_children' => 'if well behaved',
                 'temperment' => 'loyal',
                 'size' => 'small'
               }, 'dog::cocker' );
harf
butt wiggles
shreik
tail over back
yarf
tail wagging
