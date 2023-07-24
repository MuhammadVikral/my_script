#!/usr/bin/env fish

sudo archlinux-java set java-8-openjdk/jre
set -Ux JAVA_HOME /usr/lib/jvm/java-8-openjdk/jre/
java -version
echo $JAVA_HOME
