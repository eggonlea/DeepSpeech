LOOP=2
ITER1=4
ITER2=8
for i in $(seq 0 $LOOP)
do
	echo "=== $i ==="
	./bin/train_auglbs.sh $ITER1
	echo "=== $i ==="
	./bin/train_augcv2.sh $ITER1
	echo "=== $i ==="
	./bin/train_augdogfood.sh $ITER2
	echo "=== $i ==="
	./bin/train_aug10xmdf.sh $ITER2
	echo "=== $i ==="
	./bin/export.sh
done
echo "=== $i ==="
./bin/export.sh
