#!/bin/bash -e

echo "==> Installing OpenJDK 8u252..."
# Reference tools to help you manage your development environments 
source "$HOME/.sdkman/bin/sdkman-init.sh"
# Installing the same version 2x will result in exit code 1
# When re-provisioning need to start by removing installed version
sdk uninstall java 8.0.252-open > /dev/null 2>&1
sdk install java 8.0.252-open > /dev/null 2>&1

echo "==> Create & activate Conda environment..."
source "$HOME/.miniconda/etc/profile.d/conda.sh"
conda create --yes --name databricks python=3.7.3
conda activate databricks

echo "==> Installing Azure Databricks Connect..." 
# https://docs.microsoft.com/en-us/azure/databricks/dev-tools/databricks-connect
pip install -U databricks-connect==6.5

# Point SPARK_HOME to databricks_connect on activating the databricks environment
mkdir -p $HOME/.miniconda/envs/databricks/etc/conda/activate.d/
cat << 'EOF' >> $HOME/.miniconda/envs/databricks/etc/conda/activate.d/env_vars.sh
#!/bin/bash
export SPARK_HOME=$(databricks-connect get-spark-home)
EOF

echo "==> Installing Azure Databricks CLI..."
# https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/
pip install databricks-cli

echo "==> Deactivate Conda environment..."
conda deactivate

echo "==> Getting Databricks JDBC Driver 2.6.11..."
sudo mkdir -p /opt/jdbc/SimbaSparkJDBC
wget --quiet https://databricks.com/wp-content/uploads/2.6.11.1014/SimbaSparkJDBC-2.6.11.1014.zip
unzip -o -q SimbaSparkJDBC-2.6.11.1014.zip
sudo unzip -o -q SimbaSparkJDBC4-2.6.11.1014.zip -d /opt/jdbc/SimbaSparkJDBC/SimbaSparkJDBC4-2.6.11.1014
sudo unzip -o -q SimbaSparkJDBC41-2.6.11.1014.zip -d /opt/jdbc/SimbaSparkJDBC/SimbaSparkJDBC41-2.6.11.1014
sudo unzip -o -q SimbaSparkJDBC42-2.6.11.1014.zip -d /opt/jdbc/SimbaSparkJDBC/SimbaSparkJDBC42-2.6.11.1014
rm -f SimbaSparkJDBC-2.6.11.1014.zip
rm -f SimbaSparkJDBC4-2.6.11.1014.zip
rm -f SimbaSparkJDBC41-2.6.11.1014.zip
rm -f SimbaSparkJDBC42-2.6.11.1014.zip