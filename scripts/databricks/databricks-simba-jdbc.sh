#!/bin/bash -e

echo "==> Download Databricks JDBC Driver (2.6.11)..."
mkdir -p /opt/jdbc/SimbaSparkJDBC
wget --quiet https://databricks.com/wp-content/uploads/2.6.11.1014/SimbaSparkJDBC-2.6.11.1014.zip
unzip -o -q SimbaSparkJDBC-2.6.11.1014.zip
unzip -o -q SimbaSparkJDBC4-2.6.11.1014.zip -d /opt/jdbc/SimbaSparkJDBC/SimbaSparkJDBC4-2.6.11.1014
unzip -o -q SimbaSparkJDBC41-2.6.11.1014.zip -d /opt/jdbc/SimbaSparkJDBC/SimbaSparkJDBC41-2.6.11.1014
unzip -o -q SimbaSparkJDBC42-2.6.11.1014.zip -d /opt/jdbc/SimbaSparkJDBC/SimbaSparkJDBC42-2.6.11.1014
rm -f SimbaSparkJDBC-2.6.11.1014.zip
rm -f SimbaSparkJDBC4-2.6.11.1014.zip
rm -f SimbaSparkJDBC41-2.6.11.1014.zip
rm -f SimbaSparkJDBC42-2.6.11.1014.zip