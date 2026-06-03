terraform {
  required_providers {
    nebius = {
      source = "nebius/nebius"
    }
  }
}

provider "nebius" {
  token = var.nebius_token
}

# --------------------------------------------------
# Managed Kubernetes Cluster
# --------------------------------------------------

resource "nebius_mk8s_v1_cluster" "vllm_lab" {
  parent_id = var.project_id

  name = "vllm-gpu-lab"

  control_plane = {
    version = "1.32"

    endpoints = {
      public_endpoint = {}
    }

    subnet_id = "vpcsubnet-e00qp7c75wmw43q5pd"
  }
}

# --------------------------------------------------
# CPU Node Pool
# --------------------------------------------------

resource "nebius_mk8s_v1_node_group" "cpu_nodes" {
  parent_id = nebius_mk8s_v1_cluster.vllm_lab.id

  name = "cpu-node-group"

  fixed_node_count = 1

  template = {
    resources = {
      platform = "cpu-e2"
      preset   = "4vcpu-16gb"
    }

    subnet_id = "vpcsubnet-e00qp7c75wmw43q5pd"

    boot_disk = {
      size_gibibytes = 64
      type           = "NETWORK_SSD"
    }
  }
}

# --------------------------------------------------
# GPU Node Pool (L40S)
# --------------------------------------------------

resource "nebius_mk8s_v1_node_group" "gpu_nodes" {
  parent_id = nebius_mk8s_v1_cluster.vllm_lab.id

  name = "gpu-node-group"

  fixed_node_count = 1

  template = {

    preemptible = {}

    resources = {
      #L40S Intel
      platform = "gpu-l40s-a"
      preset = "1gpu-8vcpu-32gb"

      #L40S AMD
      #platform = "gpu-l40s-d"
      #preset = "1gpu-16vcpu-96gb"
    }

    gpu_settings = {
      drivers_preset = "cuda12.8"
    }

    subnet_id = "vpcsubnet-e00qp7c75wmw43q5pd"

    boot_disk = {
      size_gibibytes = 128
      type           = "NETWORK_SSD"
    }
  }
}
