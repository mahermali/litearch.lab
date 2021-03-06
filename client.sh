# Prepare
sudo tee -a /etc/apt/apt.conf.d/99force-ipv4 << END
Acquire::ForceIPv4 "true";
END

# 1. Docker
sudo apt-get update 
sudo apt install -y docker.io 
sudo usermod -aG docker $USER 

# 2. Consul

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install consul
sudo tee /etc/consul.d/consul.hcl << END
datacenter = "LiteArch"
data_dir = "/opt/consul"
encrypt = "ITQ+ZCJDQNY+Ek753fK23sAgWPs5Yt2Hy8LilZTOoew="
retry_join = [%IPS%]
server = false
ui = true
client_addr = "0.0.0.0"
END
sudo systemctl restart consul 

# 3. Nomad
sudo apt-get update && sudo apt-get install nomad
sudo tee /etc/nomad.d/nomad.hcl << END
datacenter = "LiteArch"
data_dir = "/opt/nomad"
client {
  enabled = true
  meta{
    "capabilities" = "#capabilities"
  }
}
plugin "raw_exec" {
  config {
    enabled = true
  }
}
END
sudo systemctl restart nomad


# 4. IP Tables
sudo tee -a /etc/systemd/resolved.conf << END
DNS=127.0.0.1
Domains=~consul
END

sudo iptables -t nat -A PREROUTING -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600 
sudo iptables -t nat -A PREROUTING -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600 
sudo iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600 
sudo iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600 

sudo echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections 
sudo echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections 

sudo apt-get -y install iptables-persistent 
