# Autor: Alex Shahini
# Datum: 20.12.2024
import boto3
import csv
import json

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Extrahiere Bucket- und Dateiinformationen aus dem Trigger-Event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']

    try:
        # Lade die CSV-Datei aus dem Input-Bucket
        response = s3.get_object(Bucket=bucket_name, Key=file_key)
        csv_content = response['Body'].read().decode('utf-8').splitlines()

        # Überprüfe, ob die CSV-Datei eine gültige Kopfzeile hat
        if not csv_content or len(csv_content) < 2:
            raise ValueError("CSV-Datei ist leer oder hat keine gültige Kopfzeile.")

        # Konvertiere CSV zu JSON
        csv_reader = csv.DictReader(csv_content)
        if not csv_reader.fieldnames:
            raise ValueError("CSV-Datei hat keine gültige Kopfzeile.")

        json_data = [row for row in csv_reader if any(row.values())]  # Ignoriere leere Zeilen

        # Dynamischen Output-Bucket-Namen erstellen
        input_suffix = bucket_name.split('-')[-1]  # Nummer am Ende des Input-Buckets
        out_bucket = f"outbucketcsvtojson-{input_suffix}"

        # JSON-Datei im Output-Bucket speichern
        json_file_key = file_key.replace(".csv", ".json")
        s3.put_object(
            Bucket=out_bucket,
            Key=json_file_key,
            Body=json.dumps(json_data, ensure_ascii=False, indent=2),  # Formatierte JSON-Ausgabe
            ContentType='application/json'
        )

        print(f"Erfolgreich konvertiert: {file_key} in {json_file_key} im Bucket {out_bucket}")
        return {
            "statusCode": 200,
            "body": f"Datei erfolgreich konvertiert: {json_file_key} im Bucket {out_bucket}"
        }

    except ValueError as ve:
        print(f"Validierungsfehler: {str(ve)}")
        return {
            "statusCode": 400,
            "body": f"Validierungsfehler: {str(ve)}"
        }

    except Exception as e:
        print(f"Fehler beim Verarbeiten der Datei {file_key}: {str(e)}")
        return {
            "statusCode": 500,
            "body": f"Fehler beim Verarbeiten der Datei {file_key}: {str(e)}"
        }
