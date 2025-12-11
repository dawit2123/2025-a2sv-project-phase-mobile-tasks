# eCommerce Mobile App

A Flutter eCommerce application built with Clean Architecture and Test-Driven Development (TDD) principles.

## Architecture

This project follows **Clean Architecture** principles, separating the codebase into three main layers:

### 1. Domain Layer (Business Logic)
The innermost layer containing business logic and entities.
- **Entities**: Core business objects (e.g., `Product`)
- **Repositories**: Abstract interfaces defining data operations
- **Use Cases**: Application-specific business rules

### 2. Data Layer
Responsible for data management and external communication.
- **Models**: Data representations that extend domain entities
- **Data Sources**: Abstract interfaces for remote and local data access
- **Repository Implementations**: Concrete implementations of domain repositories

### 3. Presentation Layer
Handles UI and user interactions.
- **Widgets**: UI components
- **State Management**: Application state handling
- **Pages/Screens**: Complete page views

## Folder Structure

```
lib/
├── core/
│   ├── error/
│   │   └── failures.dart          # Error handling abstractions
│   └── usecases/                  # Base use case classes
├── features/
│   └── product/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── product_local_data_source.dart
│       │   │   └── product_remote_data_source.dart
│       │   ├── models/
│       │   │   └── product_model.dart
│       │   └── repositories/
│       │       └── product_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── product.dart
│       │   ├── repositories/
│       │   │   └── product_repository.dart
│       │   └── usecases/
│       │       ├── get_product.dart
│       │       ├── insert_product.dart
│       │       ├── update_product.dart
│       │       └── delete_product.dart
│       └── presentation/
│           ├── pages/
│           ├── widgets/
│           └── bloc/              # State management
```

## Data Flow

1. **Presentation → Domain**: UI triggers use cases
2. **Domain → Data**: Use cases call repository interfaces
3. **Data → External**: Repository implementations use data sources
4. **External → Data**: Data sources fetch/store data
5. **Data → Domain**: Data is converted from models to entities
6. **Domain → Presentation**: Results are returned to UI

## Dependencies

- **equatable**: Value equality for entities and models
- **dartz**: Functional programming (Either type for error handling)

## Getting Started

This project is a starting point for a Flutter application following Clean Architecture.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
