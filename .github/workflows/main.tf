
name: 'Terraform'

on:
  push:
    branches:
    - main
  pull_request:

jobs:
  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest

    steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1

    - name: Terraform Init
      run: terraform init
      env:
        GOOGLE_CREDENTIALS: ${{ secrets.GCP_SA_KEY }}

    - name: Terraform Format
      run: terraform fmt -check

    - name: Terraform Plan
      run: terraform plan
      env:
        GOOGLE_CREDENTIALS: ${{ secrets.GCP_SA_KEY }}

    - name: Terraform Apply
      if: github.ref == 'refs/heads/main' && github.event_name == 'push'
      run: terraform apply -auto-approve
      env:
        GOOGLE_CREDENTIALS: ${{ secrets.GCP_SA_KEY }}
