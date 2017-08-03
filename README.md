# debian9-workbase
A customized minimal Debian 9 Docker image with one regular user, one text editor and a nicer prompt.

## Goal

I often need to build Debian-based Docker images that, in addition to their main purpose (web server, etc), must have the minimal set of tools so I can work inside the container with command line.  
Also, containers from those images often must perform actions with UID/GID != 0, typically for dealing with regular users files that are shared between host and containers.  
Finally, that's not because it's "only" a container that a Bash session in it have to be ugly. When I type commands that produce large lines of results, I like to distinguish easily commands from results.

That's why I wrote this Dockerfile.  
It builds an image that is intended to be **a base for building other images** which need these requirements. The installed text editor is Nano. See the Dockerfile for a complete list of what is installed.

## How to use

### Basic build

With no customization (see below), this will produce a Debian 9.0 image in which a user called "mainuser" with ID 1000 is present. The password for this user is "password".  
If you run a container from it with no command (defaults to a Bash session), you'll see something like "root@a34836157dfb@host". The part "@host" means that the container is run on a host system whose name was not passed to the container. In fact, this part is intended to show the *hostname* of the host machine. This is useful when you have to SSH inside multiple containers running on multiple remote machines. Read the following explanations to know how to provide this name.

### Customization

Two ways are possible to pass the host machine's name:

* Statically: the image itself can store this information if you specify `--build-arg PARENT_HOSTNAME=the-host-name` when using this Dockerfile. Of course I suggest to use `--build-arg PARENT_HOSTNAME=$(hostname)`. This method can be useful if the image and all its descendants are planned to be used on one machine only, or to set a default name other than "host". This avoids the need of using the dynamic method for all your containers.
* Dynamically: even if you have used the static method (the dynamic one overrides the static one), you can always start a container (from this image or a descendant) with `-e PARENT_HOSTNAME=$(hostname)`.

In all cases, a running container will contain an environment variable called PARENT_HOSTNAME whose value is the host machine's name (displayed in the prompt).

You can also statically customize the login, ID, and password (might be useful in some cases) of the normal user by specifying (examples):  
`--build-arg MAIN_USER_LOGIN=batman`  
`--build-arg MAIN_USER_ID=1006`  
`--build-arg main_user_passwd=l5KfQR935b0s`  
when using this Dockerfile.

The value you give to main_user_password must be the *openSSL hash* of the real password ; use `openssl passwd` then enter the real password to obtain the hash.  
The value you give to MAIN_USER_ID is for both UID and GID of the user to be created.

Arguments in uppercase will result in environment variables inside the containers, while arguments in lowercase will not.

### Finally

Once this image is built, you can create images that are based on it.  
The login, ID and password of the normal user can be changed dynamically if you define an *entrypoint* that uses tools like usermod/groupmod.
