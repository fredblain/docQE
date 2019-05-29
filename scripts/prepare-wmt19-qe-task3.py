#! /usr/bin/env python
# -*- coding: utf-8 -*-
#
# prepare-wmt19-qe-task3.py
#
# Copyright (C) 2019 Frederic Blain (feedoo) <f.blain@sheffield.ac.uk>
#
# Licensed under the "THE BEER-WARE LICENSE" (Revision 42):
# Fred (feedoo) Blain wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a tomato juice or coffee in return
#

"""
This script prepares the data to be used for TL for the QE shared task 3
('QE as a metric')
This requires the DA data from 2018 to be first downloaded and extracted under /tmp
- link: http://ufallab.ms.mff.cuni.cz/~bojar/wmt18-metrics-task-package.tgz
"""

import sys, csv, os
import codecs
from collections import defaultdict
import glob

lang_src = 'eng'
SDIR = '/home/fblain/workspace/data/docQE/newstests/newstest2018/'
DDIR = '/home/fblain/workspace/data/docQE/systems/2018/'

lang_tgt = 'deu' ## german
DDIR = DDIR + '/english-german/'
SRC = SDIR + '/newstest2018-ende-src.en.txt'
REF = SDIR + '/newstest2018-ende-ref.de.txt'

# lang_tgt = 'rus' ## russian
# DDIR = DDIR + '/english-russian/'
# SRC = SDIR + '/newstest2018-enru-src.en.txt'
# REF = SDIR + '/newstest2018-enru-ref.ru.txt'

## loading source sentences
src_sents = []
with codecs.open(SRC, 'r', encoding='utf-8') as fh:
    for src in fh:
        # print("{}\t{}".format(file_name, translation.rstrip()))
        src_sents.append(src.rstrip())

## loading reference translations 
ref_translations = []
with codecs.open(REF, 'r', encoding='utf-8') as fh:
    for reftranslation in fh:
        # print("{}\t{}".format(file_name, translation.rstrip()))
        ref_translations.append(reftranslation.rstrip())

## loading the systems' outputs
sys_outputs = defaultdict(list)
for sys_o in glob.glob(DDIR + "/*.txt"):
    file_name = os.path.basename(sys_o)
    with codecs.open(sys_o, 'r', encoding='utf-8') as fh:
        for translation in fh:
            # print("{}\t{}".format(file_name, translation.rstrip()))
            sys_outputs[file_name].append(translation.rstrip())

da_seg = defaultdict(list)
with codecs.open("/tmp/wmt18-metrics-task-package/manual-evaluation/WMT18ResearchersData-20180814/AllRefDA.csv", 'r', encoding='utf-16') as fDA, \
        codecs.open("/tmp/wmt18_DA.{}-{}.src".format(lang_src[:2], lang_tgt[:2]), 'w', encoding='utf-8') as fsrc, \
        codecs.open("/tmp/wmt18_DA.{}-{}.ref".format(lang_src[:2], lang_tgt[:2]), 'w', encoding='utf-8') as fref, \
        codecs.open("/tmp/wmt18_DA.{}-{}.mt".format(lang_src[:2], lang_tgt[:2]), 'w', encoding='utf-8') as fmt, \
        codecs.open("/tmp/wmt18_DA.{}-{}.score".format(lang_src[:2], lang_tgt[:2]), 'w', encoding='utf-8') as fscore:

            csv_reader = csv.reader(fDA, delimiter=',')
            next(csv_reader) ## skippinng header

            for row in csv_reader:
                if row[3] == 'TGT':  ## we skip 'BAD' and 'REF'
                    if row[4] == lang_src and row[5] == lang_tgt:
                        sys_id = row[1]
                        seg_id = row[2]
                        da_score = row[6]
                        # if sys_id in da_seg:
                        #     da_seg[sys_id].append("{}@@{}".format(seg_id, da_score))
                        # else:
                        #     da_seg[sys_id]
                        da_seg[sys_id].append("{}@@{}".format(seg_id, da_score))

            for sys_id in da_seg:
                for seg in da_seg[sys_id]:
                    translation_id, score = seg.split('@@')
                    fsrc.write("{}\n".format(src_sents[int(translation_id) - 1]))
                    fref.write("{}\n".format(ref_translations[int(translation_id) - 1]))
                    fmt.write("{}\n".format(sys_outputs[sys_id][int(translation_id) - 1]))
                    fscore.write("{:.4}\n".format(int(score)/100))
