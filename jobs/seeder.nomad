job "seeder-job" {
  datacenters = ["LiteArch"]
  type = "service"

  group "seeder-group" {
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
    ephemeral_disk {
      size = 300
    }

    task "seeder" {
      driver = "docker"
      config {
        image = "maherali/litearch-lab-seeder:latest"
        dns_servers = ["${attr.unique.network.ip-address}", "8.8.8.8"]     
      }

      template {
        env=true
        destination="secrets/file.env"
        data= <<EOH
Environment=Development
Api__BaseUrl="http://fabio.service.consul/service/"
          EOH
      }

      service {
        name = "seeder"        
      }
    }
  }
}
