### Projektstruktur
Hier in der Projektstruktur sehen wir alle Files, welche wir für das Projekt benötigen.
Im nächsten Schritt werden alle notwendigen Tools für die Nutzung installiert.
```
Modul346-Cloudloesungen-konzipieren-und-realisieren/
├── csvtojson.sh         # Skript
├── requirements.txt     # Python-Abhängigkeiten
├── test.csv             # Beispiel-CSV-Datei
└── README.md            # Dokumentation
```

---

### Schritte zur Installation der benötigten Tools (Linux)

Es ist notwendig in den folgenden Schritten die Commands in der Konsole auszuführen.

---

#### 1. **Repository klonen**
Der erste Schritt besteht darin das Repository zu klonen.
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
  Nach dem AWS CLI installiert ist muss es noch configuriert werden.
  Dies kann man mit folgendem Befehl machen:
  ```
  aws configure
  ```
  Als erstes wird man nach der AWS Access Key ID gefragt, dies kann man leer lassen,
  da diese jedes mal beim Starten des Labs überschrieben wird.

  Auch der AWS Secret Access Key kann leer gelassen werden, da dieser ebenfalls überschrieben wird.

  Bei "Default region name" nehemen wir "us-east-1".

  Bei "Default output format" nehmen wir "json"
  ![aws_konfigurieren](image/aws_konfigurieren.png)


  Danach müssen wir die AWS Access Key ID und den AWS Secret Access Key in unsere Credentials einfügen.

  Unsere Credentials sind für uns im AWS Lab ersichtlich:

  ![aws_credentials](image/aws_credentials.png)  

  Diese kopieren wir und raus, und bearbeiten  dann unser "credentials" File welches sich im versteckten ordner ".aws" befindet.

  Mit einem Texteditor wie Nano oder einem ähnlichen Editor pasten wir unsere Credentials rein.

  ![aws_credentials](image/aws_config.png)


  Nun haben wir AWS CLI installiert und konfiguriert.

  
- **Verifizierung:**  
  Mit folgendem Befehl lässt sich überprüfen, ob die Installation erfolgreich war:
  ```bash
  aws --version
  ```
  Zum Testen ob es wir es richtig konfiguriert haben, können wir mit

  ```
  aws s3 ls
  ```
  unsere Buckets aufzählen lassen, sollten wir keine haben, wird einfch eine leere Ausgabe gemacht.

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

Es ist wichtig zu beachten, dass alle unsere Files sich im gleichen Verzeichnis befinden!




Im ersten Schritt müsen wir unsere Lambda Function "lambda_function.py" zippen.

Dies machen wir mit folgendem Befehl:

```
zip lambda_function.zip lambda_function.py
```
Wenn wir dies gemacht haben, müssen wir das File noch ausführbar machen

1. **Ausführungsrechte setzen (falls noch nicht geschehen)**:
   ```bash
   chmod +x csvtojson.sh

------------------------------------------------------------
### Testing

1. Wir führen nun unser Skript mit:
  ```
/. csvtojson.sh
  ```
aus.
  
1. **test.csv-Datei vorbereiten**

Die Datei `test.csv` muss sich im gleichen Verzeichnis wie das Bash-Skript, welches die Infrastruktur aufbaut, befinden. Dadurch wird beim Ausführen des Skripts die `test.csv`-Datei automatisch in den neu erstellten Input-Bucket hochgeladen. Anschliessend wird durch den S3-Trigger die Lambda-Funktion ausgeführt, die die CSV-Datei ins JSON-Format konvertiert und im Output-Bucket ablegt.

   **Beispiel für den Inhalt von `test.csv`:**
   ```csv
   id,name,age,city,country,profession,email,salary
   1,John Doe,29,Zurich,Switzerland,Engineer,john.doe@example.com,75000
   2,Jane Smith,34,Bern,Switzerland,Doctor,jane.smith@example.com,90000
   3,Bob Brown,23,Geneva,Switzerland,Teacher,bob.brown@example.com,50000
   4,Alice White,28,Basel,Switzerland,Designer,alice.white@example.com,62000
   5,Chris Green,41,Luzern,Switzerland,Manager,chris.green@example.com,110000
   6,Mary Black,30,Zug,Switzerland,Journalist,mary.black@example.com,65000
   7,Peter Gray,27,Lausanne,Switzerland,Data Analyst,peter.gray@example.com,80000
   8,Susan Blue,32,Fribourg,Switzerland,Architect,susan.blue@example.com,95000
   9,David Gold,36,Winterthur,Switzerland,Librarian,david.gold@example.com,47000
   10,Laura Silver,29,St. Gallen,Switzerland,Marketing Specialist,laura.silver@example.com,71000
   ```
  Die test.csv-Datei schaut nach der Konvertierung ins JSON-Format wie folgt aus:
  ```json
  [
  {
    "id": "1",
    "name": "John Doe",
    "age": "29",
    "city": "Zurich",
    "country": "Switzerland",
    "profession": "Engineer",
    "email": "john.doe@example.com",
    "salary": "75000"
  },
  {
    "id": "2",
    "name": "Jane Smith",
    "age": "34",
    "city": "Bern",
    "country": "Switzerland",
    "profession": "Doctor",
    "email": "jane.smith@example.com",
    "salary": "90000"
  },
  {
    "id": "3",
    "name": "Bob Brown",
    "age": "23",
    "city": "Geneva",
    "country": "Switzerland",
    "profession": "Teacher",
    "email": "bob.brown@example.com",
    "salary": "50000"
  },
  {
    "id": "4",
    "name": "Alice White",
    "age": "28",
    "city": "Basel",
    "country": "Switzerland",
    "profession": "Designer",
    "email": "alice.white@example.com",
    "salary": "62000"
  },
  {
    "id": "5",
    "name": "Chris Green",
    "age": "41",
    "city": "Luzern",
    "country": "Switzerland",
    "profession": "Manager",
    "email": "chris.green@example.com",
    "salary": "110000"
  },
  {
    "id": "6",
    "name": "Mary Black",
    "age": "30",
    "city": "Zug",
    "country": "Switzerland",
    "profession": "Journalist",
    "email": "mary.black@example.com",
    "salary": "65000"
  },
  {
    "id": "7",
    "name": "Peter Gray",
    "age": "27",
    "city": "Lausanne",
    "country": "Switzerland",
    "profession": "Data Analyst",
    "email": "peter.gray@example.com",
    "salary": "80000"
  },
  {
    "id": "8",
    "name": "Susan Blue",
    "age": "32",
    "city": "Fribourg",
    "country": "Switzerland",
    "profession": "Architect",
    "email": "susan.blue@example.com",
    "salary": "95000"
  },
  {
    "id": "9",
    "name": "David Gold",
    "age": "36",
    "city": "Winterthur",
    "country": "Switzerland",
    "profession": "Librarian",
    "email": "david.gold@example.com",
    "salary": "47000"
  },
  {
    "id": "10",
    "name": "Laura Silver",
    "age": "29",
    "city": "St. Gallen",
    "country": "Switzerland",
    "profession": "Marketing Specialist",
    "email": "laura.silver@example.com",
    "salary": "71000"
  }
]
```
