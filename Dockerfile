FROM debian:10

#WORKDIR /tmp

RUN apt-get update && apt-get install openjdk-11-jdk -y && \
apt-get install apt-transport-https jruby -y && \
apt-get install texinfo build-essential ant git -y

RUN git clone https://github.com/jnr/jffi && cd jffi/ && ant jar

RUN apt-get install wget -y
RUN wget https://artifacts.elastic.co/downloads/logstash/logstash-7.9.3.deb
RUN dpkg -i --force-all logstash-7.9.3.deb

RUN ls /usr/share/logstash/vendor/jruby/lib/jni/arm-Linux/
RUN cp jffi/build/jni/libjffi-1.3.so /usr/share/logstash/vendor/jruby/lib/jni/arm-Linux/libjffi-1.3.so

CMD ["/usr/share/logstash/bin/logstash", "-f",  "/etc/logstash/conf.d", "-l", "/var/log/logstash", "--log.level=info", "--path.settings=/etc/logstash"]