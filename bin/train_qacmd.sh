set -x

EPOCH=${1:-1}

N_HIDDEN=2048

TRAIN_FILES=\
/srv/corpus/qa_cmd/all.csv

DEV_FILES=\
/srv/corpus/qa_cmd/all.csv

TEST_FILES=\
/srv/corpus/qa_cmd/all.csv

time python -u ./DeepSpeech.py \
	--checkpoint_dir ~/ds/checkpoint/ \
	--feature_cache ~/ds/cache/ \
	--summary_dir ~/ds/summary/ \
	--train_files ${TRAIN_FILES} \
	--dev_files ${DEV_FILES} \
	--test_files ${TEST_FILES} \
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

