package Term::Menus;
 
#    Menus.pm
#
#    Copyright (C) 2000, 2001, 2002, 2003, 2004, 2005, 2006
#    by Brian M. Kelly. <Brian.Kelly@fullautosoftware.net>
#
#    You may distribute under the terms of the GNU General
#    Public License, as specified in the LICENSE file.
#    (http://www.opensource.org/licenses/gpl-license.php).
#
#    http://www.fullautosoftware.net/

## See user documentation at the end of this file.  Search for =head

require 5.002;

## Module export.
use vars qw(@EXPORT);
@EXPORT = qw(pick Menu);
## Module import.
use Exporter ();
our @ISA = qw(Exporter);


$VERSION = 1.16;


BEGIN {
   our $menu_cfg_file='';
   our $fullauto=0;
   if (caller(2) eq 'FullAuto') {
      require menu_cfg;
      import menu_cfg;
      $menu_cfg_file='menu_cfg.pm';
      $fullauto=1;
   }
}

##############################################################
##############################################################
#
#  If you would like to re-name the 'user-subroutine-module-file'
#  to a name that would facilitate management and
#  identification of user defined subroutines, then rename
#  everything between the two double-lines of pound
#  symbols above and below from the current name ( 'user_sub'
#  was the original default name ) to the new module
#  name of your choosing. 
#
#  Example:  use user_sub;                 --> use sales_sub;
#            our $sub_module='user_sub.pm' --> our $sub_module='sales_sub.pm';
#
#      Continue for the remainder of the section ...

BEGIN {
   our $sub_module='';
   if (caller(2) eq 'FullAuto') {
      require user_sub;
      import user_sub;
      $sub_module='user_sub.pm';
   }
}

our %email_defaults=();
if (defined %user_sub::email_defaults
      && %user_sub::email_defaults) {
   %email_defaults=%user_sub::email_defaults;
}
our %email_addresses=();
if (defined %user_sub::email_addresses
      && %user_sub::email_addresses) {
   %email_addresses=%user_sub::email_addresses;
}
our $passwd_file_loc='';
if (defined $user_sub::passwd_file_loc && $user_sub::passwd_file_loc) {
   $passwd_file_loc=$user_sub::passwd_file_loc;
}
our $test=0;
if (defined $user_sub::test && $user_sub::test) {
   $test=$user_sub::test;
}
our $timeout=30;
if (defined $user_sub::timeout && $user_sub::timeout) {
   $timeout=$user_sub::timeout; 
}
our $log=0;
if (defined $user_sub::log && $user_sub::log) {
   $log=$user_sub::log;
}

##############################################################
##############################################################

our %LookUpMenuName=();

my $m_flag=0;
my $s_flag=0;
foreach my $dir (@INC) {
   if (!$m_flag && -f "$dir/$menu_cfg_file") {
      $m_flag=1;
      open(FH,"<$dir/$menu_cfg_file");
      my $line='';my %menudups=();
      while ($line=<FH>) {
         if ($line=~/^[ \t]*\%(.*)\s*=/) {
            if (!exists $menudups{$1}) {
               $menudups{$1}='';
            } else {
               my $die="\n       FATAL ERROR! - Duplicate Hash Blocks:"
                      ."\n              ->  \"%$1\" is defined more than once\n"
                      ."              in the $dir/$menu_cfg_file file.\n\n"
                      ."       Hint:  delete or comment-out all duplicates\n\n";
               if ($fullauto) {
                  print $die if !$FA_lib::cron;
                  &FA_lib::handle_error($die,'__cleanup__');
               } else { die $die }
            }
         }
      }
   }
   if (!$s_flag && -f "$dir/$sub_module") {
      $s_flag=1;
      open(FH,"<$dir/$sub_module");
      my $line='';my %dups=();
      while ($line=<FH>) {
         if ($line=~/^[ \t]*\%(.*)\s*=/) {
            if (!exists $dups{$1}) {
               $dups{$1}='';
            } else {
               my $die="\n       FATAL ERROR! - Duplicate Hash Blocks:"
                      ."\n              ->  \"%$1\" is defined more "
                      ."than once\n              in the $dir/"
                      ."$sub_module file.\n\n       Hint:  delete "
                      ."or comment-out all duplicates\n\n";
               if ($fullauto) {
                  print $die if !$FA_lib::cron;
                  &FA_lib::handle_error($die,'__cleanup__');
               } else { die $die }
               #print $die;exit;
            }
         }
      }
   }
}

if ($fullauto) {
   no strict 'refs';
   foreach my $symname (keys %Term::Menus::) {
      if (eval "\\%$symname") {
         my $hashref=eval "\\%$symname";
         HF: foreach my $key (keys %{$hashref}) {
            if (ref ${$hashref}{$key} eq 'HASH') {
               foreach my $ky (keys %{${$hashref}{$key}}) {
                  if (lc($ky) eq 'text') {
                     $LookUpMenuName{$hashref}="$symname";
                     last HF;
                  }
               }
            }
         }
      }
   }
}

sub fa_login
{

   my $user_sub='';my $menu_args='';$to='';
   my $start_menu_ref='';
   eval {
      ($user_sub,$menu_args,$to)=&FA_lib::fa_login(@_);
      $start_menu_ref=$menu_cfg::start_menu_ref;
      $to||=0;
      $timeout=$to if $to;
      if ($user_sub) {
         &run_sub($user_sub,$menu_args);
      } elsif (ref $start_menu_ref eq 'HASH') {
         if (!exists $LookUpMenuName{$start_menu_ref}) {
            my $die="\n       FATAL ERROR! - The top level menu,"
                   ." indicated\n              by the "
                   ."\$start_menu_ref variable in\n       "
                   ."       the menu_cfg.pm file, is NOT\n"
                   ."              EXPORTED\n\n       Hint: "
                   ."\@EXPORT = qw( %Menu_1 %Menu_2 ... )\;"
                   ."\n\n\tour \$start_menu_ref=\\%Menu_1\;"
                   ."\n\n       \[ Menu_1 is example - "
                   ."name you choose is optional \]\n";
            &FA_lib::handle_error($die);
         }
         &Menu($start_menu_ref);
      } elsif ($start_menu_ref) {
         my $die="\n       FATAL ERROR! - The top level menu "
                ."block indicated\n              by the "
                ."\$start_menu_ref variable in the\n       "
                ."       menu_cfg.pm file, does not exist as"
                ."\n              a properly constructed and"
                ."\\or named hash\n              block in the"
                ." ".__PACKAGE__.".pm file\n\n       Hint:  "
                ."our \$start_menu_ref=\\%Menu_1\;\n\n       "
                ."\[ Menu_1 is example - name you choose is"
                ." optional \]\n\n       %Menu_1=\(\n"
                ."          Item_1 => { ... },\n        "
                ."...\n       \)\;\n";
         &FA_lib::handle_error($die);
      } else {
         my $die="\n       FATAL ERROR! - The \$start_menu_ref\n"
                ."              variable in the menu_cfg.pm\n"
                ."              file, is not defined or properly"
                ."\n              initialized with the name of "
                ."the\n              menu hash block designated"
                ." for the\n              top level menu.\n\n"
                ."              Hint:  our \$start_menu_ref"
                ."=\\%Menu_1\;\n\n       \[ Menu_1 is example - "
                ."name you choose is optional \]\n\n       "
                ."%Menu_1=\(\n          Item_1 => { ... },\n"
                ."          ...\n       \)\;\n";
         &FA_lib::handle_error($die);
      }
   };
   if ($@) {
      my $cmdlin=52;
      $cmdlin=47 if $user_sub;
      &FA_lib::handle_error($@,"-$cmdlin",'__cleanup__');
   }
   print "\n==> DONE!!!!!!!!!" if !$FA_lib::cron && !$FA_lib::stdio;
   &FA_lib::cleanup(1);

}

sub run_sub
{
   my $user_sub=$_[0];
   my $menu_args= (defined $_[1]) ? $_[1] : '';
   my $subfile=substr($sub_module,0,-3).'::';
   my $return=
      eval "\&$subfile$user_sub\(\@{\$menu_args}\)";
   &FA_lib::handle_error($@,'-1') if $@;
   return $return;
}

sub get_all_hosts
{
   return FA_lib::get_all_hosts(@_);
}

{
   use Sys::Hostname;
   our $local_hostname=hostname;
}

# Set clear
our $clear='';
$clear=$FA_lib::clear if defined $FA_lib::clear;
$clear.="\n" if $clear;
my $count=0;
our $blanklines='';
while ($count++!=30) { $blanklines.="\n" }
our $OS=$^O;
our $parent_menu='';

