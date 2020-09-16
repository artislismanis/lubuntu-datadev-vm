#!/bin/bash -eu

# Customisations shown here depend on the following software being installed as a part of your provisioning steps
# PosgreSQL, DBeaver IDE and jq

# Set variables
USER_NAME="datadev"
USER_PASSWORD="datadev"
DB_NAME="datadev"

echo "==> Create development PostgreSQL user and database"
cat <<EOF > createdb.sql
DO
\$do\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles  
      WHERE  rolname = '$USER_NAME') THEN
      CREATE ROLE $USER_NAME LOGIN PASSWORD '$USER_PASSWORD';
   END IF;
END
\$do\$;

SELECT 'CREATE DATABASE $DB_NAME'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$DB_NAME') \gexec

GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $USER_NAME;
\c $DB_NAME
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $USER_NAME;
EOF

sudo systemctl start postgresql
sudo -u postgres -H -- psql -f createdb.sql 
sudo systemctl stop postgresql

rm -f createdb.sql

echo "==> Configure DBeaver DB connection" 
dbeaver-ce -help > /dev/null 2>&1
DBEAVER_HOME=$(readlink -f ~/snap/dbeaver-ce/current)
DBEAVER_DATA_CONFIG="$DBEAVER_HOME/.local/share/DBeaverData/workspace6/General/.dbeaver"

if ! [[ -d "$DBEAVER_DATA_CONFIG" ]]
then 
	mkdir -p $DBEAVER_DATA_CONFIG
    echo "{}" > $DBEAVER_DATA_CONFIG/data-sources.json
else
	cp $DBEAVER_DATA_CONFIG/data-sources.json $DBEAVER_DATA_CONFIG/data-sources.json.old
fi

cat <<EOF > $DBEAVER_DATA_CONFIG/postgresql-local.json
{
	"folders": {},
	"connections": {
		"postgres-jdbc-1745e26a248-16ff0402bfc5f78": {
			"provider": "postgresql",
			"driver": "postgres-jdbc",
			"name": "Local Dev - $DB_NAME",
			"save-password": false,
			"show-system-objects": true,
			"read-only": false,
			"configuration": {
				"host": "localhost",
				"port": "5432",
				"database": "$DB_NAME",
				"url": "jdbc:postgresql://localhost:5432/$DB_NAME",
				"type": "dev",
				"provider-properties": {
					"@dbeaver-show-non-default-db@": "false",
					"@dbeaver-show-template-db@": "false",
					"postgresql.dd.plain.string": "false",
					"postgresql.dd.tag.string": "false"
				},
				"auth-model": "native"
			}
		}
	},
	"connection-types": {
		"dev": {
			"name": "Development",
			"color": "255,255,255",
			"description": "Regular development database",
			"auto-commit": true,
			"confirm-execute": false,
			"confirm-data-change": false
		}
	}
}

EOF

# Merge with DBeaver data sources config
jqtmp=$(mktemp)
jq -s '.[0] * .[1]'  $DBEAVER_DATA_CONFIG/data-sources.json $DBEAVER_DATA_CONFIG/postgresql-local.json > "$jqtmp"
rm -f $DBEAVER_DATA_CONFIG/data-sources.json
mv "$jqtmp" $DBEAVER_DATA_CONFIG/data-sources.json 