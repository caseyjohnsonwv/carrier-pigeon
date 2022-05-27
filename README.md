# carrier-pigeon

TLDR, what I want this to do:
1. I log into Spotify in the UI, pick a playlist, and hit convert
2. The UI gives me the Job ID for the conversion, which I can give to someone else
3. That person logs into Apple Music in the UI and downloads the playlist to their library

Obviously this should work in both directions :)

---

## Deployment

1. Package the Lambdas into ZIP archives by running `python3 build.py` in `/src/backend`.
2. Create a `terraform.tfvars` in `/infrastructure` with the below variables:
```
env_name   = "dev"
aws_region = "us-east-2"
```
3. Run `terraform init` and `terraform apply` to stand up the infrastructure.