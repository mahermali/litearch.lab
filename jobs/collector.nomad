job "litearch-collector-job" {
  datacenters = ["LiteArch"]
  type = "system"

  group "litearch-collector-group" {   

    network {
      port "tcp" {
        static = 20999
      }
    }

    task "litearch-collector" {
      driver = "docker"

      config {
        image = "maherali/litearch-collector:latest"
        dns_servers = ["${attr.unique.network.ip-address}", "8.8.8.8"] 
        force_pull=true  
        ports = ["tcp"]  
      }

      template {
        env=true
        destination="secrets/file.env"
        data= <<EOH
Environment=Development
Configuration__ConnectionString="redis.service.consul"
Configuration__Port="20999"
Configuration__ExpiresInSeconds="30"
          EOH
      }

      resources {
        cpu    = 250
        memory = 512
      }

      service {
        name = "litearch-collector"
        port = "tcp"        
        
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
