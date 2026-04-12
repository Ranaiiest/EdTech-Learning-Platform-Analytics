import sys
from google.cloud import bigquery

PROJECT_ID = "sampleproject-492912"
DATASET_ID = "learnco_analytics"

TABLES = [
    "course_performance",
    "student_engagement"
]

def main():
    try:
        client = bigquery.Client(project=PROJECT_ID)

        # 1. Check dataset exists
        dataset_ref = f"{PROJECT_ID}.{DATASET_ID}"
        try:
            client.get_dataset(dataset_ref)
            print(f"✅ Dataset exists: {dataset_ref}")
        except Exception:
            print(f"❌ Dataset NOT found: {dataset_ref}")
            sys.exit(1)

        # 2. Check tables + data
        for table in TABLES:
            table_ref = f"{PROJECT_ID}.{DATASET_ID}.{table}"

            try:
                client.get_table(table_ref)
                print(f"✅ Table exists: {table}")
            except Exception:
                print(f"❌ Table NOT found: {table}")
                sys.exit(1)

            # Check row count
            query = f"SELECT COUNT(*) as cnt FROM `{table_ref}`"
            result = client.query(query).result()
            count = list(result)[0].cnt

            if count == 0:
                print(f"❌ Table {table} is EMPTY")
                sys.exit(1)
            else:
                print(f"✅ Table {table} has {count} rows")

        print("🎉 All smoke tests PASSED")
        sys.exit(0)

    except Exception as e:
        print(f"❌ Smoke test failed: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()