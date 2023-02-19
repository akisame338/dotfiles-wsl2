#!/bin/bash

function execute() {
  cmd=${1}
  echo ${cmd}
  eval ${cmd}
}

function make_backup_or_delete() {
  target=${1}

  if [ -L ${target} ]; then
    echo "Symbolic link \`${target}\` exists, remove it."
    execute "rm ${target}"
  elif [ -f ${target} ]; then
    bakup_file="${target}.BAK"
    echo "File \`${target}\` already exists, make a backup copy \`${bakup_file}\` and remove."
    execute "cp ${target} ${bakup_file}"
    execute "rm ${target}"
  fi
}

function create_symbolic_link() {
  src_file=${1}
  dst_file=${2}

  make_backup_or_delete ${dst_file}
  execute "ln -s ${src_file} ${dst_file}"
}

function copy() {
  src_file=${1}
  dst_file=${2}

  make_backup_or_delete ${dst_file}
  execute "cp ${src_file} ${dst_file}"
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
copy "${PWD}/wsl/.wslconfig" "${HOST_USER_DIR}/.wslconfig"

# Windows Terminal config
windows_terminal_dir=`find ${HOST_USER_DIR}/AppData/Local/Packages/ -type d -name 'Microsoft.WindowsTerminal_*' | head -n 1`
copy "${PWD}/windows-terminal/settings.json" "${windows_terminal_dir}/LocalState/settings.json"

# VSCode
# user (Windows)
vscode_user_src_dir="${PWD}/vscode/user"
vscode_user_dst_dir="${HOST_USER_DIR}/AppData/Roaming/Code/User"
while read -d $'\0' src_file; do
  dst_file=`echo ${src_file} | sed "s@${vscode_user_src_dir}@${vscode_user_dst_dir}@"`
  copy ${src_file} ${dst_file}
done < <(find ${vscode_user_src_dir} -mindepth 1 -maxdepth 1 -print0)
# remote (WSL2)
vscode_remote_src_dir="${PWD}/vscode/remote"
while read -d $'\0' src_file; do
  dst_file=`echo ${src_file} | sed "s@${vscode_remote_src_dir}@${HOME}/.vscode-server/data/Machine@"`
  create_symbolic_link ${src_file} ${dst_file}
done < <(find ${vscode_remote_src_dir} -mindepth 1 -maxdepth 1 -print0)
