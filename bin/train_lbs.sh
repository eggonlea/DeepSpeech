set -x

EPOCH=${1:-1}

N_HIDDEN=2048

TRAIN_FILES=\
/srv/corpus/librivox/librivox-train-clean-100.csv,\
/srv/corpus/librivox/librivox-train-clean-360.csv,\
/srv/corpus/librivox/librivox-train-other-500.csv

#/srv/corpus/cv1/cv-valid-train.csv,\
#/srv/corpus/cv1/cv-other-train.csv,\
#/srv/corpus/cv2/train.csv,\
#/srv/corpus/cv2/other.csv,\
#/srv/corpus/cv2/validated.csv,\
#/srv/corpus/ted3/ted-train.csv

DEV_FILES=\
/srv/corpus/librivox/librivox-dev-clean.csv

TEST_FILES=\
/srv/corpus/librivox/librivox-test-clean.csv

CACHE_PATH=\
~/ds/cache.lbs/

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

