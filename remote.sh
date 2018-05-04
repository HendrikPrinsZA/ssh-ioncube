#!/bin/bash

function showHelp() {
	echo "Remote"
    echo "    Encode all files in a directory with the ionCube encoder"
	printf "\n"
	echo "Usage"
	echo "  ./remote.sh --source=\"/var/www/html\" --target=\"/var/www/html/encoded\" --dir=\"1.0.13\""
   	printf "\n"
	echo "Options"
	echo "  source                 Source directory path [required]"
	echo "  target                 Target directory path [required]"
	echo "  dir                    Directory name of the folder to be encoded [required]"
	echo "  encoder                Path to the ionCube encoder executable (Defaults to ioncube_encoder.sh)"
	echo "  ioncube-extra-args     Additional ionCube arguments"
    echo "  verbose                Display information during operations"
	echo "  dry-run                Display what the script does without actually doing anything"
   	printf "\n"
	echo "Requirements"
    echo "  Execute in the installed ionCube encoder directory, requires 'ioncube_encoder.sh' (see https://www.ioncube.com/sa/USER-GUIDE.pdf)"
}

DIR="$(dirname "$0")"
cd ${DIR}

SOURCE=""
TARGET=""
DIR=""
ENCODER="ioncube_encoder.sh"
PHP_VERSION="-56"
IONCUBE_EXTRA_ARGS=""
DRY_RUN="n"
VERBOSE=""

for i in "$@"
do
    case $i in
        --target=*)
            TARGET="${i#*=}"
            shift
        ;;
        --source=*)
            SOURCE="${i#*=}"
            echo "FOUND SOURCE AS ${SOURCE}"
            shift
        ;;
        --ioncube-extra-args=*)
            IONCUBE_EXTRA_ARGS="${i#*=}"
            shift
        ;;
        --dir=*)
            DIR="${i#*=}"
            shift
        ;;
		--encoder=*)
			ENCODER="${i#*=}"
			shift
		;;
        --dry-run)
            DRY_RUN="y"
            shift
        ;;
        --verbose)
            VERBOSE=" --verbose"
            shift
        ;;
		--help)
			showHelp
			exit 0
		;;
    esac
done

function exitWithSuccessMessage {
    echo "Done"
    exit 0
}

if [ $DRY_RUN = "y" ]; then
    echo ":: Dry Run ::"
fi

# Check if the 'ioncube_encoder.sh' file exists in this directory
if [ ! -f $ENCODER ]; then
    echo "Error: Could not find '$ENCODER'"
    showHelp
    exit 1
fi

# Check if the argument DIR is set
if [ ! $DIR = "" ]; then
    SOURCE_DIR="${SOURCE}/${DIR}"
else
    echo "Error: Required paramater --dir=\"<folder>\" not found"
    showHelp
    exit 1
fi

# Check if the source directory exists
if [ ! -d $SOURCE_DIR ]; then
    echo "Error: Could not find '${SOURCE_DIR}'"
    showHelp
    exit 1
else
    if [ $DRY_RUN = "y" ]; then
        echo "Source path set to \"$SOURCE_DIR\""
    fi
fi

function checkAndSetLockFile { # $1 = relative path, $2 = dir name
    LOCKFILE="${1}/${2}.LOCK"
    if [ -f $LOCKFILE ]; then
        echo "Error: Found a lock-file, another process is still in progress..."
        cat $LOCKFILE
        exit 1
    else
        echo "This lock-file was created on $(date +"%Y-%m-%d %H:%M:%S")" > $LOCKFILE
    fi
}
function cleanLockFile { # $1 = relative path, $2 = dir name
    LOCKFILE="${1}/${2}.LOCK"
    rm $LOCKFILE
}

if [ $DRY_RUN = "n" ]; then
    checkAndSetLockFile $TARGET $DIR
    /bin/bash $ENCODER $PHP_VERSION "$SOURCE_DIR" --into "$TARGET" --create-target --replace-target --no-doc-comments $IONCUBE_EXTRA_ARGS $VERBOSE
    EXIT_CODE=$?
    cleanLockFile $TARGET $DIR

    if [ ! $EXIT_CODE -eq 0 ]; then
        exit $EXIT_CODE
    fi
else
    echo "The following command would be executed:"
    echo "./$ENCODER $PHP_VERSION \"$SOURCE_DIR\" --into \"$TARGET\" --create-target --replace-target --no-doc-comments $IONCUBE_EXTRA_ARGS $VERBOSE"
fi

exitWithSuccessMessage
