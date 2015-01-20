# Dockerfile creating tomcat server with ELK (Elasticsearch/Logstash/Kibana) services

# Help:
# Default command: docker run -d --name tomcat-elk-server -p 9200:9200 -p 80:80 -p 8080:8080 sdd330/tomcat-elk
# Default command will start Tomcat (Monitored by ELK) within a docker
# To login to bash: docker exec -it tomcat-elk-server bash

FROM tomcat:7
MAINTAINER yang.leijun@gmail.com

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive
ENV ES_PKG_NAME elasticsearch-1.4.2
ENV KIB_PKG_NAME kibana-4.0.0-beta3
ENV LGS_PKG_NAME logstash-1.4.2

# Install supervisor.
RUN apt-get update && \
	apt-get install -y supervisor && \
	mkdir -p /var/log/supervisor && \
	mkdir -p /etc/supervisor/conf.d

# Install ElasticSearch.
RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

# Install Kibana.
RUN \
  cd / && \
  wget https://download.elasticsearch.org/kibana/kibana/$KIB_PKG_NAME.tar.gz && \
  tar xvzf $KIB_PKG_NAME.tar.gz && \
  rm -f $KIB_PKG_NAME.tar.gz && \
  mv /$KIB_PKG_NAME /kibana
	
# Install Logstash.
RUN \
  cd / && \
  wget https://download.elasticsearch.org/logstash/logstash/$LGS_PKG_NAME.tar.gz && \
  tar xvzf $LGS_PKG_NAME.tar.gz && \
  rm -f $LGS_PKG_NAME.tar.gz && \
  mv /$LGS_PKG_NAME /logstash

# Make image information and configuration self-contained
ADD . /app

# Install elasticsearch Head and Marvel plugins.
RUN /elasticsearch/bin/plugin -i elasticsearch/marvel/latest
RUN /elasticsearch/bin/plugin -install mobz/elasticsearch-head

VOLUME [ "/usr/local/tomcat/webapps" ]

# Define default command.
CMD ["supervisord", "-c", "/app/config/supervisord.conf"]

# Expose ports.
EXPOSE 9200 80 8080