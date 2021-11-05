#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

DOCKER_CONTAINER_ubuntu="ansible-test_ubuntu"
DOCKER_CONTAINER_centos="ansible-test_centos"
DOCKER_CONTAINER_debian="ansible-test_debian"

case $1 in
	start)
	cd docker/${DOCKER_CONTAINER_ubuntu} && docker build -t ansible_ubuntu . && cd ../..
	cd docker/${DOCKER_CONTAINER_centos} && docker build -t ansible_centos . && cd ../..
	cd docker/${DOCKER_CONTAINER_debian} && docker build -t ansible_debian . && cd ../..
	
	docker run -ti --privileged --name ${DOCKER_CONTAINER_ubuntu} -d -p 5000:22 ansible_ubuntu
	sleep 5
	docker run -ti --privileged --name ${DOCKER_CONTAINER_centos} -d -p 5001:22 ansible_centos
	sleep 5
	docker run -ti --privileged --name ${DOCKER_CONTAINER_debian} -d -p 5002:22 ansible_debian

	printf "\n[local]\n${DOCKER_CONTAINER_ubuntu} ansible_connection=docker\n${DOCKER_CONTAINER_centos} ansible_connection=docker\n${DOCKER_CONTAINER_debian} ansible_connection=docker" > ./ansible/env/local_docker
	;;

	stop)
	docker stop ${DOCKER_CONTAINER_ubuntu}
	docker stop ${DOCKER_CONTAINER_centos}
	docker stop ${DOCKER_CONTAINER_debian}
	
	sleep 5

	docker rm ${DOCKER_CONTAINER_ubuntu}
	docker rm ${DOCKER_CONTAINER_centos}
	docker rm ${DOCKER_CONTAINER_debian}
	;;
	
	debian-start)
	cd docker/${DOCKER_CONTAINER_debian} && docker build -t ansible_debian . && cd ../..
	docker run -ti --privileged --name ${DOCKER_CONTAINER_debian} -d -p 5002:22 ansible_debian
	printf "\n[local]\n${DOCKER_CONTAINER_ubuntu} ansible_connection=docker\n${DOCKER_CONTAINER_centos} ansible_connection=docker\n${DOCKER_CONTAINER_debian} ansible_connection=docker" > ./ansible/env/local_docker
	;;
	
	debian-stop)
	docker stop ${DOCKER_CONTAINER_debian}
	sleep 5
	docker rm ${DOCKER_CONTAINER_debian}
	;;
	
	ubuntu-start)
	cd docker/${DOCKER_CONTAINER_ubuntu} && docker build -t ansible_ubuntu . && cd ../..
	docker run -ti --privileged --name ${DOCKER_CONTAINER_ubuntu} -d -p 5000:22 ansible_ubuntu
	printf "\n[local]\n${DOCKER_CONTAINER_ubuntu} ansible_connection=docker\n${DOCKER_CONTAINER_centos} ansible_connection=docker\n${DOCKER_CONTAINER_debian} ansible_connection=docker" > ./ansible/env/local_docker
	;;
	
	ubuntu-stop)
	docker stop ${DOCKER_CONTAINER_ubuntu}
	sleep 5
	docker rm ${DOCKER_CONTAINER_ubuntu}
	;;
	
	centos-start)
	cd docker/${DOCKER_CONTAINER_centos} && docker build -t ansible_centos . && cd ../..
	docker run -ti --privileged --name ${DOCKER_CONTAINER_centos} -d -p 5001:22 ansible_centos
	printf "\n[local]\n${DOCKER_CONTAINER_ubuntu} ansible_connection=docker\n${DOCKER_CONTAINER_centos} ansible_connection=docker\n${DOCKER_CONTAINER_debian} ansible_connection=docker" > ./ansible/env/local_docker
	;;
	
	centos-stop)
	docker stop ${DOCKER_CONTAINER_centos}
	sleep 5
	docker rm ${DOCKER_CONTAINER_centos}
	;;
	
	*)
	printf "Usage:\n\tsudo bash $0 start/stop\n\tsudo bash $0 debian-start/debian-stop\n\tsudo bash $0 ubuntu-start/ubuntu-stop\n\tsudo bash $0 centos-start/centos-stop\n"

esac
