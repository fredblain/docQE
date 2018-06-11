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
  lp=$2
  src=$3
  tgt=$4

  end='sgm'
  if [ ${year} == 08 ] || [ ${year} == 09 ];
  then
    end='xml'
  fi

  add=''
  if [ ${year} == 15 ] || [ ${year} == 16 ] || [ ${year} == 17 ]; 
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

  mkdir ${lp}
  pushd ${lp}
  # perl ../../../scripts/reference-from-sgm.perl ../newstest20${year}${add}-ref.${tgt}.${end} ../newstest20${year}${add}-src.${src}.${end} ${tgt}
  perl ../../../scripts/source-and-reference-from-sgm.perl ../newstest20${year}${add}-ref.${tgt}.${end} ../newstest20${year}${add}-src.${src}.${end} ${src} ${tgt}
  
  popd
}

wdir='../newstests/'

mkdir -p ${wdir}
pushd ${wdir}

# 2008
wget 'http://matrix.statmt.org/test_sets/newstest2008.tgz' -O newstest2008.tgz
tar zxf newstest2008.tgz
pushd newstest2008
extract 08 german-english de en
extract 08 english-french en fr
extract 08 english-spanish en es
popd

# 2009
# wget 'http://matrix.statmt.org/test_sets/newstest2009.tgz' -O newstest2009.tgz   # not the one release with the submissions....
# tar zxf newstest2009.tgz
wget 'http://www.statmt.org/wmt09/wmt09-eval.tar.gz' -O newstest2009.tgz
tar xf newstest2009.tgz --wildcards --no-anchored "wmt09-eval/source+ref-xml/*"
mkdir newstest2009
mv wmt09-eval/source+ref-xml/* newstest2009 ; rm -rf wmt09-eval 
pushd newstest2009
extract 09 german-english de en
extract 09 english-french en fr
extract 09 english-spanish en es
popd

# 2010
wget 'http://matrix.statmt.org/test_sets/newstest2010.tgz' -O newstest2010.tgz
tar zxf newstest2010.tgz
mv test2010 newstest2010
pushd newstest2010
extract 10 german-english de en
extract 10 english-french en fr
extract 10 english-spanish en es
popd

# 2011
wget 'http://matrix.statmt.org/test_sets/newstest2011.tgz' -O newstest2011.tgz
tar zxf newstest2011.tgz
mv test2011 newstest2011
pushd newstest2011
extract 11 german-english de en
extract 11 english-french en fr
extract 11 english-spanish en es
popd

# 2012
wget 'http://matrix.statmt.org/test_sets/newstest2012.tgz' -O newstest2012.tgz
tar zxf newstest2012.tgz
mv test2012 newstest2012
pushd newstest2012
extract 12 german-english de en
extract 12 english-french en fr
extract 12 english-spanish en es
popd

# 2013
wget 'http://matrix.statmt.org/test_sets/newstest2013.tgz' -O newstest2013.tgz
tar zxf newstest2013.tgz
mv test newstest2013
pushd newstest2013
extract 13 german-english de en
extract 13 english-french en fr
extract 13 english-russian en ru
extract 13 english-spanish en es
popd

# 2014
# wget 'http://matrix.statmt.org/test_sets/newstest2014.tgz' -O newstest2014.tgz
# wget 'http://www.statmt.org/wmt14/test-full.tgz' -O newstest2014.tgz
# tar zxf newstest2014.tgz
# mv test-full newstest2014
wget 'http://statmt.org/wmt14/submissions.tgz' -O newstest2014.tgz
tar xf newstest2014.tgz --wildcards --no-anchored "wmt14-data/sgm/sources/"
tar xf newstest2014.tgz --wildcards --no-anchored "wmt14-data/sgm/references/"
mkdir newstest2014
mv wmt14-data/sgm/sources/* newstest2014/ ; mv wmt14-data/sgm/references/* newstest2014/ ; rm -rf wmt14-data
pushd newstest2014
extract 14 german-english de en
extract 14 english-french en fr
extract 14 english-russian en ru
popd

# 2015
wget 'http://matrix.statmt.org/test_sets/newstest2015.tgz' -O newstest2015.tgz
tar zxf newstest2015.tgz
# wget 'http://statmt.org/wmt15/wmt15-submitted-data.tgz' -O newstest2015.tgz
# tar xf newstest2015.tgz --wildcards --no-anchored "wmt15-submitted-data/sgm/sources/"
# tar xf newstest2015.tgz --wildcards --no-anchored "wmt15-submitted-data/sgm/references/"
# mkdir newstest2015
# mv wmt15-submitted-data/sgm/sources/* newstest2015/ ; mv wmt15-submitted-data/sgm/references/* newstest2015/ ; rm -rf wmt15-submitted-data
mv newsdiscusstest2015 newstest2015/
pushd newstest2015
extract 15 german-english de en
# extract 15 english-french en fr
extract 15 english-russian en ru
popd

# 2016
wget 'http://matrix.statmt.org/test_sets/newstest2016.tgz' -O newstest2016.tgz
tar zxf newstest2016.tgz
mv sgm newstest2016
# wget 'http://data.statmt.org/wmt16/translation-task/wmt16-submitted-data-v2.tgz' -O newstest2016.tgz
# tar xf newstest2016.tgz --wildcards --no-anchored "wmt16-submitted-data/sgm/sources/"
# tar xf newstest2016.tgz --wildcards --no-anchored "wmt16-submitted-data/sgm/references/"
# mkdir newstest2016
# mv wmt16-submitted-data/sgm/sources/* newstest2016/ ; mv wmt16-submitted-data/sgm/references/* newstest2016/ ; rm -rf wmt16-submitted-data
pushd newstest2016
extract 16 german-english de en
extract 16 english-russian en ru
popd

# 2017
wget 'http://matrix.statmt.org/test_sets/newstest2017.tgz' -O newstest2017.tgz
tar zxf newstest2017.tgz
mv test newstest2017
# wget 'http://data.statmt.org/wmt17/translation-task/wmt17-submitted-data-v1.0.tgz' -O newstest2017.tgz
# tar xf newstest2017.tgz --wildcards --no-anchored "wmt17-submitted-data/sgm/sources/"
# tar xf newstest2017.tgz --wildcards --no-anchored "wmt17-submitted-data/sgm/references/"
# mkdir newstest2017
# mv wmt17-submitted-data/sgm/sources/* newstest2017/ ; mv wmt17-submitted-data/sgm/references/* newstest2017/ ; rm -rf wmt17-submitted-data
pushd newstest2017
extract 17 german-english de en
extract 17 english-russian en ru
popd

popd
