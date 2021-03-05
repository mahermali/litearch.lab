job "fabio" {
  datacenters = ["LiteArch"]
  type = "system"

  group "fabio" {
    task "fabio" {
      driver = "docker"
      config {
        image = "fabiolb/fabio"
        network_mode = "host"
      }

      env {
        LOG_ACCESS_TARGET = "stdout"
        LOG_ACCESS_FORMAT = "$remote_host - - [$time_common] $request $response_status $response_body_size -> $upstream_request_url, $upstream_host"
        PROXY_ADDR = ":80"
      }

      resources {
        cpu    = 200
        memory = 128
        network {
          mbits = 20
          port "lb" {
            static = 80
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}