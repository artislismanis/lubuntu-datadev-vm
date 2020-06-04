#!/bin/bash -e

echo "==> Activate Databricks conda environment..."
source "$HOME/.miniconda/etc/profile.d/conda.sh"
conda activate databricks

echo "==> Installing Azure Databricks CLI..."
# https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/
pip install databricks-cli

echo "==> Deactivate Databricks conda environment..."
conda deactivate
