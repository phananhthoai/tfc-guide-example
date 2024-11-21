terraform {
  backend "remote" {
    organization = "sbu"

    workspaces {
      name = "source"
    }
  }
}
