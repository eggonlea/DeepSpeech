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
import pandas


COLUMNNAMES = ['wav_filename', 'wav_filesize', 'transcript']

def preprocess_data(target_dir):
    # Folder structure:
    # - target_dir/
    #   - *.wav
    #   - *.txt

    # Transcripts file has one line per WAV file, where each line consists of
    # the WAV file name without extension followed by a single space followed
    # by the transcript.

    # Since the transcripts themselves can contain spaces, we split on space but
    # only once, then build a mapping from file name to transcript
    transcripts = {}
    for txt in glob.glob(os.path.join(target_dir, '*.txt')):
        with open(txt) as fin:
            cur = dict((line.split(' ', maxsplit=1) for line in fin))
            transcripts.update(cur)

    def regulate(txt):
        txt = txt.strip('\n').lower()
        ret = ''
        words = txt.split()
        for idx, word in enumerate(words):
            try:
                words[idx] = num2words(word)
            except:
                pass

        return ' '.join(words)

    def load_set(glob_path):
        set_files = []
        for wav in glob.glob(glob_path):
            try:
                wav_filename = wav
                wav_filesize = os.path.getsize(wav)
                transcript_key = os.path.splitext(os.path.basename(wav))[0]
                transcript = regulate(transcripts[transcript_key])
                set_files.append((wav_filename, wav_filesize, transcript))
            except KeyError:
                print('Warning: Missing transcript for WAV file {}.'.format(wav))
        return set_files

    print('Loading samples...')
    files = load_set(os.path.join(target_dir, '*.wav'))
    df = pandas.DataFrame(data=files, columns=COLUMNNAMES)

    # Trim train set to under 10s by removing the last couple hundred samples
    durations = (df['wav_filesize'] - 44) / 16000 / 2
    df = df[durations <= 10.0]
    print('Trimming {} samples > 10 seconds'.format((durations > 10.0).sum()))

    csv = os.path.join(target_dir, 'all.csv')
    print('Saving set of {} into {}...'.format(len(df), csv))
    df.to_csv(csv, index=False)

def main():
    parser = argparse.ArgumentParser(description='Import any wav corpus')
    parser.add_argument('--target_dir', help='Folder containing wav files and transcription txt files.')
    params = parser.parse_args()

    if not params.target_dir:
        print('Target dir must be specified')
        exit(1)

    preprocess_data(params.target_dir)


if __name__ == "__main__":
    main()
