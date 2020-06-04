#!/bin/bash -e

echo "==> Activate Databricks conda environment..."
source "$HOME/.miniconda/etc/profile.d/conda.sh"
conda activate databricks

echo "==> Installing Azure Databricks Connect..." 
# https://docs.microsoft.com/en-us/azure/databricks/dev-tools/databricks-connect
pip install -U databricks-connect==6.5

# Point SPARK_HOME to databricks-connect spark instance on activating the databricks environment
mkdir -p $HOME/.miniconda/envs/databricks/etc/conda/activate.d/
cat << 'EOF' > $HOME/.miniconda/envs/databricks/etc/conda/activate.d/env_vars.sh
#!/bin/bash
export SPARK_HOME=$(databricks-connect get-spark-home)
EOF

echo "==> Deactivate Databricks conda environment..."
conda deactivate