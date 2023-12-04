#!/bin/sh

#set -e

[[ "$DEBUG" == "true" ]] && set -x

config=$(yq '.auth' /etc/samba/config.yml)
i=0
obj=$(echo "$config" | yq '.['$i']')
while [[ ! "$obj" = null ]]; do
  user=$(echo "$obj" | yq '.user')
  group=$(echo "$obj" | yq '.group')
  uid=$(echo "$obj" | yq '.uid')
  gid=$(echo "$obj" | yq '.gid')
  password=$(echo "$obj" | yq '.password')
  if [[ "$password" = "null" ]]; then
    password=$(cat "$(echo "$obj" | yq '.password_file')")
  fi
  echo "Creating user $user/$group ($uid:$gid)"
  id -g "$gid" &>/dev/null || id -gn "$group" &>/dev/null || addgroup -g "$gid" -S "$group"
  id -u "$uid" &>/dev/null || id -un "$user" &>/dev/null || adduser -u "$uid" -G "$group" "$user" -SHD
  echo -e "$password\n$password" | smbpasswd -a -s "$user"
  unset password
  let i++
  obj=$(echo "$config" | yq '.['$i']')
done;

exec "$@"