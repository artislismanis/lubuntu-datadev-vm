#!/bin/bash -e

echo "==> Installing Azure Databricks CLI..."
source "$HOME/.miniconda/etc/profile.d/conda.sh"
conda activate databricks
# https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/
pip install databricks-cli
conda deactivate
