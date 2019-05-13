#! /usr/bin/env python
# -*- coding: utf-8 -*-

# score-bleu.py
#
# Copyright (C) 2018 Frederic Blain (feedoo) <f.blain@sheffield.ac.uk>
#
# Licensed under the "THE BEER-WARE LICENSE" (Revision 42):
# Fred (feedoo) Blain wrote this file. As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a tomato juice or coffee in return
#

"""
This script is used to score each sentence, for each document (or systems' output), with BLEU.
"""

import codecs
import glob
from nltk import word_tokenize
from nltk.corpus import stopwords
from nltk.translate import bleu_score
import os, sys
from gensim.models import TfidfModel
from gensim import corpora
from polyglot.text import Text


# YEARS = ['2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017','2018']#, '2019']
YEARS = ['2011', '2012', '2013', '2014', '2015', '2016', '2017','2018']#, '2019']
# LPs = {'german-english':['de','en'], 'english-russian':['en','ru'], 'english-french':['en','fr'], 'english-spanish':['en','es']}
LPs = {'english-german':['en','de'], 'english-russian':['en','ru']}

ODIR = '../filelists-and-doc-scores'

class TransUnit(object):

    def __init__(self, name, language):
        self._mt_sents = []
        self._ref_sents = []
        self._language = language

    def add(self, mt, ref):
        self._mt_sents.append(tok(mt, self._language))
        self._ref_sents.append(tok(ref, self._language))

    def mt_sents(self):
        return self._mt_sents

    def ref_sents(self):
        return self._ref_sents


def tok(sentence, language):
    if language == 'russian':
        tok = Text(sentence)
        return tok.words
    else:
        return word_tokenize(sentence, language)

def calc_tfidf(mt_doc, ref_doc, language):
    ref_txt = [[w.lower() for w in s if w not in stopwords.words(language)] for s in ref_doc]
    ref_dictionary = corpora.Dictionary(ref_txt)
    ref_txt2bow = [ref_dictionary.doc2bow(t) for t in ref_txt]
    tfidf = TfidfModel(ref_txt2bow)

    mt_txt = [[w.lower() for w in s if w not in stopwords.words(language)] for s in mt_doc]
    mt_dictionary = corpora.Dictionary(mt_txt)
    mt_txt2bow = [mt_dictionary.doc2bow(t) for t in mt_txt]

    return [sum([s for _,s in tfidf[t]]) for t in mt_txt2bow]

for lp in LPs:
    src, tgt = LPs[lp]
    _, language = lp.split('-')
    for year in YEARS:
        print("processing {}...".format(year))
        for f in glob.glob(ODIR + '/{}*filelist-systems.'.format(year) + tgt):
            system = f
            newstest = f.replace('systems','alignref')
            # we read the lines with the name of the document (aligned at line-level, from align-docs.py
            with codecs.open(system, 'r', encoding='utf-8') as fmt, codecs.open(newstest, 'r', encoding='utf-8') as fref:
                for lmt, lref in zip(fmt, fref):
                    name_mt = lmt.rstrip()
                    name_ref = lref.rstrip()
                    tu = TransUnit(os.path.basename(name_mt), language)
                    print(name_mt)
                    # we open the file containing the actual translations/references, in order to score the pairs
                    with codecs.open(name_mt, 'r', encoding='utf-8') as fdmt, \
                        codecs.open(name_ref, 'r', encoding='utf-8') as fdref:
                        for mt, ref in zip(fdmt, fdref):
                            tu.add(mt.rstrip().replace('\x93','"').replace('\x94','"'), ref.rstrip())  # some files have encoding issues (e.g. de-en.newstest2008.cmu-statxfer.xml (line 2183)

                    with codecs.open(name_mt+'.all-bleu-scores', 'w', encoding='utf-8') as fallbleu, codecs.open(name_mt+'.bleu', 'w', encoding='utf-8') as fbleu:
                        doc_bleu = round(bleu_score.corpus_bleu(tu.ref_sents(), tu.mt_sents(), smoothing_function=bleu_score.SmoothingFunction().method7), 4)
                        s_scores = []
                        for mt, ref in zip(tu.mt_sents(), tu.ref_sents()):
                            try:
                                s_score = round(bleu_score.sentence_bleu([ref], mt, smoothing_function=bleu_score.SmoothingFunction().method7), 4)
                                #we normalise to 1
                                if s_score > 1:
                                    s_score = 1.0
                                s_scores.append(s_score)
                            except Exception as e:
                                print("exception raised: {}, giving a score of 0.00".format(e))
                                print("ref: ", ref, " || mt: ", mt)
                                s_scores.append(0.0)
                                # sys.exit(-1)

                        refs_len = [len(r) for r in tu.ref_sents()]
                        doc_avg_bleu = round(sum([r_len * b for r_len, b in zip(refs_len, s_scores)]) / sum(refs_len), 4)
                        tfidf = calc_tfidf(tu.mt_sents(), tu.ref_sents(), language)
                        tfidf_bleu = round(sum([tfidf_s * b for tfidf_s, b in zip(tfidf, s_scores)]) / sum(refs_len), 4)
                        for s_score in s_scores:
                            # print(mt, ref, s_score, doc_avg_bleu, doc_bleu, tfidf_bleu)
                            print(s_score, doc_avg_bleu, doc_bleu, tfidf_bleu)
                            fbleu.write('{}\n'.format(s_score))
                            fallbleu.write('{}\t{}\t{}\t{}\n'.format(s_score, doc_avg_bleu, doc_bleu, tfidf_bleu))
