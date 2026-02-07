# RipFresh Offline-Datenmodell (ohne UI)

## Repository-Struktur (logische Analyse)
- `ripFresh/`: Enthält ausschließlich Rezept-PDFs (teilweise in Unterordnern). Das ist die **primäre Datenquelle**.
- `ripFresh/recipes.json`: Normalisierter Index über alle PDFs im Repository.
- `ripFresh/recipes.schema.json`: JSON-Schema zur Validierung des Index.
- `AppModel/`: Swift-Modelle und Lade-Logik für Bundle-Import sowie Persistenz-Konzept.
- `scripts/generate_recipes_json.py`: Erzeugt den Index aus den PDF-Dateien.

## Datenquelle
Die vollständigen Rezeptinformationen liegen in den PDF-Karten. Für die Offline-App werden diese PDFs unverändert in den App Bundle aufgenommen. Der JSON-Index referenziert jede PDF-Datei über Pfad, Größe und SHA-256-Hash.

## Bundle-Strategie
- Alle PDFs werden in den App Bundle aufgenommen (z. B. als Folder-Reference).
- `recipes.json` und `recipes.schema.json` liegen im gleichen Bundle, damit sie gemeinsam geladen und validiert werden können.

## Lade-Flow (App-Start)
1. `RecipeBundleLoader.loadIndex()` lädt `recipes.json`.
2. Bei Bedarf lädt die App einzelne PDF-Rohdaten über `RecipeBundleLoader.loadPDFData(for:)`.
3. Optional: Initiale Speicherung der Indexdaten in Core Data (ohne Änderung der Rezeptdaten).

## Read-Only-Konzept
Rezeptdaten bleiben unverändert: alle Modifikationen (Favoriten, Wochenplanung, Einkaufsliste) werden **separat** persistiert.

## Persistenz-Konzept (Favoriten, Wochenplanung, Einkaufsliste)
- **Favoriten**: Liste von `recipeId`s mit Timestamp.
- **Wochenplanung**: Einträge pro Tag und Slot (Frühstück/Mittag/Abend/Snack).
- **Einkaufsliste**: Beliebige Items mit optionaler Menge/Notiz und `isChecked`.

Implementationshinweis:
- In Core Data jeweils eigene Entities oder eine JSON-Datei pro Feature.
- Das Beispiel in `PersistenceConcept.swift` zeigt eine filebasierte Variante (lokal, offline, read/write).
