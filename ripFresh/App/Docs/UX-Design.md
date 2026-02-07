# RipFresh UX/Interface Konzept

## Navigation Struktur
- **Tab Bar mit fünf Bereichen**: Rezepte, Suche, Favoriten, Wochenplanung, Einkaufsliste.
- **Begründung**: Häufige Aufgaben sind direkt erreichbar, ohne tiefe Navigation. Die Tab Bar bleibt beim Kochen stabil und reduziert kognitive Last.
- **Offline-Nutzung**: Jede Hauptfunktion greift auf lokale Datenmodelle und Persistenz zu, keine Netzwerkabhängigkeit.

## Design System
- **Farben**: Ruhige Blau/Grün-Töne (calmBlue/calmMint) für Fokus, neutrale Hintergründe für Lesen.
- **Typografie**: Runde Systemschrift mit klaren Hierarchien (Title/Headline/Body/Caption).
- **Komponenten**: Große Karten mit sanften Radien, ruhige Schatten, klare Chip-Filter.
- **Dark Mode**: Systemfarben für Text und Hintergründe, damit Dark Mode automatisch unterstützt wird.
- **Animationen**: Keine animierten Übergänge außer Standard-UI-Transitions.

---

## Screens

### 1) Rezeptübersicht
**Layout Entscheidung**
- Große Bildkarten in vertikaler Liste, damit schnelle visuelle Erkennung möglich ist.
- Titel und wichtigste Meta-Infos (Zeit, Portionen, Schwierigkeit) sind direkt sichtbar.

**Bedienbarkeit beim Kochen**
- Favoriten-Button direkt auf der Karte, kein tiefes Navigieren nötig.
- Große Tap-Flächen, um mit einem Finger sicher zu navigieren.

**Offline Nutzbarkeit**
- Rezepte werden lokal geladen und gecacht.

**Komplexität reduzieren**
- Nur primäre Informationen auf der Karte; Details erst im Rezeptdetail.

---

### 2) Rezeptdetail
**Layout Entscheidung**
- Hero-Bild oben, anschließend klare Informationsblöcke (Tags, Zutaten, Schritte).
- Kochmodus als primärer Call-to-Action am unteren Rand.

**Bedienbarkeit beim Kochen**
- Kochmodus-Button fixiert unten, groß und leicht erreichbar.
- Zutatenliste mit klaren Mengenangaben.

**Offline Nutzbarkeit**
- Detailinformationen werden lokal aus dem Datenmodell geladen.

**Komplexität reduzieren**
- Tags sind kompakt als Chips, keine überladenen Metadaten.

---

### 3) Kochmodus
**Layout Entscheidung**
- Fokus auf Schritt-Titel und Anweisung mit größerer Schrift.
- Fortschrittsanzeige oben für Orientierung.

**Bedienbarkeit beim Kochen**
- Große Buttons für Vor/Zurück, Toggle für „Display wach halten“.
- Kontrastreiche Typografie für schnelle Lesbarkeit.

**Offline Nutzbarkeit**
- Schritte sind lokal verfügbar.

**Komplexität reduzieren**
- Nur eine Aufgabe gleichzeitig: der aktuelle Schritt.

---

### 4) Suche & Filter
**Layout Entscheidung**
- Filterchips horizontal, damit sie schnell gescannt werden.
- Suchleiste oben für sofortigen Zugriff.

**Bedienbarkeit beim Kochen**
- Filter können mit wenigen Taps angepasst werden.

**Offline Nutzbarkeit**
- Filterung erfolgt lokal auf dem Datensatz.

**Komplexität reduzieren**
- Maximal ein aktiver Schwierigkeitsfilter, Tags als Auswahlmenge.

---

### 5) Favoriten
**Layout Entscheidung**
- Ruhige Listenansicht, identisch zur Suche, damit die Interaktion konsistent bleibt.

**Bedienbarkeit beim Kochen**
- Favoriten bleiben schnell auffindbar, besonders für häufige Gerichte.

**Offline Nutzbarkeit**
- Favoriten werden lokal gespeichert.

**Komplexität reduzieren**
- Leerer Zustand mit klarer Handlungsaufforderung.

---

### 6) Wochenplanung
**Layout Entscheidung**
- Jeder Tag als Karte, damit die Woche übersichtlich bleibt.
- Kurze Rezeptzeilen pro Tag für schnelle Planung.

**Bedienbarkeit beim Kochen**
- Im Detail kann ein Rezept direkt einem Tag zugewiesen werden.

**Offline Nutzbarkeit**
- Wochenplan wird lokal persistiert und ist jederzeit verfügbar.

**Komplexität reduzieren**
- Fokus auf die aktuelle Woche, Reset-Option zum schnellen Neustart.

---

### 7) Einkaufsliste
**Layout Entscheidung**
- Checkliste mit Kategorie und Menge, damit Einkäufe strukturiert sind.
- Schnellzugriff zum manuellen Hinzufügen.

**Bedienbarkeit beim Kochen**
- Große Checkmarks, schnell abhakbar mit einer Hand.

**Offline Nutzbarkeit**
- Liste wird lokal gespeichert, funktioniert ohne Verbindung.

**Komplexität reduzieren**
- Wenige UI-Elemente, klare visuelle Hierarchie.
