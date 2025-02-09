#!/bin/sh

# python
#mypython3='/local/lgai/anaconda3/bin/python3.7'

# use cosine similarity as objective function 
word_mode='PretrainedGO'

# use pretrained BERT label embedding, plus additional training
echo 'running pretrained with 300 native dim'


def_emb_dim='300' # input dimension to GCN (NOT (?) including any portion of embedding to be trained)
#pre_def_emb_dim=$def_emb_dim #'300' # how many dims are pretrained - used for file name, not arg # TODO
gcn_native_emb_dim='300' # how many dims to be trained
metric_option='cosine'
nonlinear_gcnn='relu'

server='/local/lgai'
data_where_train_is='goAndGeneAnnotationDec2018' ## where the train.csv is 
which_data='goAndGeneAnnotationMar2017' ## where the go.obo is 
work_dir=$server/$which_data

#w2v_emb=$work_dir'/BERT_base_cased_tune_go_branch/fine_tune_lm_bioBERT/cosine.768.reduce300ClsVec/label_vector.txt'
w2v_emb=$work_dir'/word_pubmed_intersect_GOdb_w2v_pretrained.pickle'

bert_model=$work_dir/'BERT_base_cased_tune_go_branch/fine_tune_lm_bioBERT' # use the full mask + nextSentence to innit
data_dir=$server/$data_where_train_is/'entailment_data/AicScore/go_bert_cls'
pregenerated_data=$server/$data_where_train_is/'BERT_base_cased_tune_go_branch' # use the data of full mask + nextSentence to innit
bert_output_dir=$pregenerated_data/'fine_tune_lm_bioBERT'

vocab_list='word_pubmed_intersect_GOdb.txt' # all vocab to be used, can be BERT or something, so we don't hardcode 

mkdir $work_dir/'GCN'

# make results dir, e.g. cosine_pre300_aux300 #_epoch10
result_folder=$work_dir/'GCN/'$metric_option'_pre'$pre_def_emb_dim'_native'$gcn_native_emb_dim #'_epoch'$n_epoch #$def_emb_dim.'clsVec'
mkdir $result_folder

# model_load=$result_folder/'best_state_dict.pytorch'

source activate tensorflow_gpuenv

# conda activate tensorflow_gpuenv

cd $server/EncodeGeneOntology

CUDA_VISIBLE_DEVICES=1 /local/lgai/anaconda3/bin/python3.7 $server/EncodeGeneOntology/GCN/encoder/do_model.py \
--vocab_list $vocab_list  --main_dir $work_dir --qnli_dir $data_dir   \
--lr 0.001 --epoch 200 --use_cuda --metric_option $metric_option \
--batch_size_label_desc 128 --batch_size_label 20 --batch_size_bert 8 \
--bert_model $bert_model --pregenerated_data $pregenerated_data       \
--bert_output_dir $bert_output_dir                                    \
--result_folder $result_folder                                        \
--nonlinear_gcnn $nonlinear_gcnn                                      \
--w2v_emb $w2v_emb   --fix_word_emb                                   \
--def_emb_dim $def_emb_dim                                            \
--gcn_native_emb_dim $gcn_native_emb_dim                                   \
--word_mode $word_mode > $result_folder/train.log
#--pre_def_emb_dim $pre_def_emb_dim  # currently not option

echo 'done'
date




# currently do_model only has pretrainedGO flag, which expects native dim
# TOTO how to run GCN using BERT for initialization
echo 'running pretrained with 100 additional native dim'
word_mode='PretrainedGO'


def_emb_dim='300' # input dimension to GCN (NOT (?) including any portion of embedding to be trained)
#pre_def_emb_dim='300' # how many dims are pretrained - used for file name, not arg TODO potentially same as def_emb_dim now
gcn_native_emb_dim='100'
metric_option='cosine'
nonlinear_gcnn='relu'

server='/local/lgai'
data_where_train_is='goAndGeneAnnotationDec2018' ## where the train.csv is 
which_data='goAndGeneAnnotationMar2017' ## where the go.obo is 
work_dir=$server/$which_data
bert_model=$work_dir/'BERT_base_cased_tune_go_branch/fine_tune_lm_bioBERT' # use the full mask + nextSentence to innit
data_dir=$server/$data_where_train_is/'entailment_data/AicScore/go_bert_cls'
pregenerated_data=$server/$data_where_train_is/'BERT_base_cased_tune_go_branch' # use the data of full mask + nextSentence to innit
bert_output_dir=$pregenerated_data/'fine_tune_lm_bioBERT'


# use pretrained BERT label embedding
#w2v_emb=$work_dir'/BERT_base_cased_tune_go_branch/fine_tune_lm_bioBERT/cosine.768.reduce300ClsVec/label_vector.txt'
w2v_emb=$work_dir'/word_pubmed_intersect_GOdb_w2v_pretrained.pickle'


vocab_list='word_pubmed_intersect_GOdb.txt' # all vocab to be used, can be BERT or something, so we don't hardcode 

mkdir $work_dir/'GCN'

result_folder=$work_dir/'GCN/'$metric_option'_pre'$def_emb_dim'_native'$gcn_native_emb_dim #'_epoch'$n_epoch #$def_emb_dim.'clsVec'
mkdir $result_folder

# model_load=$result_folder/'best_state_dict.pytorch'

source activate tensorflow_gpuenv

# conda activate tensorflow_gpuenv

cd $server/EncodeGeneOntology

CUDA_VISIBLE_DEVICES=1 /local/lgai/anaconda3/bin/python3.7 $server/EncodeGeneOntology/GCN/encoder/do_model.py \
--vocab_list $vocab_list  --main_dir $work_dir --qnli_dir $data_dir   \
--lr 0.001 --epoch 200 --use_cuda --metric_option $metric_option \
--batch_size_label_desc 128 --batch_size_label 20 --batch_size_bert 8 \
--bert_model $bert_model --pregenerated_data $pregenerated_data       \
--bert_output_dir $bert_output_dir                                    \
--result_folder $result_folder                                        \
--nonlinear_gcnn $nonlinear_gcnn                                      \
--w2v_emb $w2v_emb   --fix_word_emb                                   \
--def_emb_dim $def_emb_dim                                            \
--gcn_native_emb_dim $gcn_native_emb_dim                             \
--word_mode $word_mode > $result_folder/train.log
#--pre_def_emb_dim $pre_def_emb_dim  # currently not option

echo 'done'
date



