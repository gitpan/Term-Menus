use strict;

# On some platforms (*ahem*, MacPerl 5.6.1) "use lib qw(lib);" doesn't
# find the local "lib" directory, so we use File::Spec to do it properly.
use File::Spec;
use lib File::Spec->catdir('lib');

# We use Module::Build to test & install itself.
use Module::Build;

Module::Build->new(
   (sign => 1),
   module_name => 'Term::Menus',
   license     => 'gpl',
   requires => { perl => '5.002' },
   auto_features => {
               YAML_support =>
               {
                  description => "Can write fully-functional META.yml files",
                  requires => { YAML => ' >= 0.35 ' },
               },
            },
   dist_author => "Brian Kelly <Brian.Kelly\@fullautosoftware.net>",
   sign => 1,
   create_readme => 1,
   create_packlist => 1,
   test_files => [ 't/test.t' ],
)->create_build_script;

