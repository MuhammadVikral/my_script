#!/usr/bin/env fish

sudo archlinux-java set java-11-openjdk
set -x JAVA_HOME /usr/lib/jvm/java-11-openjdk
java -version
echo $JAVA_HOME
