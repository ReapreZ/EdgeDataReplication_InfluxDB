#!/bin/bash

# Starte InfluxDB im Hintergrund
influxd &

# Warte darauf, dass InfluxDB vollständig hochgefahren ist und bereit ist
until curl -s http://localhost:8087/health | grep -q '"status":"pass"'; do
  echo "Warte auf InfluxDB..."
  sleep 2
done

echo "InfluxDB ist bereit!"

# Führe das Setup-Skript für die Replikation aus
/setup_replication.sh

# Hier können weitere Befehle zum Starten des Containers folgen, falls nötig
exec "$@"  # Führt den Standardprozess (falls vorhanden) weiter aus
