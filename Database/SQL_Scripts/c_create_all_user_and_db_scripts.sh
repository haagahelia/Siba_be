rm -f 0000__CreateAlldb_and_user.sql
sh ./a_create_all_db_script.sh
sh ./b_create_all_db_data_refresh_script.sh
cat ./../../../createSchemaAndUsers.sql 000__* > 0000__CreateAlldb_and_user.sql

