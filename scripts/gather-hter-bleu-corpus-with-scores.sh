#! /bin/bash
#
# produce-hter-score.sh
#
# Copyright (C) 2019 Frederic Blain (feedoo) <f.blain@sheffield.ac.uk>
#
# Licensed under the "THE BEER-WARE LICENSE" (Revision 42):
# Fred (feedoo) Blain wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a tomato juice or coffee in return
#

###
# This script takes a list of "aligned-doc" files (from align-doc.py) and compute the
# TER at sentence-level (w/ tercom) + gather the BLEU scores
# in order to train a word- and sentence-level QE model
###

## '-filtered' means top submission + one bottom one only, per task, per year
## '' all submissions otherwise
filt='-filtered'
# filt=''

srclang=english
src=en

## starting/ending year dfining the range of edition to consider
## to create the dataset
startingyear=2011
endingyear=2017

pushd ../filelists-and-doc-scores

for target in 'german-de' 'russian-ru'; do
# for target in 'russian-ru'; do
# for target in 'german-de'; do
  tgtlang=`echo ${target} | cut -f1 -d'-'`
  tgt=`echo ${target} | cut -f2 -d'-'` 

  echo "processing systems for ${tgtlang}${filt}..."
  
  rm -f /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}
  touch /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}
  
  rm -f /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${tgt}
  touch /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${tgt}
  
  rm -f /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${src}
  touch /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${src}

  rm -f /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}.tok.bleu
  touch /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}.tok.bleu
  
  for year in $(seq ${startingyear} ${endingyear}); do
    echo "processing ${year}..."
    ## cat ${year}.${srclang}-${tgtlang}.filelist-systems${filt}.${tgt} > /tmp/${year}.${srclang}-${tgtlang}.systems${filt}.${tgt}
    ## cat ${year}.${srclang}-${tgtlang}.filelist-alignref${filt}.${tgt} > /tmp/${year}.${srclang}-${tgtlang}.ref${filt}.${tgt}
    paste ${year}.${srclang}-${tgtlang}.filelist-systems${filt}.${tgt} ${year}.${srclang}-${tgtlang}.filelist-alignref${filt}.${tgt} | while  IFS="$(printf '\t')" read -r system ref; do
      srcfile=${ref%.*}
      nb_line_src=`wc -l ${srcfile}.${src} | cut -f1 -d' '`
      nb_line_ref=`wc -l ${ref} | cut -f1 -d' '`
      nb_line_sys=`wc -l ${system} | cut -f1 -d' '`

      if ([ ${nb_line_src} -eq ${nb_line_ref} ] && [ ${nb_line_ref} -eq ${nb_line_sys} ]); then
        cat ${srcfile}.${src} >> /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${src}
        cat ${system} >> /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}
        cat ${system}.bleu >> /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}.tok.bleu
        cat ${ref} >> /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${tgt}
      else
        echo "/!\ with the nb of line between those files: ${srcfile}.${src} (${nb_line_src} lines), ${ref} (${nb_line_ref} lines), ${system} (${nb_line_sys} lines)"
      fi
    done
  done

  echo "tokenization..."
  perl ~/workspace/tools/mosesdecoder/scripts/tokenizer/tokenizer.perl -no-escape -threads 4 -l ${tgt} < /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt} > /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}.tok
  perl ~/workspace/tools/mosesdecoder/scripts/tokenizer/tokenizer.perl -no-escape -threads 4 -l ${src} < /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${src} > /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${src}.tok
  perl ~/workspace/tools/mosesdecoder/scripts/tokenizer/tokenizer.perl -no-escape -threads 4 -l ${tgt} < /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${tgt} > /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${tgt}.tok

  echo "applying seg-id script..."
  perl ~/workspace/scripts/seg-id.pl /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}.tok
  perl ~/workspace/scripts/seg-id.pl /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${tgt}.tok

  echo "computing TER w/ tercom..."
  java -jar /home/fblain/workspace/tools/tercom-0.7.25/tercom.7.25.jar -r /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${tgt}.tok.seg -h /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}.tok.seg -o ter -n /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}.tok.raw
  tail -n+3 /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}.tok.raw.ter | cut -f4 -d' ' | awk 'BEGIN{OFS=FS="$"}{$1=sprintf("%0.4f",$1)}1' > /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}.tok.ter

  echo "computing ChrF..."
  python /home/fblain/workspace/tools/chrF/chrF++.py -s -R /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.ref${filt}.${tgt}.tok -H /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}.tok > /tmp/${srclang}-${tgtlang}_${startingyear}-${endingyear}.systems${filt}.${tgt}.tok.chrf

done

popd
