job "swiss-job" {
  datacenters = ["LiteArch"]
  type = "system"

  group "swiss-group" {
    task "swiss" {
      driver = "docker"
      config {
        image = "leodotcloud/swiss-army-knife"
        dns_servers = ["${attr.unique.network.ip-address}", "8.8.8.8"] 
      }

      resources {
        cpu    = 200
        memory = 128
        network {
          mbits = 20        
        }
      }
    }
  }
}