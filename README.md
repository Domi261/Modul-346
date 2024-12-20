### Projektstruktur
Hier in der Projektstruktur sehen wir alle Files, welche wir für das Projekt benötigen.
Im nächsten Schritt werden alle notwendigen Tools für die Nutzung installiert.
```
Modul346-Cloudloesungen-konzipieren-und-realisieren/
├── images               # Dieser Ordner beinhaltet Bilder für die Dokumentation und kann ignoriert werden 
├── csvtojson.sh         # Skript
├── lambda_function.py   # Die eigentliche Lambda Funktion
├── requirements.txt     # Python-Abhängigkeiten
├── test1.csv            # CSV-Datei, welche konvertiert wird
└── README.md            # Dokumentation
```

---

### Schritte zur Installation der benötigten Tools (Linux)

Es ist notwendig die folgenden Commands in der Konsole auszuführen.

---

#### 1. **Repository klonen**
Der erste Schritt besteht darin, das Repository zu klonen.
```bash
git clone https://github.com/Logoko709/Modul346-Cloudloesungen-konzipieren-und-realisieren.git
```
```bash
cd Modul346-Cloudloesungen-konzipieren-und-realisieren
```
---

#### 2. **AWS CLI installieren und konfigurieren**
- **Installation auf Ubuntu/Debian:**
```bash
sudo apt update
```
```bash
sudo apt install awscli -y
```
Nach dem AWS CLI installiert ist muss es noch konfiguriert werden.
Dies kann man mit folgendem Befehl machen:
```
aws configure
```
Als erstes wird man nach der AWS Access Key ID gefragt, dies kann man leer lassen,
da diese jedes mal beim Starten des Labs überschrieben wird.

Auch der AWS Secret Access Key kann leer gelassen werden, da dieser ebenfalls überschrieben wird.

Bei "Default region name" nehemen wir "us-east-1".

Bei "Default output format" nehmen wir "json".
  
![aws_konfigurieren](images/aws_configure_einrichten.png)


Danach müssen wir die AWS Access Key ID und den AWS Secret Access Key in unsere Credentials einfügen.

Unsere Credentials sind für uns im AWS Lab ersichtlich:

![aws_credentials](images/aws_lab_credentials.png)  

Diese kopieren wir und raus und bearbeiten dann unser "credentials" File, welches sich im versteckten ordner ".aws" befindet.

Mit einem Texteditor wie Nano oder einem ähnlichen Editor pasten wir unsere Credentials rein.

![aws_credentials](images/nano_credentials.png)


Nun haben wir AWS CLI installiert und konfiguriert.

  
- **Verifizierung:**
    
Mit folgendem Befehl lässt sich überprüfen, ob die Installation erfolgreich war:
```bash
aws --version
```
Mit folgendem Befehl lässt sich testen, ob wir es richtig konfiguriert haben.

```
aws s3 ls
```
Damit werden unsere Buckets aufgezählt, sollten wir keine haben, wird einfch eine leere Ausgabe erscheinen.

![aws_credentials](images/buckets_sind_da.png)
---

#### 3. **Python 3.x und pip installieren**

- **Installation auf Ubuntu/Debian:**
```bash
sudo apt update
```
```bash
sudo apt install python3 python3-pip -y
```
- **Verifizierung:**  
Überprüfe die installierte Version von Python und pip:
```bash
python3 --version
```
```bash
pip3 --version
```

---

#### 4. **Abhängigkeiten aus `requirements.txt` installieren**

- **Installiere die Abhängigkeiten:**  
Nutze pip, um die Pakete aus der `requirements.txt` zu installieren:
```bash
pip3 install -r requirements.txt
```
- **Verifizierung der boto3-Installation:**  
Überprüfe, ob `boto3` korrekt installiert wurde:
```bash
pip3 show boto3
```

------------------------------------------------------------

**Alles bereit!**

Die notwendigen Tools und Pakete sind installiert. Nun müssen wir noch 2 kleine Schritte machen, bevor wir das Skript ausführen können.

------------------------------------------------------------

### Schritte zur Ausführung des Skripts

Es ist wichtig zu beachten, dass alle unsere Files sich im gleichen Verzeichnis befinden:

![aws_credentials](images/all_in_dir.png)

- **Im ersten Schritt müsen wir unsere Lambda Function "lambda_function.py" zippen.**

Dies machen wir mit folgendem Befehl:

```
zip lambda_function.zip lambda_function.py

```
![aws_credentials](images/lambda_zippen.png)

- **Wenn wir dies gemacht haben, müssen wir das File noch ausführbar machen**

Dies können wir mit chmod machen:

```bash
chmod +x csvtojson.sh
```
------------------------------------------------------------
### Ausführen des Skripts

Wir führen unser Skript nun mit:

```bash
./csvtojson.sh
```
aus. 

Wie wir sehen, wird am Anfang unsere ganze Infrastruktur eingerichtet.

Als erstes werden die 2 Buckets erstellt, wichtig zu beachten war hierbei, dass die Buckets immer einen **universell

einmaligen** Namen bekommen, dies konnten wir mit der "TIMESTAMP=$" Variable bewerkstelligen.

Im nächsten Schritt wird die Lambda Funktion in AWS erstellt und es werden die Lambda-Berechtigungen für den S3-Trigger hinzugefügt hinzugefügt.

Danach wir der S3-Trigger konfiguriert.

Das Skript nimmt dann unser "test1.csv" und lädt es in den Input-Bucket hoch.

Im nächsten Schritt wird das CSV-File zu einem JSON-File konvertiert und in den Output-Bucket hochgeladen.

Danach downloadet es für uns die fertige JSON-Datei namens "test1.json" und das Skript zeigt und schon die Datei mir korrekter Syntax an.



![aws_credentials](images/script_explained.png)

Nun könne wir noch validieren, ob das Skript wirklich alles gemacht hat:

Als erstes listen wir unsere Buckets auf:

![aws_credentials](images/get_buckets.png)

Wie wir sehen wurden unsere Buckets erfolgreich hinzugefügt.

Nun validieren wir noch unsere Funktion, hierbei können wir den Namen aus dem Skript entnehmen und die Region noch auf "us-east-1" eingrenzen.

![aws_credentials](images/get_function.png)

Die Durchführung des Skripts hat erfolgreich funktioniert, alles ist vorhanden und funktioniert so wie es sollte
