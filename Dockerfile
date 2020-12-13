FROM alpine:latest
ENV ARCHIVE_NAME=
ENV BACKUP_FOLDER=
ENV DESTINATION=/media/volume
ENV DELETE_ARCHIVE=
ENV DELETE_DESTINATION=
ENV DATE_DIR_FILE=


WORKDIR /

COPY restore.sh restore.sh
RUN chmod 700 restore.sh


ENTRYPOINT ["/bin/ash", "-c"]

CMD ["/restore.sh"]
