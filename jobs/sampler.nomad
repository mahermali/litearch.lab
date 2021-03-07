job "litearch-sampler-job" {
  datacenters = ["LiteArch"]
  type = "system"

  group "litearch-sampler-group" {

    task "litearch-sampler" {
        driver = "raw_exec"

        config {
            command = "bash"
            args=["sampler.sh"]
        }

        artifact {
            source = "https://raw.githubusercontent.com/mahermali/litearch.trafik/main/sampler.sh"
        }

        resources {
            cpu    = 100
            memory = 64
      }     
    }
  }
}
