FROM ubuntu:20.04
LABEL About: "Ubuntu20.04_Fluxbox_NoVNC"
LABEL Maintainer: "Apoorv Vyavahare <apoorvvyavahare@pm.me>"
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive \
#VNC Server Password
	VNC_PASS="" \
#VNC Server Title(w/ spaces)
	VNC_TITLE="" \
#VNC Resolution(720p is preferable)
	VNC_RESOLUTION="1280x720" \
#Local Display Server Port
	DISPLAY=:0 \
#NoVNC Port
	NOVNC_PORT=$PORT \
#Ngrok Token
	NGROK_TOKEN="" \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8
COPY . /app
RUN rm -rf /etc/apt/sources.list && \
#All Official Focal Repos
	bash -c 'echo -e "deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse\ndeb http://archive.canonical.com/ubuntu focal partner\ndeb-src http://archive.canonical.com/ubuntu focal partner" >/etc/apt/sources.list' && \
	rm /bin/sh && ln -s /bin/bash /bin/sh && \
	apt-get update && \
	apt-get install -y \
#Packages Installation
	tzdata \
	software-properties-common \
	apt-transport-https \
	wget \
	git \
	curl \
	vim \
	zip \
	net-tools \
	iputils-ping \
	build-essential \
	python3 \
	python3-pip \
	python-is-python3 \
	perl \
	ruby \
	golang \
	lua5.3 \
	scala \
	mono-complete \
	r-base \
	default-jre \
	default-jdk \
	clojure \
	php \
	firefox \
	gnome-terminal \
	gnome-calculator \
	gnome-system-monitor \
	gedit \
	vim-gtk3 \
	mousepad \
	libreoffice \
	pcmanfm \
	snapd \
	terminator \
	websockify \
	supervisor \
	x11vnc \
	xvfb \
	gnupg \
	dirmngr \
	gdebi-core \
	nginx \
	novnc \
#Fluxbox
	/app/fluxbox-heroku-mod.deb && \
#MATE Desktop
	#apt install -y \ 
	#ubuntu-mate-core \
	#ubuntu-mate-desktop && \
#XFCE Desktop
	#apt install -y \
	#xubuntu-desktop && \
#VNC
	x11vnc -storepasswd $VNC_PASS /etc/xpass && \
#NoVNC
	cp /usr/share/novnc/vnc.html /usr/share/novnc/index.html && \
	openssl req -new -newkey rsa:4096 -days 36500 -nodes -x509 -subj "/C=IN/ST=Maharastra/L=Private/O=Dis/CN=www.google.com" -keyout /etc/ssl/novnc.key  -out /etc/ssl/novnc.cert && \
#VS Code
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
	install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
	sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
	rm -f packages.microsoft.gpg && \
	apt install apt-transport-https && \
	apt update && \
	apt install code -y && \
	cd /usr/bin && \
#Brave
	curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list && \
	apt update && \
	apt install brave-browser -y && \
#PeaZip
	wget https://github.com/peazip/PeaZip/releases/download/7.9.0/peazip_7.9.0.LINUX.x86_64.GTK2.deb && \
	dpkg -i peazip_7.9.0.LINUX.x86_64.GTK2.deb && \
	rm -rf peazip_7.9.0.LINUX.x86_64.GTK2.deb && \
#Sublime
	curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add - && \
	add-apt-repository "deb https://download.sublimetext.com/ apt/stable/" && \
	apt install -y sublime-text && \
#TeamViewer
	wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb -P /tmp && \
	apt install -y /tmp/teamviewer_amd64.deb && \
	rm -rf /tmp/teamviewer_amd64.deb && \
#Ngrok
	chmod +x /app/ngrok_install.sh && \
	/app/ngrok_install.sh
CMD supervisord -c /app/supervisord.conf