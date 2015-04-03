build:
	sudo docker.io build --no-cache -t aoki/stanza .

install:

run:
	sudo docker.io run -d --restart="always" --link glytoucan-apache:test.ts.glytoucan.org -p 9292:9292 --name="stanza_bluetree" aoki/stanza

runtest:
	sudo docker.io run -d --restart="always" -p 9292:9292 --name="stanza_bluetree" aoki/stanza

bash:
	sudo docker.io run -it -v /opt/stanza:/stanza:rw --link glytoucan_prod:test.ts.glytoucan.org aoki/stanza /bin/bash

#runtest:
#	sudo docker run --rm -P --name stanza_bio_test aoki/stanza

#run-linked:
#	sudo docker run --rm -t -i -link stanza_bluetree:stanza aoki/stanza bash

backup:
	sudo docker run --rm --volumes-from stanza_bluetree -t -i busybox sh

clean: stop rm build run
	echo "clean"

cleanall: rmdir clean
	echo "clean"

rmdir: 
	sudo rm -rf /opt/stanza/*

setup:
	sudo ./setup.sh

ps:
	sudo docker.io ps

stop:
	sudo docker.io stop stanza_bluetree

logs:
	sudo docker.io logs -f --tail=100 stanza_bluetree

rm:
	sudo docker.io rm stanza_bluetree

ip:
	sudo docker.io inspect -f "{{ .NetworkSettings.IPAddress }}" stanza_bluetree

ssh:
#	ssh -i /usr/local/share/baseimage-docker/insecure_key root@172.17.0.8
	sudo docker-ssh stanza_bluetree

restart:
	sudo docker.io restart stanza_bluetree

dump:
	sudo docker.io export stanza_bluetree > stanza.glycoinfo.tar

load:
	cat stanza.glycoinfo.tar.gz | docker import - aoki/docker-stanza:stanza_bluetree
	
.PHONY: build run test clean
