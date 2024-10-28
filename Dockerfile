FROM httpd:latest

ARG USERNAME
ARG PASSWORD

# This is where the files are mounted to later.
RUN mkdir /data

# Turn on fancy directory listings (with sortable columns).
RUN sed -i "s|#Include conf/extra/httpd-autoindex.conf|Include conf/extra/httpd-autoindex.conf|" /usr/local/apache2/conf/httpd.conf

# Turn off automatically loading index.html etc.
RUN sed -i "s|LoadModule dir_module modules/mod_dir.so|#LoadModule dir_module modules/mod_dir.so|" /usr/local/apache2/conf/httpd.conf

# Change document root to the mounted directory (/data).
RUN sed -i "s|DocumentRoot \"/usr/local/apache2/htdocs\"|DocumentRoot \"/data\"|" /usr/local/apache2/conf/httpd.conf

# Create the new <Directory> section. (We keep the <Directory "/usr/local/apache2/htdocs"> as is. It's now unused anyway.)
RUN echo "<Directory \"/data\">" >> /usr/local/apache2/conf/httpd.conf
RUN echo "  Options Indexes" >> /usr/local/apache2/conf/httpd.conf
RUN echo "  IndexOptions Charset=UTF-8" >> /usr/local/apache2/conf/httpd.conf
RUN echo "  IndexOptions NameWidth=*" >> /usr/local/apache2/conf/httpd.conf
RUN echo "  AllowOverride AuthConfig" >> /usr/local/apache2/conf/httpd.conf
RUN echo "  AuthType Basic" >> /usr/local/apache2/conf/httpd.conf
RUN echo "  AuthName syncthing" >> /usr/local/apache2/conf/httpd.conf
RUN echo "  AuthUserFile \"/usr/local/apache2/passwords\"" >> /usr/local/apache2/conf/httpd.conf
RUN echo "  Require user ${USERNAME}" >> /usr/local/apache2/conf/httpd.conf
RUN echo "</Directory>" >> /usr/local/apache2/conf/httpd.conf

# Create the password file.
RUN htpasswd -bc /usr/local/apache2/passwords ${USERNAME} ${PASSWORD}

