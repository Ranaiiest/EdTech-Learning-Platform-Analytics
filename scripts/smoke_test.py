import sys
from google.cloud import bigquery

PROJECT_ID = "sampleproject-492912"
DATASET_ID = "learnco_analytics"

TABLES = ["course_performance", "student_engagement"]

def main():
    client = bigquery.Client(project=PROJECT_ID)

    # Dataset check
    try:
        client.get_dataset(f"{PROJECT_ID}.{DATASET_ID}")
        print("✅ Dataset exists")
    except:
        print("❌ Dataset missing")
        sys.exit(1)

    # Tables + data check
    for table in TABLES:
        table_ref = f"{PROJECT_ID}.{DATASET_ID}.{table}"

        try:
            client.get_table(table_ref)
            print(f"✅ Table exists: {table}")
        except:
            print(f"❌ Table missing: {table}")
            sys.exit(1)

        query = f"SELECT COUNT(*) as cnt FROM `{table_ref}`"
        result = client.query(query).result()
        count = list(result)[0].cnt

        if count == 0:
            print(f"❌ Table empty: {table}")
            sys.exit(1)

        print(f"✅ {table} has data: {count} rows")

    print("🎉 Smoke tests passed")
    sys.exit(0)

if __name__ == "__main__":
    main()