#!/bin/bash

function check_diff() {
  original_file=${1}
  copied_file=${2}

  cmd="diff ${original_file} ${copied_file}"
  eval "${cmd} > /dev/null"
  if [ ${?} -ne 0 ]; then
    echo "There are differences between \`${original_file}\` and \`${copied_file}\`, run following command to check:"
    echo -e "\n${cmd}\n"
  fi
}

HOST_USER_DIR=`wslpath "$(wslvar USERPROFILE)"`

# WSL config
check_diff "${PWD}/wsl/.wslconfig" "${HOST_USER_DIR}/.wslconfig"

# VSCode
# user (Windows)
vscode_user_src_dir="${PWD}/vscode/user"
vscode_user_dst_dir="${HOST_USER_DIR}/AppData/Roaming/Code/User"
while read -d $'\0' src_file; do
  dst_file=`echo ${src_file} | sed "s@${vscode_user_src_dir}@${vscode_user_dst_dir}@"`
  check_diff ${src_file} ${dst_file}
done < <(find ${vscode_user_src_dir} -mindepth 1 -maxdepth 1 -print0)
