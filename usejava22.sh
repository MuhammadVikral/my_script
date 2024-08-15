#!/usr/bin/env fish

sudo archlinux-java set java-22-openjdk
set -Ux JAVA_HOME /usr/lib/jvm/java-22-openjdk
java -version
echo $JAVA_HOME
