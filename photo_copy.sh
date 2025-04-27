#/bin/bash
#
# 写真ファイルをカメラや外部ストレージからコピーするスクリプト
#   photo_copy.sh コピー元ディレクトリ(オプション)
# 設定ファイル
#   photo_copy.conf

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONF_FILE="${SCRIPT_DIR}/photo_copy.conf"

if [ -f "$CONF_FILE" ] ; then
  source "$CONF_FILE"
else
  echo "ERROR: Configuration File not found: ${CONF_FILE}" 1>&2
  exit 1
fi

if [ "$1" != "" ] ; then
  ORIGIN="$1"
fi

if [ ! -d "$ORIGIN" ] ; then
  if [ ! -d "$ORIGIN2" ] ; then
    echo "WARNING: Camera drive is NOT mounted." 1>&2
    exit 1
  else
    ORIGIN="$ORIGIN2"
  fi
fi

function create_dir {
    if [ ! -d "$TARGET_DIR" ] ; then
      mkdir -p "$TARGET_DIR"
      if [ $? -ne 0 ] ; then
        echo "ERROR: Cannot create directory: ${TARGET_DIR}"
        exit 1
      fi
    fi
}

function file_copy {
  for file in "${TARGET_FILES[@]}" ; do
    create_dir
    orig_path="$file"
    orig_filename=`echo "$orig_path" | awk '{split($1, ary, "\/"); print ary[length(ary)]}'`
    num=`echo "$orig_filename" | awk '{split($1, ary, "\."); trunk=ary[length(ary)-1]; print substr(trunk,length(trunk)-2,3)}'`
    ext=`echo "$orig_filename" | awk '{split($1, ary, "\."); print ary[length(ary)]}'`
    timestamp=`date -r "$file" "+%Y-%m-%d_%H%M%S"`
    filename="${timestamp}_${num}.${ext}"
    dest_path="$TARGET_DIR"/"$filename"
    echo "Copying $orig_path to $dest_path"
    cp "$orig_path" "$dest_path"
    if [ $? -ne 0 ] ; then
      echo "ERROR: Cannot create target file: ${dest_path}"
      exit 1
    fi
  done
}

for date in `ls -lTtr "$ORIGIN" | grep rw | awk '{printf("%02d-%02d-%02d\n", $9, $6, $7);}' | sort | uniq` ; do
  year=`echo $date | awk '{split($1, ary, "-"); printf("%d",ary[1])}'`
  month=`echo $date | awk '{split($1, ary, "-"); printf("%d",ary[2])}'`
  day=`echo $date | awk '{split($1, ary, "-"); printf("%d",ary[3])}'`

  # JPEG Files
  TARGET_FILES=(`ls -lTtr "$ORIGIN"/*{JPG,JPEG,jpg,jpeg} 2> /dev/null | awk '{print $6 " " $7 " " $9 " " $10}' | grep "$month $day $year" | awk '{print $4}'`)
  TARGET_DIR=$JPEG_DIR/${date}
  file_copy

  # RAW Files
  TARGET_FILES=(`ls -lTtr "$ORIGIN"/*{ORF,CR2,CR3,ARW,CRW,TIF,NEF,NRW,RAF,RW2,DNG,PEF,BAY,RWL,X3F} 2> /dev/null | awk '{print $6 " " $7 " " $9 " " $10}' | grep "$month $day $year" | awk '{print $4}'`)
  TARGET_DIR=$RAW_DIR/${date}
  file_copy

  # Video Files
  TARGET_FILES=(`ls -lTtr "$ORIGIN"/*{MOV,MP4} 2> /dev/null | awk '{print $6 " " $7 " " $9 " " $10}' | grep "$month $day $year" | awk '{print $4}'`)
  TARGET_DIR=$VIDEO_DIR/${date}
  file_copy
done

echo "Image file copying finished."
