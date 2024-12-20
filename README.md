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

Diese kopieren wir und raus und bearbeiten dann unser "credentials" File, welches sich im versteckten Ordner ".aws" befindet.

Mit einem Texteditor wie Nano oder einem ähnlichen Editor kopieren wir unsere Credentials rein.

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
Nutze pip, um die Pakete aus der `requirements.txt` Datei zu installieren:
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

Die notwendigen Tools und Pakete sind installiert. Nun müssen wir noch 3 kleine Schritte machen, bevor wir das Skript ausführen können.

------------------------------------------------------------

### Schritte zur Ausführung des Skripts

Es ist wichtig zu beachten, dass alle unsere Files sich im gleichen Verzeichnis befinden:

![aws_credentials](images/all_in_dir.png)

**Im ersten Schritt muss der Role ARN (Amazon Resource Name) geändert werden.**

Der Grund, warum jeder Nutzer oder jede Umgebung eine individuelle Role ARN benötigt, liegt darin, dass Rollen an bestimmte AWS-Konten, Berechtigungen und Sicherheitsrichtlinien gebunden sind.

Der Role ARN kann im IAM-Dashboard eingesehen werden.

Dafür geht man ins IAM-Dashboard rein.

![IAM](images/IAM.png)

Beim Reiter Zugriffsverwaltung kann man dann auf "Rollen" klicken:

![Rollen](images/Rollen_fix.png)

Nun werden sämtliche Rollen angezeigt.

Dann klickt man auf die "Lab Role"


![Rollen](images/ARN_Lab_Role.png)


Nun sieht man den ARN

Diesen muss man rauskopieren und dann mit einem Texteditor wie Nano in das File csvtojson.sh einfügen:


![Rollen](images/einfügen.png)


**Im zweiten Schritt müsen wir unsere Lambda Function "lambda_function.py" zippen.**

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

Als erstes werden die 2 Buckets erstellt, wichtig zu beachten war hierbei, dass die Buckets immer einen **universell**

**einmaligen** Namen bekommen, dies konnten wir mit der "TIMESTAMP=$" Variable bewerkstelligen.

Im nächsten Schritt wird die Lambda Funktion in AWS erstellt und es werden die Lambda-Berechtigungen für den S3-Trigger hinzugefügt.

Danach wir der S3-Trigger konfiguriert.

Das Skript nimmt dann unser "test1.csv" und lädt es in den Input-Bucket hoch.

Im nächsten Schritt wird das CSV-File zu einem JSON-File konvertiert und in den Output-Bucket hochgeladen.

Danach downloadet es für uns die fertige JSON-Datei namens "test1.json" und das Skript zeigt uns schon die Datei mit korrekter Syntax an.



![aws_credentials](images/script_explained.png)

Nun können wir noch validieren, ob das Skript wirklich alles gemacht hat:

Als erstes listen wir unsere Buckets auf:

![aws_credentials](images/get_buckets.png)

Wie wir sehen wurden unsere Buckets erfolgreich hinzugefügt.

Nun validieren wir noch unsere Funktion, hierbei können wir den Namen aus dem Skript entnehmen und die Region noch auf "us-east-1" eingrenzen.

![aws_credentials](images/get_function.png)

Die Durchführung des Skripts hat erfolgreich funktioniert, alles ist vorhanden und funktioniert so wie es sollte.


#### **Ablaufprozess**

