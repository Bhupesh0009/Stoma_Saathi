# Stoma Saathi - Project Structure

## Directory Organization

```
lib/
├── main.dart                      # App entry point (minimal)
├── models/
│   ├── app_models.dart           # Core data models (LocalizedText, LessonData, ModuleData, AppText)
│   └── modules_data.dart         # Module definitions and buildModules()
├── utils/
│   └── theme_utils.dart          # Theme, color utilities, and helper functions
├── widgets/
│   ├── index.dart               # Barrel file for shared widgets
│   ├── language_chip.dart       # Language selection widget
│   ├── info_banner.dart         # Information display banner
│   ├── text_card.dart           # Text card with bullet points
│   └── [other shared widgets]   # Additional reusable components
├── screens/
│   ├── home/
│   │   ├── index.dart           # Barrel file for home screens
│   │   ├── home_screen.dart     # Main home screen
│   │   ├── splash_screen.dart   # Splash screen
│   │   └── [other home components]
│   ├── module_1/
│   │   ├── index.dart           # Module 1 - Stoma Basics
│   │   ├── module_screen.dart
│   │   └── lesson_screens/
│   │       ├── lesson_1.dart
│   │       ├── lesson_2.dart
│   │       └── [...]
│   ├── module_2/
│   │   ├── index.dart           # Module 2 - Stoma Care Kit
│   │   ├── module_screen.dart
│   │   ├── lesson_screens/
│   │   │   ├── types_of_ostomy_bags.dart  # First lesson
│   │   │   ├── skin_barrier_products.dart
│   │   │   └── [...]
│   │   └── widgets/
│   │       ├── ostomy_system_card.dart
│   │       └── [module-specific widgets]
│   ├── module_3/ ... module_8/  # Similar structure for other modules
│   └── [shared lesson components]
└── [assets structure unchanged]
```

## File Organization Strategy

### Models (`lib/models/`)
- **app_models.dart**: Contains all core data classes
  - `enum AppLanguage`
  - `class LocalizedText`
  - `class LessonData`
  - `class ModuleData`
  - `class AppText`

- **modules_data.dart**: Contains module-specific data
  - `buildModules()` function that returns list of 8 modules with their lessons

### Utils (`lib/utils/`)
- **theme_utils.dart**: Theme configuration and helper functions
  - `buildAppTheme()` - ThemeData configuration
  - `darken()` - Color manipulation helper

### Widgets (`lib/widgets/`)
Shared, reusable components used across multiple screens:
- Language selector chip
- Info banner cards
- Text cards with bullet points
- Module tiles
- Module artwork
- And other common components

### Screens (`lib/screens/`)

#### Home Screen (`lib/screens/home/`)
- Home page listing all modules
- Splash screen
- Navigation bar
- Module cards

#### Module Screens (`lib/screens/module_1/` through `lib/screens/module_8/`)
Each module folder contains:
- **module_screen.dart**: Module overview page
- **lesson_screens/**: Separate files for each lesson
- **widgets/**: Module-specific widget components

### Example: Module 2 Structure
```
module_2/
├── index.dart
├── module_screen.dart          # Module 2 home page
├── lesson_screens/
│   ├── lesson_1_types_bags.dart
│   ├── lesson_2_skin_barrier.dart
│   ├── lesson_3_measuring.dart
│   ├── lesson_4_disposal.dart
│   ├── lesson_5_adhesive.dart
│   ├── lesson_6_protective_films.dart
│   └── lesson_7_cleaning.dart
└── widgets/
    ├── ostomy_system_card.dart      # Reusable card for pouch systems
    ├── one_piece_illustration.dart
    └── two_piece_illustration.dart
```

## Migration Path

1. **Phase 1**: Create folder structure and model files ✓
2. **Phase 2**: Extract shared widgets
3. **Phase 3**: Extract home screen components
4. **Phase 4**: Extract module-specific screens progressively
5. **Phase 5**: Update main.dart to import from organized modules
6. **Phase 6**: Remove code duplication and finalize imports

## Key Principles

- **Single Responsibility**: Each file has one clear purpose
- **DRY (Don't Repeat Yourself)**: Shared code goes to `widgets/` and `utils/`
- **Scalability**: Easy to add new modules without modifying existing code
- **Maintainability**: Clear folder structure makes code easier to find and update
- **Modularity**: Each module is self-contained and can be developed/tested independently

## Current Status

The folder structure is in place. The existing `main.dart` remains functional.
The code can be gradually extracted into organized files without breaking the app.
