packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

data "git-repository" "cwd" {}

locals {
  build_version     = var.build_version
  image_name = "imm-toolkit-${local.build_version}"
}

source "azure-arm" "basic-example" {
  build_resource_group_name = "azure-devops-cgascoig-imm-toolkit"

  managed_image_name = local.image_name
  managed_image_resource_group_name = "azure-devops-cgascoig-imm-toolkit"

  os_type = "Linux"
  image_publisher = "Canonical"
  image_offer = "0001-com-ubuntu-server-jammy"
  image_sku = "22_04-lts-gen2"

  azure_tags = {
    dept = "engineering"
  }

  vm_size = "Standard_DS1_v2"
}

build {
  sources = ["sources.azure-arm.basic-example"]

  provisioner "shell" {
    inline = [
      "echo Sleeping 30 secs",
      "sleep 30",

      "echo Updating apt",
      "sudo apt-get update",

      "echo Running apt-get upgrade",
      "sudo apt-get upgrade -y",

      "echo Installing ansible",
      "sudo apt-get install -y ansible",
    ]
  }

  provisioner "ansible-local" {
    playbook_dir = "ansible"
    playbook_file = "ansible/main.yml"
  }

  hcp_packer_registry {
    bucket_name = "imm-toolkit"
    description = "IMM Toolkit learning VM."

    bucket_labels = {
      "os"             = "Ubuntu",
      "ubuntu-version" = "22.04 LTS",
    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }
}