sub Menu
{
#print "MENUCALLER=",(caller)[0]," and ",__PACKAGE__,"\n";<STDIN>;
   my $MenuUnit_hash_ref=$_[0];
   my $picks_from_parent=$_[1];
   my $recurse= (defined $_[2]) ? $_[2] : 0;
   my $FullMenu= (defined $_[3]) ? $_[3] : {};
   my $Selected= (defined $_[4]) ? $_[4] : {};
   my $Conveyed= (defined $_[5]) ? $_[5] : {};
   my $SavePick= (defined $_[6]) ? $_[6] : {};
   my $SaveLast= (defined $_[7]) ? $_[7] : {};
   my $SaveNext= (defined $_[8]) ? $_[8] : {};
   my $parent_menu= (defined $_[9]) ? $_[9] : '';
   my $no_wantarray=0;
   if ((defined $_[10] && $_[10]) ||
         ((caller)[0] ne __PACKAGE__ && !wantarray)) {
      $no_wantarray=1;
   }
   my %Items=();my %negate=();my %result=();
   my %convey=();my %chosen=();my %default=();
   my $picks=[];my $banner='';my $num__='';
   my $display_this_many_items=10;
   my $master_substituted='';my $convey='';
   my $num=0;my @convey=();my $filtered=0;my $sorted='';
   foreach my $key (keys %{$MenuUnit_hash_ref}) {
      if (4<length $key && substr($key,0,4) eq 'Item') {
         $Items{substr($key,5)}=${$MenuUnit_hash_ref}{$key};
      }
   }
   ############################################
   # Breakdown the MenuUnit into its Components
   ############################################

      # Breakdown Each Item into its Components
      #########################################

   while (++$num) {
      @convey=();
      last unless exists $Items{$num};
      if (exists ${$Items{$num}}{Negate} &&
            (!exists ${$MenuUnit_hash_ref}{Select} ||
            ${$MenuUnit_hash_ref}{Select} eq 'One')) {
         my $die="Can Only Use \"Negate =>\""
                ."\n\t\tElement in ".__PACKAGE__.".pm when the"
                ."\n\t\t\"Select =>\" Element is set to \'Many\'\n\n";
         &FA_lib::handle_error($die) if $fullauto;
         die $die;
      }
      my $pmsi_regex=qr/\]p(?:r+evious[-_]*)*m*(?:e+nu[-_]*)
         *s*(?:e+lected[-_]*)*i*(?:t+ems[-_]*)*\[/xi;
      my $con_regex=qr/\]c(o+nvey)*\[/i;
      if (exists ${$Items{$num}}{Convey}) {
         if (ref ${$Items{$num}}{Convey} eq 'ARRAY') {
            #@convey=@{${$Items{$num}}{Convey}};
            foreach my $line (@{${$Items{$num}}{Convey}}) {
               $line=~s/\s?$//s;
               push @convey, $line;
            }
         } elsif (substr(${$Items{$num}}{Convey},0,1) eq '&') {
            if (defined $picks_from_parent &&
                          !ref $picks_from_parent) {
               ${$Items{$num}}{Convey}=~s/\s?$//s;
               my $convey=${$Items{$num}}{Convey};
               $convey=~s/$pmsi_regex/$picks_from_parent/;
               @convey=eval $convey;
            }
         } elsif (${$Items{$num}}{Convey}=~/$pmsi_regex/) {
            ${$Items{$num}}{Convey}=~s/\s?$//s;
            my $convey=${$Items{$num}}{Convey};
            $convey=~s/$pmsi_regex/$picks_from_parent/;
            push @convey, $convey;
         } else {
            ${$Items{$num}}{Convey}=~s/\s?$//s;
            push @convey, ${$Items{$num}}{Convey};
         }
         foreach my $item (@convey) {
            my $text=${$Items{$num}}{Text};
            $text=~s/$con_regex/$item/g;
            if ($text=~/$pmsi_regex\{([^}]+)\}/) {
               my $parse_text=$text;
               while ($parse_text=~m/($pmsi_regex)\{([^}]+)\}/g) {
                  my @nums=();my $one=$1;
                  my $two=$2;
                  my $menubasename=substr($two,0,(index $two,'_'));
                  if (-1<index $two,'|') {
                     my $nums=substr($two,(index $two,'_')+1);
                     foreach my $num (split /\s*\|\s*/, $nums) {
                        push @nums, $num;
                     }
                     $two=~s/\|/\\\|/g;
                  } else {
                     push @nums, substr($two,(index $two,'_')+1);
                  } $one=~s/\]/\\\]/;$one=~s/\[/\\\[/;
                  foreach my $num (@nums) {
                     if (exists ${$Conveyed}{"${menubasename}_$num"}) {
                        $text=~
                        s/$one\{$two\}/${$Conveyed}{"${menubasename}_$num"}/eg;
                        last;
                     }
                  }
                  $text=~s/$pmsi_regex/$picks_from_parent/g
                     if $picks_from_parent;
               }
            } elsif (defined $picks_from_parent) {
               $text=~s/$pmsi_regex/$picks_from_parent/g;
            }
            if (-1<index $text,"__Master_${$}__") {
               $text=~
                  s/__Master_${$}__/Local-Host: $local_hostname/sg;
               $master_substituted="Local-Host: $local_hostname";
            }
            if (exists ${$Items{$num}}{Include}) {
               if ($text=~/${$Items{$num}}{Include}/s) {
                  next if exists ${$Items{$num}}{Exclude} &&
                        $text=~/${$Items{$num}}{Exclude}/;
                  push @{$picks}, $text;
               } else { next }
            } elsif (exists ${$Items{$num}}{Exclude} &&
               $text=~/${$Items{$num}}{Exclude}/) {
               next;
            } else { push @{$picks}, $text }

            if (exists ${$Items{$num}}{Convey} &&
                  ${$Items{$num}}{Convey} ne '') {
               $convey{$text}=[$item,${$Items{$num}}{Convey}];
            } elsif (!exists ${$Items{$num}}{Convey}) {
               $convey{$text}=[$item,''];
            }
            $default{$text}=${$Items{$num}}{Default}
               if exists ${$Items{$num}}{Default};
            $negate{$text}=${$Items{$num}}{Negate}
               if exists ${$Items{$num}}{Negate};
            $result{$text}=${$Items{$num}}{Result}
               if exists ${$Items{$num}}{Result};
            $filtered=1 if exists ${$Items{$num}}{Filter};
            $sorted=${$Items{$num}}{Sort}
               if exists ${$Items{$num}}{Sort};
            $chosen{$text}="Item_$num";
         }
      } else {
         my $text=${$Items{$num}}{Text};
         if ($text=~/$pmsi_regex\{([^}]+)\}/) {
            my $parse_text=${$Items{$num}}{Text};
            while ($parse_text=~m/($pmsi_regex)\{([^}]+)\}/g) {
               my @nums=();my $one=$1;
               my $two=$2;
               my $menubasename=substr($two,0,(index $two,'_'));
               if (-1<index $two,'|') {
                  my $nums=substr($two,(index $two,'_')+1);
                  foreach my $num (split /\s*\|\s*/, $nums) {
                     push @nums, $num;
                  }
                  $two=~s/\|/\\\|/g;
               } else {
                  push @nums, substr($two,(index $two,'_')+1);
               } $one=~s/\]/\\\]/;$one=~s/\[/\\\[/;
               foreach my $num (@nums) {
                  if (exists ${$Conveyed}{"${menubasename}_$num"}) {
                     ${$Items{$num}}{Text}=~
                     s/$one\{$two\}/${$Conveyed}{"${menubasename}_$num"}/eg;
                     last;
                  }
               }
               $text=~s/$pmsi_regex/$picks_from_parent/g
                  if $picks_from_parent;
            }
         } elsif (defined $picks_from_parent) {
            $text=~s/$pmsi_regex/$picks_from_parent/g;
         }
         if (-1<index ${$Items{$num}}{Text},"__Master_${$}__") {
            $text=~
               s/__Master_${$}__/Local-Host: $local_hostname/sg;
            $master_substituted=
                             "Local-Host: $local_hostname";
         }
         if (exists ${$Items{$num}}{Include}) {
            if (${$Items{$num}}{Text}=~/${$Items{$num}}{Include}/) {
               next if exists ${$Items{$num}}{Exclude} &&
                     ${$Items{$num}}{Text}=~/${$Items{$num}}{Exclude}/;
            
               push @{$picks}, $text;
            } else { next }
         } elsif (exists ${$Items{$num}}{Exclude} &&
            ${$Items{$num}}{Text}=~/${$Items{$num}}{Exclude}/) {
            next;
         } else { push @{$picks}, $text }
         $convey{${$Items{$num}}{Text}}=['',${$Items{$num}}{Convey}]
            if exists ${$Items{$num}}{Convey};
         $default{${$Items{$num}}{Text}}=${$Items{$num}}{Default}
            if exists ${$Items{$num}}{Default};
         $negate{${$Items{$num}}{Text}}=${$Items{$num}}{Negate}
            if exists ${$Items{$num}}{Negate};
         $result{${$Items{$num}}{Text}}=${$Items{$num}}{Result}
            if exists ${$Items{$num}}{Result};
         $chosen{${$Items{$num}}{Text}}="Item_$num";
         $num__{${$Items{$num}}{Text}}=${$Items{$num}}{__NUM__}
            if exists ${$Items{$num}}{__NUM__};
         $filtered=1 if exists ${$Items{$num}}{Filter};
         $sorted=${$Items{$num}}{Sort}
            if exists ${$Items{$num}}{Sort}; 
      } $banner='';
   }


      #########################################
      # End Items Breakdown

   $banner=${$_[0]}{Banner}
      if exists ${$_[0]}{Banner};
   $display_this_many_items=${$_[0]}{Display}
      if exists ${$_[0]}{Display};


   ############################################
   # End MenuUnit Breakdown
   ############################################

   my $cl_def=0;
   foreach my $key (keys %{$SaveNext}) {
      if (${$FullMenu}{$key}[5] eq 'ERASE') {
         ${$FullMenu}{$key}[5]='' if !exists ${$SaveLast}{$key};
         $cl_def=1;
         last;
      }
   }
   %default=() if defined ${$FullMenu}{$MenuUnit_hash_ref}[5]
      && !$cl_def;
   my $nm_=(keys %num__)?\%num__:'_ZERO_';
   ${$FullMenu}{$MenuUnit_hash_ref}=[ $MenuUnit_hash_ref,
      \%negate,\%result,\%convey,\%chosen,\%default,$nm_,
      $filtered,$picks ];
   if (exists ${$MenuUnit_hash_ref}{Select} &&
         ${$MenuUnit_hash_ref}{Select} eq 'Many') {
      ($pick,$FullMenu,$Selected,$Conveyed,$SavePick,
              $SaveLast,$SaveNext,$parent_menu)=&pick($picks,$banner,
                        $display_this_many_items,'',
                        $MenuUnit_hash_ref,++$recurse,
                        $picks_from_parent,$parent_menu,
			$menu_cfg_file,$FullMenu,
			$Selected,$Conveyed,$SavePick,
			$SaveLast,$SaveNext,
		        \%LookUpMenuName,\@convey,
                        $no_wantarray);
      if ($fullauto && $master_substituted) {
         $pick=~s/$master_substituted/__Master_${$}__/sg;
      }
      if ($pick eq ']quit[') {
         return ']quit['
      } elsif ($pick eq '-' || $pick eq '+') {
         return $pick,$FullMenu,$Selected,$Conveyed,
                    $SavePick,$SaveLast,$SaveNext;
      } elsif ($pick=~/DONE/) {
         return $pick,$FullMenu,$Selected,$Conveyed,
                       $SavePick,$SaveLast,$SaveNext;
      } elsif (ref $pick eq 'ARRAY' && wantarray
            && 1==$recurse) {
         return @{$pick}
      } elsif ($pick) { return $pick }
   } else {
      my $pick=(&pick($picks,$banner,$display_this_many_items,
                       '',$MenuUnit_hash_ref,++$recurse,
                       $picks_from_parent,$parent_menu,
		       $menu_cfg_file,$FullMenu,
		       $Selected,$Conveyed,$SavePick,
		       $SaveLast,$SaveNext,
	               \%LookUpMenuName,\@convey,
                       $no_wantarray))[0];
      if ($fullauto && $master_substituted) {
         $pick=~s/$master_substituted/__Master_${$}__/sg;
      }
      if ($pick eq ']quit[') {
         return ']quit['
      } elsif ($pick eq '-' || $pick eq '+') {
         if (keys %{${$Selected}{$MenuUnit_hash_ref}}) {
            return '+',$FullMenu,$Selected,$Conveyed,
                       $SavePick,$SaveLast,$SaveNext;
         } else {
            return $pick,$FullMenu,$Selected,$Conveyed,
                       $SavePick,$SaveLast,$SaveNext;
         }
      } elsif ($pick=~/DONE/) {
         return $pick,$FullMenu,$Selected,$Conveyed,
                       $SavePick,$SaveLast,$SaveNext;
      } elsif (ref $pick eq 'ARRAY' && wantarray
            && 1==$recurse) {
         return @{$pick}
      } elsif ($pick) { return $pick }
   }

}

