# JMeter Performance Testing Project - Testshop

Dieses Projekt ist ein professionelles Grundgerüst für Lasttests der `bqnow-testapp`. Es dient als Lernpfad von den ersten Klicks bis zur komplexen API-Korrelation und industriekonformen Report-Generierung.

## 🏗 Projektstruktur
- `jmx/`: JMeter Testpläne (`.jmx`). Hauptdatei: `smoketestjmx.jmx`.
- `data/`: Testdaten (z.B. `users.csv` für parametrisierte Logins).
- `results/`: Testergebnisse (`.jtl`) und generierte HTML-Reports.
- `scripts/`: Helper-Scripts für die Automatisierung (CI/CD-ready).

---

## 🧪 Realisierte Test-Szenarien

Das Projekt nutzt **Transaction Controller**, um Business-Prozesse logisch zu gruppieren und die Gesamtzeit einer "User Journey" zu messen.

### UC01: Full Checkout Journey (Happy Path)
Simuliert einen erfolgreichen Kaufprozess:
1.  **Homepage Visit**: Initialer Seitenaufruf.
2.  **API Login**: Authentifizierung mit Daten aus `users.csv`.
3.  **Browse Products**: Abruf der Produktliste und **dynamische Extraktion** eines zufälligen Produkts.
4.  **Product Details**: Aufruf der Detailseite des extrahierten Produkts.
5.  **Checkout**: Kaufabschluss mit den korrelierten Daten.

### UC02: Error Checkout Journey (Negative Testing)
Prüft die Fehlerbehandlung des Systems:
- **Ziel**: Gezieltes Auslösen eines Fehlers durch Kauf des Produkts `999` ("Glitchy Gadget").
- **Technik**: Einsatz eines **JSON Path Filters** (`$.data[?(@.id == 999)]`), um das Fehlerprodukt sicher im Katalog zu finden, unabhängig von seiner Position.
- **Validierung**: Erwartet einen **HTTP 500**. Dank `Ignore Status` in der Response Assertion wird dieser kontrollierte Fehler in JMeter als "Erfolg" gewertet.

---

## 📚 Architektur & Best Practices

### 🛰 API vs. UI Testing
Ein Kern-Insight dieses Projekts: JMeter umgeht das Frontend und spricht direkt die **REST-API Endpoints** (`/api/...`) an. Dies ermöglicht isolierte Backend-Tests, erfordert aber eine manuelle Pflege der Header (z.B. `Content-Type: application/json`).

### 🧩 Korrelation & JSON-Path Filter
Für stabile Tests nutzen wir fortgeschrittene Extraktions-Techniken:
- **Index-Suche**: `$.data[0]` (nimmt das erste Element).
- **Zufall**: `Match No: 0` im PostProcessor würfelt ein Element aus.
- **Attribut-Filter**: `$.data[?(@.id == 999)]` findet Objekte anhand ihrer ID. Dies ist der Goldstandard für robuste Testskripte.

### 🏠 Portabilität (Relative Pfade)
Alle Dateipfade (z.B. zur `users.csv`) sind **relativ** angegeben. Dadurch ist das Projekt sofort auf jedem System (lokal, Jenkins, GitHub Actions) ohne Anpassungen lauffähig.

---

## 📈 Last-Profile & Thread Group Parameter

| Parameter | Bedeutung für den Test |
| :--- | :--- |
| **Number of Threads** | Anzahl der parallelen User (Last-Level). |
| **Ramp-up Period** | Zeit zum Hochfahren der User (Vermeidung von Schock-Last). |
| **Loop Count** | Wiederholungen. "Infinite" kombiniert mit Duration für Dauertests. |
| **Action on Error** | `startnextloop` sorgt dafür, dass bei einem Fehler (z.B. Login Fail) der Thread sauber neu startet, statt Folgefehler zu produzieren. |

### Last-Szenarien im Vergleich

| Szenario | Threads | Ramp-up | Duration | Loop | Ziel |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **🎯 Debugging** | **1** | **1** | **--** | **1** | **Script-Logik prüfen (Timer auf 0ms).** |
| Smoke Test | 2-5 | 5 | -- | 1 | Funktionaler Check nach Deployment. |
| Load Test | 20 | 30 | 600s | Inf. | Realistisches Nutzeraufkommen messen. |
| Stress Test | 200 | 10 | 60s | Inf. | Absolute Belastungsgrenze finden (Bruchtest). |

---

## 🚀 Ausführung (PRO-Mode)

### 1. Per Hilfsskript (Empfohlen)
Löscht alte Daten und baut einen frischen HTML-Report:
```bash
./scripts/run_test.sh
```

### 2. Der HTML-Report
Nach der Ausführung findest du unter `results/report/index.html` ein Dashboard mit:
- **Total Transactions**: Gesamtzeit der Journeys (`UC01`, `UC02`).
- **Response Time Over Time**: Zeitverlauf der Performance.
- **Error Ratio**: Detaillierte Aufschlüsselung fehlerhafter Requests.

---

## 🛠 GUI Tipps & Tricks
1. **Säubern**: Nutzen Sie immer den **Doppel-Besen** (`CMD+Shift+E`), um alte JTL-Daten aus der GUI-Ansicht zu löschen.
2. **Path Context**: JMeter startet standardmäßig im Verzeichnis des JMX-Files oder dem Start-Verzeichnis der Shell.
3. **Log-Panel**: Bei Problemen hilft das Log-Panel (gelbes Ausrufezeichen rechts oben).
