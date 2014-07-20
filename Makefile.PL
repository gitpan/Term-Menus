# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name            'Term-Menus';
sign;
author          'Brian M. Kelly <Brian.Kelly@fullautosoftware.net>';
license         'gpl-3.0';
all_from        'lib/Term/Menus.pm';

requires        'Data::Dump::Streamer'      => 0;
requires        'PadWalker'                 => 0;
requires        'Devel::Symdump'            => 0;
requires        'Term::ReadKey'             => 0;
requires        'Term::RawInput'            => 1.20;
auto_install;
WriteAll;

package MY; # so that "SUPER" works right
sub MY::distdir {

   my $inherited = shift->SUPER::distdir(@_);

   $inherited =~ s/^(distdir .*)$/$1 distsignature/m;

   $inherited;

}