sub pick # USAGE: &pick( ref_to_choices_array,
             #  (Optional)       banner_string,
             #  (Optional)       display_this_many_items,
	     #  (Optional)       log_file_handle,
             #  ----------
             #  For Use With Sub-Menus
             #  ----------
             #  (Optional)       MenuUnit_hash_ref,
             #  (Optional)       recurse_level,
             #  (Optional)       picks_from_parent,
	     #  (Optional)       parent_menu,
	     #  (Optional)       menus_cfg_file,
             #  (Optional)       Full_Menu_data_structure,
             #  (Optional)       Selected_data_structure,
             #  (Optional)       Conveyed_data_structure,
             #  (Optional)       SavePick_data_structure,
             #  (Optional)       SaveLast_data_structure, 
             #  (Optional)       SaveNext_data_structure,
	     #  (Optional)       LookUpMenuName_data_structure,
             #  (Optional)       convey_item_contents_arrayref_from_menu,
             #  (Optional)       no_wantarray_flag )
{

   #  "pick" --> This function presents the user with
   #  with a list of items from which to choose.

   my @pickone=@{$_[0]};
   my $banner=defined $_[1] ? $_[1] : "\n   Please Pick an Item :";
   my $display_this_many_items=defined $_[2] ? $_[2] : 10;
   my $log_handle= (defined $_[3]) ? $_[3] : '';

   # Used Only With Cascasding Menus (Optional)
   my $MenuUnit_hash_ref= (defined $_[4]) ? $_[4] : '';
   my $recurse_level= (defined $_[5]) ? $_[5] : 1;
   my $picks_from_parent= (defined $_[6]) ? $_[6] : '';
   my $parent_menu= (defined $_[7]) ? $_[7] : '';
   my $menu_cfg_file= (defined $_[8]) ? $_[8] : '';
   my $FullMenu= (defined $_[9]) ? $_[9] : {};
   my $Selected= (defined $_[10]) ? $_[10] : {};
   my $Conveyed= (defined $_[11]) ? $_[11] : {};
   my $SavePick= (defined $_[12]) ? $_[12] : {};
   my $SaveLast= (defined $_[13]) ? $_[13] : {};
   my $SaveNext= (defined $_[14]) ? $_[14] : {};
   my $LookUpMenuName= (defined $_[15]) ? $_[15] : {};
   my $Convey_contents= (defined $_[16]) ? $_[16] : [];
   my $no_wantarray= (defined $_[17]) ? $_[17] : 0;

   my %items=();my %picks=();my %negate=();
   my %exclude=();my %include=();my %default=();
   if ($SavePick && exists ${$SavePick}{$MenuUnit_hash_ref}) {
      %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
   }
   my $num_pick=$#pickone+1;
   my $caller=(caller(1))[3];
   print $blanklines;
   if ($OS ne 'cygwin') {
      if ($clear) {
         print $clear;
      } elsif ($OS eq 'MSWin32') {
         system("cmd /c cls");
         print "\n";
      } else {
         print `clear`."\n";
      }
   }
   my $numbor=0;                    # Number of Item Selected
   my $return_from_child_menu=0;

   my $choose_num='';
   my $convey='';
   my $menu_output='';
   my $hidedefaults=0;
   my $start=0;

   sub delete_Selected
   {
      my $Selected=$_[2];
      my $SavePick=$_[3];
      my $SaveNext=$_[4];
      if ($_[1]) {
         my $result=${$Selected}{$_[0]}{$_[1]};
         delete ${$Selected}{$_[0]}{$_[1]};
         delete ${$SavePick}{$_[0]}{$_[1]};
         #delete ${$SaveNext}{$_[0]};
         if ($result) {
            &delete_Selected($result,'',
                $Selected,$SavePick,$SaveNext);
         } delete ${$SaveNext}{$_[0]};
      } else {
         if (keys %{${$Selected}{$_[0]}}) {
            foreach my $key (keys %{${$Selected}{$_[0]}}) {
               delete ${$Selected}{$_[0]}{$key};
               delete ${$SavePick}{$_[0]}{$key};
               delete ${$SaveNext}{$_[0]};
            }
         } else {
            foreach my $key (keys %{${$SavePick}{$_[0]}}) {
               delete ${$SavePick}{$_[0]}{$key};
               delete ${$SaveNext}{$_[0]};
            }
         } 
      } delete ${$SaveNext}{$_[0]};
      return $SaveNext;

   } 

   sub find_Selected
   {
      my $Selected=$_[2];
      if ($_[1]) {
         my $result=${$Selected}{$_[0]}{$_[1]};
         if (substr($result,0,1) eq '&') {
            return 0;
         } else {
            return &find_Selected($result,'',$Selected);
         }
      } else {
         if (keys %{${$Selected}{$_[0]}}) {
            foreach my $key (keys %{${$Selected}{$_[0]}}) {
               my $result=${$Selected}{$_[0]}{$key};
               return '+' if substr($result,0,1) eq '&'; 
               my $output=find_Selected($result,'',$Selected);
               return '+' if $output eq '+';
            }
         }
      }
   }

   sub get_subs_from_menu
   {
      my $Selected=$_[0];
      my @subs=();
      foreach my $key (keys %{$Selected}) {
         foreach my $item (keys %{${$Selected}{$key}}) {
            if (substr(${$Selected}{$key}{$item},0,1) eq '&') {
               push @subs, ${$Selected}{$key}{$item};
            }
         }
      } return @subs;
   }

   my $get_result = sub {

      # $_[0] => $MenuUnit_hash_ref
      # $_[1] => \@pickone
      # $_[2] => $numbor
      # $_[3] => $picks_from_parent

      my $convey='';my $result='';
      my $send_all=0;my $all_convey='';
      my $FullMenu=$_[4];
      my $Conveyed=$_[5];
      my $Selected=$_[6];
      my $SaveNext=$_[7];
      my $parent_menu=$_[8];
      my $menu_cfg_file=$_[9];
      my $Convey_contents=$_[10];
      if (exists ${$FullMenu}{$_[0]}[3]{${$_[1]}[$_[2]-1]}) {
         if (exists ${$_[0]}{${$FullMenu}{$_[0]}
                            [4]{${$_[1]}[$_[2]-1]}}{Convey}) {
            $convey=${${$FullMenu}{$_[0]}[3]}
                               {${$_[1]}[$_[2]-1]}[0];
            if (keys %{${$Selected}{$_[0]}}) {
               my $get_convey='';
               foreach my $item (keys %{${$Selected}{$_[0]}}) {
                  $get_convey.='"'.${${$FullMenu}{$_[0]}[3]}
                               {${$_[1]}[$item-1]}[0].'",'
               } $get_convey.="\"$convey\"";
               $all_convey="[ $get_convey ]";
            }
            $convey='SKIP' if $convey eq '';
         }
         if (exists ${$_[0]}{${$FullMenu}{$_[0]}
               [4]{${$_[1]}[$_[2]-1]}}{Convey}) {
            ${$Conveyed}{${$LookUpMenuName}{$_[0]}}=$convey;
            $parent_menu=${$LookUpMenuName}{$_[0]};
            if (ref ${$_[0]}{${$FullMenu}{$_[0]}
                  [4]{${$_[1]}[$_[2]-1]}}{'Result'} eq 'HASH') {
               if (exists ${$_[0]}{${$FullMenu}{$_[0]}
                     [4]{${$_[1]}[$_[2]-1]}}{'Result'}{'Label'}) {
                  $LookUpMenuName{${$_[0]}{${$FullMenu}{$_[0]}
                     [4]{${$_[1]}[$_[2]-1]}}{'Result'}}=
                     ${$_[0]}{${$FullMenu}{$_[0]}
                     [4]{${$_[1]}[$_[2]-1]}}{'Result'}{'Label'};
                  $parent_menu=$LookUpMenuName{$_[0]};
               } else {
                  die "NO LABEL IN MENU BLOCK\n"; 
               }
            } elsif (unpack('a1',
                  ${$_[0]}{${$FullMenu}{$_[0]}
                  [4]{${$_[1]}[$_[2]-1]}}{'Result'})
                  ne '&') {
            }
         }
      } else { $convey=$_[3] }
      if (exists ${$FullMenu}{$_[0]}[2]
                                  {${$_[1]}[$_[2]-1]}) {
         my $ret_regex=qr/\]r(e+turn)*\[/i;
         my $test_result=substr(${$FullMenu}{$_[0]}
            [2]{${$_[1]}[$_[2]-1]},0,1);
         if ((ref ${$FullMenu}{$_[0]}[2]
                   {${$_[1]}[$_[2]-1]} eq 'HASH' &&
                   exists ${$FullMenu}{$_[0]}[2]
                   {${$_[1]}[$_[2]-1]}{Item_1})
                   || substr(${$FullMenu}{$_[0]}
                   [2]{${$_[1]}[$_[2]-1]},0,1) eq '&'
                   || ${$FullMenu}{$_[0]}[2]{${$_[1]}[$_[2]-1]}
                   =~/$ret_regex/) {
            $result=${$FullMenu}{$_[0]}[2]
                                     {${$_[1]}[$_[2]-1]};
            my $con_regex=qr/\]c(o+nvey)*\[/i;
            my $sicm_regex=
               qr/\]s(e+lected[-_]*)*i*(t+ems[-_]*)
                  *c*(u+rrent[-_]*)*m*(e+nu[-_]*)*a*(l+l)*\[/xi;
            my $pmsi_regex=qr/\]p(r+evious[-_]*)*m*(e+nu[-_]*)
                  *s*(e+lected[-_]*)*i*(t+ems[-_]*)*\[/xi;
            if (ref $result eq 'HASH' &&
                    !exists ${$LookUpMenuName}{$result}) {
            #   my $die="The \"Result =>\" Setting".
            #           "\n\t\tFound in the Menu Unit -> ".
            #          "${$LookUpMenuName}{$_[0]}\n\t\tis a ".
            #           "HASH reference to a Menu Unit\,\n\t\t".
            #           "that does NOT EXIST or is NOT EXPORTED".
            #           "\n\n\tHint: Make sure the Names of all".
            #           "\n\t      Menu Hash Blocks in the\n\t".
            #           "      $menus_cfg_file file are\n\t".
            #           "      listed in the \@EXPORT list\n\t".
            #           "      found at the beginning of\n\t".
            #           "      the $menus_cfg_file file\n\n\t".
            #           "our \@EXPORT = qw( %Menu_1 %Menu_2 ... )\;\n";
            #   #print $MRLOG $die if -1<index $MRLOG,'*';
            #   #close($MRLOG) if -1<index $MRLOG,'*';
               if (exists ${$result}{'Label'}) {
                  $LookUpMenuName{$result}=${$result}{'Label'};
               } else {
                  my $die="NO MENU LABEL DEFINED\n";
                  &FA_lib::handle_error($die) if $fullauto;
                  die $die;
               }
            }
            if ($result=~/$con_regex|$pmsi_regex|$sicm_regex/) {
               my $one='';
               while ($result=~m/($sicm_regex)/g) {
                  next if $1 eq $one;
                  $one=$1;
                  $send_all=1 if -1<index lc($one),'a';
                  my $esc_one=$one;
                  $esc_one=~s/\]/\\\]/;$esc_one=~s/\[/\\\[/;
                  if ($convey ne 'SKIP') {
                     if ($send_all) {
                        if (${$MenuUnit_hash_ref}{Select} eq 'Many') {
                           $result=~s/\"$esc_one\"/$all_convey/g;
                        } else {
                           my $die="Can Only Use \"All\" (or A)";
                           $die.="\n\t\tQualifier in ".__PACKAGE__;
                           $die.=".pm when the";
                           $die.="\n\t\t\"Select =>\" Element is ";
                           $die.="set to\n\t\t\'Many\' in Menu Block ";
                           $die.='%'.${$LookUpMenuName}{$_[0]}."\n\n";
                           &FA_lib::handle_error($die) if $fullauto;
                           die $die;
                        }
                     } else {
                        $result=~s/$esc_one/$convey/g;
                     }
                  } $result=~s/$esc_one/${$_[1]}[$_[2]-1]/g;
               } $one='';
               while ($result=~m/($pmsi_regex)/g) {
                  next if $1 eq $one;
                  $one=$1;
                  my $esc_one=$one;
                  $esc_one=~s/\]/\\\]/;$esc_one=~s/\[/\\\[/;
                  while ($result=~m/$esc_one\{[^}]+\}/) {
                     my $convey_ed=${$Conveyed}{$1};
                     $result=~s/$esc_one\{([^}]+)\}/${$Conveyed}{$1}/e;
                  } my $pp=$picks_from_parent;
                  $pp="\"$pp\"" if $pp=~/\s/s;
                  $result=~s/$esc_one/$pp/g;
               } $one='';
               while ($result=~m/($con_regex)/g) {
                  next if $1 eq $one;
                  $one=$1;
                  my $esc_one=$one;
                  $esc_one=~s/\]/\\\]/;$esc_one=~s/\[/\\\[/;
                  $result=~s/\"$esc_one\"/$Convey_contents/g;
               }
            } elsif (substr($result,0,1) eq '&') {
               my $subname='&'.substr($sub_module,0,-3)
                           .'::'.substr($result,1);
               if (!eval "defined $subname") {
                  my $die="The \"Result =>\" Setting";
                  $die.="\n\t\t-> " . ${$FullMenu}{$_[0]}
                                      [2]{${$_[1]}[$_[2]-1]};
                  $die.="\n\t\tFound in the Menu Unit -> ";
                  $die.="${$LookUpMenuName}{$_[0]}\n\t\t";
                  $die.="Specifies a Subroutine\,";
                  $die.=" $result that Does NOT Exist\n\t\tin the ";
                  $die.=" User Subroutines File $sub_module";
                  $die.=".\n";
                  if (defined $log_handle &&
                        -1<index $log_handle,'*') {
                     print $log_handle $die;
                     close(log_handle);
                  }
                  &FA_lib::handle_error($die) if $fullauto;
                  die $die;
               }
            }
            if ($result=~/Convey\s*=\>/) {
               if ($convey ne 'SKIP') {
                  $result=~s/Convey\s*=\>/$convey/g;
               } else {
                  $result=~s/Convey\s*=\>/${$_[1]}[$_[2]-1]/g;
               }
            }
            if ($result=~/Text\s*=\>/) {
               $result=~s/Text\s*=\>/${$_[1]}[$_[2]-1]/g;
            }
         } else {
            my $die="\n       FATAL ERROR! - The \"Result =>\" Setting"
                   ."\n              -> " . ${$FullMenu}{$_[0]}
                                            [2]{${$_[1]}[$_[2]-1]}
                   ."\n              Found in the Menu Unit -> "
                   ."$_[0]\n              is not a Menu Unit\,"
                   ." and Because it Does Not Have\n              "
                   ."an \"&\" as the Lead Character, $0\n"
                   ."              Cannot Determine "
                  ."if it is a Valid SubRoutine.\n\n";
            if ($fullauto) {
               print $die if !$FA_lib::cron;
               &FA_lib::handle_error($die);
            } else { die $die }
         }
      }
      chomp($_[2]);
      if ($send_all && keys %{${$Selected}{$_[0]}}) {
         foreach my $item (keys %{${$Selected}{$_[0]}}) {
            ${$Selected}{$_[0]}{$item}='';
         }
      } ${$Selected}{$_[0]}{$_[2]}=$result;
      if (ref ${$_[0]}{${$FullMenu}{$_[0]}
            [4]{${$_[1]}[$_[2]-1]}}{'Result'} eq 'HASH') {
         if (exists ${$_[0]}{${$FullMenu}{$_[0]}
               [4]{${$_[1]}[$_[2]-1]}}{'Result'}{'Label'}) {
            ${$SaveNext}{$_[0]}=
               ${${$FullMenu}{$_[0]}[2]}
               {${$_[1]}[$_[2]-1]};
         } else {
            die "NO MENU LABEL DEFINED\n";
         }
      } return $FullMenu,$Conveyed,$SaveNext,$Selected,$convey,$parent_menu;
   };

   my $sum_menu=0;my $filtered_menu=0;
   while (1) {
      if ($num_pick-$start<=$display_this_many_items) {
         $choose_num=$num_pick-$start;
      } else { $choose_num=$display_this_many_items }
      $numbor=$start+$choose_num+1;my $done=0;my $savechk=0;my %pn=();
      my $sorted_flag=0;
      while ($numbor<=$start || $start+$choose_num < $numbor) {
         my $menu_text='';my $pn='';
         $menu_text.=$banner if defined $banner;
         $menu_text.="\n\n";
         my $picknum=$start+1;
         my $numlist=$choose_num;
         my $mark=' ';my $mark_flg=0;my $prev_menu=0;
         while (0 < $numlist) {
            if (exists $picks{$picknum}) {
               $mark_flg=1;
               if ($return_from_child_menu) {
                  $mark=$picks{$picknum}=$return_from_child_menu;
                  $prev_menu=$picknum;
               } else { $mark=$picks{$picknum} }
               if ($picks{$picknum} ne '+' && $picks{$picknum} ne '-') {
                  $mark_flg=1;$mark='*';
                  if (exists ${$FullMenu}{$MenuUnit_hash_ref}[2]
                        {$pickone[$picknum-1]}{Item_1}) {
                     if (exists ${$FullMenu}{$MenuUnit_hash_ref}[3]
                                         {$pickone[$picknum-1]}) {
                        $convey=${${$FullMenu}{$MenuUnit_hash_ref}[3]
                                         {$pickone[$picknum-1]}}[0];
                     } else { $convey=$pickone[$picknum-1] }
                     ($menu_output,$FullMenu,$Selected,$Conveyed,$SavePick,
                        $SaveLast,$SaveNext)=&Menu(${$FullMenu}
                        {$MenuUnit_hash_ref}[2]
                        {$pickone[$picknum-1]},$convey,
                        $recurse_level,$FullMenu,
                        $Selected,$Conveyed,$SavePick,
                        $SaveLast,$SaveNext,$MenuUnit_hash_ref,
                        $no_wantarray);
                     chomp($menu_output) if !(ref $menu_output);
                     if ($menu_output eq '-') {
                        $picks{$picknum}='-';$mark='-';
                     } elsif ($menu_output eq '+') {
                        $picks{$picknum}='+';$mark='+';
                     } elsif ($menu_output eq 'DONE_SUB') {
                        return 'DONE_SUB';
                     } elsif ($menu_output eq 'DONE') {
                        if (1==$recurse_level) {
                           my $subfile=substr($sub_module,0,-3).'::';
                           foreach my $sub (&get_subs_from_menu($Selected)) {
                              $sub=unpack('x1 a*',$sub);
                              eval {
                                 unless (defined eval "$subfile$sub") {
                                    if ($@) {
                                       if ($fullauto) {
                                          &FA_lib::handle_error($@,'-1');
                                       } else { die $@ }
                                    }
                                    #### TEST FOR UNDEF SUB - ADD MORE
                                    #### ERROR INFO
                                 }
                              };
                              if ($@) {
                                 &FA_lib::handle_error($@,'-5')
                                    if $fullauto;
                                 die $@;
                              }
                           } return 'DONE_SUB';
                        } else { return 'DONE' }
                     } elsif ($menu_output) {
                        return $menu_output;
                     } else { $picks{$picknum}='+';$mark='+' }
                  } else {
                     $picks{$picknum}='*';
                  }
               }
            } else { $mark=' ' }
            if (!$hidedefaults && ${$FullMenu}{$MenuUnit_hash_ref}[5]
                  {$pickone[$picknum-1]} && (${$FullMenu}
                  {$MenuUnit_hash_ref}[5]{$pickone[$picknum-1]}
                  eq '*' || $pickone[$picknum-1]=~
                  /${$FullMenu}{$MenuUnit_hash_ref}[5]{$pickone[$picknum-1]}/
                  )) {
               $picks{$picknum}='*';$mark='*';$mark_flg=1;
            }
            $pn=$picknum;
            if (${$FullMenu}{$MenuUnit_hash_ref}[6]{$pickone[$picknum-1]} &&
                  ${$FullMenu}{$MenuUnit_hash_ref}[6]{$pickone[$picknum-1]}
                  ne '_ZERO_') {
               $pn=${$FullMenu}{$MenuUnit_hash_ref}[6]{$pickone[$picknum-1]};
               $mark=${$SavePick}{$parent_menu}{$pn}||' ';
               if (${$FullMenu}{$MenuUnit_hash_ref}[7]) {
                  $filtered_menu=1;
               } else {
                  $sum_menu=1;
               }
            }
            $pn{$pn}='';
            $menu_text.="   $mark  $pn. \t$pickone[$picknum-1]\n";
            if ($mark eq ' ' || (exists $picks{$picknum} ||
                  exists $picks{$pn})) {
               ${$_[0]}[$pn-1]=$pickone[$picknum-1];
               #$picknum++;
            } $picknum++;
            $numlist--;
         } $hidedefaults=1;
         print $blanklines;
         if ($OS ne 'cygwin') {
            if ($clear) {
               print $clear;
            } elsif ($OS eq 'MSWin32') {
               system("cmd /c cls");
               print "\n";
            } else {
               print `clear`."\n";
            }
         } print $menu_text;
         if (wantarray && !$no_wantarray &&
               (exists ${$MenuUnit_hash_ref}{Select} &&
               ${$MenuUnit_hash_ref}{Select} eq 'Many')) {
            print "\n";my $ch=0;
            unless (keys %{${$FullMenu}{$MenuUnit_hash_ref}[1]}) {
               print "   a.  Select All.";$ch=1;
            }
            if ($mark_flg==1) {
               print "   c.  Clear All.";print "\n" if $ch;
            } 
            print "   f.  Finish.\n";
         }
         if ($display_this_many_items<$num_pick) {
            print "\n   $num_pick Total Choices\n",
                  "\n   Press ENTER \(or \"d\"\) to scroll downward\n",
                  "\n   OR \"u\" to scroll upward  \(Press \"q\" to quit\)\n";
         } else { print"\n   \(Press \"q\" to quit\)\n" }
         print"\n   PLEASE ENTER A CHOICE: ";
         $numbor=<STDIN>;$pn=$numbor;chomp $pn;
         if ($numbor=~/^f$/i && wantarray && !$no_wantarray
               && (exists ${$MenuUnit_hash_ref}{Select} &&
               ${$MenuUnit_hash_ref}{Select} eq 'Many')) {
            my $choice='';my @keys=();
            @keys=keys %picks;
            if (-1==$#keys) {
               @keys=keys %{${$SavePick}{$parent_menu}};
               if (-1==$#keys) {
### DO CONDITIONAL FOR THIS!!!!!!!!!!!!!!!!!
                  print $blanklines;
                  if ($OS ne 'cygwin') {
                     if ($clear) {
                        print $clear;
                     } elsif ($OS eq 'MSWin32') {
                        system("cmd /c cls");
                        print "\n";
                     } else {
                        print `clear`."\n";
                     }
                  }
                  print "\n\n       Attention USER! :\n\n       ",
                        "You have selected \"f\" to finish your\n",
                        "       selections, BUT -> You have not actually\n",
                        "       selected anything!\n\n       Do you wish ",
                        "to quit or re-attempt selecting?\n\n       ",
                        "Press \"q\" to quit or ENTER to continue ... ";
                  $choice=<STDIN>;
                  chomp($choice);
                  next if lc($choice) ne 'q';
                  return ']quit['
              }
            }
            my $ret_regex=qr/\]?r(e+turn)*\[?/i;
            my $return_values=0;
            sub numerically { $a <=> $b }
            my @sortedpicks=();
            if ($sum_menu || $filtered_menu) {
               @sortedpicks=sort numerically keys
                  %{${$SavePick}{$parent_menu}};
            } else {
               @sortedpicks=sort numerically keys %picks;
            }
            foreach my $pk (@sortedpicks) {
               $return_values=1 if !exists
                  ${$FullMenu}{$MenuUnit_hash_ref}[2]{${$_[0]}[$pk-1]}
                  || !keys
                  %{${$FullMenu}{$MenuUnit_hash_ref}[2]{${$_[0]}[$pk-1]}}
                  || ${$FullMenu}{$MenuUnit_hash_ref}[2]{${$_[0]}[$pk-1]}
                  =~/$ret_regex/i;
               #if ($filtered_menu || $sorted) {
               if (${${$FullMenu}{$parent_menu}[8]}[$pk-1] &&
                     !${$_[0]}[$pk-1]) {
                  my $txt=${${$FullMenu}{$parent_menu}[8]}[$pk-1];
                  if (-1<index $txt,"__Master_${$}__") {
                     $txt=~
                        s/__Master_${$}__/Local-Host: $local_hostname/sg;
                  }
                  push @pickd, $txt;
               } elsif (${$_[0]}[$pk-1]) {
                  my $txt=${$_[0]}[$pk-1];
                  if (-1<index $txt,"__Master_${$}__") {
                     $txt=~
                        s/__Master_${$}__/Local-Host: $local_hostname/sg;
                  }
                  push @pickd, $txt;
               } elsif ($pickone[$picknum-1]) {
                  my $txt=$pickone[$picknum-1];
                  if (-1<index $txt,"__Master_${$}__") {
                     $txt=~
                        s/__Master_${$}__/Local-Host: $local_hostname/sg;
                  }
                  push @pickd, $txt;
               }
            }
            #print "RETURNING4 and PICKD=@pickd\n";<STDIN>;
            return \@pickd if $return_values;
            return 'DONE';
         } elsif ($numbor=~/^\s*%(.*)/s) {
            my $one=$1||'';
            chomp $one;my @spl=();my $sort_ed='';
            if ($one) {

            } elsif ($sorted && $sorted eq 'forward') {
               @spl=reverse @pickone;$sort_ed='reverse';
            } else { @spl=sort @pickone;$sort_ed='forward' }
            chomp $numbor;
            my $cnt=0;my $ct=0;my @splice=();
            my %sorts=();
            foreach my $line (@pickone) {
               $cnt++;
               if (${$FullMenu}{$MenuUnit_hash_ref}[6]
                     {$pickone[$picknum-1]} && ${$FullMenu}
                     {$MenuUnit_hash_ref}[6]{$pickone[$picknum-1]}
                     ne '_ZERO_') {
                  $sort{$line}=${$FullMenu}{$MenuUnit_hash_ref}[6]{$line};
               } else { $sort{$line}=$cnt }
            } $cnt=0;my $chose_n='';
            my %chosen=();
            if (!$sorted) {
               %chosen=(
                  Label  => 'chosen',
                  Select => 'Many',
                  Banner => ${$MenuUnit_hash_ref}{Banner},
               );
               my $cnt=0;
               foreach my $text (@spl) {
                  my $num=$sort{$text};
                  $cnt++;
                  if (exists $picks{$text}) {
                     $chosen{'Item_'.$cnt}=
                        { Text => $text,Default => '*',__NUM__=>$num };
                  } else {
                     $chosen{'Item_'.$cnt}=
                        { Text => $text,__NUM__=>$num };
                  }
                  $chosen{'Item_'.$cnt}{Result}=$result{$text}
                     if exists $result{$text};
                  $chosen{'Item_'.$cnt}{Convey}=$convey{$text}
                     if exists $convey{$text};
                  $chosen{'Item_'.$cnt}{Sort}=$sort_ed;
               } $sorted=$sort_ed;
            } else {
               @pickone=reverse @pickone;
               next;
            }
            if (1) {
               $chose_n=\%chosen;
            } else {

            }
            $LookUpMenuName{$chose_n}
               =${$chose_n}{'Label'};
            %{${$SavePick}{$MenuUnit_hash_ref}}=%picks;
            ${$SaveLast}{$MenuUnit_hash_ref}=$numbor;
            ($menu_output,$FullMenu,$Selected,$Conveyed,$SavePick,
               $SaveLast,$SaveNext)=&Menu(
               $chose_n,$convey,
               $recurse_level,$FullMenu,
               $Selected,$Conveyed,$SavePick,
               $SaveLast,$SaveNext,$MenuUnit_hash_ref,
               $no_wantarray);
               chomp($menu_output) if !(ref $menu_output);
            if ($menu_output eq '-') {
               %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
            } elsif ($menu_output eq '+') {
               %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
            } elsif ($menu_output eq 'DONE_SUB') {
               return 'DONE_SUB';
            } elsif ($menu_output eq 'DONE') {
               if (1==$recurse_level) {
                  my $subfile=substr($sub_module,0,-3).'::';
                  foreach my $sub (&get_subs_from_menu($Selected)) {
                     $sub=unpack('x1 a*',$sub);
                     eval {
                        unless (defined eval "$subfile$sub") {
                           if ($@) {
                              if ($fullauto) {
                                 &FA_lib::handle_error($@,'-1');
                              } else { die $@ }
                           }
                           #### TEST FOR UNDEF SUB - ADD MORE
                           #### ERROR INFO
                        }
                     };
                     if ($@) {
                        &FA_lib::handle_error($@,'-5')
                           if $fullauto;
                        die $@;
                     }
                  } return 'DONE_SUB';
               } else { return 'DONE' }
            } elsif ($menu_output) {
               return $menu_output;
            } else { %picks=%{${$SavePick}{$MenuUnit_hash_ref}} }
            #print "DO THE SORT\n";<STDIN>;
         } elsif ($numbor=~/^\*\s*$/s) {
            if (!exists ${$MenuUnit_hash_ref}{Select} || 
                  ${$MenuUnit_hash_ref}{Select} eq 'One') {
               print "\n   ERROR: Cannot Show Multiple Selected Items\n".
                     "          When 'Select' is NOT set to 'Many'\n";
               sleep 3;next;
            }
            my @splice=();
            if ($filtered_menu) {
               foreach my $key (keys %{${$SavePick}{$parent_menu}}) {
                  $picks{$key}='*';
               }
               foreach my $key (keys %picks) {
                  if ($parent_menu) {
                     ${${$SavePick}{$parent_menu}}{$key}='*';
                  } else {
                     ${${$SavePick}{$MenuUnit_hash_ref}}{$key}='*';
                  }
               }
            }
            foreach my $pick (sort numerically keys %picks) {
               push @splice,($pick-1)
            }
            foreach $spl (@splice) {
               if ($parent_menu) {
                  push @spl, ${${$FullMenu}{$parent_menu}[8]}[$spl];
               } else {
                  push @spl, ${${$FullMenu}{$MenuUnit_hash_ref}[8]}[$spl];
               }
            }
            my %chosen=(
               Label  => 'chosen',
               Select => 'Many',
               Banner => ${$MenuUnit_hash_ref}{Banner},
            ); my $cnt=0;
            my $hash_ref=$parent_menu||$MenuUnit_hash_ref;
            foreach my $text (@spl) {
               my $num=shift @splice;
               $cnt++;
               $chosen{'Item_'.$cnt}=
                  { Text => $text,Default => '*',__NUM__=>$num+1 };
               $chosen{'Item_'.$cnt}=
                  { Result  => $result{$text} }
                  if exists $result{$text};
               $chosen{'Item_'.$cnt}=
                  { Convey  => $convey{$text} }
                  if exists $convey{$text};
            }
            my $chose_n=\%chosen;
            $LookUpMenuName{$chose_n}
               =${$chose_n}{'Label'};
            %{${$SavePick}{$MenuUnit_hash_ref}}=%picks;
            ${$SaveLast}{$MenuUnit_hash_ref}=$numbor;
            ($menu_output,$FullMenu,$Selected,$Conveyed,$SavePick,
               $SaveLast,$SaveNext)=&Menu(
               $chose_n,$convey,
               $recurse_level,$FullMenu,
               $Selected,$Conveyed,$SavePick,
               $SaveLast,$SaveNext,$MenuUnit_hash_ref,
               $no_wantarray);
               chomp($menu_output) if !(ref $menu_output);
            if ($menu_output eq '-') {
               %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
            } elsif ($menu_output eq '+') {
               %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
            } elsif ($menu_output eq 'DONE_SUB') {
               return 'DONE_SUB';
            } elsif ($menu_output eq 'DONE') {
               if (1==$recurse_level) {
                  my $subfile=substr($sub_module,0,-3).'::';
                  foreach my $sub (&get_subs_from_menu($Selected)) {
                     $sub=unpack('x1 a*',$sub);
                     eval {
                        unless (defined eval "$subfile$sub") {
                           if ($@) {
                              if ($fullauto) {
                                 &FA_lib::handle_error($@,'-1');
                              } else { die $@ }
                           }
                           #### TEST FOR UNDEF SUB - ADD MORE
                           #### ERROR INFO
                        }
                     };
                     if ($@) {
                        &FA_lib::handle_error($@,'-5')
                           if $fullauto;
                        die $@;
                     }
                  } return 'DONE_SUB';
               } else { return 'DONE' }
            } elsif ($menu_output) {
               return $menu_output;
            } else { %picks=%{${$SavePick}{$MenuUnit_hash_ref}} }
         } elsif ($numbor=~/^\s*\/(.+)$/s) {
            my $one=$1||'';
            chomp $one;
            $one=qr/$one/ if $one;
            my @spl=();
            chomp $numbor;
            my $cnt=0;my $ct=0;my @splice=();
            foreach my $pik (@pickone) {
               $cnt++;
               if ($pik=~/$one/s) {
                  push @spl, $pik;
                  $splice[$ct++]=$cnt;
               }
            }
            next if $#spl==-1;
            my %chosen=(
               Label  => 'chosen',
               Select => 'Many',
               Banner => ${$MenuUnit_hash_ref}{Banner},
            ); $cnt=0;
            foreach my $text (@spl) {
               my $num=$splice[$cnt];
               $cnt++;
               if (exists $picks{$text}) {
                  $chosen{'Item_'.$cnt}=
                     { Text => $text,Default => '*',__NUM__=>$num };
               } else {
                  $chosen{'Item_'.$cnt}=
                     { Text => $text,__NUM__=>$num };
               }
               $chosen{'Item_'.$cnt}{Result}=$result{$text}
                  if exists $result{$text};
               $chosen{'Item_'.$cnt}{Convey}=$convey{$text}
                  if exists $convey{$text};
               $chosen{'Item_'.$cnt}{Filter}=1;
            }
            my $chose_n=\%chosen;
            $LookUpMenuName{$chose_n}
               =${$chose_n}{'Label'};
            %{${$SavePick}{$MenuUnit_hash_ref}}=%picks;
            ${$SaveLast}{$MenuUnit_hash_ref}=$numbor;
            ($menu_output,$FullMenu,$Selected,$Conveyed,$SavePick,
               $SaveLast,$SaveNext)=&Menu(
               $chose_n,$convey,
               $recurse_level,$FullMenu,
               $Selected,$Conveyed,$SavePick,
               $SaveLast,$SaveNext,$MenuUnit_hash_ref,
               $no_wantarray);
               chomp($menu_output) if !(ref $menu_output);
            if ($menu_output eq '-') {
               %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
            } elsif ($menu_output eq '+') {
               %picks=%{${$SavePick}{$MenuUnit_hash_ref}};
            } elsif ($menu_output eq 'DONE_SUB') {
               return 'DONE_SUB';
            } elsif ($menu_output eq 'DONE') {
               if (1==$recurse_level) {
                  my $subfile=substr($sub_module,0,-3).'::';
                  foreach my $sub (&get_subs_from_menu($Selected)) {
                     $sub=unpack('x1 a*',$sub);
                     eval {
                        unless (defined eval "$subfile$sub") {
                           if ($@) {
                              &FA_lib::handle_error($@) if $fullauto;
                              die $die;
                           }
                           #### TEST FOR UNDEF SUB - ADD MORE ERROR INFO
                        }
                     };
                     if ($@) {
                        if (unpack('a11',$@) eq 'FATAL ERROR') {
                           if (wantarray && !$no_wantarray) {
                              return '', $@;
                           } elsif ($fullauto) {
                              &FA_lib::handle_error($@,'-10');
                           } else { die $@ }
                        } else {
                           my $die="\n       FATAL ERROR! - The Local "
                                  ."System $local_hostname Conveyed\n"
                                  ."              the Following "
                                  ."Unrecoverable Error Condition :\n\n"
                                  ."       $@";
                           if (defined $log_handle &&
                                 -1<index $log_handle,'*') {
                              print $log_handle $die;
                              close(log_handle);
                           }
                           if (wantarray && !$no_wantarray) {
                              return '',$die;
                           } elsif ($@) {
                              &FA_lib::handle_error($die,'-28') if $fullauto;
                              die $die;
                           }
                        }
                     }
                  } return 'DONE_SUB';
               } else { return 'DONE' }
            } elsif ($menu_output eq '-') {
               $return_from_child_menu='-';
            } elsif ($menu_output eq '+') {
               $return_from_child_menu='+';
            } elsif ($menu_output) {
               return $menu_output;
            }
         } elsif ($numbor=~/^\</ && $FullMenu) {
            if ($recurse_level==1) {
               print "\n   WARNING! - You are at the First Menu!",
                     "\n   (Press any key to continue ...) ";<STDIN>;
            } elsif (grep { /\+|\*/ } values %picks) {
               delete ${$SaveLast}{$MenuUnit_hash_ref};
               return '+',
                  $FullMenu,$Selected,$Conveyed,
                  $SavePick,$SaveLast,$SaveNext,
                  $parent_menu;
            } else {
               delete ${$SaveLast}{$MenuUnit_hash_ref};
               return '-',
                  $FullMenu,$Selected,$Conveyed,
                  $SavePick,$SaveLast,$SaveNext,
                  $parent_menu;
            } last;
         } elsif ($numbor=~/^\>/ && exists
                  ${$SaveNext}{$MenuUnit_hash_ref}) {
            if (exists ${$FullMenu}{$MenuUnit_hash_ref}[3]
                  {$pickone[${$SaveLast}{
                  $MenuUnit_hash_ref}-1]}) {
               $convey=${${$FullMenu}{$MenuUnit_hash_ref}[3]
                  {$pickone[${$SaveLast}{
                  $MenuUnit_hash_ref}-1]}}[0];
            } else { $convey=$pickone[${$SaveLast}{
                  $MenuUnit_hash_ref}-1] }
            ($menu_output,$FullMenu,$Selected,$Conveyed,$SavePick,
               $SaveLast,$SaveNext)=&Menu(${$FullMenu}
               {$MenuUnit_hash_ref}[2]
               {$pickone[${$SaveLast}{
               $MenuUnit_hash_ref}-1]},$convey,
               $recurse_level,$FullMenu,
               $Selected,$Conveyed,$SavePick,
               $SaveLast,$SaveNext,$MenuUnit_hash_ref,
               $no_wantarray);
            chomp($menu_output) if !(ref $menu_output);
            if ($menu_output eq 'DONE_SUB') {
               return 'DONE_SUB';
            } elsif ($menu_output eq 'DONE') {
               if (1==$recurse_level) {
                  my $subfile=substr($sub_module,0,-3).'::';
                  foreach my $sub (&get_subs_from_menu($Selected)) {
                     $sub=unpack('x1 a*',$sub);
                     eval {
                        unless (defined eval "$subfile$sub") {
                           if ($@) {
                              &FA_lib::handle_error($@) if $fullauto;
                              die $die;
                           }
                           #### TEST FOR UNDEF SUB - ADD MORE ERROR INFO
                        }
                     };
                     if ($@) {
                        if (unpack('a11',$@) eq 'FATAL ERROR') {
                           if (wantarray && !$no_wantarray) {
                              return '', $@;
                           } elsif ($fullauto) {
                              &FA_lib::handle_error($@,'-10');
                           } else { die $@ }
                        } else {
                           my $die="\n       FATAL ERROR! - The Local "
                                  ."System $local_hostname Conveyed\n"
                                  ."              the Following "
                                  ."Unrecoverable Error Condition :\n\n"
                                  ."       $@";
                           if (defined $log_handle &&
                                 -1<index $log_handle,'*') {
                              print $log_handle $die;
                              close(log_handle);
                           }
                           if (wantarray && !$no_wantarray) {
                              return '',$die;
                           } elsif ($@) {
                              &FA_lib::handle_error($die,'-28') if $fullauto;
                              die $die;
                           }
                        }
                     }
                  } return 'DONE_SUB';
               } else { return 'DONE' }
            } elsif ($menu_output eq '-') {
               $return_from_child_menu='-';
            } elsif ($menu_output eq '+') {
               $return_from_child_menu='+';
            } elsif ($menu_output) {
               return $menu_output;
            }
         } elsif ($numbor=~/^q$/i) { 
            return ']quit['
         } elsif (!keys %{${$FullMenu}{$MenuUnit_hash_ref}[1]}
                                             && $numbor=~/^a$/i) {
            if (!exists ${$MenuUnit_hash_ref}{Select} ||
                  ${$MenuUnit_hash_ref}{Select} eq 'One') {
               print "\n   ERROR: Cannot Select All Items\n".
                     "          When 'Select' is NOT set to 'Many'\n";
               sleep 3;next;
            }
            if ($sum_menu || $filtered_menu) {
               foreach my $key (keys %{${$FullMenu}{$MenuUnit_hash_ref}[6]}) {
                  ${$SavePick}{$parent_menu}{${$FullMenu}
                     {$MenuUnit_hash_ref}[6]{$key}}='*';
               }
            } else {
               my $ch_num=$num_pick;
               while (1) {
                  $picks{$ch_num--}="a";
                  last if $ch_num==0;
               }
            }
         } elsif ($numbor=~/^c$/i) {
            if (!exists ${$MenuUnit_hash_ref}{Select} ||
                  ${$MenuUnit_hash_ref}{Select} eq 'One') {
               print "\n   ERROR: Cannot Clear Items\n".
                     "          When 'Select' is NOT set to 'Many'\n";
               sleep 3;next;
            }
            if ($sum_menu || $filtered_menu) {
               foreach my $key (keys %{${$FullMenu}{$MenuUnit_hash_ref}[6]}) {
                  delete ${$SavePick}{$parent_menu}{${$FullMenu}
                     {$MenuUnit_hash_ref}[6]{$key}};
               }
            } else {
               foreach my $pick (keys %picks) {
                  if (exists $picks{$pick}) {
                     if ($picks{$pick} eq '*') {
                        delete $picks{$pick};
                        delete $items{$pick};
                        delete ${$Selected}{$MenuUnit_hash_ref}{$pick};
                     } elsif ($picks{$pick} eq '+') {
                        &delete_Selected($MenuUnit_hash_ref,$pick,
                           $Selected,$SavePick,$SaveNext);
                        $SaveNext=$SaveLast;
                        delete $picks{$pick};
                        delete $items{$pick};
                     }
                  }
               } ${$FullMenu}{$MenuUnit_hash_ref}[5]='';
            }
         }
         if ($numbor=~/^()$/ || $numbor=~/^\n/ || $numbor=~/^d$/i) {
            if ($display_this_many_items<$num_pick-$start) {
               $start=$start+$display_this_many_items;
            } else { $start=0 }
            $hidedefaults=0;
            $numbor=$start+$choose_num+1;
            last;
         } elsif ($numbor=~/^u$/i) {
            if (0<=$start-$display_this_many_items) {
               $start=$start-$display_this_many_items;
            } else { $start=0 }
            $numbor=$start+$choose_num+1;
            last;
         } chomp $numbor;
         if ($numbor!~/^\d+$/ && !$return_from_child_menu) {
            $numbor=$start+$choose_num+1;
            last;
         } elsif (exists $pn{$numbor}) {
#print "ARE WE HERE and PN=$pn and NUMBOR=$numbor and SUM=$sum_menu\n";<STDIN>;%pn=();
            my $callertest=__PACKAGE__."::Menu";
            if (wantarray && !$no_wantarray &&
                  (exists ${$MenuUnit_hash_ref}{Select} && 
                  ${$MenuUnit_hash_ref}{Select} eq 'Many')) {
#print "WHAT IS PNXXXX=$pn and THIS=$picks{$picknum-1} and keys=",(join "\n",keys %{${$SavePick}{$parent_menu}})," and $numbor and SUMMENU=$sum_menu<==\n";<STDIN>;
               if (exists $picks{$numbor}) {
#print "ARE WE HERE??? and ${$SavePick}{$parent_menu}{$numbor}<==\n";
                  if ($picks{$numbor} eq '*') {
                     delete $picks{$numbor};
                     delete $items{$numbor};
                     delete ${$Selected}{$MenuUnit_hash_ref}{$numbor};
                     delete ${$SavePick}{$parent_menu}{$numbor}
                        if $sum_menu || $filtered_menu;
#print "WHAT IS PNXXXX=$pn and THIS=$picks{$picknum-1} and keys=",(join "\n",keys %{${$SavePick}{$parent_menu}})," and NUMBOR=$numbor and SUMMENU=$sum_menu<==\n";<STDIN>;
                  } else {
                     &delete_Selected($MenuUnit_hash_ref,$numbor,
                         $Selected,$SavePick,$SaveNext);
                     $SaveNext=$SaveLast;
                     delete $picks{$numbor};
                     delete $items{$numbor};
                  }
               } elsif (($sum_menu || $filtered_menu) && (exists
                     ${$SavePick}{$parent_menu}{$numbor})) {
                  delete ${$Selected}{$MenuUnit_hash_ref}{$numbor};
                  delete $picks{$numbor};
                  delete $items{$numbor};
                  delete ${$SaveNext}{$MenuUnit_hash_ref};
                  delete ${$SavePick}{$parent_menu}{$numbor};
               } else {
                  $items{$numbor}=${$FullMenu}{$MenuUnit_hash_ref}
                                             [4]{$pickone[$numbor-1]};
                  ${$SavePick}{$parent_menu}{$numbor}='*'
                     if $sum_menu || $filtered_menu;
                  my $skip=0;
                  foreach my $key (keys %picks) {
                     if ($picks{$key} ne '-' && 
                           (grep { $items{$numbor} eq $_ }
                           @{$negate{$key}})) {
                        my $warn="\n   WARNING! You Cannot Select ";
                        $warn.="Line $numbor while Line $key is Selected!\n";
                        print "$warn";<STDIN>;
                        $skip=1;
                     } elsif ($picks{$key} eq '-') {
                        delete ${$Selected}{$MenuUnit_hash_ref}{$key};
                        delete $picks{$key};
                        delete ${$SaveNext}{$MenuUnit_hash_ref};
                     }
                  }
                  if ($skip==0) {
                     $picks{$numbor}='*';
                     $negate{$numbor}=
                        ${${$FullMenu}{$MenuUnit_hash_ref}[1]}
                        {$pickone[$picknum-1]};
                     %{${$SavePick}{$MenuUnit_hash_ref}}=%picks;
                     ${$SaveLast}{$MenuUnit_hash_ref}=$numbor;
                  }
               }
               if ($prev_menu && $prev_menu!=$numbor) {
                  &delete_Selected($MenuUnit_hash_ref,$prev_menu,
                     $Selected,$SavePick,$SaveNext);
                  delete $picks{$prev_menu};
                  delete $items{$prev_menu};
               }
            } elsif (ref ${$FullMenu}{$MenuUnit_hash_ref}[2]
                         {$pickone[$numbor-1]} eq 'HASH') {
               if (exists ${$FullMenu}{$MenuUnit_hash_ref}[2]
                         {$pickone[$numbor-1]}{'Label'}) {
                  chomp($numbor);
                  if (exists $picks{$numbor}) {
                     ${$FullMenu}{$MenuUnit_hash_ref}[5]='ERASE';
                     $hidedefaults=0;
                     $SaveNext=$SaveLast;
                     if ($picks{$numbor} eq '*') {
                        delete $picks{$numbor};
                        delete $items{$numbor};
                        delete ${$Selected}{$MenuUnit_hash_ref}{$numbor};
                     } elsif ($picks{$numbor} ne ' ') {
                        &delete_Selected($MenuUnit_hash_ref,$numbor,
                           $Selected,$SavePick,$SaveNext);
                        delete $picks{$numbor};
                        delete $items{$numbor};
                     }
                  }
                  if ($prev_menu && $prev_menu!=$numbor) {
                     ${$FullMenu}{$MenuUnit_hash_ref}[5]='ERASE';
                     $hidedefaults=0;
                     $SaveNext=$SaveLast;
                     &delete_Selected($MenuUnit_hash_ref,$prev_menu,
                        $Selected,$SavePick,$SaveNext);
                     delete $picks{$prev_menu};
                     delete $items{$prev_menu};
                  }
                  ($FullMenu,$Conveyed,$SaveNext,$Selected,
                     $convey,$parent_menu)
                     =$get_result->($MenuUnit_hash_ref,
                     \@pickone,$numbor,$picks_from_parent,
                     $FullMenu,$Conveyed,$Selected,
                     $SaveNext,$parent_menu,$menu_cfg_file,
                     $Convey_contents);
                  $picks{$numbor}='*';
                  %{${$SavePick}{$MenuUnit_hash_ref}}=%picks;
                  ${$SaveLast}{$MenuUnit_hash_ref}=$numbor;
                  ($menu_output,$FullMenu,$Selected,$Conveyed,$SavePick,
                     $SaveLast,$SaveNext,$parent_menu)=&Menu(${$FullMenu}
                     {$MenuUnit_hash_ref}[2]
                     {$pickone[$numbor-1]},$convey,
                     $recurse_level,$FullMenu,
                     $Selected,$Conveyed,$SavePick,
                     $SaveLast,$SaveNext,$MenuUnit_hash_ref,
                     $no_wantarray);
                  chomp($menu_output) if !(ref $menu_output);
                  if ($menu_output eq '-') {
                     $return_from_child_menu='-';
                  } elsif ($menu_output eq '+') {
                     $return_from_child_menu='+';
                  } elsif ($menu_output eq 'DONE_SUB') {
                     return 'DONE_SUB';
                  } elsif ($menu_output eq 'DONE' and 1<$recurse_level) {
                     return 'DONE';
                  } elsif ($menu_output) {
                     return $menu_output;
                  } else {
                     my $subfile=substr($sub_module,0,-3).'::';
                     foreach my $sub (&get_subs_from_menu($Selected)) {
                        $sub=unpack('x1 a*',$sub);
                        eval { 
                           unless (defined eval "$subfile$sub") {
                              if ($@) {
                                 &FA_lib::handle_error($@) if $fullauto;
                                 die $die;
                              }
                              #### TEST FOR UNDEF SUB - ADD MORE ERROR INFO
                           }
                        };
                        if ($@) {
                           if (unpack('a11',$@) eq 'FATAL ERROR') {
                              if (wantarray && !$no_wantarray) {
                                 return '',$@;
                              } elsif ($fullauto) {
                                 &FA_lib::handle_error($@,'-10');
                              } else { die $die }
                           } else {
                              my $die="\n       FATAL ERROR! - The Local "
                                     ."System $local_hostname Conveyed\n"
                                     ."              the Following "
                                     ."Unrecoverable Error Condition :\n\n"
                                     ."       $@";
                              if (defined $log_handle &&
                                    -1<index $log_handle,'*') {
                                 print $log_handle $die;
                                 close($log_handle);
                              }
                              if (wantarray && !$no_wantarray) {
                                 return '',$die;
                              } elsif ($fullauto) {
                                 &FA_lib::handle_error($die,'-28');
                              } else { die $die }
                           }
                        }
                     } return 'DONE_SUB';
                  }
               } else {
                  die "NO LABEL IN MENU BLOCK\n";
               }
            } elsif ($FullMenu && $caller eq $callertest &&
                  (exists ${$MenuUnit_hash_ref}{Select} && 
                  ${$MenuUnit_hash_ref}{Select} eq 'Many')) {
               chomp($numbor);
               if (exists $picks{$numbor}) {
                  if ($picks{$numbor} eq '*') {
                     delete $picks{$numbor};
                     delete $items{$numbor};
                     delete ${$Selected}{$MenuUnit_hash_ref}{$numbor};
                  } else {
                     &delete_Selected($MenuUnit_hash_ref,$numbor,
                        $Selected,$SavePick,$SaveNext);
                     $SaveNext=$SaveLast;
                     delete $picks{$numbor};
                     delete $items{$numbor};
                  } last;
               }
               if (keys %{${$FullMenu}{$MenuUnit_hash_ref}[2]}) { 
                  if (substr(${$FullMenu}{$MenuUnit_hash_ref}
                        [2]{$pickone[$numbor-1]},0,1) ne '&') {
                     my $die="The \"Result =>\" Setting";
                     $die.="\n\t\t-> " . ${$FullMenu}{$MenuUnit_hash_ref}
                                                [2]{$pickone[$numbor-1]};
                     $die.="\n\t\tFound in the Menu Unit -> ";
                     $die.="$MenuUnit_hash_ref\n\t\tis not a Menu Unit\,";
                     $die.=" and Because it Does Not Have\n\t\tan \"&\" as";
                     $die.=" the Lead Character, $0\n\t\tCannot Determine ";
                     $die.="if it is a Valid SubRoutine.\n\n";
                     if (defined $log_handle &&
                           -1<index $log_handle,'*') {
                        print $log_handle $die;
                        close($log_handle);
                     }
                     &FA_lib::handle_error($die) if $fullauto;
                     die $die;
                  }
                  if (${$FullMenu}{$MenuUnit_hash_ref}[2]
                                   {$pickone[$numbor-1]}) { }
                  ($FullMenu,$Conveyed,$SaveNext,$Selected,$convey,$parent_menu)
                     =$get_result->($MenuUnit_hash_ref,
                     \@pickone,$numbor,$picks_from_parent,
                     $FullMenu,$Conveyed,$Selected,
                     $SaveNext,$parent_menu,$menu_cfg_file,
                     $Convey_contents);
                  ${$SaveLast}{$MenuUnit_hash_ref}=$numbor;
                  my %pick=();
                  $pick{$numbor}='*';
                  %{${$SavePick}{$MenuUnit_hash_ref}}=%pick;
                  my $subfile=substr($sub_module,0,-3).'::';
                  foreach my $sub (&get_subs_from_menu($Selected)) {
                     $sub=unpack('x1 a*',$sub);
                     eval {
                        unless (defined eval "$subfile$sub") {
                           if ($@) {
                              &FA_lib::handle_error($@) if $fullauto;
                              die $die;
                           }
                           #### TEST FOR UNDEF SUB - ADD MORE ERROR INFO
                        }
                     };
                     if ($@) {
                        if (unpack('a11',$@) eq 'FATAL ERROR') {
                           if (wantarray && !$no_wantarray) {
                              return '',$@;
                           } elsif ($fullauto) {
                              &FA_lib::handle_error($@,'-10');
                           } else { die $die }
                        } else {
                           my $die="\n       FATAL ERROR! - The Local "
                                  ."System $local_hostname Conveyed\n"
                                  ."              the Following "
                                  ."Unrecoverable Error Condition :\n\n"
                                  ."       $@";
                           if (defined $log_handle &&
                                 -1<index $log_handle,'*') {
                              print $log_handle $die;
                              close($log_handle);
                           }
                           if (wantarray && !$no_wantarray) {
                              return '',$die;
                           } elsif ($fullauto) {
                              &FA_lib::handle_error($die,'-28');
                           } else { die $die }
                        }
                     }
                  }
               } else { $done=1;last }
               return 'DONE_SUB';
            } else { $done=1 }
            last if !$return_from_child_menu;
         }
      } last if $done;
   }
   if (wantarray && !$no_wantarray &&
         (exists ${$MenuUnit_hash_ref}{Select} &&
         ${$MenuUnit_hash_ref}{Select} eq 'Many')) {
      my @picks=();
      foreach (keys %picks) {
         my $pik=$pickone[$_-1];
         push @picks, $pik; 
      } undef @pickone;
      if ($MenuUnit_hash_ref) {
         print $blanklines;
         if ($OS ne 'cygwin') {
            if ($clear) {
               print $clear;
            } elsif ($OS eq 'MSWin32') {
               system("cmd /c cls");
               print "\n";
            } else {
               print `clear`."\n";
            }
         }
         return \@picks,
                $FullMenu,$Selected,$Conveyed,
                $SavePick,$SaveLast,$SaveNext,
                $parent_menu;
      } else {
         return @picks;
      }
   }
   my $pick=$pickone[$numbor-1];
   undef @pickone;return $pick;

}

