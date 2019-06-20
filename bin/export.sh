set -x

N_HIDDEN=2048

time python -u ./DeepSpeech.py --checkpoint_dir ~/ds/checkpoint --n_hidden ${N_HIDDEN} --export_dir ~/ds/models
time python -u ./DeepSpeech.py --checkpoint_dir ~/ds/checkpoint --n_hidden ${N_HIDDEN} --export_dir ~/ds/models --export_tflite --nouse_seq_length 

pushd ~/ds/models
time ~/download/models/convert_graphdef_memmapped_format --in_graph=output_graph.pb --out_graph=output_graph.pbmm
popd

