set -x

# 3-gram pruned
time ./bin/lmplz \
	-T ./tmp/ \
	-o 3 \
	--prune 0 1 \
	--text normalized.txt \
	--arpa 3_pruned.arpa

time ./bin/build_binary \
	-T ./tmp/ \
	3_pruned.arpa \
	3_pruned.binary

time ./bin/build_binary \
	-T ./tmp/ \
	-a 255 \
	-q 8 \
	trie \
	3_pruned.arpa \
	3_pruned_quantized.binary

# 3-gram all
time ./bin/lmplz \
	-T ./tmp/ \
	-o 3 \
	--text normalized.txt \
	--arpa 3_all.arpa

time ./bin/build_binary \
	-T ./tmp/ \
	3_all.arpa \
	3_all.binary

time ./bin/build_binary \
	-T ./tmp/ \
	-a 255 \
	-q 8 \
	trie \
	3_all.arpa \
	3_all_quantized.binary

# 5-gram pruned
time ./bin/lmplz \
	-T ./tmp/ \
	-o 5 \
	--prune 0 1 \
	--text normalized.txt \
	--arpa 5_pruned.arpa

time ./bin/build_binary \
	-T ./tmp/ \
	5_pruned.arpa \
	5_pruned.binary

time ./bin/build_binary \
	-T ./tmp/ \
	-a 255 \
	-q 8 \
	trie \
	5_pruned.arpa \
	5_pruned_quantized.binary

# 5-gram all
time ./bin/lmplz \
	-T ./tmp/ \
	-o 5 \
	--text normalized.txt \
	--arpa 5_all.arpa

time ./bin/build_binary \
	-T ./tmp/ \
	5_all.arpa \
	5_all.binary

time ./bin/build_binary \
	-T ./tmp/ \
	-a 255 \
	-q 8 \
	trie \
	5_all.arpa \
	5_all_quantized.binary
