job "litearch-trafik-sampler-job" {
  datacenters = ["LiteArch"]
  type = "system"

  group "litearch-trafik-sampler-group" {

    task "litearch-trafik-sampler" {
        driver = "raw_exec"

        config {
            command = "bash"
            args=["local/sampler.sh"]
        }

        artifact {
            source = "https://raw.githubusercontent.com/mahermali/litearch.trafik/main/sampler.sh"
            mode = "file"
            destination = "local/sampler.sh"
        }

        resources {
            cpu    = 100
            memory = 64
      }     
    }
  }
}