1;
__END__;


######################## User Documentation ##########################


## To format the following documentation into a more readable format,
## use one of these programs: perldoc; pod2man; pod2html; pod2text.
## For example, to nicely format this documentation for printing, you
## may use pod2man and groff to convert to postscript:
##   pod2man Term/Menus.pm | groff -man -Tps > Term::Menus.ps

=head1 NAME

Term::Menus - Create Powerful Terminal, Console and CMD Enviroment Menus

=head1 SYNOPSIS

C<use Term::Menus;>

see METHODS section below

=head1 DESCRIPTION

Term::Menus allows you to create powerful Terminal, Console and CMD environment
menus. Any perl script used in a Terminal, Console or CMD environment can
now include a menu facility that includes sub-menus, forward and backward
navigation, single or multiple selection capabilities, dynamic item creation
and customized banners. All this power is simple to implement with a straight
forward and very intuitive configuration hash structure that mirrors the actual
menu architechture needed by the application. A separate configuration file is
optional. Term::Menus is cross platform compatible.

Term::Menus is a stand-alone - other CPAN modules are not needed for its
implementation ( so it's *easy* to install! ;-) )

Term::Menus was initially conceived and designed to work seemlessly
with the soon-to-be-released perl based Network Automation Utility called
FullAuto - however, it is not itself dependant on other FullAuto components,
and will work with *any* perl script/application.
 

Reasons to use this module are:

=over 2

=item *

You have a list (or array) of items, and wish to present the user a simple
CMD enviroment menu to pick a single item and return that item as a scalar
(or simple string). Example:

   use Term::Menus;

   my @list=('First Item','Second Item','Third Item');
   my $banner="  Please Pick an Item:";
   my $selection=&pick(\@list,$banner);
   print "SELECTION = $selection\n";

The user sees ==>


   Please Pick an Item:

      1.        First Item
      2.        Second Item
      3.        Third Item

   (Press "q" to quit)

   PLEASE ENTER A CHOICE:

--< 2 >-<ENTER>----------------------------------

The user sees ==>

   SELECTION = Second Item

=item *

You have a large list of items and need scrolling capability:

   use Term::Menus;

   my @list=`ls -1 /bin`;
   my $banner="   Please Pick an Item:";
   my $selection=&pick(\@list,$banner);
   print "SELECTION = $selection\n";

The user sees ==>

   Please Pick an Item:

      1.        arch
      2.        ash
      3.        awk
      4.        basename
      5.        bash
      6.        cat
      7.        chgrp
      8.        chmod
      9.        chown
      10.       cp

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

--<ENTER>--------------------------------------

   Please Pick an Item:

      11.       cpio
      12.       csh
      13.       cut
      14.       date
      15.       dd
      16.       df
      17.       echo
      18.       ed
      19.       egrep
      20.       env

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

--< 14 >-<ENTER>----------------------------------

The user sees ==>

   SELECTION = date

=item *

You need to select multiple items and return the selected list:

   use Term::Menus;

   my @list=`ls -1 /bin`;
   my %Menu_1=(

      Item_1 => {

         Text    => "/bin Utility - ]Convey[",
         Convey  => [ `ls -1 /bin` ],

      },

      Select => 'Many',
      Banner => "\n   Choose a /bin Utility :"
   );

   my @selections=&Menu(\%Menu_1);
   print "SELECTIONS = @selections\n";

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

--< 3 >-<ENTER>----------------------------------

--< 7 >-<ENTER>----------------------------------

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
   *  3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
   *  7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

--< f >-<ENTER>----------------------------------

The user sees ==>

   SELECTIONS = /bin Utility - awk /bin Utility - chgrp


=item *

You need sub-menus:

(Note: Only one level of sub-menus are supported in Version 1.0 -
       more *may* work - but thorough testing has not been done -
       proceed at your own risk!)


   use Term::Menus;

   my %Menu_2=(

      Label  => 'Menu_2',
      Item_1 => {

         Text   => "]Previous[ is a ]Convey[ Utility",
         Convey => [ 'Good','Bad' ]
      },

      Select => 'One',
      Banner => "\n   Choose an Answer :"
   );

   my %Menu_1=(

      Label  => 'Menu_1',
      Item_1 => {

         Text   => "/bin/Utility - ]Convey[",
         Convey => [ `ls -1 /bin` ],
         Result => \%Menu_2,

      },

      Select => 'One',
      Banner => "\n   Choose a /bin Utility :"
   );

   my @selections=&Menu(\%Menu_1);
   print "SELECTIONS=@selections\n";

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

--< 5 >-<ENTER>----------------------------------

   Choose an Answer :

      1.        bash is a Good Utility
      2.        bash is a Bad Utility

   (Press "q" to quit)

   PLEASE ENTER A CHOICE:

--< 1 >-<ENTER>----------------------------------

The user sees ==>

   SELECTIONS = bash is a Good Utility

=back

More examples are in the B<EXAMPLES> section below.

Usage questions should be directed to the Usenet newsgroup
comp.lang.perl.modules.

Contact me, Brian Kelly <Brian.Kelly@fullautosoftware.net>,
if you find any bugs or have suggestions for improvements.

=head2 What To Know Before Using

=over 2

=item *

There are two methods available with Term::Menus - &pick() and &Menu().
C<&Menu()> uses C<&pick()> - you can get the same results using
only
C<&Menu()>. However, if you need to simply pick one item from a single
list - use C<&pick()>. The syntax is simpler, and you'll write less code.
;-)

