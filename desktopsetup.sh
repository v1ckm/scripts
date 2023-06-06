#!/bin/sh

# change to home directory
cd

# install required packages
apk --no-cache add bash firefox git openbox python2 python3 supervisor terminus-font ttf-inconsolata xterm xvfb x11vnc

# Copy openbox config
cp -vr /etc/xdg/openbox ~/.config

# autostart firefox
mkdir -v ~/.config/openbox
echo 'firefox &' | tee -a ~/.config/openbox/autostart
chmod -v +x ~/.config/openbox/autostart

# install python 2.7
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
python get-pip.py

# install pyxdg
pip install pyxdg

# install novnc
wget https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz
tar -xzvf v1.4.0.tar.gz

# configure supervisord
mkdir -v /etc/supervisor.d
echo "[program:Xvfb]
autorestart=true
command=/usr/bin/Xvfb
priority=1
redirect_stderr=true
stdout_logfile=/var/log/Xvfb.log
stdout_logfile_maxbytes=0
stdout_logfile_backups=0

[program:openbox-session]
autorestart=true
command=/usr/bin/openbox-session
environment=DISPLAY=":0.0"
priority=2
redirect_stderr=true
stdout_logfile=/var/log/openbox-session.log
stdout_logfile_maxbytes=0
stdout_logfile_backups=0

[program:x11vnc]
autorestart=true
command=/usr/bin/x11vnc -display :0
priority=3
redirect_stderr=true
stdout_logfile=/var/log/x11vnc.log
stdout_logfile_maxbytes=0
stdout_logfile_backups=0

[program:novnc_proxy]
autorestart=true
command=/root/noVNC-1.4.0/utils/novnc_proxy --vnc localhost:5900
priority=4
redirect_stderr=true
stdout_logfile=/var/log/x11vnc.log
stdout_logfile_maxbytes=0
stdout_logfile_backups=0" | tee -a /etc/supervisor.d/vnc.ini

# start supervisord
exec /usr/bin/supervisord -y 0 -z 0
