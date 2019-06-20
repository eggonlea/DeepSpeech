for i in 1 $(seq 20 20 1000);
do
	echo "Beam Width $i"
	python ./evaluate_tflite.py --model ~/ds/models/output_graph.tflite --alphabet ~/download/models/alphabet.txt --lm ~/download/models/lm.binary --trie ~/download/models/trie --csv /srv/corpus/librivox/100.csv --beam_width $i
done
