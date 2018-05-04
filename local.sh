#!/bin/bash

function showHelp() {
	echo "Local"
    echo "  Connect to the remote machine and delegate the ionCube script to be run"
	printf "\n"
	echo "Usage"
    echo "  ./local.sh --host=\"devops.example.com\" --user=\"administrator\" --exec=\"/home/administrator/ssh-ioncube/remote.sh\""
   	printf "\n"
	echo "Options"
    echo "  host       Remote machine host [required]"
    echo "  user       Remote machine user [required]"
    echo "  exec       Abs path to the remote.sh script [required]"
    printf "\n"
    echo "[See additional options with './remote.sh --help']"
   	printf "\n"
	echo "Requirements"
    echo "  ssh + authorized key (see https://www.ssh.com/ssh/copy-id)"
}

HOST=""
USER=""
LOCATION=""

for i in "$@"
do
case $i in
    --host=*)
        HOST="${i#*=}"
        shift
    ;;
    --user=*)
        USER="${i#*=}"
        shift
    ;;
    --exec=*)
        EXEC="${i#*=}"
        shift
    ;;
    --help)
        showHelp
        exit 0
    ;;
esac
done

USER_AT_HOST="${USER}@${HOST}"
TARGET_FOLDER=$(git symbolic-ref -q --short HEAD || git describe --tags --exact-match)

ssh $USER_AT_HOST "/bin/bash $EXEC $@"
EXIT_CODE=$?
if [ ! $EXIT_CODE -eq 0 ]; then
    exit $EXIT_CODE
else
    exit 0
fi
