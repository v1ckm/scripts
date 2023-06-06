#!/bin/sh

# INSTRUCTIONS
# Create Docker container: docker run -it -p 6080:6080 --rm alpine
# Run script: wget -q -O - https://raw.githubusercontent.com/v1ckm/scripts/main/desktopsetup.sh | sh

# install required packages
apk --no-cache add bash firefox git openbox python2 python3 supervisor terminus-font ttf-inconsolata xterm xvfb x11vnc

# Create and change to vnc user
adduser -D vnc
su - vnc

# configure supervisord
cat >$HOME/supervisord.conf <<'EOF'
[unix_http_server]
file=%(here)s/supervisord.sock

[supervisord]

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix://%(here)s/supervisord.sock

[program:Xvfb]
autorestart=true
command=/usr/bin/Xvfb
priority=1
redirect_stderr=true
stdout_logfile=%(here)s/Xvfb.log
stdout_logfile_maxbytes=0
stdout_logfile_backups=0

[program:openbox-session]
autorestart=true
command=/usr/bin/openbox-session
environment=DISPLAY=":0.0"
priority=2
redirect_stderr=true
stdout_logfile=%(here)s/openbox-session.log
stdout_logfile_maxbytes=0
stdout_logfile_backups=0

[program:x11vnc]
autorestart=true
command=/usr/bin/x11vnc -display :0
priority=3
redirect_stderr=true
stdout_logfile=%(here)s/x11vnc.log
stdout_logfile_maxbytes=0
stdout_logfile_backups=0

[program:novnc_proxy]
autorestart=true
command=%(here)s/noVNC-1.4.0/utils/novnc_proxy --vnc localhost:5900
priority=4
redirect_stderr=true
stdout_logfile=%(here)s/x11vnc.log
stdout_logfile_maxbytes=0
stdout_logfile_backups=0
EOF

# install python2.7 pip
export PATH=$HOME/.local/bin:$PATH
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
python get-pip.py

# install pyxdg
pip install pyxdg

# Copy openbox config and autostart firefox
cp -r /etc/xdg/openbox ~/.config
mkdir ~/.config/openbox
echo 'firefox &' > ~/.config/openbox/autostart
chmod +x ~/.config/openbox/autostart

# install novnc
wget https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz
tar -xzvf v1.4.0.tar.gz

echo "### DONE ###"
echo "Visit http://localhost:6080/vnc.html"

# start supervisord
exec /usr/bin/supervisord -c $HOME/supervisord.conf -y 0 -z 0
