#!/bin/bash
# Exit on error
set -e

# Create and activate conda environment (if not already created)
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate diffwave # diffwave works for wavegrad as well


# Download checkpoints
wget https://lmnt.com/assets/wavegrad/wavegrad-24kHz.pt -P checkpoints/wavegrad/

# Run inference (adjust paths as needed)
# python3 inference_NS.py --checkpoint_file generator_v3 \
#     --input_wavs_dir ../../open-universe/data/voicebank_demand/16k/test/noisy \
#     --output_dir ../../open-universe/results/voicebank_demand/16k/test/noisy/hifi-gan


# ./diff_inference.sh diffwave-ljspeech-22kHz-1000578.pt testing_files/noisy testing_results
