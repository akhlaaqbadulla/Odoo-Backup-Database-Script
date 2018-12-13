#!/bin/bash

#database acess
BACKUP_DIR=~/YourDirectory
ODOO_DATABASE=YourDbName
ADMIN_PASSWORD=YourDbMasterPassword@.
#temporary backups will be arhived in this folder
TMPBACKUP='/root/tmp/'
#name of backup
NAME='DB_Backup_name'
#Remote Google Drive directory ID where the file will be uploaded
ID='Yous_GDrive_Folder_Id'

# create a backup directory
mkdir -p ${BACKUP_DIR}

# create a backup
curl -X POST \
    -F "master_pwd=${ADMIN_PASSWORD}" \
    -F "name=${ODOO_DATABASE}" \
    -F "backup_format=zip" \
    -o ${BACKUP_DIR}/${ODOO_DATABASE}.$(date +%F).zip \
    http://localhost:8069/web/database/backup


# delete old backups
find ${BACKUP_DIR} -type f -mtime +7 -name "${ODOO_DATABASE}.*.zip" -delete



if [ ! -d "$TMPBACKUP" ]; then
        mkdir $TMPBACKUP
fi

cd $TMPBACKUP

#Archive the directory
tar -zcf "$NAME-$(date '+%Y-%m-%d').tar.gz" $BACKUP_DIR

# upload to google drive and delete the source file from tmp
drive upload "$NAME-$(date '+%Y-%m-%d').tar.gz" --parent $ID --delete