=item *

You'll need to be running at least Perl version 5.002 to use this
module.  This module does not require any libraries that don't already
come with a standard Perl distribution.

=back

=head1 METHODS

=over 4

=item B<pick> - create a simple menu 

    $pick = &pick ($list|\@list|['list',...],[$Banner]);

Where I<$list> is a variable containing a array or list reference.
This argument can also be a escaped array (sending a reference) or
an anonymous array (which also sends a reference).

I<$Banner> is an optional argument sending a customized Banner to
top the simple menu - giving instructions, descriptions, etc.
The default is "Please Pick an Item:"

=item B<Menu> - create a complex Menu

    $pick  = &Menu ($list|\@list|['list',...],[$Banner]);

Where I<$pick> is a variable containing a array or list reference
of the pick or picks.

    @picks = &Menu ($Menu_1|\%Menu_1|{ Label => 'Menu_1' });

Where I<$Menu_1> is a hash reference to the top level Menu
Configuration Hash Structure.

=back

=head2  Menu Configuration Hash Structures

=over 4

These are the building blocks of the overall Menu architecture. Each
hash structure represents a I<menu screen>. A single menu layer, has
only one hash structure defining it. A menu with a single sub-menu
will have two hash structures. The menus connect via the C<Result>
element of an I<Item> - C<Item_1> - hash structure in parent menu
C<%Menu_1>:


   my %Menu_2=(

      Label  => 'Menu_2',
      Item_1 => {

         Text   => "]Previous[ is a ]Convey[ Utility",
         Convey => [ 'Good','Bad' ]
      },

      Select => 'One',
      Banner => "\n   Choose an Answer :"
   );

   my %Menu_1=(

      Label  => 'Menu_1',
      Item_1 => {

         Text   => "/bin/Utility - ]Convey[",
         Convey => [ `ls -1 /bin` ],
         Result => \%Menu_2,

      },

      Select => 'One',
      Banner => "\n   Choose a /bin Utility :"
   );

