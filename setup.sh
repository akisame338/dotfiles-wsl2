#!/bin/bash

function execute() {
  cmd=${1}
  echo ${cmd}
  eval ${cmd}
}

function make_backup() {
  target=${1}
  bakup_file="${target}.BAK"
  echo "Make a backup copy as \`${bakup_file}\`."

  if [ -f ${bakup_file} ]; then
    echo "File \`${bakup_file}\` already exists!"
    make_backup ${bakup_file}
  fi
  execute "mv ${target} ${bakup_file}"
}

function make_backup_or_delete() {
  target=${1}

  if [ -L ${target} ]; then
    echo "Symbolic link \`${target}\` exists, remove it."
    execute "rm ${target}"
  elif [ -f ${target} ]; then
    echo "File \`${target}\` already exists!"
    make_backup ${target}
  fi
}

function create_symbolic_link() {
  src_file=${1}
  dst_file=${2}

  echo "Try to create a symbolic link to \`${src_file}\` with the name \`${dst_file}\`"
  make_backup_or_delete ${dst_file}
  execute "ln -s ${src_file} ${dst_file}"
  echo -e "Successfully created symbolic link.\n"
}

function copy_file() {
  src_file=${1}
  dst_file=${2}

  echo "Try to copy \`${src_file}\` to \`${dst_file}\`."
  make_backup_or_delete ${dst_file}
  execute "cp ${src_file} ${dst_file}"
  echo -e "Successfully copied file.\n"
}

HOST_USER_DIR=`wslpath "$(wslvar USERPROFILE)"`

echo "Create symbolic links / Copy files"

# Home
SRC_DIR="${PWD}/home"
while read -d $'\0' src_file; do
  dst_file=`echo ${src_file} | sed "s@${SRC_DIR}@${HOME}@"`
  create_symbolic_link ${src_file} ${dst_file}
done < <(find ${SRC_DIR} -mindepth 1 -maxdepth 1 -print0)

# WSL config
copy_file "${PWD}/wsl/.wslconfig" "${HOST_USER_DIR}/.wslconfig"

# Windows Terminal config
windows_terminal_dir=`find ${HOST_USER_DIR}/AppData/Local/Packages/ -type d -name 'Microsoft.WindowsTerminal_*' | head -n 1`
copy_file "${PWD}/windows-terminal/settings.json" "${windows_terminal_dir}/LocalState/settings.json"

# VSCode
# user (Windows)
vscode_user_src_dir="${PWD}/vscode/user"
vscode_user_dst_dir="${HOST_USER_DIR}/AppData/Roaming/Code/User"
while read -d $'\0' src_file; do
  dst_file=`echo ${src_file} | sed "s@${vscode_user_src_dir}@${vscode_user_dst_dir}@"`
  copy_file ${src_file} ${dst_file}
done < <(find ${vscode_user_src_dir} -mindepth 1 -maxdepth 1 -print0)
# remote (WSL2)
vscode_remote_src_dir="${PWD}/vscode/remote"
while read -d $'\0' src_file; do
  dst_file=`echo ${src_file} | sed "s@${vscode_remote_src_dir}@${HOME}/.vscode-server/data/Machine@"`
  create_symbolic_link ${src_file} ${dst_file}
done < <(find ${vscode_remote_src_dir} -mindepth 1 -maxdepth 1 -print0)
