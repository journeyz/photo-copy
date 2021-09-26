#/bin/bash

ORIGIN=/Volumes/Untitled/DCIM/100OLYMP
JPEG_DIR=/Volumes/USB-HD-1TB/Media/Photo/2021
RAW_DIR=/Volumes/USB-HD-1TB/Media/PhotoRaw/2021
VIDEO_DIR=/Volumes/USB-HD-1TB/Media/Video/2021

if [ "$1" != "" ] ; then
  ORIGIN=$1
fi

if [ ! -d "$ORIGIN" ] ; then
  echo "WARNING: Camera drive is NOT mounted."
  exit 1
fi

for date in `ls -lTtr $ORIGIN | grep rw | awk '{printf("%02d-%02d-%02d\n", $9, $6, $7);}' | sort | uniq` ; do
  jpeg_date_dir=$JPEG_DIR/${date}
  raw_date_dir=$RAW_DIR/${date}
  video_date_dir=$VIDEO_DIR/${date}

  year=`echo $date | awk '{split($1, ary, "-"); printf("%d",ary[1])}'`
  month=`echo $date | awk '{split($1, ary, "-"); printf("%d",ary[2])}'`
  day=`echo $date | awk '{split($1, ary, "-"); printf("%d",ary[3])}'`

  JPEG_FILES=(`ls -lTtr $ORIGIN/*{JPG,JPEG,jpg,jpeg} 2> /dev/null | awk '{print $6 " " $7 " " $9 " " $10}' | grep "$month $day $year" | awk '{print $4}'`)
  for file in "${JPEG_FILES[@]}" ; do
    if [ ! -d "$jpeg_date_dir" ] ; then
      mkdir -p "$jpeg_date_dir"
    fi
    orig_path=$file
    filename=`echo $orig_path | awk '{split($1, ary, "\/"); print ary[length(ary)]}'`
    dest_path=$jpeg_date_dir/$filename
    echo "Copying $orig_path to $dest_path"
    cp "$orig_path" "$dest_path"
  done

  RAW_FILES=(`ls -lTtr $ORIGIN/*{ORF,CR2,CR3} 2> /dev/null | awk '{print $6 " " $7 " " $9 " " $10}' | grep "$month $day $year" | awk '{print $4}'`)
  for file in "${RAW_FILES[@]}" ; do
    if [ ! -d "$raw_date_dir" ] ; then
      mkdir -p "$raw_date_dir"
    fi
    orig_path=$file
    filename=`echo $orig_path | awk '{split($1, ary, "\/"); print ary[length(ary)]}'`
    dest_path=$raw_date_dir/$filename
    echo "Copying $orig_path to $dest_path"
    cp "$orig_path" "$dest_path"
  done

  VIDEO_FILES=(`ls -lTtr $ORIGIN/*{MOV,MP4} 2> /dev/null | awk '{print $6 " " $7 " " $9 " " $10}' | grep "$month $day $year" | awk '{print $4}'`)
  for file in "${VIDEO_FILES[@]}" ; do
    if [ ! -d "$video_date_dir" ] ; then
      mkdir -p "$video_date_dir"
    fi
    orig_path=$file
    filename=`echo $orig_path | awk '{split($1, ary, "\/"); print ary[length(ary)]}'`
    dest_path=$video_date_dir/$filename
    echo "Copying $orig_path to $dest_path"
    cp "$orig_path" "$dest_path"
  done
done

echo "Image file copying finished."