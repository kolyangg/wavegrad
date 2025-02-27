#!/bin/bash

# Usage: ./inference_script.sh <model_file> <spectrogram_dir> <output_dir>

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <model_file> <spectrogram_dir> <output_dir>"
    exit 1
fi

# Assign arguments to variables
MODEL_FILE="$1"
SPECTROGRAM_DIR="$2"
OUTPUT_DIR="$3"

# Check if spectrogram directory exists
if [ ! -d "$SPECTROGRAM_DIR" ]; then
    echo "Error: Spectrogram directory '$SPECTROGRAM_DIR' does not exist."
    exit 1
fi

# Create output directory if it does not exist
mkdir -p "$OUTPUT_DIR"

# Get the total number of files to process
TOTAL_FILES=$(ls "$SPECTROGRAM_DIR"/*.spec.npy 2>/dev/null | wc -l)
if [ "$TOTAL_FILES" -eq 0 ]; then
    echo "No .spec.npy files found in '$SPECTROGRAM_DIR'."
    exit 1
fi

# Set an environment variable to suppress FutureWarning
export PYTHONWARNINGS="ignore::FutureWarning"

# Initialize the progress bar
echo "Processing $TOTAL_FILES files..."
CURRENT=0

# Process each .spec.npy file in the spectrogram directory
for SPEC_FILE in "$SPECTROGRAM_DIR"/*.spec.npy; do
    # Extract the base filename without extension
    BASE_NAME=$(basename "$SPEC_FILE" .spec.npy)
    # Define the output WAV file path
    OUTPUT_FILE="$OUTPUT_DIR/$BASE_NAME"
    # Run the inference command
    python3 -m wavegrad.inference "$MODEL_FILE" "$SPEC_FILE" -o "$OUTPUT_FILE"
    # Update the progress
    CURRENT=$((CURRENT + 1))
    PROGRESS=$((CURRENT * 100 / TOTAL_FILES))
    echo -ne "Progress: [$CURRENT/$TOTAL_FILES] ($PROGRESS%)\r"
done

# Complete progress bar
echo -ne "Progress: [$CURRENT/$TOTAL_FILES] (100%)\n"

echo "Processing completed. Output files are in '$OUTPUT_DIR'."
