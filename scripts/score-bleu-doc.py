#! /usr/bin/env python
# -*- coding: utf-8 -*-
#
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
This script is used to compute each document' global (w/tf)BLEU scores, based on sentence-level evaluation (BLEU).
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
from scipy import stats
#import sys  

#reload(sys)  
#sys.setdefaultencoding('utf8')


LPs = {'german-english':['de','en'], 'english-russian':['en','ru'], 'english-french':['en','fr'], 'english-spanish':['en','es']}

ODIR = '../filelists-and-doc-scores'

class TransUnit(object):

    def __init__(self, name, language, srclanguage):
        self._src_sents = []
        self._mt_sents = []
        self._ref_sents = []
        self._language = language
        self._srclanguage = srclanguage

    def add(self, src, mt, ref):
        self._src_sents.append(tok(src, self._srclanguage))
        self._mt_sents.append(tok(mt, self._language))
        self._ref_sents.append(tok(ref, self._language))

    def src_sents(self):
        return self._src_sents

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
    lp_bleu = []
    lp_avg_bleu = []
    lp_tf_bleu = []

    # the 'filtered' flag, corresponds to worse/best systems only, for each lp, for each year (see align-docs.py)
    flag = ''
    flag='-filtered'
    for f in glob.glob(ODIR + '/*filelist-systems' + flag + '.' + tgt):
        year = f.split('/')[-1].split('.')[0]
        system = f
        newstest = f.replace('systems','alignref')

        with codecs.open(ODIR + '/' + year + '.train.'+ src + '-'+ tgt + flag +'.'+ src, 'w', encoding='utf-8') as wsrc, \
                codecs.open(ODIR + '/' + year + '.train.'+ src + '-'+ tgt + flag +'.'+ tgt, 'w', encoding='utf-8') as wmt, \
                codecs.open(ODIR + '/' + year + '.bleu.' + src + '-'+ tgt + flag + '.hter', 'w', encoding='utf-8') as wbleu, \
                codecs.open(ODIR + '/' + year + '.wbleu.' + src + '-'+ tgt + flag + '.hter', 'w', encoding='utf-8') as wwbleu, \
                codecs.open(ODIR + '/' + year + '.tfbleu.' + src + '-'+ tgt + flag + '.hter', 'w', encoding='utf-8') as wtfbleu, \
                codecs.open(system, 'r', encoding='utf-8') as fmt, codecs.open(newstest, 'r', encoding='utf-8') as fref:
                    for lmt, lref in zip(fmt, fref):
                        name_src = lref.rstrip()[:-3] + '.'+src
                        name_mt = lmt.rstrip()
                        name_ref = lref.rstrip()
                        tu = TransUnit(os.path.basename(name_mt), language, _)
                        print(name_mt)
                        try:
                            with codecs.open(name_src, 'r', encoding='utf-8') as fdsrc, \
                                    codecs.open(name_mt, 'r', encoding='utf-8') as fdmt, \
                                    codecs.open(name_ref, 'r', encoding='utf-8') as fdref:
                                    for src_line, mt, ref in zip(fdsrc, fdmt, fdref):
                                        # some files have encoding issues (e.g. de-en.newstest2008.cmu-statxfer.xml (line 2183)
                                        # tu.add(src_line.rstrip(), mt.rstrip(), ref.rstrip())
                                        tu.add(src_line.rstrip(), mt.rstrip().replace('\x93','"').replace('\x94','"'), ref.rstrip())
                                #with codecs.open(name_mt+'.bleu', 'w', encoding='utf-8') as fb:
                            doc_bleu = bleu_score.corpus_bleu(tu.ref_sents(), tu.mt_sents(), smoothing_function=bleu_score.SmoothingFunction().method0)
                            s_scores = []
                            for mt, ref in zip(tu.mt_sents(), tu.ref_sents()):
                                try:
                                    s_scores.append(bleu_score.sentence_bleu(ref, mt, smoothing_function=bleu_score.SmoothingFunction().method7))
                                except Exception as e:
                                    print("exception raised: {}, giving a score of 0.00".format(e))
                                    print("ref: ", ref, " || mt: ", mt)
                                    s_scores.append(0.0)
                                    # sys.exit(-1)

                            refs_len = [len(r) for r in tu.ref_sents()]
                            doc_avg_bleu = sum([r_len * b for r_len, b in zip(refs_len, s_scores)]) / sum(refs_len)
                            tfidf = calc_tfidf(tu.mt_sents(), tu.ref_sents(), language)
                            tfidf_bleu = sum([tfidf_s * b for tfidf_s, b in zip(tfidf, s_scores)]) / sum(refs_len)
                            #for s_score in s_scores:
                            for s_mt, s_src in zip(tu.mt_sEnts(), tu.src_sents()):
                                wmt.write(' '.join(s_mt)+'\n')
                                wsrc.write(' '.join(s_src)+'\n')
                                #fscore.write(s_score+'\n')
                                #print(mt, ref, s_score, doc_avg_bleu, doc_bleu, tfidf_bleu)
                                #print(s_score, doc_avg_bleu, doc_bleu, tfidf_bleu)
                                #fb.write('{}\t{}\t{}\t{}\n'.format(s_score, doc_avg_bleu, doc_bleu, tfidf_bleu))
                            wmt.write('#doc#\n')
                            wsrc.write('#doc#\n')
                            wbleu.write('{}\n'.format(doc_bleu))
                            lp_bleu.append(doc_bleu)
                            wwbleu.write('{}\n'.format(doc_avg_bleu))
                            lp_avg_bleu.append(doc_avg_bleu)
                            wtfbleu.write('{}\n'.format(tfidf_bleu*10))
                            lp_tf_bleu.append(tfidf_bleu)
                        except FileNotFoundError as e:
                            print(e)
                            pass
