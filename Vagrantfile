# -*- mode: ruby -*-
# vi: set ft=ruby :

$IPADDRESS="10.3.45.99"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.network :private_network, ip: $IPADDRESS

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--name", "elk-playground", "--memory", "3072", "--cpus", "4"]
    # To see boot-proccess uncomment next line
    # vb.gui = true
  end
  
  config.vm.post_up_message = "Your ELK-playground is ready

    	Webserver:       http://#$IPADDRESS
    	Kibana:          http://#$IPADDRESS:5601
    	Elasticsearch:   http://#$IPADDRESS:9200

    	    - HQ-Plugin:       http://#$IPADDRESS:9200/_plugin/HQ/
    	    - Sense-Plugin:    http://#$IPADDRESS:9200/_plugin/sense/
    "
    
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
  	wget -qO - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
  	sudo add-apt-repository "deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main"
  	sudo add-apt-repository "deb http://packages.elasticsearch.org/logstash/1.4/debian stable main"
  	
    sudo apt-get update
    sudo apt-get install -y openjdk-7-jre git apache2-mpm-worker
    sudo apt-get install -y elasticsearch logstash logstash-contrib
    sudo update-rc.d elasticsearch defaults 95 10
    
    # add logstash to adm group
    sudo usermod -a -G adm logstash
    
    # clone kibana master
    # sudo ssh-keyscan github.com >> ~/.ssh/known_hosts
    # sudo git clone https://github.com/elasticsearch/kibana.git /var/www/kibana
    
    # python related
    sudo apt-get install -y python-pip
    sudo apt-get install -y ipython
    sudo pip install elasticsearch
    sudo pip install html2text
    sudo /usr/share/elasticsearch/bin/plugin --install bleskes/sense
    sudo /usr/share/elasticsearch/bin/plugin --install royrusso/elasticsearch-HQ
    sudo service elasticsearch restart    

    # create sample config for apache-logs
    sudo cp /vagrant/logstash/apache.conf /etc/logstash/conf.d/apache.conf
    sudo service logstash restart  
    
    # install redis
    sudo apt-get install -y redis-server redis-tools
    # produce some dummy data
    bash /vagrant/bin/redis-data.sh 1>/dev/null
     
    # install kibana
	cd
	wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz -O kibana-4.0.1-linux-x64.tar.gz -q
    tar xfvz kibana-4.0.1-linux-x64.tar.gz > /dev/null
    sudo mv kibana-4.0.1-linux-x64 /usr/share/kibana
    # run as a service
    sudo cp /vagrant/init.d/kibana /etc/init.d/kibana
    sudo chmod 0755 /etc/init.d/kibana
    sudo update-rc.d kibana defaults 96 20
    sudo service kibana start    

  	
  SHELL
end

