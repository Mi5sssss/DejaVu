
file=./c4_train/c4_train.jsonl
    
echo "start running ${file}"

ARGS="--model-name /home/xier2/model/pretrained_models/opt-1_3b \
--model-type opt-save \
--seed 42 \
--fp16 \
--num-layers 12 \
--max-layers 24 \
--budget 11400 \
--num-iters 1000 \
--dist-url tcp://127.0.0.1:9032 \
--token-micro-batch-size 1 \
--world-size 4 --pipeline-group-size 4 --data-group-size 1 \
--pp-mode pipe_sync_sample_mask_token_pipe \
--infer-data ${file}"

(trap 'kill 0' SIGINT; \
python dist_inference_runner.py $(echo ${ARGS}) --cuda-id 0 --rank 0 \
    &
python dist_inference_runner.py $(echo ${ARGS}) --cuda-id 1 --rank 1 \
    &
python dist_inference_runner.py $(echo ${ARGS}) --cuda-id 2 --rank 2 \
    &
python dist_inference_runner.py $(echo ${ARGS}) --cuda-id 3 --rank 3 \
    &
# python dist_inference_runner.py $(echo ${ARGS}) --cuda-id 4 --rank 4 \
#     &
# python dist_inference_runner.py $(echo ${ARGS}) --cuda-id 5 --rank 5 \
#     &
# python dist_inference_runner.py $(echo ${ARGS}) --cuda-id 6 --rank 6 \
#     &
# python dist_inference_runner.py $(echo ${ARGS}) --cuda-id 7 --rank 7 \
#     & \
wait)

