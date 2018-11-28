FROM ubuntu:18.04

RUN apt-get update && apt-get install -y curl gnupg

RUN . /etc/lsb-release \
  && GCSFUSE_REPO=gcsfuse-$DISTRIB_CODENAME \
  && echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && apt-get update \
  && apt-get install -y gcsfuse

ARG MOUNT_POINT=/mnt/gcs
RUN mkdir -p $MOUNT_POINT
WORKDIR $MOUNT_POINT

ENV GCS_BUCKET=bucket-name \
  KEY_FILE= \
  MOUNT_POINT=$MOUNT_POINT

CMD bash -c "gcsfuse --key-file=$KEY_FILE $GCS_BUCKET $MOUNT_POINT && while true; do sleep 3600; done"
