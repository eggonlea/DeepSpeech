#!/usr/bin/env python
from __future__ import absolute_import, division, print_function
from num2words import num2words

# Make sure we can import stuff from util/
# This script needs to be run from the root of the DeepSpeech repository
import os
import sys
sys.path.insert(1, os.path.join(sys.path[0], '..'))

import argparse
import glob
import numpy as np
import pandas as pd
import re
import string

COLUMNNAMES = ['wav_filename', 'wav_filesize', 'transcript']

def preprocess_data(params):
    # Folder structure:
    # - target_dir/
    #   - *.wav
    #   - *.txt

    # Transcripts file has one line per WAV file, where each line consists of
    # the WAV file name without extension followed by a single space followed
    # by the transcript.

    # Since the transcripts themselves can contain spaces, we split on space but
    # only once, then build a mapping from file name to transcript
    target_dir = params.target_dir
    verbose = params.verbose
    transcripts = {}
    for txt in glob.glob(os.path.join(target_dir, '**/*.txt'), recursive=True):
        print('Importing %s' % txt)
        with open(txt) as fin:
            cur = dict((line.split(' ', maxsplit=1) for line in fin))
            transcripts.update(cur)

    def regulate(txt):
        # remove punctuations
        txt = re.sub("[^a-z0-9' ]+", ' ', txt.lower())

        # num2words
        words = list(filter(None, re.split('(\d+)| ', txt)))
        for idx, word in enumerate(words):
            try:
                words[idx] = num2words(word)
            except:
                pass
        txt = ' '.join(words)

        # remove punctuations
        ret = re.sub("[^a-z0-9' ]+", ' ', txt)

        return ret.strip()

    def load_set(target_dir):
        empty = 0
        missing = 0
        set_files = []
        empties = []
        wavs = glob.glob(os.path.join(target_dir, '**/*.wav'), recursive=True)
        for wav in wavs:
            try:
                wav_filename = wav
                wav_filesize = os.path.getsize(wav)
                transcript_key = os.path.splitext(os.path.relpath(wav, target_dir))[0]
                transcript = regulate(transcripts[transcript_key])
                if len(transcript) == 0:
                    empty += 1
                    empties.append((wav_filename, wav_filesize, ''))
                    if verbose:
                        print('#{}: Ignore empty transcript for WAV file {}.'.format(empty, wav))
                else:
                    set_files.append((wav_filename, wav_filesize, transcript))
            except KeyError:
                missing += 1
                empties.append((wav_filename, wav_filesize, ''))
                if verbose:
                    print('#{}: Missing transcript for WAV file {}.'.format(missing, wav))
        print('Ignored totally %d empty transcripts' % empty)
        print('Ignored totally %d missing transcripts' % missing)
        return set_files, empties

    print('Loading samples...')
    files, empties = load_set(target_dir)
    df = pd.DataFrame(data=files, columns=COLUMNNAMES)

    # Trim train set to under 10s by removing the last couple hundred samples
    durations = (df['wav_filesize'] - 44) / 16000 / 2
    df = df[durations <= 10.0]
    print('Trimming {} samples > 10 seconds'.format((durations > 10.0).sum()))

    np.random.seed(13579)
    train, dev, test = np.split(df.sample(frac=1), [int(.8*len(df)), int(.9*len(df))])

    print('Saving set of {} into all.csv'.format(len(df)))
    df.to_csv(os.path.join(target_dir, 'all.csv'), index=False)

    print('Saving set of {} into train.csv'.format(len(train)))
    train.to_csv(os.path.join(target_dir, 'train.csv'), index=False)

    print('Saving set of {} into dev.csv'.format(len(dev)))
    dev.to_csv(os.path.join(target_dir, 'dev.csv'), index=False)

    print('Saving set of {} into test.csv'.format(len(test)))
    test.to_csv(os.path.join(target_dir, 'test.csv'), index=False)

    empty = pd.DataFrame(data=empties, columns=COLUMNNAMES)
    print('Saving set of {} into empty.csv'.format(len(empty)))
    empty.to_csv(os.path.join(target_dir, 'empty.csv'), index=False)

def main():
    parser = argparse.ArgumentParser(description='Import any wav corpus')
    parser.add_argument('--target_dir', help='Folder containing wav files and transcription txt files.')
    parser.add_argument('--verbose', action='store_true', default=False, help='Print verbose messages')
    params = parser.parse_args()

    if not params.target_dir:
        print('Target dir must be specified')
        exit(1)

    preprocess_data(params)


if __name__ == "__main__":
    main()
