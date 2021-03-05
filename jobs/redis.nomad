job "redis-job" {
  datacenters = ["LiteArch"]

  group "redis-group" {
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
    }
  }
}
