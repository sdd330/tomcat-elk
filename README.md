# Tomcat ELK
------------
Dockerfile creating tomcat server with ELK (Elasticsearch/Logstash/Kibana) services

Usage
------------

To start an instance:

	docker run -d --name tomcat-elk-server -p 9200:9200 -p 80:80 -p 8080:8080 sdd330/tomcat-elk

To start with webapp storage on host:

	docker run -d --name tomcat-elk-server -p 9200:9200 -p 80:80 -p 8080:8080 -v <webapp-dir>:/usr/local/tomcat/webapps sdd330/tomcat-elk

To login to bash:
	
	docker exec -it tomcat-elk-server bash
