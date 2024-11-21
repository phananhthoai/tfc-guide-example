terraform {
  backend "remote" {
    organization = "sbu1"

    workspaces {
      name = "source"
    }
  }
}
