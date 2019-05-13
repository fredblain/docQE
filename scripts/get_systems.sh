#! /bin/bash
#
# get.sh
#
# Copyright (C) 2018 Frederic Blain (feedoo) <f.blain@sheffield.ac.uk>
#
# Licensed under the "THE BEER-WARE LICENSE" (Revision 42):
# Fred (feedoo) Blain wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a tomato juice or coffee in return
#

extract(){
  year=$1
  src=$2
  tgt=$3

  end='sgm'
  if [ ${year} == 08 ] || [ ${year} == 09 ];
  then
    end='xml'
  fi

  add=''
  add2=''
  if [ ${year} == 15 ] || [ ${year} == 16 ] || [ ${year} == 17 ] || [ ${year} == 18 ] || [ ${year} == 19 ]; 
  then
    add='-'${src}${tgt}
  fi
  if [ ${year} == 14 ];
  then
    if [ ${src} == 'en' ];
    then
      add='-'${tgt}'en'
    else
      add='-'${src}'en'
    fi
  fi
  if [ ${year} == 19 ];
  then
    add2='-ts'
  fi

  for f in *.${end}; do
    sys=`basename ${f} .${end}`
    mkdir ${sys}
    pushd ${sys}
    perl ../../../../scripts/reference-from-sgm.perl ../${f} ../../../../newstests/newstest20${year}/newstest20${year}${add}-src${add2}.${src}.* ${sys}.${tgt}
    # perl ../../../scripts/reference-from-sgm.perl ../newstest20${year}${add}-ref.${tgt}.${end} ../newstest20${year}${add}-src.${src}.${end} ${tgt}
    popd
  done
}

mkdir -p ../systems
pushd ../systems

mkdir 2008 ; pushd 2008
echo "fetching 2008 data..."
# wget 'http://www.statmt.org/wmt08/wmt08-eval.tar.gz' -O wmt08_all-tasks-systems.tgz

# src='de' ; tgt='en' ; lp='german-english'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt08_all-tasks-systems.tgz --wildcards --no-anchored "wmt08-eval/submissions-xml/${src}-${tgt}/*newstest*"
# mv wmt08-eval/submissions-xml/${src}-${tgt}/* . ; rm -rf 'wmt08-eval'
# # extract 08 de en
# popd
#
# src='en' ; tgt='fr' ; lp='english-french'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt08_all-tasks-systems.tgz --wildcards --no-anchored "wmt08-eval/submissions-xml/${src}-${tgt}/*newstest*"
# mv wmt08-eval/submissions-xml/${src}-${tgt}/* . ; rm -rf 'wmt08-eval'
# extract 08 en fr
# popd
#
# src='en' ; tgt='es' ; lp='english-spanish'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt08_all-tasks-systems.tgz --wildcards --no-anchored "wmt08-eval/submissions-xml/${src}-${tgt}/*newstest*"
# mv wmt08-eval/submissions-xml/${src}-${tgt}/* . ; rm -rf 'wmt08-eval'
# extract 08 en es
# popd

