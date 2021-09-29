terraform {
  backend "remote" {
    organization = "tanle-test"
    workspaces {
      name = "MyWorkspace-OwnerTanLe"
    }
  }
}
