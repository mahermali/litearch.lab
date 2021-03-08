job "litearch-trafik-portal-job" {
  datacenters = ["LiteArch"]
  type = "service"

  group "litearch-trafik-portal-group" {
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

    task "portal" {
      driver = "docker"

      config {
        image = "maherali/litearch-trafik-portal:latest"
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
TRAFIK_API_URL="#API"
TRAFIK_PORTAL_PREFIX="trafik-portal"
        EOH
      }

      service {
        name = "trafik-portal"
        port = "http"
        tags = ["urlprefix-/trafik-portal strip=/trafik-portal"]
        
        check {
          name     = "alive"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }        
      }
    }
  }
}
