
# Image containing:
# 1.  Ubuntu:18.04
# 2.  Java (1.8)
# 3.  Maven (3.5.4)
# 4.  Node.js (12.19.0)
# 5.  NPM (6.14.8)
# 6.  Yarn (1.5.1)
# 7.  Bower (1.8.2)
# 8.  python 2.7 + 3.6 + pip + pip3 + pipenv
# 9.  Gradle (6.0.1)
# 10. Go (1.12.6)
# 11. Ruby, rbenv and ruby-build
# 12. Scala (2.12.6)
# 13. SBT (1.5.1)
# 14. Utils - wget, curl, git, unzip, gnupg, locales
USER_HOME="/root"
JAVA_VERSION=8
GRADLE_VERSION=6.0.1
GOLANG_VERSION=1.12.6
SCALA_VERSION=2.12.6
SBT_VERSION=1.5.1
YARN_VERSION=1.5.1
MAVEN_VERSION=3.5.4
MAVEN_BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
MAVEN_VERSION_SHA=CE50B1C91364CB77EFE3776F756A6D92B76D9038B0A0782F7D53ACF1E997A14D


export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

### Install wget, curl, git, unzip, gnupg, locales
apt-get update -y && \
	apt-get -y install wget curl git unzip gnupg locales && \
	locale-gen en_US.UTF-8 && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

### Install Java openjdk 8
echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu bionic main" | tee /etc/apt/sources.list.d/ppa_openjdk-r.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys DA1A4A13543B466853BAF164EB9B1D8886F44E2A && \
    apt-get update -y && \
    apt-get -y install openjdk-${JAVA_VERSION}-jdk && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

### Install Maven (3.5.4)
mkdir -p /usr/share/maven /usr/share/maven/ref && \
	curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
	echo "${MAVEN_VERSION_SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - && \
	tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 && \
	rm -f /tmp/apache-maven.tar.gz && \
	ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
	mkdir -p -m 777 ${USER_HOME}/.m2/repository && \
	rm -rf /tmp/*
export MAVEN_HOME=/usr/share/maven
export MAVEN_CONFIG=${USER_HOME}/.m2


### Install Node.js (12.19.0) + NPM (6.14.8)
apt-get update -y && \
	curl -sL https://deb.nodesource.com/setup_12.x | bash && \
    apt-get install -y nodejs build-essential && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

### Install Yarn
npm i -g yarn@${YARN_VERSION}

### Install Bower + provide premmsions
npm i -g bower --allow-root && \
	echo '{ "allow_root": true }' > ${USER_HOME}/.bowerrc

### Install Gradle
wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt && \
    rm gradle-${GRADLE_VERSION}-bin.zip

### Set Gradle in the environment variables
export GRADLE_HOME=/opt/gradle-${GRADLE_VERSION}
export PATH=$PATH:/opt/gradle-${GRADLE_VERSION}/bin

### Install all the python2.7 + python3.6 packages
apt-get update && \
	apt-get install -y python3-pip python3.6-venv && \
    apt-get install -y python-pip && \
    pip3 install pipenv && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

# python utilities
python -m pip install --upgrade pip && \
    python3 -m pip install --upgrade pip && \
    python -m pip install virtualenv && \
    python3 -m pip install virtualenv

### python3.7 (used with UA flag: 'python.path')
apt-get update && \
    apt-get install -y python3.7 python3.7-venv && \
    python3.7 -m pip install --upgrade pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
    
# # Update Install Packages

apt-get update && apt-get install -y --no-install-recommends ca-certificates curl wget

# # Set Environment Variables
export PYTHON_VERSION=2.7.13
export PYTHON_PIP_VERSION=9.0.1

# # Download Packages
wget  https://github.com/whitesource/unified-agent-distribution/blob/master/standAlone/wss-unified-agent.jar

apt-get update && apt-get install -y

### Install GO
mkdir -p ${USER_HOME}/goroot && \
    curl https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz | \
    tar xvzf - -C ${USER_HOME}/goroot --strip-components=1

## Set GO environment variables
export GOROOT=${USER_HOME}/goroot
export GOPATH=${USER_HOME}/gopath
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

## Install package managers
go get -u github.com/golang/dep/cmd/dep
go get github.com/tools/godep
go get github.com/LK4D4/vndr
go get -u github.com/kardianos/govendor
go get -u github.com/gpmgo/gopm
go get github.com/Masterminds/glide

### Install Ruby
apt-get update && \
	apt-get install -y ruby ruby-dev ruby-bundler && \
    apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

### Install rbenv and ruby-build
git clone https://github.com/sstephenson/rbenv.git /.rbenv; \
	git clone https://github.com/sstephenson/ruby-build.git /.rbenv/plugins/ruby-build; \
	/.rbenv/plugins/ruby-build/install.sh && \
	echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh && \
	echo 'eval "$(rbenv init -)"' >> /.bashrc
export PATH=/.rbenv/bin:$PATH

apt-get update -y && \
	apt-get install -y --force-yes build-essential && \
	apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

### Install Scala
wget https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.deb --no-check-certificate && \
	dpkg -i scala-${SCALA_VERSION}.deb && \
	rm scala-${SCALA_VERSION}.deb

### Install SBT
wget https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz && \
	tar xzvf sbt-${SBT_VERSION}.tgz -C /usr/share/ && \
	update-alternatives --install /usr/bin/sbt sbt /usr/share/sbt/bin/sbt 9998
export SBT_HOME=/usr/share/sbt/bin/
export PATH=$PATH:$SBT_HOME


### Install dotnet cli/ Nuget/ sdk-2.2 and sdk-3.1 and sdk-5.0
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
	dpkg -i packages-microsoft-prod.deb && \
	apt-get update && \
	apt-get install -y apt-transport-https && \
	apt-get install -y dotnet-sdk-2.2 && \
	apt-get install -y dotnet-sdk-3.1 && \
	apt-get install -y dotnet-sdk-5.0 && \
	apt-get install -y nuget && \
	rm packages-microsoft-prod.deb && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*
	
gem install bundler -v 2.1.4
nuget update -self
	
apt-get update -y 
