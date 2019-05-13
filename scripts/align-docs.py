#! /usr/bin/env python
# -*- coding: utf-8 -*-
#
# align-docs.py
#
# Copyright (C) 2018 Frederic Blain (feedoo) <f.blain@sheffield.ac.uk>
#
# Licensed under the "THE BEER-WARE LICENSE" (Revision 42):
# Fred (feedoo) Blain wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a tomato juice or coffee in return
#

"""
This script aligns, at document-level, systems' submission for each year, for each language-pair
"""

import codecs
from collections import defaultdict
import sys, os
from os.path import isfile, join


NEWTESTS = '../newstests/newstest'
SYSTEMS = '../systems/'
ODIR = '../filelists-and-doc-scores/'

YEARS = ['2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018']#, '2019']
LPs = {'german-english':['de','en'], 'english-russian':['en','ru'], 'english-french':['en','fr'], 'english-spanish':['en','es'], 'english-german':['en','de']}
# we filter best and worse systems for each year:
# FILTERED_SYS = { \
#         '2008':[], \
#         '2009':[], \
#         '2010':['lium14.en-fr','uk-dan.en-fr'], \
#         '2011':['newstest2011.de-en.cst-contrastive','newstest2011.de-en.linguatec','newstest2011.en-es.udein','newstest2011.en-es.upm','newstest2011.en-fr.lium','newstest2011.en-fr.cu-zeman'], \
#         '2012':['newstest2012.de-en.quaero_primary','newstest2012.de-en.uk-dan-moses','newstest2012.en-es.uedin-wmt12', 'newstest2012.en-es.uk-dan-moses','newstest2012.en-fr.RWTH-Jane2-HPBT-constrained','newstest2012.en-fr.uk-dan-moses'], \
#         '2013':['newstest2013.de-en.QUAERO_primary.2601','newstest2013.de-en.desrt.2704','newstest2013.en-es.uedin-wmt13.2835','newstest2013.en-es.Shef-wproa.2778', 'newstest2013.en-fr.uedin-wmt13.2884','newstest2013.en-fr.Its-LATL.2652', 'newstest2013.en-ru.PROMT.2753','newstest2013.en-ru.cu-zeman.2730'], \
#         '2014':['newstest2014.eubridge.3569.de-en','newstest2014.DCU-ICTCAS-Tsinghua-L.3444.de-en','newstest2014.uedin-wmt14.3023.en-fr','newstest2014.PROMT-Rule-based.3083.en-fr','newstest2014.uedin-unconstrained.3445.en-ru','newstest2014.PROMT-Rule-based.3081.en-ru'], \
#         '2015':['newstest2015.uedin-jhu-phrase.4102.de-en','newstest2015.Illinois.4085.de-en','newstest2015.uedin-jhu-phrase.4144.en-ru','newstest2015.USAAR-gacha.3962.en-ru'], \
#         '2016':['newstest2016.uedin-nmt.4313.de-en','newstest2016.uedin-nmt.4313.de-en','newstest2016.uedin-nmt.4307.en-ru','newstest2016.AFRL-MITLL-verb-annot.4526.en-ru'], \
#         '2017':['newstest2017.uedin-nmt.4723.de-en','newstest2017.TALP-UPC.4830.de-en','newstest2017.uedin-nmt.4756.en-ru','newstest2017.PROMT-Rule-based.4736.en-ru'] \
#         }
#
FILTERED_SYS = { \
        '2008':[], \
        '2009':[], \
        '2010':[], \
        '2011':[], \
        '2012':[], \
        '2013':['newstest2013.en-ru.PROMT.2753','newstest2013.en-ru.cu-zeman.2730','newstest2013.en-de.Shef-wproa.2748','newstest2013.en-de.uedin-wmt13.2638'], \
        '2014':['newstest2014.uedin-unconstrained.3445.en-ru','newstest2014.PROMT-Rule-based.3081.en-ru','newstest2014.uedin-stanford-unconstrained.3539.en-de','newstest2014.PROMT-Rule-based.3079.en-de'], \
        '2015':['newstest2015.uedin-jhu-phrase.4144.en-ru','newstest2015.USAAR-gacha.3962.en-ru', 'newstest2015.Neural-MT.4079.en-de','newstest2015.ExEx.4124.en-de'], \
        '2016':['newstest2016.uedin-nmt.4307.en-ru','newstest2016.AFRL-MITLL-verb-annot.4526.en-ru','newstest2016.uedin-nmt.4312.en-de','newstest2016.jhu-syntax.4528.en-de'], \
        '2017':['newstest2017.uedin-nmt.4756.en-ru','newstest2017.PROMT-Rule-based.4736.en-ru','newstest2017.uedin-nmt.4722.en-de','newstest2017.PROMT-Rule-based.4735.en-de'], \
        '2018':['newstest2018.Microsoft-Marian.5691.en-de','newstest2018.RWTH-UNSUPER.5484.en-de','newstest2018.Alibaba-ensemble-model.5713.en-ru','newstest2018.PROMT-Hybrid-OpenNMT.5654.en-ru'], \
        '2019':['newstest2019.MSRA.MADL.6926.en-de','newstest2019.TartuNLP-c.6508.en-de','newstest2019.Facebook_FAIR.6724.en-ru','newstest2019.NICT.6563.en-ru'], \
        }

if not os.path.exists(ODIR):
    os.makedirs(ODIR)

for year in YEARS:
    cur_dir = SYSTEMS + '/' + year
    dirs = [d for d in os.listdir(cur_dir) if not isfile(join(cur_dir, d))]
    for lp in dirs:
        src, tgt = LPs[lp]
        # print("{} -- {} ({},{})".format(year, lp, src, tgt))
        lp_dir = cur_dir + '/' + lp
        system_list = [d for d in os.listdir(lp_dir) if not isfile(join(lp_dir, d))]
        with codecs.open(ODIR + '/' + year + '.' + lp + '.filelist-systems.' + tgt, 'w', encoding='utf-8') as fs, \
                codecs.open(ODIR + '/' + year + '.' + lp + '.filelist-alignref.' + tgt, 'w', encoding='utf-8') as fn, \
                codecs.open(ODIR + '/' + year + '.' + lp + '.filelist-systems-filtered.' + tgt, 'w', encoding='utf-8') as fsf, \
                codecs.open(ODIR + '/' + year + '.' + lp + '.filelist-alignref-filtered.' + tgt, 'w', encoding='utf-8') as fnf:
                    for system_name in system_list:
                        if system_name in FILTERED_SYS[year]:
                            filtered = True
                        else:
                            filtered = False
                        # print("processing {} ...".format(system_name))
                        sys_dir = lp_dir + '/' + system_name
                        doc_list = [f for f in os.listdir(sys_dir) if isfile(join(sys_dir, f)) and not f.endswith(".bleu")]
                        for doc in doc_list:
                            doc_name,_ = doc.split('.' + system_name + '.')
                            ref_doc = NEWTESTS + year + '/' + lp + '/' + doc_name + '.' + tgt
                            # print(ref_doc, sys_dir + '/' + doc)
                            fs.write(sys_dir + '/' + doc + '\n')
                            fn.write(ref_doc + '\n')
                            # fs.write(sys_dir[3:] + '/' + doc + '\n') # the [3:] is used to remove the '../' at the begining of the pathname 
                            # fn.write(ref_doc[3:] + '\n')
                            if filtered:
                                fsf.write(sys_dir + '/' + doc + '\n')
                                fnf.write(ref_doc + '\n')
