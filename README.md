# JMeter Performance Testing Project

## Struktur
- `jmx/`: JMeter Test Plans (.jmx)
- `data/`: Test data files (CSV, JSON)
- `results/`: Test execution results and reports
- `scripts/`: Helper scripts for CI/CD or local execution

## Ausführung (CLI)
Um einen Test ohne GUI zu starten:
`jmeter -n -t jmx/mein_test.jmx -l results/result.jtl -e -o results/report`

## Best Practices
1. **Keine Listener während des Lasttests:** Deaktiviere "View Results Tree" für echte Läufe.
2. **Daten-Parametrisierung:** Nutze CSV Data Set Config für dynamische Daten.
3. **Assertions:** Prüfe nicht nur auf HTTP 200, sondern auch auf Content.
