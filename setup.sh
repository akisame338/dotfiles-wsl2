#!/bin/bash

function execute() {
  cmd=${1}
  echo ${cmd}
  eval ${cmd}
}

echo "Create symbolic links."

SRC_DIR="${PWD}/home"
while read -d $'\0' src_file; do
  dst_file=`echo ${src_file} | sed "s@${SRC_DIR}@${HOME}@"`

  if [ -f ${dst_file} ]; then
    bakup_file="${dst_file}.BAK"
    echo "File \`${dst_file}\` already exists, make a backup copy \`${bakup_file}\` and remove."
    execute "cp ${dst_file} ${bakup_file}"
    execute "rm ${dst_file}"
  elif [ -L ${dst_file} ]; then
    echo "Symbolic link \`${dst_file}\` exists, remove it."
    execute "rm ${dst_file}"
  fi

  execute "ln -s ${src_file} ${dst_file}"
done < <(find ${SRC_DIR} -mindepth 1 -maxdepth 1 -print0)
