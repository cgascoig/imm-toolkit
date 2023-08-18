packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 1"
    }
  }
}

source "azure-arm" "basic-example" {
  build_resource_group_name = "azure-devops-cgascoig-imm-toolkit"

  managed_image_name = "imm-toolkit-{{isotime \"200601020304\"}}"
  managed_image_resource_group_name = "azure-devops-cgascoig-imm-toolkit"

  os_type = "Linux"
  image_publisher = "Canonical"
  image_offer = "0001-com-ubuntu-server-jammy"
  image_sku = "22_04-lts-gen2"

  azure_tags = {
    dept = "engineering"
  }

  #location = "Australia Southeast"
  vm_size = "Standard_DS1_v2"
}

build {
  sources = ["sources.azure-arm.basic-example"]
}

