# Syncthing Listing
[https://syncthing.net/](Syncthing) is a tool to synchronize your files, just like, for example, Nextcloud. However, it's not centralized and doesn't need a central server.

In practice, however, you might use one peer (that is always on) as the blessed peer. For this, it's handy if it can display your files, so you have access to them even on computers where
Syncthing is not installed. Syncthing itself doesn't offer such functionality and concentrates only on file syncing.

This image starts an Apache webserver that displays (read-only) the contents of your Syncthing installation.


## Usage

The idea is that you have a directory on your blessed peer that contains all your Syncthing directories, e.g., ~/syncthing (containing Invoices/, Photos/, Work/, etc.).

Further, the listing should be access-controlled (via HTTP authentication). So you need to make up a username and a password.

Build the image like this:
```
PASSWORD="the password" docker build --tag syncthing-listing --build-arg USERNAME="the username" --secret id=password,env=PASSWORD .
```
You should replace the username and the password in quotation marks with the values of your own choice.

Run the image like this:
```
docker run -it -p 8081:80 -v ~/syncthing:/data:ro syncthing-listing
```

Adjust the port on the host after your liking.

The above command will not return you the prompt in the shell. If you want that you need to append a `&` to the command. If you then want to stop the container, issue `docker container list` to get the name of the container and then `docker container stop <containername>` to actually stop it.

If you want to get a shell in the container, append a `/bin/bash` to the run command. Then, inside the container, you may want to call `apachectl start` to start the server in the background.

Notes:
* The file permissions are not changed/translated from the host to the container. The files need to be world-readable so that Apache can actually deliver them to the browser.
* There is no SSL/HTTPS involved here. It's treated as out of scope here and expected to be added independently with some reverse proxy mechanism that does the SSL termination.

