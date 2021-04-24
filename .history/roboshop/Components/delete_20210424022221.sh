[Unit]
Description=Student Service 
After=network.target remote-fs.target nss-lookup.target


[Service]
ExecStart=/home/student/apache-tomcat-8.5.65/bin/startup.sh start   
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
ExecStop=home/student/apache-tomcat-8.5.65/bin/shutdown.sh start
# We want systemd to give httpd some time to finish gracefully, but still want
# it to kill httpd after TimeoutStopSec if something went wrong during the
# graceful stop. Normally, Systemd sends SIGTERM signal right after the
# ExecStop, which would kill httpd. We are sending useless SIGCONT here to give
# httpd time to finish.
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target