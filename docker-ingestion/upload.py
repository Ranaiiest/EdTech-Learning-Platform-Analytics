import os
from dotenv import load_dotenv
from azure.storage.filedatalake import DataLakeServiceClient
from azure.identity import ClientSecretCredential

# LOAD ENV VARIABLES
load_dotenv()

TENANT_ID = os.getenv("TENANT_ID")
CLIENT_ID = os.getenv("CLIENT_ID")
CLIENT_SECRET = os.getenv("CLIENT_SECRET")

WORKSPACE_ID = os.getenv("WORKSPACE_ID")
LAKEHOUSE_ID = os.getenv("LAKEHOUSE_ID")
ACCOUNT_URL = os.getenv("ACCOUNT_URL")

# AUTHENTICATION
credential = ClientSecretCredential(
    tenant_id=TENANT_ID,
    client_id=CLIENT_ID,
    client_secret=CLIENT_SECRET
)

service_client = DataLakeServiceClient(
    account_url=ACCOUNT_URL,
    credential=credential
)

fs_client = service_client.get_file_system_client(
    file_system=WORKSPACE_ID
)

# CREATE DIRECTORY
def create_dir(path):
    dir_client = fs_client.get_directory_client(
        f"{LAKEHOUSE_ID}/Files/{path}"
    )
    try:
        dir_client.create_directory()
    except Exception:
        pass  # already exists

# UPLOAD FILE
def upload(file, path):
    file_client = fs_client.get_file_client(
        f"{LAKEHOUSE_ID}/Files/{path}/{file}"
    )
    with open(file, "rb") as f:
        file_client.upload_data(f, overwrite=True)
    print(f"Uploaded {file} → {path}")

# MAIN
if __name__ == "__main__":

    print("Creating directories...")

    create_dir("bronze/edtech/courses")
    create_dir("bronze/edtech/students")
    create_dir("bronze/edtech/assessments")

    print("Uploading files...")

    upload("courses.csv", "bronze/edtech/courses")
    upload("students.csv", "bronze/edtech/students")
    upload("assessments.csv", "bronze/edtech/assessments")

    print("ALL FILES UPLOADED SUCCESSFULLY")