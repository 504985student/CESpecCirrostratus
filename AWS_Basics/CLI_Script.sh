#!/bin/bash

# variabelen
SOURCE_BUCKET="cs-bucket-cespec-cirrostratus"
BACKUP_BUCKET="cs-bucket-cespec-backup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_PATH="s3://$BACKUP_BUCKET/backup-$TIMESTAMP/"

# stel de verbinding op met de backup bucket
aws s3 sync s3://$SOURCE_BUCKET $BACKUP_PATH

# Output result
if [ $? -eq 0 ]; then
  echo "de backup is gelukt! $TIMESTAMP."
else
  echo "de backup is niet gelukt! $TIMESTAMP."
fi
