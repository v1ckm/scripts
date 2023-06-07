#!/bin/sh

# INSTRUCTIONS
# Create Docker container: docker run -it -p 6080:6080 --rm alpine
# Run script: wget -q -O - https://raw.githubusercontent.com/v1ckm/scripts/main/desktopsetup.sh | sh

# install required packages
apk --no-cache add bash firefox git openbox python2 python3 supervisor terminus-font ttf-inconsolata xterm xvfb x11vnc

# Create vnc user
adduser -D vnc

# Update supervisord.conf
su vnc -c 'echo "[unix_http_server]" >> $HOME/supervisord.conf'
su vnc -c 'echo "file=%(here)s/supervisord.sock" >> $HOME/supervisord.conf'
su vnc -c 'echo "" >> $HOME/supervisord.conf'
su vnc -c 'echo "[supervisord]" >> $HOME/supervisord.conf'
su vnc -c 'echo "logfile=%(here)s/supervisord.log" >> $HOME/supervisord.conf'
su vnc -c 'echo "" >> $HOME/supervisord.conf'
su vnc -c 'echo "[rpcinterface:supervisor]" >> $HOME/supervisord.conf'
su vnc -c 'echo "supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface" >> $HOME/supervisord.conf'
su vnc -c 'echo "" >> $HOME/supervisord.conf'
su vnc -c 'echo "[supervisorctl]" >> $HOME/supervisord.conf'
su vnc -c 'echo "serverurl=unix://%(here)s/supervisord.sock" >> $HOME/supervisord.conf'
su vnc -c 'echo "" >> $HOME/supervisord.conf'
su vnc -c 'echo "[program:Xvfb]" >> $HOME/supervisord.conf'
su vnc -c 'echo "autorestart=true" >> $HOME/supervisord.conf'
su vnc -c 'echo "command=/usr/bin/Xvfb" >> $HOME/supervisord.conf'
su vnc -c 'echo "priority=1" >> $HOME/supervisord.conf'
su vnc -c 'echo "redirect_stderr=true" >> $HOME/supervisord.conf'
su vnc -c 'echo "stdout_logfile=%(here)s/Xvfb.log" >> $HOME/supervisord.conf'
su vnc -c 'echo "stdout_logfile_maxbytes=0" >> $HOME/supervisord.conf'
su vnc -c 'echo "stdout_logfile_backups=0" >> $HOME/supervisord.conf'
su vnc -c 'echo "" >> $HOME/supervisord.conf'
su vnc -c 'echo "[program:openbox-session]" >> $HOME/supervisord.conf'
su vnc -c 'echo "autorestart=true" >> $HOME/supervisord.conf'
su vnc -c 'echo "command=/usr/bin/openbox-session" >> $HOME/supervisord.conf'
su vnc -c 'echo "environment=DISPLAY=":0.0"" >> $HOME/supervisord.conf'
su vnc -c 'echo "priority=2" >> $HOME/supervisord.conf'
su vnc -c 'echo "redirect_stderr=true" >> $HOME/supervisord.conf'
su vnc -c 'echo "stdout_logfile=%(here)s/openbox-session.log" >> $HOME/supervisord.conf'
su vnc -c 'echo "stdout_logfile_maxbytes=0" >> $HOME/supervisord.conf'
su vnc -c 'echo "stdout_logfile_backups=0" >> $HOME/supervisord.conf'
su vnc -c 'echo "" >> $HOME/supervisord.conf'
su vnc -c 'echo "[program:x11vnc]" >> $HOME/supervisord.conf'
su vnc -c 'echo "autorestart=true" >> $HOME/supervisord.conf'
su vnc -c 'echo "command=/usr/bin/x11vnc -display :0" >> $HOME/supervisord.conf'
su vnc -c 'echo "priority=3" >> $HOME/supervisord.conf'
su vnc -c 'echo "redirect_stderr=true" >> $HOME/supervisord.conf'
su vnc -c 'echo "stdout_logfile=%(here)s/x11vnc.log" >> $HOME/supervisord.conf'
su vnc -c 'echo "stdout_logfile_maxbytes=0" >> $HOME/supervisord.conf'
su vnc -c 'echo "stdout_logfile_backups=0" >> $HOME/supervisord.conf'
su vnc -c 'echo "" >> $HOME/supervisord.conf'
su vnc -c 'echo "[program:novnc_proxy]" >> $HOME/supervisord.conf'
su vnc -c 'echo "autorestart=true" >> $HOME/supervisord.conf'
su vnc -c 'echo "command=%(here)s/noVNC-1.4.0/utils/novnc_proxy --vnc localhost:5900" >> $HOME/supervisord.conf'
su vnc -c 'echo "priority=4" >> $HOME/supervisord.conf'
su vnc -c 'echo "redirect_stderr=true" >> $HOME/supervisord.conf'
su vnc -c 'echo "stdout_logfile=%(here)s/x11vnc.log" >> $HOME/supervisord.conf'
su vnc -c 'echo "stdout_logfile_maxbytes=0" >> $HOME/supervisord.conf'
su vnc -c 'echo "stdout_logfile_backups=0" >> $HOME/supervisord.conf'

# install python2.7 pip
su vnc -c 'export PATH=$HOME/.local/bin:$PATH; cd $HOME; wget https://bootstrap.pypa.io/pip/2.7/get-pip.py'
su vnc -c 'export PATH=$HOME/.local/bin:$PATH; cd $HOME; python get-pip.py'

# install pyxdg
su vnc -c 'export PATH=$HOME/.local/bin:$PATH; cd $HOME; pip install pyxdg'

# Copy openbox config and autostart firefox
su vnc -c 'cp -r /etc/xdg/openbox ~/.config'
su vnc -c 'mkdir ~/.config/openbox'
su vnc -c 'echo "firefox &" > ~/.config/openbox/autostart'
su vnc -c 'chmod +x ~/.config/openbox/autostart'

# install novnc
su vnc -c 'cd $HOME; wget https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz'
su vnc -c 'cd $HOME; tar -xzvf v1.4.0.tar.gz'

echo "### DONE ###"
echo "Visit http://localhost:6080/vnc.html"

# start supervisord
su vnc -c '/usr/bin/supervisord -c $HOME/supervisord.conf -y 0 -z 0'
