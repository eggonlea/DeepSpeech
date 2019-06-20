for ALPHA in $(seq 0.25 0.1 2.0); do
for BETA in $(seq 0.55 0.1 5.0); do
	echo "Alpha=$ALPHA Beta=$BETA"
	python ./evaluate_tflite.py --model ~/ds/models/output_graph.tflite --alphabet ~/download/models/alphabet.txt --lm ~/download/models/lm.binary --trie ~/download/models/trie --csv /srv/corpus/qa_cmd/all.csv --lm_alpha $ALPHA --lm_beta $BETA
done
done
