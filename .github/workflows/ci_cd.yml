name: Terraform CI/CD with Smoke Tests

on:
  push:
    branches: [ main ]

jobs:

  terraform:
    name: Terraform Apply
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repo
        uses: actions/checkout@v4

      - name: Authenticate to GCP
        uses: google-github-actions/auth@v2
        with:
          credentials_json: '${{ secrets.GCP_KEY }}'

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Terraform Init
        run: terraform init
        working-directory: terraform

      - name: Terraform Apply
        run: terraform apply -auto-approve
        working-directory: terraform


  smoke_tests:
    name: Smoke Tests
    runs-on: ubuntu-latest
    needs: terraform   # 👈 VERY IMPORTANT

    steps:
      - name: Checkout Repo
        uses: actions/checkout@v4

      - name: Authenticate to GCP
        uses: google-github-actions/auth@v2
        with:
          credentials_json: '${{ secrets.GCP_KEY }}'

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Install Dependencies
        run: pip install -r requirements.txt

      - name: Run Smoke Tests
        run: python scripts/smoke_test.py