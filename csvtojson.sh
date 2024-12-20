#!/bin/bash

set -e  # Bricht das Skript bei jedem Fehler ab

# Überprüfen, ob AWS CLI installiert ist
if ! command -v aws &> /dev/null; then
    echo "Fehler: AWS CLI ist nicht installiert. Bitte installiere AWS CLI, bevor du fortfährst."
    exit 1
fi

# IAM-Rollen-ARN aus IAM-Konsole
ROLE_ARN="" <---- ARN muss abgeändert werden!

# Überprüfen, ob die Variable für die IAM-Rolle gesetzt wurde
if [ "$ROLE_ARN" = "<EXISTING_ROLE_ARN>" ]; then
    echo "Fehler: Bitte ersetze <EXISTING_ROLE_ARN> durch den ARN deiner vorhandenen IAM-Rolle."
    exit 1
fi

# Variablen für Bucket-Namen (eindeutig durch zufälligen Suffix)
TIMESTAMP=$(date +%s)
REGION="us-east-1"
INPUT_BUCKET="inputbucketcsvtojson-${TIMESTAMP}"
OUTPUT_BUCKET="outbucketcsvtojson-${TIMESTAMP}"
LAMBDA_FUNCTION_NAME="CsvToJsonConverter40"
ZIP_FILE="lambda_function.zip"

echo "Starte die Einrichtung der AWS-Infrastruktur..."

# 1. S3-Buckets erstellen
echo "Erstelle S3-Buckets..."
aws s3 mb s3://$INPUT_BUCKET --region $REGION
aws s3 mb s3://$OUTPUT_BUCKET --region $REGION
echo "Buckets erstellt: $INPUT_BUCKET, $OUTPUT_BUCKET"

# 2. Prüfen, ob das ZIP-File vorhanden ist
if [ ! -f "$ZIP_FILE" ]; then
    echo "Fehler: ZIP-Datei für die Lambda-Funktion existiert nicht."
    exit 1
fi

# 3. Lambda-Funktion erstellen
echo "Erstelle Lambda-Funktion..."
LAMBDA_ARN=$(aws lambda create-function \
    --function-name $LAMBDA_FUNCTION_NAME \
    --runtime python3.9 \
    --role $ROLE_ARN \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://$ZIP_FILE \
    --query "FunctionArn" \
    --output text \
    --region $REGION)

echo "Lambda-Funktion erstellt: $LAMBDA_ARN"

# Berechtigungen für Lambda-Funktion hinzufügen
echo "Füge Lambda-Berechtigungen für S3-Trigger hinzu..."
aws lambda add-permission \
    --function-name $LAMBDA_FUNCTION_NAME \
    --principal s3.amazonaws.com \
    --statement-id s3invoke \
    --action lambda:InvokeFunction \
    --source-arn arn:aws:s3:::$INPUT_BUCKET \
    --region $REGION

# S3-Trigger für Lambda-Funktion konfigurieren
echo "Konfiguriere S3-Trigger..."
aws s3api put-bucket-notification-configuration \
    --bucket $INPUT_BUCKET \
    --notification-configuration file://<(cat <<EOF
{
    "LambdaFunctionConfigurations": [
        {
            "LambdaFunctionArn": "$LAMBDA_ARN",
            "Events": ["s3:ObjectCreated:*"]
        }
    ]
}
EOF
) --region $REGION

echo "S3-Trigger für Lambda-Funktion $LAMBDA_FUNCTION_NAME eingerichtet."

# 6. Test-CSV-Datei hochladen
if [ ! -f "test1.csv" ]; then
    echo "Fehler: Die Datei test1.csv wurde im Verzeichnis nicht gefunden."
    exit 1
fi

echo "Verwende vorhandene Test-CSV-Datei test1.csv aus dem aktuellen Verzeichnis."
echo "Lade Test-CSV-Datei in den Input-Bucket hoch..."
aws s3 cp test1.csv s3://$INPUT_BUCKET/test1.csv --region $REGION
echo "Test-CSV-Datei test1.csv hochgeladen."

echo "Lade Test-CSV-Datei in den Input-Bucket hoch..."
aws s3 cp test1.csv s3://$INPUT_BUCKET/test1.csv --region $REGION
echo "Test-CSV-Datei test1.csv hochgeladen."

# 7. Warten auf die Verarbeitung durch die Lambda-Funktion
echo "Warte auf die Verarbeitung der JSON-Datei im Output-Bucket..."
MAX_WAIT=60
WAIT=0
FOUND=false

while [ $WAIT -lt $MAX_WAIT ]; do
    if aws s3 ls s3://$OUTPUT_BUCKET/test1.json --region $REGION >/dev/null 2>&1; then
        FOUND=true
        break
    fi
    sleep 5
    WAIT=$((WAIT+5))
done

if [ "$FOUND" = true ]; then
    echo "JSON-Datei test1.json gefunden im Output-Bucket."

    # JSON-Datei herunterladen und anzeigen
    echo "Lade die JSON-Datei test1.json herunter..."
    aws s3 cp s3://$OUTPUT_BUCKET/test1.json ./test1.json --region $REGION
    echo "Inhalt der JSON-Datei test1.json:"
    cat test1.json
else
    echo "JSON-Datei wurde nicht innerhalb von $MAX_WAIT Sekunden im Output-Bucket gefunden."
    echo "Überprüfe die Logs der Lambda-Funktion in CloudWatch für Fehler."
    aws logs tail /aws/lambda/$LAMBDA_FUNCTION_NAME --region $REGION --follow
fi
