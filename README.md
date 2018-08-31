# docker-grav
Grav CMS in docker

## Install plugins

[https://getgrav.org/downloads]

After installation you have to chown all folder or restart docker box

  chown -R web:staff /var/www/html

### Install admin
  docker exec -it irodatarhelyparkhu_grav_1 bin/gpm admin

### Install template
  docker exec -it irodatarhelyparkhu_grav_1 bin/gpm install learn2-git-sync

### Install user manager
  docker exec -it irodatarhelyparkhu_grav_1 bin/gpm install admin-addon-user-manager
