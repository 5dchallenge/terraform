#!/bin/bash 

wget -c https://raw.githubusercontent.com/devopsdemoapps/devops-demo/master/devops-demo.sql

mysql -u ${rds.master_username} -p${rds_password} -h ${rds.address} ${rds.db_name} < devops-demo.sql


