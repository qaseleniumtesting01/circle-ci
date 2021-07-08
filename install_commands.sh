
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




### Install Gradle
wget -q https://services.gradle.org/distributions/gradle-6.0.1-bin.zip && \
    unzip gradle-6.0.1-bin.zip -d /opt && \
    rm gradle-6.0.1-bin.zip
### Set Gradle in the environment variables
export GRADLE_HOME=/opt/gradle-6.0.1
export PATH=$PATH:/opt/gradle-6.0.1/bin

echo GRADLE_HOME
echo PATH

