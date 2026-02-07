# Architektur: Offline iOS Koch-App (HelloFresh-ähnlich)

## Projektstruktur (Ordnerstruktur)
```
RipFreshApp/
├─ App/
│  ├─ RipFreshApp.swift
│  └─ AppEnvironment.swift
├─ Resources/
│  ├─ Recipes/
│  │  ├─ recipes.json
│  │  └─ media/
│  │     ├─ images/
│  │     └─ videos/
│  └─ Localization/
├─ Core/
│  ├─ Models/
│  ├─ Persistence/
│  ├─ Parsing/
│  ├─ Services/
│  └─ Utilities/
├─ Features/
│  ├─ RecipeList/
│  │  ├─ RecipeListView.swift
│  │  └─ RecipeListViewModel.swift
│  ├─ RecipeDetail/
│  │  ├─ RecipeDetailView.swift
│  │  └─ RecipeDetailViewModel.swift
│  ├─ Search/
│  ├─ Favorites/
│  └─ ShoppingList/
├─ Domain/
│  ├─ Entities/
│  ├─ UseCases/
│  └─ Repositories/
├─ Data/
│  ├─ Repositories/
│  ├─ DTOs/
│  └─ DataSources/
│     ├─ BundleDataSource/
│     └─ LocalStoreDataSource/
├─ Presentation/
│  ├─ Components/
│  ├─ Navigation/
│  └─ ViewState/
└─ Tests/
   ├─ Unit/
   └─ Snapshot/
```

**Begründung**: Eine klar getrennte Schichtung (Presentation/Domain/Data/Core) erleichtert MVVM, ermöglicht testbare Use Cases und hält die UI unabhängig von Datendetails. Die `Resources/`-Ebene bündelt alle offline verfügbaren Assets (Rezepte, Bilder, Videos) und erfüllt „Offline First“ sowie „Keine Laufzeit-Abhängigkeiten“. Die `Features/`-Struktur sorgt dafür, dass jede Funktion eine eindeutige Verantwortung besitzt.

## Benennung der Hauptkomponenten

### App-Layer
- **RipFreshApp.swift**: Einstiegspunkt, initialisiert App-Environment und Root-Navigation.
- **AppEnvironment**: Kapselt Abhängigkeiten (Repositories, Use Cases, Services) als zentraler Dependency-Container.

**Begründung**: Ein klarer Einstiegspunkt und ein Environment-Container stellen sicher, dass Abhängigkeiten explizit sind und testbar bleiben.

### Domain-Layer
- **Entities**: `Recipe`, `Ingredient`, `Step`, `Nutrition`, `Category`.
- **UseCases**: `LoadRecipesUseCase`, `SearchRecipesUseCase`, `GetRecipeDetailUseCase`, `ToggleFavoriteUseCase`, `GenerateShoppingListUseCase`.
- **Repositories (Interfaces)**: `RecipeRepository`, `FavoritesRepository`, `ShoppingListRepository`.

**Begründung**: Domain kapselt die Fachlogik unabhängig von der Datenquelle und ermöglicht konsistente Geschäftsregeln für alle Views.

### Data-Layer
- **DataSources**
  - `BundleDataSource`: Lädt `recipes.json` und eingebettete Assets aus dem App-Bundle.
  - `LocalStoreDataSource`: Persistenz für Favoriten/Shopping-Liste (z. B. File-basierter Store, Core Data oder SQLite ohne externe Libraries).
- **DTOs**: Datenmodelle für Parsing/Serialisierung.
- **Repositories (Implementierungen)**: Übersetzen DTOs zu Domain-Entities.

**Begründung**: Data isoliert das „Wie“ der Datenbeschaffung von der Fachlogik und schützt die UI vor Format- und Speicher-Details.

### Presentation-Layer (SwiftUI + MVVM)
- **ViewModels**: `RecipeListViewModel`, `RecipeDetailViewModel`, `SearchViewModel`, etc.
- **Views**: `RecipeListView`, `RecipeDetailView`.
- **Components**: Wiederverwendbare UI-Bausteine.

**Begründung**: MVVM stellt eine klare Trennung von Darstellung (View) und Logik (ViewModel) sicher und erlaubt State-Management ohne Business-Logik in Views.

### Core-Layer
- **Parsing**: JSON-Decoder, Mapping, Validierung.
- **Persistence**: FileStore/CoreData/SQLite-Wrapper (ohne Runtime-Abhängigkeiten).
- **Services**: Zeitmessung, Inhaltsindexer, In-Memory-Cache.
- **Utilities**: Allgemeine Helfer (Formatierung, Fehlerhandling).

**Begründung**: Cross-Cutting Concerns werden zentral gebündelt, damit Domain und Presentation schlank bleiben.

## Datenfluss (Offline First)

1. **App-Start** → `RipFreshApp` baut `AppEnvironment`.
2. **ViewModel** fordert Daten über **Use Case** an.
3. **Use Case** nutzt **Repository-Interface**.
4. **Repository-Implementierung** kombiniert
   - `BundleDataSource` (statisch eingebettete Rezepte)
   - `LocalStoreDataSource` (Benutzerdaten wie Favoriten/Listen)
5. **Repository** mappt DTOs → Domain-Entities.
6. **Use Case** liefert Domain-Entities an **ViewModel**.
7. **ViewModel** transformiert Entities → ViewState → **View**.

**Begründung**: Dieser Fluss stellt sicher, dass Views niemals direkt auf Datenquellen zugreifen, alle Geschäftsregeln zentral bleiben und Offline-Daten im Bundle oberste Priorität haben.

## Verantwortlichkeiten je Layer

### Presentation
- UI Rendering (SwiftUI)
- UI-Interaktionen (Bindings)
- ViewState-Transformation

**Begründung**: Präsentation bleibt UI-orientiert und enthält keine Geschäftslogik.

### ViewModel (Teil des Presentation-Layers)
- Orchestriert Use Cases
- Bereitet ViewState auf
- UI-spezifische Logik (z. B. Sortierung/Filterung für Anzeige)

**Begründung**: ViewModels verbinden UI mit Domain und sorgen für testbare Zustandslogik.

### Domain
- Geschäftsregeln (z. B. Favoritenlogik, Shopping-Liste-Generierung)
- Datenmodelle unabhängig von Speicherformat
- Use Cases als Orchestratoren der Kernlogik

**Begründung**: Die Domain ist stabil, unabhängig und wiederverwendbar.

### Data
- Datenzugriff (Bundle, lokale Persistenz)
- Mapping und Validierung
- Repositories als Adapter zur Domain

**Begründung**: Data kapselt Implementierungsdetails und ermöglicht Austausch der Speicherstrategie ohne Domain/UI-Anpassung.

### Core
- Gemeinsame Infrastruktur (Parsing, Persistence, Caching)

**Begründung**: Querschnittsfunktionen werden zentralisiert, um Code-Duplikation zu vermeiden.

## Architekturentscheidungen (kurz begründet)
- **MVVM + SwiftUI**: Standardkonform zu iOS 16, testbare UI-Logik und klare Trennung von Zuständen.
- **Domain/Data/Presentation Schichten**: Minimiert Kopplung und erleichtert Offline-First-Implementierung.
- **Bundle-First-Datenzugriff**: Gewährleistet sofortige Verfügbarkeit aller Rezepte ohne Netzwerk.
- **Repository Pattern**: Entkoppelt Use Cases von Datenspeichern und ermöglicht spätere Erweiterungen ohne UI-Änderung.
- **Keine Runtime-Abhängigkeiten**: Erfüllt Vorgaben, reduziert Risiko von Offline-Fehlern.
