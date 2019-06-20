set -x

EPOCH=${1:-1}

N_HIDDEN=2048

TRAIN_FILES=\
/srv/corpus/aug_10xmdf/aug_10xmdf.csv

DEV_FILES=\
/srv/corpus/aug_10xqacmd/aug_10xqacmd.csv

TEST_FILES=\
/srv/corpus/qacmd/all.csv

CACHE_PATH=\
~/ds/cache.aug_10xmdf/

time python -u ./DeepSpeech.py \
	--checkpoint_dir ~/ds/checkpoint \
	--summary_dir ~/ds/summary \
	--train_files ${TRAIN_FILES} \
	--dev_files ${DEV_FILES} \
	--test_files ${TEST_FILES} \
	--feature_cache ${CACHE_PATH} \
	--epochs ${EPOCH} \
	--n_hidden ${N_HIDDEN} \
	--learning_rate 0.000001 \
	--dropout_rate 0.2 \
	--train_batch_size 24 \
	--dev_batch_size 48 \
	--test_batch-size 48 \
	--display_step 0\
	--validation_step 1 \
	--log_level 1 \
	--summary_secs 60

#	--noearly_stop