src='en' ; tgt='de' ; lp='english-german'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt08_all-tasks-systems.tgz --wildcards --no-anchored "wmt08-eval/submissions-xml/${src}-${tgt}/*newstest*"
mv wmt08-eval/submissions-xml/${src}-${tgt}/* . ; rm -rf 'wmt08-eval'
extract 08 en de
popd

popd # end of 2008

#############################################################

mkdir 2009 ; pushd 2009
echo "fetching 2009 data..."
# wget 'http://www.statmt.org/wmt09/wmt09-eval.tar.gz' -O wmt09_all-tasks-systems.tgz
#
# src='de' ; tgt='en' ; lp='german-english'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt09_all-tasks-systems.tgz --wildcards --no-anchored "wmt09-eval/submissions-xml/${src}-${tgt}/*"
# mv wmt09-eval/submissions-xml/${src}-${tgt}/* . ; rm -rf 'wmt09-eval'
# extract 09 de en
# popd
#
# src='en' ; tgt='fr' ; lp='english-french'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt09_all-tasks-systems.tgz --wildcards --no-anchored "wmt09-eval/submissions-xml/${src}-${tgt}/*"
# mv wmt09-eval/submissions-xml/${src}-${tgt}/* . ; rm -rf 'wmt09-eval'
# extract 09 en fr
# popd
#
# src='en' ; tgt='es' ; lp='english-spanish'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt09_all-tasks-systems.tgz --wildcards --no-anchored "wmt09-eval/submissions-xml/${src}-${tgt}/*"
# mv wmt09-eval/submissions-xml/${src}-${tgt}/* . ; rm -rf 'wmt09-eval'
# extract 09 en es
# popd

src='en' ; tgt='de' ; lp='english-german'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt09_all-tasks-systems.tgz --wildcards --no-anchored "wmt09-eval/submissions-xml/${src}-${tgt}/*"
mv wmt09-eval/submissions-xml/${src}-${tgt}/* . ; rm -rf 'wmt09-eval'
extract 09 en de
popd

popd # end of 2009

#############################################################

mkdir 2010 ; pushd 2010
echo "fetching 2010 data..."
# wget 'http://statmt.org/wmt10/results/wmt10-data.zip' -O wmt10_all-tasks-systems.tgz  # not individual submission available, combinations only

# src='en' ; tgt='fr' ; lp='english-french'
# mkdir ${lp} ; pushd ${lp}
# wget 'http://matrix.statmt.org/data/20170430112718_U-796_S-2866_T-1624_newstest2010.decode-output.fr.sgm?1504722365' -O seal14.en-fr.sgm
# wget 'http://matrix.statmt.org/data/20100305212235_U-45_S-1396_T-1624_lium_newstest2010_enfr_primary.sgm?1504722361' -O lium14.en-fr.sgm
# # wget 'http://matrix.statmt.org/data/20100305160915_U-33_S-1348_T-1624_20100305160852_U-33_S-1348_T-1624_newstest2010.en.fr.sgm' -O Its-LATL.en-fr.sgm  # 404 not found
# wget 'http://matrix.statmt.org/data/20100305164607_U-25_S-1365_T-1624_translation.en-fr.final.sgm?1504722352' -O dfki-hybrid.en-fr.sgm
# wget 'http://matrix.statmt.org/data/20100305182827_U-21_S-1369_T-1624_en-fr.newstest2010.rwth-primary.sgm?1504722352' -O rwth.en-fr.sgm
# wget 'http://matrix.statmt.org/data/20100305200633_U-41_S-1386_T-1624_run1.en-fr.sgm?1504722352' -O rali.en-fr.sgm
# wget 'http://matrix.statmt.org/data/20100305201953_U-27_S-1389_T-1624_newstest2010-src.en-fr.sents.tok.lowercased.output.100.TRBMT.L2.2.BP.TMLM.trans.sgm?1504722352' -O KU_TRBMT_L1.en-fr.sgm
# wget 'http://matrix.statmt.org/data/20100308101106_U-20_S-1343_T-1624_newstest2010.detokenized.sgm.2?1504722363' -O uedin.en-fr.sgm
# wget 'http://matrix.statmt.org/data/20100305213757_U-26_S-1400_T-1624_NRC-Primary-newstest2010.fr.xml?1504722362' -O nrc.en-fr.sgm
# wget 'http://matrix.statmt.org/data/20100305214831_U-31_S-1404_T-1624_uk-dan.en-fr.sgm?1504722363' -O uk-dan.en-fr.sgm
# wget 'http://matrix.statmt.org/data/20100306001249_U-35_S-1417_T-1624_limsi-ncode-en2fr-primary.sgm?1504722363' -O limsi-cnrs.en-fr.sgm
# wget 'http://matrix.statmt.org/data/20100306121047_U-32_S-1431_T-1624_newstest2010.CUED_constrained_primary.fr.sgm?1504722363' -O cued.en-fr.sgm
# wget 'http://matrix.statmt.org/data/20100308205530_U-18_S-1452_T-1624_JHU.newstest2010.en-fr.sgm?1504722363' -O jhu.en-fr.sgm
# wget 'http://matrix.statmt.org/data/20100831133051_U-21_S-1469_T-1624_en-fr.newstest2010.rwth-jane.sgm?1504722364' -O rwth.en-fr.sgm
# wget 'http://matrix.statmt.org/data/20100305141533_U-28_S-1340_T-1624_newstest2010.en-fr.sgm?1504722352' -O exodus.en-fr.sgm
# extract 10 en fr
# popd

popd

#############################################################

mkdir 2011 ; pushd 2011
echo "fetching 2011 data..."
wget 'http://statmt.org/wmt11/wmt11-data.tar.gz' -O wmt11_all-tasks-systems.tgz
#
# src='de' ; tgt='en' ; lp='german-english'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt11_all-tasks-systems.tgz --wildcards --no-anchored "wmt11-data/sgm/system-outputs/newstest2011/${src}-${tgt}/"
# mv wmt11-data/sgm/system-outputs/newstest2011/${src}-${tgt}/* . ; rm -rf wmt11-data
# extract 11 de en
# popd
#
# src='en' ; tgt='fr' ; lp='english-french'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt11_all-tasks-systems.tgz --wildcards --no-anchored "wmt11-data/sgm/system-outputs/newstest2011/${src}-${tgt}/"
# mv wmt11-data/sgm/system-outputs/newstest2011/${src}-${tgt}/* . ; rm -rf wmt11-data
# extract 11 en fr
# popd
#
# src='en' ; tgt='es' ; lp='english-spanish'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt11_all-tasks-systems.tgz --wildcards --no-anchored "wmt11-data/sgm/system-outputs/newstest2011/${src}-${tgt}/"
# mv wmt11-data/sgm/system-outputs/newstest2011/${src}-${tgt}/* . ; rm -rf wmt11-data
# extract 11 en es
# popd

src='en' ; tgt='de' ; lp='english-german'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt11_all-tasks-systems.tgz --wildcards --no-anchored "wmt11-data/sgm/system-outputs/newstest2011/${src}-${tgt}/"
mv wmt11-data/sgm/system-outputs/newstest2011/${src}-${tgt}/* . ; rm -rf wmt11-data
extract 11 en de
popd

popd # end of 2011

#############################################################

mkdir 2012 ; pushd 2012
echo "fetching 2012 data..."
# wget 'http://statmt.org/wmt12/wmt12-data.tar.gz' -O wmt12_all-tasks-systems.tgz
#
# src='de' ; tgt='en' ; lp='german-english'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt12_all-tasks-systems.tgz --wildcards --no-anchored "wmt12-data/sgm/system-outputs/newstest2012/${src}-${tgt}/"
# mv wmt12-data/sgm/system-outputs/newstest2012/${src}-${tgt}/* . ; rm -rf wmt12-data
# extract 12 de en
# popd
#
# src='en' ; tgt='fr' ; lp='english-french'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt12_all-tasks-systems.tgz --wildcards --no-anchored "wmt12-data/sgm/system-outputs/newstest2012/${src}-${tgt}/"
# mv wmt12-data/sgm/system-outputs/newstest2012/${src}-${tgt}/* . ; rm -rf wmt12-data
# extract 12 en fr
# popd
#
# src='en' ; tgt='es' ; lp='english-spanish'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt12_all-tasks-systems.tgz --wildcards --no-anchored "wmt12-data/sgm/system-outputs/newstest2012/${src}-${tgt}/"
# mv wmt12-data/sgm/system-outputs/newstest2012/${src}-${tgt}/* . ; rm -rf wmt12-data
# extract 12 en es
# popd

src='en' ; tgt='de' ; lp='english-german'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt12_all-tasks-systems.tgz --wildcards --no-anchored "wmt12-data/sgm/system-outputs/newstest2012/${src}-${tgt}/"
mv wmt12-data/sgm/system-outputs/newstest2012/${src}-${tgt}/* . ; rm -rf wmt12-data
extract 12 en de
popd

popd # end of 2012

#############################################################

mkdir 2013 ; pushd 2013
echo "fetching 2013 data..."
# wget 'http://statmt.org/wmt13/wmt13-data.tar.gz' -O wmt13_all-tasks-systems.tgz
#
# src='de' ; tgt='en' ; lp='german-english'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt13_all-tasks-systems.tgz --wildcards --no-anchored "wmt13-data/sgm/system-outputs/newstest2013/${src}-${tgt}/"
# mv wmt13-data/sgm/system-outputs/newstest2013/${src}-${tgt}/* . ; rm -rf wmt13-data
# extract 13 de en
# popd
#
src='en' ; tgt='ru' ; lp='english-russian'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt13_all-tasks-systems.tgz --wildcards --no-anchored "wmt13-data/sgm/system-outputs/newstest2013/${src}-${tgt}/"
mv wmt13-data/sgm/system-outputs/newstest2013/${src}-${tgt}/* . ; rm -rf wmt13-data
extract 13 en ru
popd
#
# src='en' ; tgt='fr' ; lp='english-french'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt13_all-tasks-systems.tgz --wildcards --no-anchored "wmt13-data/sgm/system-outputs/newstest2013/${src}-${tgt}/"
# mv wmt13-data/sgm/system-outputs/newstest2013/${src}-${tgt}/* . ; rm -rf wmt13-data
# extract 13 en fr
# popd
#
# src='en' ; tgt='es' ; lp='english-spanish'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt13_all-tasks-systems.tgz --wildcards --no-anchored "wmt13-data/sgm/system-outputs/newstest2013/${src}-${tgt}/"
# mv wmt13-data/sgm/system-outputs/newstest2013/${src}-${tgt}/* . ; rm -rf wmt13-data
# extract 13 en es
# popd

src='en' ; tgt='de' ; lp='english-german'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt13_all-tasks-systems.tgz --wildcards --no-anchored "wmt13-data/sgm/system-outputs/newstest2013/${src}-${tgt}/"
mv wmt13-data/sgm/system-outputs/newstest2013/${src}-${tgt}/* . ; rm -rf wmt13-data
extract 13 en de
popd

popd # end of 2013

#############################################################

mkdir 2014 ; pushd 2014
echo "fetching 2014 data..."
# wget 'http://statmt.org/wmt14/submissions.tgz' -O wmt14_all-tasks-systems.tgz
#
# src='de' ; tgt='en' ; lp='german-english'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt14_all-tasks-systems.tgz --wildcards --no-anchored "wmt14-data/sgm/system-outputs/newstest2014/${src}-${tgt}/"
# mv wmt14-data/sgm/system-outputs/newstest2014/${src}-${tgt}/* . ; rm -rf 'wmt14-data'
# ## fix error:
# ## Died at ../../../../../../../../scripts/reference-from-sgm.perl line 33, <REF> line 2.
# ## reference-from-sgm.perl line 33: die unless $line =~ /sysid="([^\"]+)"/i || $system_from_refset;
# ## solution: adding 'sysid' attribute to doc header.
# sed -i 's/\(<doc\)/\1 sysid="rbmt1"/g' newstest2014.rbmt1.0.de-en.sgm
# sed -i 's/\(<doc\)/\1 sysid="rbmt4"/g' newstest2014.rbmt4.0.de-en.sgm 
# sed -i 's/\(<doc\)/\1 sysid="onlineA"/g' newstest2014.onlineA.0.de-en.sgm 
# sed -i 's/\(<doc\)/\1 sysid="onlineB"/g' newstest2014.onlineB.0.de-en.sgm
# sed -i 's/\(<doc\)/\1 sysid="onlineC"/g' newstest2014.onlineC.0.de-en.sgm
# extract 14 de en
# popd
#
src='en' ; tgt='ru' ; lp='english-russian'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt14_all-tasks-systems.tgz --wildcards --no-anchored "wmt14-data/sgm/system-outputs/newstest2014/${src}-${tgt}/"
mv wmt14-data/sgm/system-outputs/newstest2014/${src}-${tgt}/* . ; rm -rf 'wmt14-data'
## fix error:
## Died at ../../../../../../../../scripts/reference-from-sgm.perl line 33, <REF> line 2.
## reference-from-sgm.perl line 33: die unless $line =~ /sysid="([^\"]+)"/i || $system_from_refset;
## solution: adding 'sysid' attribute to doc header.
sed -i 's/\(<doc\)/\1 sysid="rbmt1"/g' newstest2014.rbmt1.0.en-ru.sgm
sed -i 's/\(<doc\)/\1 sysid="rbmt4"/g' newstest2014.rbmt4.0.en-ru.sgm 
sed -i 's/\(<doc\)/\1 sysid="onlineA"/g' newstest2014.onlineA.0.en-ru.sgm 
sed -i 's/\(<doc\)/\1 sysid="onlineB"/g' newstest2014.onlineB.0.en-ru.sgm
sed -i 's/\(<doc\)/\1 sysid="onlineG"/g' newstest2014.onlineG.0.en-ru.sgm
extract 14 en ru
popd
#
# src='en' ; tgt='fr' ; lp='english-french'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt14_all-tasks-systems.tgz --wildcards --no-anchored "wmt14-data/sgm/system-outputs/newstest2014/${src}-${tgt}/"
# mv wmt14-data/sgm/system-outputs/newstest2014/${src}-${tgt}/* . ; rm -rf 'wmt14-data'
# ## fix error:
# ## Died at ../../../../../../../../scripts/reference-from-sgm.perl line 33, <REF> line 2.
# ## reference-from-sgm.perl line 33: die unless $line =~ /sysid="([^\"]+)"/i || $system_from_refset;
# ## solution: adding 'sysid' attribute to doc header.
# sed -i 's/\(<doc\)/\1 sysid="rbmt1"/g' newstest2014.rbmt1.0.en-fr.sgm
# sed -i 's/\(<doc\)/\1 sysid="rbmt4"/g' newstest2014.rbmt4.0.en-fr.sgm 
# sed -i 's/\(<doc\)/\1 sysid="onlineA"/g' newstest2014.onlineA.0.en-fr.sgm 
# sed -i 's/\(<doc\)/\1 sysid="onlineB"/g' newstest2014.onlineB.0.en-fr.sgm
# sed -i 's/\(<doc\)/\1 sysid="onlineC"/g' newstest2014.onlineC.0.en-fr.sgm
# extract 14 en fr
# popd

src='en' ; tgt='de' ; lp='english-german'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt14_all-tasks-systems.tgz --wildcards --no-anchored "wmt14-data/sgm/system-outputs/newstest2014/${src}-${tgt}/"
mv wmt14-data/sgm/system-outputs/newstest2014/${src}-${tgt}/* . ; rm -rf 'wmt14-data'
## fix error:
## Died at ../../../../../../../../scripts/reference-from-sgm.perl line 33, <REF> line 2.
## reference-from-sgm.perl line 33: die unless $line =~ /sysid="([^\"]+)"/i || $system_from_refset;
## solution: adding 'sysid' attribute to doc header.
sed -i 's/\(<doc\)/\1 sysid="rbmt1"/g' newstest2014.rbmt1.0.en-de.sgm
sed -i 's/\(<doc\)/\1 sysid="rbmt4"/g' newstest2014.rbmt4.0.en-de.sgm 
sed -i 's/\(<doc\)/\1 sysid="onlineA"/g' newstest2014.onlineA.0.en-de.sgm 
sed -i 's/\(<doc\)/\1 sysid="onlineB"/g' newstest2014.onlineB.0.en-de.sgm
sed -i 's/\(<doc\)/\1 sysid="onlineC"/g' newstest2014.onlineC.0.en-de.sgm
extract 14 en de
popd

popd # end of 2014

#############################################################

mkdir 2015 ; pushd 2015
echo "fetching 2015 data..."
# wget 'http://statmt.org/wmt15/wmt15-submitted-data.tgz' -O wmt15_all-tasks-systems.tgz
#
# src='de' ; tgt='en' ; lp='german-english'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt15_all-tasks-systems.tgz --wildcards --no-anchored "wmt15-submitted-data/sgm/system-outputs/newstest2015/${src}-${tgt}/"
# mv wmt15-submitted-data/sgm/system-outputs/newstest2015/${src}-${tgt}/* . ; rm -rf 'wmt15-submitted-data'
# extract 15 de en
# popd
#
src='en' ; tgt='ru' ; lp='english-russian'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt15_all-tasks-systems.tgz --wildcards --no-anchored "wmt15-submitted-data/sgm/system-outputs/newstest2015/${src}-${tgt}/"
mv wmt15-submitted-data/sgm/system-outputs/newstest2015/${src}-${tgt}/* . ; rm -rf 'wmt15-submitted-data'
extract 15 en ru
popd

src='en' ; tgt='de' ; lp='english-german'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt15_all-tasks-systems.tgz --wildcards --no-anchored "wmt15-submitted-data/sgm/system-outputs/newstest2015/${src}-${tgt}/"
mv wmt15-submitted-data/sgm/system-outputs/newstest2015/${src}-${tgt}/* . ; rm -rf 'wmt15-submitted-data'
extract 15 en de
popd

popd # end of 2015

#############################################################

mkdir 2016 ; pushd 2016
echo "fetching 2016 data..."
# wget 'http://data.statmt.org/wmt16/translation-task/wmt16-submitted-data-v2.tgz' -O wmt16_all-newstranslation-task-systems.tgz
#
# src='de' ; tgt='en' ; lp='german-english'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt16_all-newstranslation-task-systems.tgz --wildcards --no-anchored "wmt16-submitted-data/sgm/system-outputs/newstest2016/${src}-${tgt}/"
# mv wmt16-submitted-data/sgm/system-outputs/newstest2016/${src}-${tgt}/* . ; rm -rf 'wmt16-submitted-data'
# extract 16 de en
# popd
#
src='en' ; tgt='ru' ; lp='english-russian'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt16_all-newstranslation-task-systems.tgz --wildcards --no-anchored "wmt16-submitted-data/sgm/system-outputs/newstest2016/${src}-${tgt}/"
mv wmt16-submitted-data/sgm/system-outputs/newstest2016/${src}-${tgt}/* . ; rm -rf 'wmt16-submitted-data'
extract 16 en ru
popd

src='en' ; tgt='de' ; lp='english-german'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt16_all-newstranslation-task-systems.tgz --wildcards --no-anchored "wmt16-submitted-data/sgm/system-outputs/newstest2016/${src}-${tgt}/"
mv wmt16-submitted-data/sgm/system-outputs/newstest2016/${src}-${tgt}/* . ; rm -rf 'wmt16-submitted-data'
extract 16 en de
popd

popd # end of 2016

#############################################################

mkdir 2017 ; pushd 2017
echo "fetching 2017 data..."
# wget 'http://data.statmt.org/wmt17/translation-task/wmt17-submitted-data-v1.0.tgz' -O wmt17_all-newstranslation-task-systems.tgz
#
# src='de' ; tgt='en' ; lp='german-english'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt17_all-newstranslation-task-systems.tgz --wildcards --no-anchored "wmt17-submitted-data/sgm/system-outputs/newstest2017/${src}-${tgt}/"
# mv wmt17-submitted-data/sgm/system-outputs/newstest2017/${src}-${tgt}/* . ; rm -rf 'wmt17-submitted-data'
# extract 17 de en
# popd
#
src='en' ; tgt='ru' ; lp='english-russian'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt17_all-newstranslation-task-systems.tgz --wildcards --no-anchored "wmt17-submitted-data/sgm/system-outputs/newstest2017/${src}-${tgt}/"
mv wmt17-submitted-data/sgm/system-outputs/newstest2017/${src}-${tgt}/* . ; rm -rf 'wmt17-submitted-data'
extract 17 en ru
popd

src='en' ; tgt='de' ; lp='english-german'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt17_all-newstranslation-task-systems.tgz --wildcards --no-anchored "wmt17-submitted-data/sgm/system-outputs/newstest2017/${src}-${tgt}/"
mv wmt17-submitted-data/sgm/system-outputs/newstest2017/${src}-${tgt}/* . ; rm -rf 'wmt17-submitted-data'
extract 17 en de
popd

popd # end of 2017

############################################################

mkdir 2018 ; pushd 2018
echo "fetching 2018 data..."
# wget 'http://data.statmt.org/wmt18/translation-task/wmt18-submitted-data-v1.0.tgz' -O wmt18_all-newstranslation-task-systems.tgz
#
# src='de' ; tgt='en' ; lp='german-english'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt18_all-newstranslation-task-systems.tgz --wildcards --no-anchored "wmt18-submitted-data/sgm/system-outputs/newstest2018/${src}-${tgt}/"
# mv wmt18-submitted-data/sgm/system-outputs/newstest2018/${src}-${tgt}/* . ; rm -rf 'wmt18-submitted-data'
# extract 18 de en
# popd
#
src='en' ; tgt='ru' ; lp='english-russian'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt18_all-newstranslation-task-systems.tgz --wildcards --no-anchored "wmt18-submitted-data/sgm/system-outputs/newstest2018/${src}-${tgt}/"
mv wmt18-submitted-data/sgm/system-outputs/newstest2018/${src}-${tgt}/* . ; rm -rf 'wmt18-submitted-data'
extract 18 en ru
popd

src='en' ; tgt='de' ; lp='english-german'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt18_all-newstranslation-task-systems.tgz --wildcards --no-anchored "wmt18-submitted-data/sgm/system-outputs/newstest2018/${src}-${tgt}/"
mv wmt18-submitted-data/sgm/system-outputs/newstest2018/${src}-${tgt}/* . ; rm -rf 'wmt18-submitted-data'
extract 18 en de
popd

popd # end of 2018

#############################################################

mkdir 2019 ; pushd 2019
echo "fetching 2019 data..."
# wget 'http://data.statmt.org/wmt19/translation-task/wmt19-submitted-data-v0.1.tgz' -O wmt19_all-newstranslation-task-systems.tgz
# wget 'http://data.statmt.org/wmt19/translation-task/wmt19-submitted-data-v1.tgz' -O wmt19_all-newstranslation-task-systems.tgz
# wget 'http://data.statmt.org/wmt19/translation-task/wmt19-submitted-data-v2.tgz' -O wmt19_all-newstranslation-task-systems.tgz
wget 'http://data.statmt.org/wmt19/translation-task/wmt19-submitted-data-v3.tgz' -O wmt19_all-newstranslation-task-systems.tgz

# src='de' ; tgt='en' ; lp='german-english'
# mkdir ${lp} ; pushd ${lp} 
# tar xf ../wmt19_all-newstranslation-task-systems.tgz --wildcards --no-anchored "wmt19-submitted-data/sgm/system-outputs/newstest2019/${src}-${tgt}/"
# mv wmt19-submitted-data/sgm/system-outputs/newstest2019/${src}-${tgt}/* . ; rm -rf 'wmt19-submitted-data'
# extract 19 de en
# popd
#
src='en' ; tgt='ru' ; lp='english-russian'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt19_all-newstranslation-task-systems.tgz --wildcards --no-anchored "wmt19-submitted-data/sgm/system-outputs/newstest2019/${src}-${tgt}/"
mv wmt19-submitted-data/sgm/system-outputs/newstest2019/${src}-${tgt}/* . ; rm -rf 'wmt19-submitted-data'
extract 19 en ru
popd

src='en' ; tgt='de' ; lp='english-german'
mkdir ${lp} ; pushd ${lp} 
tar xf ../wmt19_all-newstranslation-task-systems.tgz --wildcards --no-anchored "wmt19-submitted-data/sgm/system-outputs/newstest2019/${src}-${tgt}/"
mv wmt19-submitted-data/sgm/system-outputs/newstest2019/${src}-${tgt}/* . ; rm -rf 'wmt19-submitted-data'
extract 19 en de
popd

popd # end of 2019

popd # end of ../systems
