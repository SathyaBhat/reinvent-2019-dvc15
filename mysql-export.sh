#!/usr/bin/env bash
filename=${dbname}-`date +%F-%R`.sql.gz
bucket_name=${S3_BUCKET:-reinvent-mysql-exports}
mysqldump -u ${dbusername} -p${dbpassword} -h ${dbhost} --databases ${dbname} | gzip > ${filename}
aws s3 cp ${filename} s3://${bucket_name} --quiet
aws s3 presign s3://{bucket_name}/${filename} --expires-in 86400