=back

=head3  Menu Component Elements

Each Menu Configuration Hash Structure consists of elements that define
and control it's behavior, appearance, constitution and purpose. An
element's syntax is as you would expect it to be in perl - a key string
pointing to an assocaited value: C<key =E<gt> value>. The following
items
list supported key names and ther associated value types:

=over 4

=item

B<Display> => 'Integer'

=item

=over 2

=item

The I<Display> key is an I<optional> key that determines the number 
of Menu
Items that will be displayed on each screen. This is useful when the items
are multi-lined, or the screen size is bigger or smaller than the default
number utilizes in the most practical fashion. The default number is 10.

   Display => 15,

=back

=item

B<Label> => 'Char String consisting of ASCII Characters'

=item

=over 2

=item

The I<Label> key provides a unique identifier to each Menu Structure.
I<Every Menu Configuration Hash Structure B<must> have a valid and
unique Label element> Otherwise C<&Menu()> will throw an error.

   Label => 'Menu_1',

=back

=item 

B<Item_E<lt>intE<gt>> => { Item Configuration Hash
Structure }

=item

=over 2

=item

The I<Item_E<lt>intE<gt>> elements define customized menu items.
There are
essentially two methods for creating menu items: The I<Item_E<lt>intE<gt>>
elements, and the C<]Convey[> macro (described later). The difference being
that the C<]Convey[> macro turns an Item Conguration Hash into an Item
I<Template> -> a B<powerful> way to I<Item>-ize large lists
or quantities
of data that would otherwise be difficult - even impossible - to anticipate
and cope with manually.

   Item_1 => { Text => 'Item 1' },
   Item_2 => { Text => 'Item 2' },

Items created via C<]Convey[> macros have two drawbacks:

=over 2

=item *

They all have the same format.

=item *

They all share the same C<Result> element.

=back

The syntax and usage of I<Item_E<lt>intE<gt>> elements is important
and
extensive enough warrant it's own section. See B<I<Item Configuration Hash
Structures>> below.

=back

=item

B<Select> => 'One' --or-- 'Many'

=item

=over 2

=item

The I<Select> element determines whether this particular menu layer
allows the selection of multiple items - or a single item. The default
is 'One'.

   Select => 'Many',

=back

=item

B<Banner> => 'Char String consisting of ASCII Characters'

=item

=over 2

=item

The I<Banner> element provides a customized descriptive header to the menu.
I<$Banner> is an optional element - giving instructions, descriptions, etc.
The default is "Please Pick an Item:"

   Banner => "The following items are for selection,\n".
             "\tEnjoy the Experience!",
             

=back

=back

=head3 Item Congfiguration Hash Structures

Each Menu Item can have an independant configurtion. Each Menu Configuration 
Hash Structure consists of elements that define and control it's behavior, 
appearance, constitution and purpose. An element's syntax is as you would 
expect it to be in perl - a key string pointing to an assocaited value: key 
=> value. The following items list supported key names and ther associated
value types:

=over 4

=item

B<Text> => 'Char String consisting of ASCII Characters'

=item

=over 2

=item

The I<Text> element provides a customized descriptive string for the Item.
It is the text the user will see displayed, describing the selection.

   Text => 'This is Item_1',

=back

=item

B<Convey> => [ List ] --or-- @List --or-- $Scalar --or-- 'ASCII String'

=item

=over 2

=item

The I<Convey> element has a twofold purpose; it provides for the contents
of the C<]Convey[> macro, and defines or contains the string or result that
is passed on to child menus - if any. Use of this configuration element is
I<optional>. If C<Convey> is not a list, then it's value is passed onto child
menus. If C<Convey> I<is> a list, then the Item selected is passed onto the
children - if any. It is important to note, I<when used>, that only the 
resulting I<Convey> string - B<I<NOT>> the the Item C<Text> value or string, 
is conveyed to child menus. When the C<Convey> element is not used, the 
full Item C<Text> value B<is> conveyed to the children - if any. However, the 
full contents of the C<Text> element is I<returned> as the I<Result> of the
operation when the user completes all menu activity. See the I<Macro> section
below for more information.

   Convey => [ `ls -1` ] ,

=back

=item

B<Default> => 'Char String' --or-- Perl regular expression - qr/.../

=item

=over 2

=item

The I<Default> element provides a means to pre-select certain elements,
as if the items were selected by the user. This can be done with two
constructs - simple string or pre-compiled regular expression.
Note: The C<Default> element is available only when the C<Select> element
is set to C<'Many'> - C<Select => 'Many',>

   Default => 'base|chown',

   Default => qr/base|chown/i,

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
   *  4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
   *  9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

=back

=item

B<Exclude> => 'Char String' --or-- Perl regular expression - qr/.../

=item

=over 2

=item

The I<Exclude> element provides a means to remove matching elements
from the Menu seen by the user. This element is useful only when the
C<]Convey[> macro is used to populate items. This can be done with two
constructs - simple string or pre-compiled regular expression.

   Exclude => 'base|chown',

   Exclude => qr/base|chown/i,

=back

=item

B<Include> => 'Char String' --or-- Perl regular expression - qr/.../

=item

=over 2

=item

The I<Include> element provides a means to create items filtered from a larger
list of potential items available via the C<]Convey[> macro. This element is
useful only when the C<]Convey[> macro is used to populate items. The
C<Exclude> element can be used in conjunction with C<Include> to further
refine the final list of items used to construct the menu. The C<Include>
element - when used - always takes presidence, and the C<Exclude> will be used
only on the C<Include> filtered results. This element can be used with
two value constructs - simple string or pre-compiled regular expression.

   Include => 'base|chown',

   Include => qr/base|chown/i,

=back

=item

B<Result> => \%Menu_2  --or --  "&any_method()",

=item

=over 2

=item

I<Result> is an I<optional> element that also has two important uses:

=item *

For selecting the child menu next in the chain of operation and conveyance,

   Result => \%Menu_2,

--or--

=item *

For building customized method arguements using C<&Menu()>'s built-in 
macros.

=item

   Result => "&any_method($arg1,\"]Selected[\",\"]Previous[\")",

B<NOTE:> I<ALWAYS> be sure to surround the subroutine or method calling
syntax with DOUBLE QUOTES. (You can use single quotes if you don't want
interpolation). Quotes are necessary because you're telling C<&Menu()> -
I<not> Perl - what method you want invoked. C<&Menu()> won't invoke the method
until after all other processing - where Perl will try to invoke it the first
time it encounters the line during runtime - lo----ng before a user gets a
chance to see or do I<anything>. B<BUT> - be sure I<B<NOT>> to use quotes
when assigning a child menu reference to the C<Result> value.

Again, I<Result> is an I<optional> element. The default behavior when
C<Result> is omitted from the Item Configuration element, is for the selection
to be returned to the C<&Menu()>'s calling script/module/app. If the C<Select>
element was set to C<'One'>, then that item is returned regardless of whether
the Perl structure receiving the output is an array or scalar. If there were
multiple selections - i.e., C<Select> is set to C<'Many'> - then, depending
on what structure is set for receiving the output, will determine whether
C<&Menu()> returns a list (i.e. - array), or I<reference> to an array.

=back

=back

=head3 Item Congfiguration Macros

Each Menu Item can utilize a very powerful set of configuration I<Macros>.
These constructs principally act as purveyors of information - from one
menu to another, from one element to another. There are currently three
available Macros:

=over 4

=item

B<]Convey[>

=item

=over 2

=item

C<]Convey[> is used in conjunction with the I<Convey> element (described)
earlier. It's purpose to "convey" or transport or carry a list item associated
with the C<Convey> element - and replace the C<]Convey[> Macro in the C<Text>
element value with that list item. The I<Convey> mechanism utilizing the
C<Convey> Macro is essentially an I<Item multiplier>. The entire contents of
the list associated with the I<Convey> element will be turned into it's own
C<Item> when the menu is displayed. 

   use Term::Menus;

   my %Menu_1=(

      Label  => 'Menu_1',
      Item_1 => {

         Text   => "/bin/Utility - ]Convey[",
         Convey => [ `ls -1 /bin` ],
         Result => \%Menu_2,

      },

      Select => 'One',
      Banner => "\n   Choose a /bin Utility :"
   );

   my @selections=&Menu(\%Menu_1);
   print "SELECTIONS=@selections\n";

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

B<NOTE:>     C<]C[>  can be used as a shorthand for  C<]Convey[>.

=back

=item

B<]Previous[>

=item

=over 2

=item

C<]Previous[> can be used in child menus. The C<]Previous[> Macro contains
the I<Selection> of the parent menu. Unlike the C<]Convey[> Macro, the
C<]Previous[> Macro can be used in both the C<Text> element value, and the
C<Result> element values (when constructing method calls):

   use Term::Menus;

   my %Menu_2=(

      Label  => 'Menu_2',
      Item_1 => {

         Text   => "]Previous[ is a ]Convey[ Utility",
         Convey => [ 'Good','Bad' ]
      },

      Select => 'One',
      Banner => "\n   Choose an Answer :"
   );

   my %Menu_1=(

      Label  => 'Menu_1',
      Item_1 => {

         Text   => "/bin/Utility - ]Convey[",
         Convey => [ `ls -1 /bin` ],
         Result => \%Menu_2,

      },

      Select => 'One',
      Banner => "\n   Choose a /bin Utility :"
   );

   my @selections=&Menu(\%Menu_1);
   print "SELECTIONS=@selections\n";

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

--< 5 >-<ENTER>----------------------------------

   Choose an Answer :

      1.        bash is a Good Utility
      2.        bash is a Bad Utility

   (Press "q" to quit)

   PLEASE ENTER A CHOICE:

--< 1 >-<ENTER>----------------------------------

The user sees ==>

   SELECTIONS = bash is a Good Utility

B<NOTE:>     C<]P[>  can be used as a shorthand for  C<]Previous[>.

=back

=item

B<]Selected[>

=item

=over 2

=item

C<]Selected[> can only be used in a I<terminal> menu. B<(> I<A terminal menu is
the last menu in the chain, or the last menu the user sees. It is the menu that 
defines the> C<Result> I<element with a method> C<Result =E<gt> &any_method()>, 
I<or does not have a> C<Result> I<element included or defined.> B<)> 
C<]Selected[> is used to pass the selection of the I<current> menu to the
C<Result> element method of the current menu:

   use Term::Menus;  

   sub selected { print "\n   SELECTED ITEM = $_[0]\n" }

   my %Menu_1=(

      Label  => 'Menu_1',
      Item_1 => {

         Text   => "/bin/Utility - ]Convey[",
         Convey => [ `ls -1 /bin` ],
         Result => "&selected(]Selected[)",

      },

      Select => 'One',
      Banner => "\n   Choose a /bin Utility :"
   );

   &Menu(\%Menu_1);

B<NOTE:>     C<]S[>  can be used as a shorthand for  C<]Selected[>.

=back

=back

=head1 USAGE and NAVIGATION

Usage of C<&pick()> and/or C<&Menu()> during the runtime of a script in which
one or both are included, is simple and intuitive. Nearly everything the end
user needs in terms of instruction is included on-screen. The
script-writer/developer/programmer can also include whatever instructions s/he
deems necessary and/or helpful in the customizable C<Banner> (as described
above). There is however, one important feature about using C<&Menu()> with
sub-menus that's important to know about.

=head3 Forward  ' B<E<gt>> ' and  Backward  ' B<E<lt>> ' Navigation

When working with more than one C<&Menu()> screen, it's valuable to know how
to navigate back and forth between the different C<&Menu()> levels/layers.  For
example, above was illustrated the output for two layers of menus - a parent
and a child:

=over 4

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

--< 5 >-<ENTER>----------------------------------

The user sees ==>

   Choose an Answer :

      1.        bash is a Good Utility
      2.        bash is a Bad Utility

   (Press "q" to quit)

   PLEASE ENTER A CHOICE:

=back

In the above example, suppose that the user "fat-fingered" his/her
choice, and really didn't want to "bash" bash, but wanted to bash
awk instead. Is restarting the whole script/application now necessary?
Suppose it was a process that had run overnight, and the user is seeing
this menu through fogged glasses from the steam rising out of their
morning coffee? Having to run the whole job again would not be welcome news
for the BOSS. THANKFULLY, navigation makes this situation avoidable.
All the user would have to do is type ' B<E<lt>> ' to go backward to the
previous menu, and ' B<E<gt>> ' to go forward to the next menu (assuming there
is one in each case):

The user sees ==>

   Choose an Answer :

      1.        bash is a Good Utility
      2.        bash is a Bad Utility

   (Press "q" to quit)

   PLEASE ENTER A CHOICE:

 --<  >  >-<ENTER>-----------------------------

The user sees ==>

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
   -  5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

Note in the above example the Dash ' B<-> ' in front of item B<5.> This informs
the user that s/he had previously selected this item. To clear the selection,
the user would simply choose item B<5> again. This effectively deletes the
previous choice and restores the menu for a new selection. If the user was
satisfied with the choice, and was simply double checking thier selection, they
simply repeat the navigation process by typing ' B<E<gt>> ' - then <ENTER>
-
and returning to the child menu they left.

If the child menu was a I<multiple-selection> menu, and the user had made some
selections before navigating back to the parent menu, the user would see a
' B<+> ' rather than a ' B<-> '. This informs the user that selections were
made in the child menu.

   Choose a /bin Utility :

      1.        /bin Utility - arch
      2.        /bin Utility - ash
      3.        /bin Utility - awk
      4.        /bin Utility - basename
   +  5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
      9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

=head3 View Sorted Items ' B<%> '

When working with numerous items in a single menu, it may be desirable to see
the set of choices organized in either descending or reverse acscii order.
Term::Menus provides this feature with the I<Percent> ' B<%> ' key.  Simply
type ' B<%> ' and the items will be sorted in descending ascii order. Type
' B<%> ' again, and you will see the items reverse sorted. Assume that we have
the following menus.

=over 4

The user sees ==>

   Please select all files for immediate transfer:

   *  1.        addr2name.awk has  **NOT**  been transferred
   *  2.        awk.exe has  **NOT**  been transferred
      3.        gawk-3.1.4.exe has  **NOT**  been transferred
   *  4.        gawk.exe has  **NOT**  been transferred
      5.        igawk has  **NOT**  been transferred
      6.        pgawk-3.1.4.exe has  **NOT**  been transferred
      7.        pgawk.exe has  **NOT**  been transferred
   *  8.        822-date has been transferred
      9.        DllPlugInTester.exe has been transferred
   *  10.       ELFDump.exe has been transferred

   a.  Select All.   c.  Clear All.
   f.  Finish.

   929 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

--< % >-<ENTER>----------------------------------

The user sees ==>

   Please select all files for immediate transfer:

   *  8.        822-date has been transferred
      9.        DllPlugInTester.exe has been transferred
   *  10.       ELFDump.exe has been transferred
      11.       GraphicsMagick++-config has been transferred
      12.       GraphicsMagick-config has been transferred
      13.       X11 has been transferred
      14.       [.exe has been transferred
      15.       a2p.exe has been transferred
      16.       aclocal has been transferred
      17.       aclocal-1.4 has been transferred

   a.  Select All.   c.  Clear All.
   f.  Finish.

   929 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

And if we choose to enter ' B<%> ' I<again>

--< % >-<ENTER>----------------------------------

The user sees ==>

   Please select all files for immediate transfer:

      929.      znew has been transferred
      928.      zmore has been transferred
      927.      zless has been transferred
      926.      zipsplit.exe has been transferred
      925.      zipnote.exe has been transferred
      924.      zipinfo has been transferred
      923.      zipgrep has been transferred
      922.      zipcloak.exe has been transferred
      921.      zip.exe has been transferred
      920.      zgrep has been transferred

   a.  Select All.   c.  Clear All.
   f.  Finish.

   929 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE:

This submenu of selections works just like any other menu. The user can
deselect an item, clear all items, re-choose all items, etc. The choices made
here are preserved when-or-if the user navigates back to the original (parent)
menu. In other words, if Item 1. is deselected in the sorted menu, Item 1.
will also be deselected in the parent menu above.

=back

=head3 View Summary of Selected Items ' B<*> '

When working with numerous items in a single menu, it is desirable to see the 
set of choices made before leaving the menu and committing to a non-returnable 
forward (perhaps even critical) process. Term::Menus provides this feature 
with the I<Star> ' B<*> ' key. Assume we have the following menu with 93 Total 
Choices. Assume further that we have selected items 1,3,9 & 11. Note that we
cannot see Item 11 on the first screen since this menu is configured to show 
only 10 Items at a time.

=over 4

The user sees ==>

   Choose a /bin Utility :

   *  1.        /bin Utility - arch
      2.        /bin Utility - ash
   *  3.        /bin Utility - awk
      4.        /bin Utility - basename
      5.        /bin Utility - bash
      6.        /bin Utility - cat
      7.        /bin Utility - chgrp
      8.        /bin Utility - chmod
   *  9.        /bin Utility - chown
      10.       /bin Utility - cp

   a.  Select All.   c.  Clear All.
   f.  Finish.

   93 Total Choices

   Press ENTER (or "d") to scroll downward

   OR "u" to scroll upward  (Press "q" to quit)

   PLEASE ENTER A CHOICE: 

--< * >-<ENTER>----------------------------------

The user sees ==>

   Choose a /bin Utility :

   *  1.        /bin Utility - arch
   *  3.        /bin Utility - awk
   *  9.	/bin Utility - chown
   *  11.	/bin Utility - cpio

   (Press "q" to quit)

   PLEASE ENTER A CHOICE:

This submenu of selections works just like any other menu. The user can 
deselect an item, clear all items, re-choose all items, etc. The choices made 
here are preserved when-or-if the user navigates back to the original (parent) 
menu. In other words, if Item 1. is deselected in the summary menu, Item 1. 
will also be deselected in the parent menu above. 

=back

=head1 EXAMPLES

=head1 AUTHOR

Brian M. Kelly <Brian.Kelly@fullautosoftware.net>

=head1 COPYRIGHT

Copyright (C) 2000, 2001, 2002, 2003, 2004, 2005
by Brian M. Kelly.  All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License.
(http://www.opensource.org/licenses/gpl-license.php).

