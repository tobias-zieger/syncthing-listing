FROM httpd:latest

ARG USERNAME

# This is where the files are mounted to later.
RUN mkdir /data

# Turn on fancy directory listings (with sortable columns).
RUN sed -i "s|#Include conf/extra/httpd-autoindex.conf|Include conf/extra/httpd-autoindex.conf|" /usr/local/apache2/conf/httpd.conf

# Turn off automatically loading index.html etc.
RUN sed -i "s|LoadModule dir_module modules/mod_dir.so|#LoadModule dir_module modules/mod_dir.so|" /usr/local/apache2/conf/httpd.conf

# Change document root to the mounted directory (/data).
RUN sed -i "s|DocumentRoot \"/usr/local/apache2/htdocs\"|DocumentRoot \"/data\"|" /usr/local/apache2/conf/httpd.conf

# Create the new <Directory> section. (We keep the <Directory "/usr/local/apache2/htdocs"> as is. It's now unused anyway.)
RUN cat <<EOF >> /usr/local/apache2/conf/httpd.conf
<Directory "/data">
  Options Indexes
  IndexOptions Charset=UTF-8
  IndexOptions NameWidth=*
  AllowOverride AuthConfig
  AuthType Basic
  AuthName syncthing
  AuthUserFile "/usr/local/apache2/passwords"
  Require user ${USERNAME}
</Directory>
EOF

# Create the password file.
RUN --mount=type=secret,id=password htpasswd -bc /usr/local/apache2/passwords "${USERNAME}" "$(cat /run/secrets/password)"
