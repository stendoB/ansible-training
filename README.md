Návod:
0.	VM musí mať prístup na internet a root práva musia byť použiteľné
1.	Skopírovať package a rozbaliť ho v Linux VM-ke
2.	Nainštalovať docker podľa návodu tu: 
a.	Ubuntu: https://docs.docker.com/engine/install/ubuntu/
b.	Debian: https://docs.docker.com/engine/install/debian/
c.	CentOS/RedHat/OracleLinux: https://docs.docker.com/engine/install/centos/
3.	Vôjsť do priečinku ansible_training vo VM kde ste si rozbalili package
4.	Pridať execute práva pre skript príkazom: chmod +x container-start-stop.sh
5.	Spustiť skript na vytvorenie Docker containerov príkazom: sudo bash container-start-stop.sh start
6.	Skript má nasledovné použiteľné príkazy:
sudo bash container-start-stop.sh start/stop
sudo bash container-start-stop.sh debian-start/debian-stop
sudo bash container-start-stop.sh ubuntu-start/ubuntu-stop
sudo bash container-start-stop.sh centos-start/centos-stop
7.	Po spustení Docker containerov sa ansible volá nasledujúcimi príkazmi.
a.	sudo ansible all -i ansible/env/local_docker <ďalšie_nastavenia>
b.	sudo ansible-playbook -i ansible/env/local_docker <cesta_k_playbooku>
