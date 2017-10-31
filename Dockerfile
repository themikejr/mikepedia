FROM node:8.8.1

RUN mkdir /root/mikepedia_static

# COPY mikepedia / hexo src
RUN mkdir /root/mikepedia
COPY ./mikepedia_hexo /root/mikepedia

# COPY custom theme
RUN mkdir /root/mikepedia/themes
COPY ./cactus-dark /root/mikepedia/themes/cactus-dark

# Create bare hexo repository for deployment
RUN git init --bare /root/hexo_bare
COPY post-receive /root/hexo_bare/hooks/

# Cron job for daily fresh deployment
COPY deploy-blog.sh /etc/cron.daily/

# Install dropbox
#RUN mkdir /opt/dropbox
#COPY dropbox-linux.tar.gz /tmp/
#RUN tar xzfv /tmp/dropbox-linux.tar.gz --strip 1 -C /opt/dropbox
#COPY dropbox.py /opt/dropbox/
#RUN /opt/dropbox/dropboxd
#RUN chmod +x /opt/dropbox/dropbox.py
#RUN /opt/dropbox/dropbox.py exclude add ~/Dropbox/2012
#RUN /opt/dropbox/dropbox.py exclude add ~/Dropbox/Agape\ Bible\ Fellowship\ Group
#RUN echo "@reboot root /opt/dropbox/dropboxd" >> /etc/crontab
RUN mkdir /root/Dropbox
COPY blog_posts/ /root/Dropbox/blog_posts

#RUN echo "deb http://archive.ubuntu.com/ubuntu/ raring main universe" >> /etc/apt/sources.list
RUN apt update
RUN apt-get install -y nginx

COPY nginx-default /etc/nginx/sites-available/default

RUN service nginx restart

WORKDIR /root/mikepedia
RUN /root/mikepedia/hexo_git_deploy.sh

EXPOSE 80
EXPOSE 4000
