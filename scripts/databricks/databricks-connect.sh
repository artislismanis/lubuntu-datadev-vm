#!/bin/bash -e

DBR_VERSION=$1

echo "==> Installing Azure Databricks Connect..." 
source "$HOME/.miniconda/etc/profile.d/conda.sh"
conda activate databricks

# https://docs.microsoft.com/en-us/azure/databricks/dev-tools/databricks-connect
pip install -U databricks-connect==${DBR_VERSION}

# Point SPARK_HOME to databricks-connect spark instance on activating the databricks environment
mkdir -p $HOME/.miniconda/envs/databricks/etc/conda/activate.d/
cat << 'EOF' > $HOME/.miniconda/envs/databricks/etc/conda/activate.d/env_vars.sh
#!/bin/bash
export SPARK_HOME=$(databricks-connect get-spark-home)
EOF

conda deactivate