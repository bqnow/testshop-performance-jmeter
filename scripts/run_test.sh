#!/bin/bash

# JMeter Clean & Run Script
# Dieses Skript sollte vom Projekt-Root aus gestartet werden: ./scripts/run_test.sh

PROJECT_ROOT=$(pwd)
RESULTS_DIR="$PROJECT_ROOT/results"
JMX_FILE="$PROJECT_ROOT/jmx/smoketestjmx.jmx"
JTL_FILE="$RESULTS_DIR/result.jtl"
REPORT_DIR="$RESULTS_DIR/report"

# Sicherstellen, dass der Results-Ordner existiert
mkdir -p "$RESULTS_DIR"

echo "🧹 Cleaning old results..."
rm -f "$JTL_FILE"
rm -rf "$REPORT_DIR"

echo "🚀 Starting JMeter test (Non-GUI)..."
jmeter -n -t "$JMX_FILE" -l "$JTL_FILE" -e -o "$REPORT_DIR"

echo "✅ Done! View report at: $REPORT_DIR/index.html"
