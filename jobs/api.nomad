job "api-job" {
  datacenters = ["LiteArch"]
  type = "service"

  group "api-group" {
    count = 3

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
        image = "maherali/litearch-lab-api:latest"
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
Redis__HOST="redis.service.consul"
        EOH
      }

      service {
        name = "api"
        port = "http"
        tags = ["urlprefix-/api strip=/api"]
        
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
