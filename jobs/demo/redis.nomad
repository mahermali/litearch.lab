job "redis-job" {
  datacenters = ["LiteArch"]

  group "redis-group" {
    count=1
    
    network {
      port "redis" {
        static = 6379
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:latest"

        ports = ["redis"]
      }

      constraint {
        attribute = "${meta.capabilities}"
        set_contains = "node,storge"
      }

      resources {
        cpu    = 250
        memory = 512
      }

      service {
        name = "redis"
        port = "redis"        
        
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
