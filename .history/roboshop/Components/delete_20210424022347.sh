[Unit]
Description=Student Service 
After=network.target remote-fs.target nss-lookup.target


[Service]
ExecStart=/home/student/apache-tomcat-8.5.65/bin/startup.sh start   
ExecReload=/home/student/apache-tomcat-8.5.65/bin/startup.sh restart 
ExecStop=/home/student/apache-tomcat-8.5.65/bin/shutdown.sh stop 
Type=forking

[Install]
WantedBy=multi-user.target