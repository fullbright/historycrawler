#!/bin/bash


echo *************************************
echo **                           	    **
echo ** 	HISTORY CRAWLER		        **
echo **   Install history tools	        **
echo ** 				                **
echo *************************************

echo "Updating the sources list to remove the cdrom"
# the 2 commands below are used to uncomment the cdrom lines
sed -i.bak s/"^#\+ \+deb\ cdrom/deb cdrom/g" /etc/apt/sources.list
sed -i.bak s/"^#\+ \?deb\ cdrom/deb cdrom/g" /etc/apt/sources.list

echo "Commenting the deb cdrom: line in the sources list"
sed -i.bak s/^deb\ cdrom/#\ deb\ cdrom/g /etc/apt/sources.list

echo "Updating the repository and installing the pending updates"
apt-get update
apt-get upgrade -y

echo "Installing required packages for virtualbox additions"
apt-get install dkms -y
apt-get install linux-headers-3.14-1-486 -y

echo "Give the hcu user permissions to interact with shared folder by adding him/her to vboxsf group."
usermod -a -G vboxsf hcu

echo "Image, text and document processing tools and OCR."
apt-get install default-jdk zip unzip -y
apt-get install imagej -y
apt-get install imagemagick -y
apt-get install pandoc -y
apt-get install tre-agrep -y 
apt-get install pdftk -y
apt-get install tesseract-ocr tesseract-ocr-eng -y
apt-get install conky conky-all lua5.1 lua5.2 -y

echo "Install graphviz and swish-e."
apt-get install graphviz -y
apt-get install swish-e -y


echo "Install Javascript Libraries: D3."
apt-get install libjs-d3 -y

echo "Install corenlp"
cd ~
wget http://nlp.stanford.edu/software/stanford-corenlp-full-2014-01-04.zip
unzip stanford*.zip
rm stanford*.zip
mv stanford* stanford-corenlp

cd ~
wget http://nlp.stanford.edu/software/stanford-ner-2014-01-04.zip
unzip stanford-ner*.zip
rm stanford-ner*.zip
mv stanford-ner* stanford-ner

echo "Install csvfix"
cd ~
wget https://bitbucket.org/neilb/csvfix/get/c21e95d2095e.zip
unzip c21*zip
rm c21*zip
cd neilb*
make lin
cp ./csvfix/bin/csvfix /usr/local/bin/
cd ~
rm -r neilb*


echo "Installing python pip, numpy, nltk"
cd ~
wget https://bootstrap.pypa.io/ez_setup.py -O - | sudo python
easy_install pip
pip install -U numpy
pip install -U pyyaml nltk

echo "Installing other python modules"
apt-get install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose -y


echo "Install python sklearn"
apt-get install python-sklearn -y

echo "Install beautifulsoup"
apt-get install python-beautifulsoup -y

echo "Install internet archive"
pip install internetarchive


echo "Install 'orange' using easy_install"
easy_install orange

echo "Download and install Google Refine"
cd ~
wget  https://github.com/OpenRefine/OpenRefine/releases/download/2.5/google-refine-2.5-r2407.tar.gz
tar -xvf goo*gz
rm goo*gz
cd google-refine-2.5
#./refine &

echo "Install r-base-dev and r-base-html and r-doc-pdf"
aptitude install r-base-dev -y
aptitude install r-base-html r-doc-pdf -y

echo "Download and install overview server"
cd ~
wget https://github.com/overview/overview-server/releases/download/release%2F0.0.2014052801/overview-server-0.0.2014052801.zip
unzip overview*zip
rm overview*zip
cd overview*
#./run &

echo "Download and install solr"
cd ~
wget http://wwwftp.ciril.fr/pub/apache/lucene/solr/5.4.0/solr-5.4.0.tgz
tar zxvf solr-5.4.0.tgz
rm solr-5.4.0.tgz 

echo "Install subversion and maven"
apt-get install subversion -y
apt-get install maven -y
svn co http://svn.apache.org/repos/asf/mahout/trunk
cd trunk
mvn install

echo "Download and install mallet 2.0.7"
cd ~
wget http://mallet.cs.umass.edu/dist/mallet-2.0.7.tar.gz
tar -zxvf mallet-2.0.7.tar.gz
rm mallet-2.0.7.tar.gz
wget http://topic-modeling-tool.googlecode.com/files/TopicModelingTool.jar

echo "Downloading historian"
cd ~
git clone https://github.com/ianmilligan1/Historian-WARC-1.git
cp -r ~/Historian-WARC-1/WARC/hanzo-warc/ ~/
rm -r ~/Historian-WARC-1 

echo "Download and install Meandre"
cd ~
wget http://repository.seasr.org/Meandre/Releases/1.4/1.4.12/Meandre-1.4.12-linux.zip
unzip Meandre-1.4.12-linux.zip
rm Meandre-1.4.12-linux.zip
cd Meandre-1.4.12
#sh Start-Infrastructure.sh
#sh Start-Workbench.sh

echo "Install Git Atom Nodejs"
cd ~
apt-get install nodejs -y
apt-get install libgnome-keyring-dev -y
wget http://nodejs.org/dist/v0.10.28/node-v0.10.28.tar.gz 
tar xzvf node-v0.10.28.tar.gz 
cd node-v0.10.28 
./configure && make 
make install 

cd ~
git clone https://github.com/atom/atom 
cd atom script/build 
script/grunt install 
#sh atom.sh

echo "Install Voyant Server"
cd ~
mkdir Voyant-Server 
cd Voyant-Server 
wget http://dev.voyant-tools.org/downloads/current/VoyantServer.zip 
unzip VoyantServer.zip 
#java -jar VoyantServer.jar


cd ~
echo "*********** History tools installation ended.  ***************"



