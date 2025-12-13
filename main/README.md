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

### Core Dependencies
- **equatable**: Value equality for entities and models
- **dartz**: Functional programming (Either type for error handling)

### Data & Network
- **http**: HTTP client for making API requests
- **shared_preferences**: Local data persistence
- **internet_connection_checker**: Network connectivity detection

### State Management
- **flutter_bloc**: BLoC pattern implementation for state management

### Development & Testing
- **mockito**: Mocking framework for unit tests
- **build_runner**: Code generation for mocks
- **bloc_test**: Testing utilities for BLoC
- **flutter_lints**: Linting rules for code quality

## Features Implemented

### Network Layer
- **NetworkInfo**: Abstract interface for network connectivity checking
- **NetworkInfoImpl**: Concrete implementation using internet_connection_checker

### Data Sources
- **ProductLocalDataSource**: Interface for local data operations
- **ProductLocalDataSourceImpl**: Implementation using SharedPreferences for caching
- **ProductRemoteDataSource**: Interface for remote data operations
- **ProductRemoteDataSourceImpl**: Implementation using HTTP client for API calls

### Repository
- **ProductRepositoryImpl**: Enhanced implementation with:
  - Network-aware data source selection
  - Automatic caching of remote data
  - Offline-first architecture
  - Comprehensive error handling

### State Management
- **ProductBloc**: BLoC for managing product-related state
- **ProductEvent**: Event classes for user actions (Load, Create, Update, Delete)
- **ProductState**: State classes representing different UI states (Loading, Loaded, Error, Success)

## Getting Started

### Installation

```bash
cd main
flutter pub get
```

### Running the App

```bash
flutter run
```

### Testing

See [TESTING.md](TESTING.md) for detailed testing instructions.

Quick start:
```bash
# Generate mock files
flutter pub run build_runner build --delete-conflicting-outputs

# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Architecture Benefits

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Testability**: All components are independently testable with mocks
3. **Offline Support**: Automatic caching enables offline functionality
4. **Network Awareness**: Smart data source selection based on connectivity
5. **Type Safety**: Strongly typed entities, models, and states
6. **Error Handling**: Comprehensive error handling with specific failure types

## Resources

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
