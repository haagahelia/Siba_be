FROM mariadb:latest

WORKDIR /db

COPY ./SQL_Scripts/createSchemaAndUsers.sql .

COPY ./SQL_Scripts/000__CreateALLdb.sql .

#RUN mariadbd --console

EXPOSE ${3306}

CMD ["mariadbd", "--console"]



# CMD ["npm", "start"]

#     - MARIADB_DATABASE=casedb
#      - MARIADB_ROOT_PASSWORD=ruut_p4swordi
#    ports:
#      - 3309:3306
#    volumes:
#      - ./createSchemaAndUsers.sql:/docker-entrypoint-initdb.d/init.sql
#      - ./Database/SQL_Scripts/000__CreateALLdb.sql:/docker-entrypoint-initdb.d/init2.sql
#
#     - mariadb_volume:/var/lib/mysql
 