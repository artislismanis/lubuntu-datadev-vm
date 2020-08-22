#!/bin/bash -e
# Read variable passed to script
JDBC_VERSION=$1
echo "==> Download Databricks JDBC Driver (2.6.11)..."
rm -rf ~/.local/opt/jdbc/SimbaSparkJDBC/${JDBC_VERSION}
mkdir -p ~/.local/opt/jdbc/SimbaSparkJDBC/${JDBC_VERSION}
wget --quiet https://databricks.com/wp-content/uploads/${JDBC_VERSION}/SimbaSparkJDBC-${JDBC_VERSION}.zip
unzip -o -q SimbaSparkJDBC-${JDBC_VERSION}.zip
unzip -o -q SimbaSparkJDBC4-${JDBC_VERSION}.zip -d ~/.local/opt/jdbc/SimbaSparkJDBC/${JDBC_VERSION}/
unzip -o -q SimbaSparkJDBC41-${JDBC_VERSION}.zip -d ~/.local/opt/jdbc/SimbaSparkJDBC/${JDBC_VERSION}/
unzip -o -q SimbaSparkJDBC42-${JDBC_VERSION}.zip -d ~/.local/opt/jdbc/SimbaSparkJDBC/${JDBC_VERSION}/
rm -f SimbaSparkJDBC-${JDBC_VERSION}.zip
rm -f SimbaSparkJDBC4-${JDBC_VERSION}.zip
rm -f SimbaSparkJDBC41-${JDBC_VERSION}.zip
rm -f SimbaSparkJDBC42-${JDBC_VERSION}.zip