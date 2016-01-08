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
sed s/^deb\ cdrom/#\ deb\ cdrom/g sources.list

echo "Updating the repository and installing the pending updates"
apt-get update -y
apt-get upgrade -y

echo "Installing required packages for virtualbox additions"
apt-get install dkms
apt-get install linux-headers-3.14-1-486

echo "Give the hcu user permissions to interact with shared folder by adding him/her to vboxsf group."
usermod -a -G vboxsf hcu

echo "Image, text and document processing tools and OCR."
apt-get install default-jdk
apt-get imagej
apt-get install pandoc
apt-get install tre-agrep 
apt-get install pdftk
apt-get install tesseract-ocr tesseract-ocr-eng

echo "Install graphviz and swish-e."
sudo apt-get install graphviz
sudo apt-get install swish-e


echo "Install Javascript Libraries: D3."
sudo apt-get install libjs-d3

echo ""
wget http://nlp.stanford.edu/software/stanford-corenlp-full-2014-01-04.zip
unzip stanford*.zip
rm stanford*.zip
mv stanford* stanford-corenlp

wget http://nlp.stanford.edu/software/stanford-ner-2014-01-04.zip
unzip stanford-ner*.zip
rm stanford-ner*.zip
mv stanford-ner* stanford-ner

echo ""
wget https://bitbucket.org/neilb/csvfix/get/c21e95d2095e.zip
unzip c21*zip
rm c21*zip
cd neilb*
make lin
sudo cp ./csvfix/bin/csvfix /usr/local/bin
cd ~
rm -r neilb*

echo ""
wget https://bootstrap.pypa.io/ez_setup.py -O - | sudo python
sudo easy_install pip
sudo pip install -U numpy
sudo pip install -U pyyaml nltk

echo ""
sudo apt-get install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose


echo ""
sudo apt-get install python-sklearn

echo ""
sudo apt-get install python-beautifulsoup

echo ""
sudo pip install internetarchive


echo ""
sudo easy_install orange

echo ""
wget  https://github.com/OpenRefine/OpenRefine/releases/download/2.5/google-refine-2.5-r2407.tar.gz
tar -xvf goo*gz
rm goo*gz
cd google-refine-2.5
./refine &

echo ""
sudo aptitude install r-base-dev
sudo aptitude install r-base-html r-doc-pdf

echo ""
wget https://github.com/overview/overview-server/releases/download/release%2F0.0.2014052801/overview-server-0.0.2014052801.zip
unzip overview*zip
rm overview*zip
cd overview*
./run &

echo ""
wget http://apache.mirror.vexxhost.com/lucene/solr/4.8.1/solr-4.8.1.tgz
tar zxvf solr-4.8.1.tgz 
rm solr-4.8.1.tgz 

echo ""
sudo apt-get install subversion
sudo apt-get install maven
svn co http://svn.apache.org/repos/asf/mahout/trunk
cd trunk
mvn install

echo ""
wget http://mallet.cs.umass.edu/dist/mallet-2.0.7.tar.gz
tar -zxvf mallet-2.0.7.tar.gz
rm mallet-2.0.7.tar.gz
wget http://topic-modeling-tool.googlecode.com/files/TopicModelingTool.jar

echo ""
sudo apt-get install git
git clone https://github.com/ianmilligan1/Historian-WARC-1.git

echo ""
wget http://repository.seasr.org/Meandre/Releases/1.4/1.4.12/Meandre-1.4.12-linux.zip
unzip Meandre-1.4.12-linux.zip
rm Meandre-1.4.12-linux.zip
cd Meandre-1.4.12
sh Start-Infrastructure.sh
sh Start-Workbench.sh

echo ""



