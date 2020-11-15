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

    tar -x -f "$ARCHIVE_NAME" &&

    if [ -n "$DELETE_ARCHIVE" ]; then
        echo "Delete archive $ARCHIVE_NAME"
        rm -f "$ARCHIVE_NAME"
    fi
}

if [ ! -e "$ARCHIVE_NAME" ]; then
    echo '$ARCHIVE_NAME is not defined or is not a file.'
    exit 1
fi;
if [ -z "$DESTINATION" ]; then
    echo '$DESTINATION is not defined.'
    exit 1
fi;


echo "----------------------------------------"
echo "Begin restoration of $ARCHIVE_NAME in $DESTINATION"

do_restoration &
wait $!

ERR_CODE=$?
if [ $ERR_CODE -eq 0 ]; then
    echo "Restoration completed"
else
    echo "Restoration failed with error $?"
fi
echo -e "----------------------------------------\n" 
