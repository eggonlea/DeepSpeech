set -x

EPOCH=${1:-1}

TRAIN_FILES=\
/srv/corpus/librivox/librivox-train-clean-100.csv,\
/srv/corpus/librivox/librivox-train-clean-360.csv,\
/srv/corpus/librivox/librivox-train-other-500.csv

DEV_FILES=\
/srv/corpus/librivox/librivox-dev-clean.csv

TEST_FILES=\
/srv/corpus/librivox/librivox-test-clean.csv

TRAIN_CACHE=\
~/ds/cache/librivox_train.hdf5

DEV_CACHE=\
~/ds/cache/librivox_dev.hdf5

TEST_CACHE=\
~/ds/cache/librivox_test.hdf5

time ./DeepSpeech.py \
	--checkpoint_dir ~/ds/checkpoint \
	--summary_dir ~/ds/summary \
	--train_files ${TRAIN_FILES} \
	--dev_files ${DEV_FILES} \
	--test_files ${TEST_FILES} \
	--train_cached_features_path ${TRAIN_CACHE} \
	--dev_cached_features_path ${DEV_CACHE} \
	--test_cached_features_path ${TEST_CACHE} \
	--epoch -${EPOCH} \
	--n_hidden 2048 \
	--learning_rate 0.0001 \
	--dropout_rate 0.2 \
	--train_batch_size 24 \
	--dev_batch_size 48 \
	--test_batch-size 48 \
	--display_step 0\
	--validation_step 1 \
	--log_level 1 \
	--summary_secs 60

time ./DeepSpeech.py --checkpoint_dir ~/ds/checkpoint --notrain --notest --export_dir ~/ds/model
time ./DeepSpeech.py --checkpoint_dir ~/ds/checkpoint --export_tflite --notrain --notest --export_dir ~/ds/model

#/srv/corpus/cv1/cv-valid-train.csv,\
#/srv/corpus/cv1/cv-other-train.csv,\
#/srv/corpus/cv2/train.csv,\
#/srv/corpus/cv2/other.csv,\
#/srv/corpus/cv2/validated.csv,\
#/srv/corpus/ted3/ted-train.csv \
