job "litearch-trafik-api-job" {
  datacenters = ["LiteArch"]
  type = "service"

  group "litearch-trafik-api-group" {
    count = 1

    constraint {
      attribute = "${meta.capabilities}"
      set_contains = "node,app"
    }

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    network {
        port "http" {
          to=8080
        }
    }

    ephemeral_disk {
      size = 300
    }

    task "api" {
      driver = "docker"

      config {
        image = "maherali/litearch-trafik-api:latest"
        dns_servers = ["${attr.unique.network.ip-address}", "8.8.8.8"]       
        force_pull=true
        ports = [
          "http"
        ]
      }

      resources {
        cpu = 256
        memory=256       
      }

      template {
        env=true
        destination="secrets/file.env"
        data= <<EOH
Environment=Development
Configuration__ConnectionString="redis.service.consul"
        EOH
      }

      service {
        name = "trafik-api"
        port = "http"
        tags = ["urlprefix-/trafik-api strip=/trafik-api"]
        
        check {
          name     = "alive"
          type     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }        
      }
    }
  }
}
