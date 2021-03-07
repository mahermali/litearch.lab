job "fabio" {
  datacenters = ["LiteArch"]
  type = "system"

  group "fabio" {

    network {
      port "lb" {
            static = 80
      }
      port "ui" {
        static = 9998
      }
    }

    task "fabio" {
      driver = "docker"
      config {
        image = "fabiolb/fabio"
        network_mode = "host"
        ports = [
            "lb", "ui"
          ]
      }

      env {
        LOG_ACCESS_TARGET = "stdout"
        LOG_ACCESS_FORMAT = "$remote_host - - [$time_common] $request $response_status $response_body_size -> $upstream_request_url, $upstream_host"
        PROXY_ADDR = ":80"
      }

      resources {
        cpu    = 200
        memory = 128        
      }
    }
  }
}