build:
	sudo docker build -t aoki/stanza .

buildnc:
	sudo docker build --no-cache -t aoki/stanza .

install:

runprod:
	sudo docker run -d --restart="always" --link apache-stanza.redirect:test.ts.glytoucan.org --link apache-stanza.redirect:rdf.glytoucan.org -v /mnt/jenkins/workspace:/app --name="prod.stanza_bluetree" aoki/stanza 

run:
	sudo docker run -d --restart="always" -link glytoucan-apache:test.ts.glytoucan.org -p 9292:80 --name="stanza_bluetree" aoki/stanza

rundev:
	sudo docker run -d --restart="always" -p 9292:80 -v /home/aoki/workspace:/app --link apache-stanza.redirect:rdf.glytoucan.org --link apache-stanza.redirect:test.ts.glytoucan.org --name="beta.stanza_bluetree" aoki/stanza 
#--link rdf.glytoucan:rdf.glytoucan.org 

runbeta:
	sudo docker run -d --restart="always" --link apache-stanza.redirect:rdf.glytoucan.org -v /mnt/jenkins/workspace:/app --name="beta.stanza_bluetree" aoki/stanza 
# dont need this --link apache-stanza.redirect:test.ts.glytoucan.org

runtest:
	sudo docker run -d --restart="always" -p 9292:80 -v /mnt/jenkins/workspace:/app --name="stanza_bluetree" aoki/stanza

bash:
	sudo docker run -it -v /opt/stanza:/stanza:rw -v ~/workspace:/app aoki/stanza /bin/bash

#runtest:
#	sudo docker run --rm -P --name stanza_bio_test aoki/stanza

#run-linked:
#	sudo docker run --rm -t -i -link stanza_bluetree:stanza aoki/stanza bash

backup:
	sudo docker run --rm --volumes-from stanza_bluetree -t -i busybox sh

clean: stop rm build run
	echo "clean"

cleanprod:
	sudo docker stop prod.stanza_bluetree
	sudo docker rm prod.stanza_bluetree

cleanbeta:
	sudo docker stop beta.stanza_bluetree
	sudo docker rm beta.stanza_bluetree
	echo "clean"

cleanall: rmdir clean
	echo "clean"

rmdir: 
	sudo rm -rf /opt/stanza/*

setup:
	sudo ./setup.sh

ps:
	sudo docker ps

stop:
	sudo docker stop stanza_bluetree

logs:
	sudo docker logs -f --tail=1000 stanza_bluetree

betalogs:
	sudo docker logs -f --tail=1000 beta.stanza_bluetree

logsbeta:
	sudo docker logs -f --tail=1000 beta.stanza_bluetree

logsprod:
	sudo docker logs -f --tail=1000 prod.stanza_bluetree

rm:
	sudo docker rm stanza_bluetree

ip:
	sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" stanza_bluetree

ssh:
#	ssh -i /usr/local/share/baseimage-docker/insecure_key root@172.17.0.8
	sudo docker-ssh stanza_bluetree

restart:
	sudo docker restart stanza_bluetree

exec:
	sudo docker exec -it stanza_bluetree /bin/bash

dump:
	sudo docker export stanza_bluetree > stanza.glycoinfo.tar

load:
	cat stanza.glycoinfo.tar.gz | docker import - aoki/docker-stanza:stanza_bluetree
	
.PHONY: build run test clean
