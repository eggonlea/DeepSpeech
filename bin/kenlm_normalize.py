import argparse
import json
import re

def parse_opts():
    parser = argparse.ArgumentParser(
        description='Dump raw text from JSON',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('in_jason', type=str, help='Input JSON')
    parser.add_argument('out_text', type=str, help='Output raw texts')
    opts = parser.parse_args()
    return opts

def preprocess(text):
    text = text.lower();
    words = ['- ', ' -', ' - ']
    for word in words:
        text = text.replace(word, '\n')
    return text

def split(text):
    return re.split('[:,;.!?\n]+', text)

def normalize(text):
    text = text.lower();
    words = ['__unk__', '__url__', '__phone__', '- ', ' -', ' - ']
    for word in words:
        text = text.replace(word, '')
    return ' '.join(text.split())

if __name__ == '__main__':
    opts = parse_opts()
    fields = ['subject', 'message', 'response']
    with open(opts.in_jason) as in_jason, \
         open(opts.out_text, 'w') as out_text:
        for line in in_jason:
            data = json.loads(line)
            for i in fields:
                texts = split(preprocess(data[i]))
                for text in texts:
                    text = normalize(text)
                    if text: # ' ' in text:
                        out_text.write(text + '\n')
