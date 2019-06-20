FILES=`find $1 -name "*.wav"`
TOTAL=`echo $FILES | wc -w`
i=0
for FILE in $FILES
do
  i=$(( $i + 1 ))
	echo "Processing $FILE $i/$TOTAL"
	BASE=${FILE##*/}
	WAV=${BASE%.wav}
	TXT=`deepspeech --model ./output_graph.tflite --alphabet ./alphabet.txt --lm ./lm.binary --trie ./trie --audio $FILE 2> /dev/null`
	echo "$WAV $TXT" | tee -a deepspeech.out
done
