# Resources for sentence- and document-level Quality Estimation

This repository contains the resources used for our [COLING'18 paper][1], and released as part of our [framework for neural-based Quality Estimation (DeepQuest)][2].
If you use this data, please cite:

<b>DeepQuest: a framework for neural-based Quality Estimation</b>. [Julia Ive][3], [Frédéric Blain][4], [Lucia Specia][5] (2018).

    @article{ive2018deepquest,
      title={DeepQuest: a framework for neural-based Quality Estimation},
      author={Julia Ive and Frédéric Blain and Lucia Specia},
      journal={In the Proceedings of COLING 2018, the 27th International Conference on Computational Linguistics, Sante Fe, New Mexico, USA},
      year={2018}
    }

[1]: https://fredblain.org/pages/research.html
[2]: https://sheffieldnlp.github.io/deepQuest/
[3]: https://github.com/julia-ive
[4]: https://fredblain.org/
[5]: https://www.imperial.ac.uk/people/l.specia

#### \*\*Update May '19\*\*
Following the update adding both 2018 and 2019 datasets and submissions to the WMT MT task, I've added a script to compute and gather both TER (using TERcom) and BLEU (using NLTK) scores at sentence-level (note: scores computed against the reference, not PE!).
This results into a parallel corpus, aligned at sentence-level, with both TER and BLEU scores as quality labels.  

#### Instructions
Before running anything, check the shell scripts (under `scripts/`) to update the paths to the required third-party tools (such as TERcom, Moses' tokenizer, etc.). 
Then, to download and process the datasets along with the official submissions, simply run: `bash process_all.sh`.

By default, the scripts download and process the language pairs I needed: e.g. English<>German, English-French and English-Russian, from WMT'2008 to 2019. 
Feel free to update `get_newstests.sh` and `get_systems.sh` according to your needs.
The way to modify the scripts should be straightforward. 
If not, feel free to ask for help by opening an issue (so others in similar situation can benefit from the discussion).
