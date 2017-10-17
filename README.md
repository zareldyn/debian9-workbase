# debian9-workbase
A customized minimal Debian 9 Docker image with one regular user, one text editor and a nicer prompt.

![Bash session screenshot](/debian9-workbase.png?raw=true)

## Goal

I often need to build Debian-based Docker images that, in addition to their main purpose (web server, etc), must have the minimal set of tools so I can work inside the containers with my favorite commands.  
Containers from those images often must perform actions with UID/GID != 0, typically for dealing with regular user files that are shared between host and containers.  
Generally speaking, I like when my containers have some behaviors and elements of configuration in common with my host system, like the system timezone for example.  
Also, it's not because it's "only" a container that a Bash session screen in it has to be ugly. When I run commands that produce large lines of results, I like to distinguish easily commands lines from results lines.

That's why I've written this Dockerfile.  
It builds an image that is intended to be **a base for building other images** which need to satisfy these considerations. The installed text editor is *Nano*. See the Dockerfile for a complete list of what is installed.

## How to use

### Basic build

With no customization (see below), this will produce a Debian 9.0 image in which a user called "mainuser" with ID 1000 is present. The password for this user is "password".  
If you run a container from it with no command (defaults to a Bash session), you'll see something like "root@a34836157dfb@host". The part "@host" means that the container is run on a host system whose name was not passed to the container. In fact, this part is intended to show the *hostname* of the host machine. This is useful when you have to SSH and work inside multiple containers running on multiple remote machines. Read the following explanations for how to provide this name.

### Customization

Two ways are possible to pass the host machine's name:

* Statically: the image itself can store this information if you specify `--build-arg PARENT_HOSTNAME=the-host-name` when you execute this Dockerfile. Of course I suggest to use `--build-arg PARENT_HOSTNAME=$(hostname)`. This method can be useful if the image and all its descendants are planned to be run on one machine only, or to set a default name other than "host". This avoids the need to use the dynamic method for all your containers.
* Dynamically: even if you have used the static method (the dynamic one overrides the static one), you can always start a container (from this image or a descendant) with `-e PARENT_HOSTNAME=$(hostname)`.

In all cases, a running container will contain an environment variable called PARENT_HOSTNAME whose value is the host machine's name (displayed in the prompt).

You can also statically customize the login, ID, and password (might be useful in some cases) of the normal user by specifying (for example)  
`--build-arg MAIN_USER_LOGIN=batman`  
`--build-arg MAIN_USER_ID=1006`  
`--build-arg main_user_passwd='$1$3zQH3LzF$btPwP2cM/fbEDxGFTJBIq/'`  
when you execute this Dockerfile.

The value you give to main_user_password must be the *openSSL hash* of the real password ; run `openssl passwd -1` then enter the real password to obtain the hash.  
The value you give to MAIN_USER_ID is for both UID and GID of the user to be created.

If you want to apply a particular system timezone, use for example `--build-arg SYSTEM_TIMEZONE=Europe/Paris` or `--build-arg SYSTEM_TIMEZONE=$(cat /etc/timezone)`. The default is Etc/UTC.  
If you want to apply a particular default locale, use for example `--build-arg default_locale=fr_FR.UTF-8`. The default is en_US.UTF-8.

Arguments in uppercase will result in environment variables inside the containers, while arguments in lowercase will not.

Since the *container's name* is not known inside the container itself, it can be passed dynamically. Starting your container with `-e CONTAINER_NAME=the-container-name` will result to a better prompt, like "root@the-container-name@host".  
Warning! This method does NOT replace the real *hostname* of the container, which always looks something like "a34836157dfb". Also, if you provide a name (via `--name`) that is different from the `-e CONTAINER_NAME` method, the interest seems to be limited. Anyway, for now the CONTAINER_NAME environment variable is used in the Bash prompt only.

### Finally

Once this image is built, you can create images that are based on it.  
The login, ID and password of the normal user can be changed dynamically if you define an *entrypoint* that uses tools like usermod/groupmod.
