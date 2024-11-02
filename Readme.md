#### Thanks:

https://github.com/vgist/dockerfiles/tree/master/samba-server


#### Config:

Default config in **/etc/samba** .

##### config.yml:

```yaml
auth:
- user: admin
  group: admin
  uid: 1000
  gid: 1000
  password: admin
  #password_file: /data/root_password
```

##### smb.conf:

```ini
[global]
workgroup = WORKGROUP
server string = WORKGROUP
server role = standalone server
server services = -dns, -nbt
server signing = default
server multi channel support = yes

log level = 0
;log file = /usr/local/samba/var/log.%m
;max log size = 50

hosts allow = 127.0.0.0/8 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16
hosts deny = 0.0.0.0/0

security = user
guest account = nobody
pam password change = yes
map to guest = bad user
usershare allow guests = yes

create mask = 0664
force create mode = 0664
directory mask = 0775
force directory mode = 0775
follow symlinks = yes
wide links = yes
unix extensions = no

printing = bsd
printcap name = /dev/null
disable spoolss = yes
disable netbios = yes
smb ports = 445

client ipc min protocol = default
client ipc max protocol = default

;wins support = yes
;wins server = w.x.y.z
;wins proxy = yes
dns proxy = no
socket options = TCP_NODELAY
strict locking = no
local master = no

winbind scan trusted domains = yes

vfs objects = fruit streams_xattr
fruit:metadata = stream
fruit:model = MacSamba
fruit:posix_rename = yes
fruit:veto_appledouble = no
fruit:wipe_intentionally_left_blank_rfork = yes
fruit:delete_empty_adfiles = yes
fruit:time machine = yes

[Mount]
path = /mount
read only = no
guest ok = yes
write list = admin
veto files = /._*/.DS_Store/.Trashes/
delete veto files = yes
```

#### Volume:

- /mount

#### Port:

- 445/tcp

#### Command example:

```shell
docker run \
    -d \
    --name samba-server \
    -p 445:445/tcp \
    -v /your/data:/etc/samba:ro \
    -v /your/path:/mount \
    tkaxv7s/samba-server
```

#### Compose example:

```yaml
samba-server:
  image: tkaxv7s/samba-server
  container_name: samba-server
  ports:
    - "445:445/tcp"
  volumes:
    - ./data:/etc/samba:ro
    - /your/path:/mount
  restart: always
```

#### Auth:

username: admin

password: admin
