# Rsync Folders

## Precondition

Make sure to have `rsync` installed on the remote machine. In case the addon gives you an `bash: rsync: command not found` in the logs `rsync` is missing there.

## Config

Example config:

```yaml
remote_host: 192.168.1.30
remote_folder: '/home/user'
username: home_assistant_rsync
password: !secret password_rsync
use_ssh: 0
folders:
  - /media
options: '--remove-sent-files -archive --recursive --compress'
```

### `password`

User password on the remote machine

### `username`

The username for the user on the remote machine.

### `folders`

The list of folders you want to sync with the remote machine. Those locations are getting synced recursively.

When a folder is specified with a slash at the end the content are directly copied inside the remote_folder.
Without it a folder with the content is created.

For example:

* `- /config` would result into `/home/user/config`
* `- /config/` would put the content of config into `/home/user`

### `remote_host`

The ip or host of the remote machine you want to connect to.

### `remote_port` (optional)

The ssh port on the remote machine. If not set the default `22` is assumed.

### `remote_folder`

The base folder on the remote machine for syncing the folders. Sub-folders with the folders from above will be created there.

Prepend with `:` (example `remote_folder: ":NetBackup"`) to rsync on device like synology without ssh.

### `use_ssh`

0: use rsync without call ssh, example `rsync -va /media <username>@<server_ip>:<remote_folder>` usefull for NAS without ssh opened.

1: use rsync with ssh, allows you to specify a port, example `rsync -va -e "ssh -p <port> -o StrictHostKeyChecking=no" /media <username>@<server_ip>:<remote_folder>`

### `options` (optional)

Use your own options for rsync. This string is replacing the default one and get directly to rsync. The default is `-archive --recursive --compress --delete --prune-empty-dirs`.

## How to use

Run addon in the automation, example automation below:
```yaml
- alias: 'hassio_daily_backup'
  trigger:
    platform: 'time'
    at: '3:00:00'
  action:
    - service: 'hassio.addon_start'
      data:
        addon: '2caa1d32_rsync_folders' # you can get the addon id from URL when you go to the addon info
```