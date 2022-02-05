#!/bin/ash


function cleanup()
{
    kill %1 2> /dev/null
    echo "Restoration interrupted. The volume will be in unstable state."
    exit 2
}

trap 'cleanup' SIGINT
trap 'cleanup' SIGTERM


function do_restoration {
    mkdir -p "$DESTINATION" &&
    if [ -n "$DELETE_DESTINATION" ]; then
        echo "Delete everything in destination path."
        rm -rf "$DESTINATION/*"
    fi &&
    cd "$DESTINATION" &&

    tar -x -f "$BACKUP_FILE" &&

    if [ -n "$DELETE_ARCHIVE" ]; then
        echo "Delete archive $BACKUP_FILE"
        rm -f "$BACKUP_FILE"
    fi
}

if [ -z "$DESTINATION" ]; then
    echo '$DESTINATION is not defined.'
    exit 1
fi;
if [ -z "$BACKUP_FOLDER" ]; then
    echo '$BACKUP_FOLDER' is not defined
    exit 1
fi;

BACKUP_FILE="/media/backup/$BACKUP_FOLDER/$ARCHIVE_NAME"
if [ -z "$ARCHIVE_NAME" ]; then
    echo "\$ARCHIVE_NAME is empty."
    exit 1
elif [ ! -f "$BACKUP_FILE" ]; then
    if [ -n "$NO_BACKUP" ]; then
        echo "The file $BACKUP_FILE doesn't exist."
        exit 1
    else
        echo "No need to restore since there is no archive at $BACKUP_FILE."
        exit 0
    fi
fi


echo "----------------------------------------"
echo "Begin restoration of $BACKUP_FILE in $DESTINATION"

do_restoration &
wait $!

ERR_CODE=$?
if [ $ERR_CODE -eq 0 ]; then
    echo "Restoration completed"
else
    echo "Restoration failed with error $?"
fi
echo -e "----------------------------------------\n" 
