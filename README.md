# Docker image to restore a Docker volume
This image writes the content of a .tar.bz2 archive to the destination specified (normally a Docker volume).

The following table describe the environment variables to specify. The variables without a default value must be specified.
| Variable            | Description                                                                                          | Default       |
| ------------------  | ---------------------------------------------------------------------------------------------------- | ------------- |
| $ARCHIVE_NAME       | The path and name of the archive to extract to the destination folder.                               |               |
| $DESTINATION        | The destination folder where to extract the archive file. The folder is created if it doesn't exist. | /media/volume |
| $DELETE_DESTINATION | If the variable is not empty, delete the content of $DESTINATION before extracting the archive.      |               |
| $DELETE_ARCHIVE     | If the variable is not empty, delete the archive file after extracting it.                           |               |

# Example of execution
> docker run --mount type=volume,src=_my_volume_,dst=/media/volume --mount type=volume,src=_backup_,dst=/media/backup --env ARCHIVE_NAME=_/media/backup/my_backup.tar.bz2_ 

Note that you can create a volume referencing another hard drive with the following options (and you can specify a drive uuid instead with the path /dev/disk/by-uuid/):
> docker volume create -o type=_ext4_,device=_/dev/sdb1_ backup
