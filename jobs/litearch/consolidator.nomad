job "litearch-consolidator-job" {
  datacenters = ["LiteArch"]
  type = "batch"

  periodic {
    cron             = "*/3 * * * *"
    prohibit_overlap = true
  }

  group "litearch-consolidator-group" {   

    task "litearch-consolidator" {
      driver = "docker"

      config {
        image = "maherali/litearch-consolidator:latest"
        dns_servers = ["${attr.unique.network.ip-address}", "8.8.8.8"] 
        force_pull=true  
      }

      template {
        env=true
        destination="secrets/file.env"
        data= <<EOH
Environment=Development
Configuration__ConnectionString="redis.service.consul:6379"
Configuration__ConsulToken=""
Configuration__ConsulUrl="http://consul.service.consul:8500"
          EOH
      }

      resources {
        cpu    = 250
        memory = 512
      }

    }
  }
}
