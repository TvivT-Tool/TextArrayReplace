#!/usr/bin/perl -w
# use strict;

$tp_file    = "template.v" ;
$rp_file    = "replace.v"  ;
$out_file   = "out.v"      ;

$space_omit = 1            ;

#============================= Extract ==================================
open (tp_fn,"<", $tp_file);
@tp_lines = <tp_fn>;
close tp_fn ;

open (rp_fn,"<", $rp_file);
@rp_lines = <rp_fn>;
close rp_fn ;

#========================================================================
 
$rp_targets_get = 0;

for my $rp_line_num (0..$#rp_lines) {

  $rp_cline = $rp_lines[$rp_line_num];

  chomp($rp_cline);

  # rp Space
  if($space_omit) {
    $rp_cline =~ s/\s//g;
  }

  # Skip empty lines
  if ($rp_cline =~ /^\s*$/) {
    next;
  }

  if($rp_targets_get ==0) {
    @rp_targets = split(/,/, $rp_cline);
    $rp_targets_get = 1;
  }
  else{
    @rp_words = split(/,/, $rp_cline);

    foreach my $tp_cline(@tp_lines){
      $out_cline = $tp_cline ;
      for my $rp_word_num (0..$#rp_words) {
        $rp_target_one = quotemeta($rp_targets[$rp_word_num]);
        $rp_word_one   = $rp_words[$rp_word_num]             ;

        $out_cline =~ s/$rp_target_one/$rp_word_one/g;
      }
      push(@out_lines, $out_cline);
    }
  push(@out_lines, "\n");
  }

}

# print @out_lines;

open (out_fn,">", $out_file);
print out_fn @out_lines;
close out_fn;
