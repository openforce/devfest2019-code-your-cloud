# Code your Cloud Infrastructure

This is the repository with the slides and samples from my talk at DevFest Vienna 2019 (16. November 2019).

If you want to realy use the demo you need an Hetzner Cloud account as I used it in my samples. Attention: Some EUR Cents will be used when you run the samples.

I've using a file containing some environment vars that are used by Terraform and Packer.

    HCLOUD_TOKEN=<YOUR HETZNER TOKEN>
    GITLAB_URL=<YOUR GITLAB URL>
    GITLAB_RUNNERS_TOKEN=<YOUR GITLAB TOKEN>
    TF_VAR_hcloud_token=<YOUR HETZNER TOKEN>
    TF_VAR_gitlab_token=<YOUR GITLAB TOKEN>

I've called mine '.env' and to use it I do:

    set -a
    source .env
    set +a

The set is required so that the environment vars are exported to the current shell and all started processes.

The tools used are:

 * Terraform (https://www.terraform.io/)
 * Packer (https://www.packer.io/)
 * Ansible (https://www.ansible.com/)
 
 Have fun!
