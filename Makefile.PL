# Load the Module::Install bundled in ./inc/
use inc::Module::Install;
    
# Define metadata
name            'Term-Menus';
all_from        'lib/Term/Menus.pm';
    
auto_install;
WriteAll;
