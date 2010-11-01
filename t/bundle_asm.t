use strict;
use warnings;

use Test::More;

use lib 't/lib';

{
  package CMRFBA;
  use Moose;
  extends 'Config::MVP::Assembler';
  with 'Config::MVP::Assembler::WithBundles';
}

{
  package CMRFB;
  use Moose;
  extends 'Config::MVP::Reader::Hash';

  sub build_assembler { CMRFBA->new; }
}

{
  my $config = CMRFB->new->read_config({
    'Foo::Bar' => {
      x => 1,
      y => [ 2, 4 ],
      z => 3,
    },
    'bz' => {
      __package => 'Foo::Baz',
      single => 1,
      multi  => [ 2, 3 ],
    },
    'Foo::BoondleAssembler' => { },
    'Foo::Quux' => {
      a => 1,
      b => 2,
      c => 3,
    }
  });


  my @sections = $config->sections;

  is(@sections, 9, "there are nine sections");

  @sections = sort { lc $a->name cmp lc $b->name } @sections;

  is_deeply [
    map {
        { name => $_->name, package => $_->package, }
    } @sections
  ], [
        { name => 'boondle_1', package => 'Foo::Boo1' },
        { name => 'boondle_2', package => 'Foo::Boo2' },
        { name => 'boondle_3', package => 'Foo::Boo1' },
        { name => 'boondle_4', package => 'Foo::Boo2' },
        { name => 'boondle_B', package => 'Foo::Bar' },
        { name => 'boondle_C', package => 'Foo::Bar' },
        { name => 'bz', package => 'Foo::Baz' },
        { name => 'Foo::Bar', package => 'Foo::Bar' },
        { name => 'Foo::Quux', package => 'Foo::Quux' },
    ], "sections are as expected";


  my ($b_1, $b_3, $b_4, $b_b, $bar, $quux) = @sections[0, 2, 3, 4, 7, 8];

  is $b_1->payload->{x}, $bar->payload->{x},
      "boondle_1 got access to boondle_B payload";

  is $b_3->payload->{a}, $quux->payload->{a},
      "boondle_3 got access to Foo::Quux payload";

  is $b_4->payload->{b}, $quux->payload->{b},
      "boondle_4 got access to Foo::Quux payload";

  is $b_b->payload->{z}, $bar->payload->{z},
      "boondle_B got access to Foo::Bar payload";

}

done_testing;
