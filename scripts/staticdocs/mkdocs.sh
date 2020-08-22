#!/bin/bash -e

echo "==> Installing MkDocs..."
source "$HOME/.miniconda/etc/profile.d/conda.sh"
conda create --yes --name mkdocs > /dev/null 2>&1
conda activate mkdocs
pip install  --no-warn-script-location mkdocs 
conda deactivate