![CSV_to_JSON_Process_Professional_Diagram](https://github.com/user-attachments/assets/ff5e01e7-58b1-437b-b0c9-b9e81509b588)


#### **Reflexion**
Am Ende jeder Arbeit ist eine sorgfältige Reflexion von großer Bedeutung. Sie ermöglicht es, Erfolge wie auch Schwierigkeiten zu erkennen, aus Erfahrungen zu lernen und so die nächste Aufgabe noch besser anzugehen. Eine ehrliche Analyse des eigenen Vorgehens schafft Klarheit, motiviert zur Weiterentwicklung und trägt langfristig zu einer höheren Qualität der Ergebnisse bei.

### **Reflexion Dominick**

Als wir das Projekt durchführten, stießen wir auf einige Schwierigkeiten. So war es beispielsweise unklar, ob das Skript ohne manuelles Konfigurieren der ARN lauffähig ist, da diese je nach Nutzer unterschiedlich ist. Außerdem haben wir zunächst alle Änderungen in ein Test-Repository gepusht und erst am Ende in das finale Abgabe-Repository übertragen. Dieser zusätzliche Schritt hat unnötig Zeit gekostet, die wir uns durch eine bessere Planung im Vorfeld hätten sparen können. Bei einem logischen Problem im Ablauf des Skripts konnte uns Herr Dall Acqua unterstützen, sodass wir den Fehler letztendlich beheben konnten.

Rückblickend haben wir viel dazugelernt, insbesondere im Umgang mit AWS, Linux und der gesamten AWS-Infrastruktur. Wir haben erkannt, dass sich Python sehr gut für Skripte und automatisierte Abläufe eignet, und trotzdem sind wir mit unserem Bash-Skript zufrieden, da es am Ende seine Aufgabe erfüllt. Für zukünftige Projekte nehmen wir uns vor, mehr Zeit für die Planung aufzuwenden und die Aufgaben effizienter zu gestalten. Zudem dachten wir, dass die Dokumentation weniger zeitaufwendig sein würde, doch insbesondere das Erstellen der Screenshots hat deutlich mehr Zeit in Anspruch genommen als erwartet. Insgesamt sind wir mit dem Ergebnis zufrieden und spüren deutlich, wie wir unser Fachwissen erweitern konnten.


## **Reflexion Alex**

Als ich den Code geschrieben habe, stellte sich vor allem die Handhabung der dynamischen Output-Bucket-Namen als äusserst knifflig heraus. Da das Skript aufgeteilt ist – in eine lambda_function.py und ein csvtojson.sh – mussten wir sicherstellen, dass beide Teile genau wissen, welcher Input-Bucket zu welchem Output-Bucket gehört. Dieser Abgleich war nicht trivial, weil die Informationen aus einem Skript ins andere übertragen und korrekt verarbeitet werden mussten. Die Koordination der beiden Skripte hat deutlich mehr Zeit in Anspruch genommen, als ich anfangs erwartet hatte.
Auch der Umgang mit den ARN-Rollen war eine Herausforderung, da diese bei jedem Nutzer unterschiedlich sind und entsprechend dynamisch verarbeitet werden müssen. Hier half es mir, "out-of-the-box" zu denken und ein paar unkonventionelle Lösungsansätze auszuprobieren, um schliesslich eine robuste Lösung zu finden. Insgesamt habe ich durch diese Schwierigkeiten eine Menge über die Feinheiten von AWS und die Bedeutung sauberer Schnittstellen zwischen verschiedenen Code-Bestandteilen gelernt. Rückblickend hätte ich an manchen Stellen mehr Zeit für die Planung investieren sollen, um solche Komplikationen zu reduzieren. Nichtsdestotrotz bin ich am Ende zufrieden damit, was wir erreicht haben, und weiss, dass ich diese Erfahrungen in zukünftige Projekte einbringen kann.

## **Reflexion Louis**

Während des Projekts sind wir auf verschiedene Herausforderungen gestoßen, die uns wichtige Erkenntnisse gebracht haben. Der Umgang mit mehreren Repositories führte dazu, dass anfängliche Commits verloren gingen, was die Arbeit weniger transparent machte. Dies zeigte uns, wie wichtig eine einheitliche Struktur und klare Planung in der Versionsverwaltung ist.
Ein weiteres Problem war die manuelle Konfiguration der ARN, die je nach Nutzer individuell ist. Hier wurde uns bewusst, dass automatisierte Lösungen Zeit und Aufwand sparen könnten.
Trotz dieser Hürden konnten wir viel lernen, insbesondere über AWS, Linux und Automatisierung mit Skripten. Unser Bash-Skript erfüllte die Anforderungen zuverlässig, und wir konnten unser technisches Wissen deutlich erweitern.
Für zukünftige Projekte nehmen wir uns vor, die Planungsphase sorgfältiger zu gestalten und mehr Zeit für Dokumentation und Tests einzuplanen. Insgesamt sind wir mit dem Ergebnis zufrieden und fühlen uns gut vorbereitet für kommende Herausforderungen.







