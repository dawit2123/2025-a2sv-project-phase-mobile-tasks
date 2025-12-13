# Testing Guide

This document provides instructions for testing the eCommerce app.

## Prerequisites

Before running tests, ensure you have Flutter installed and all dependencies are fetched:

```bash
cd main
flutter pub get
```

## Generating Mock Files

The test files use mockito for mocking dependencies. Before running tests, you need to generate the mock files:

```bash
# Generate mock files for all test files
flutter pub run build_runner build --delete-conflicting-outputs
```

This will create `.mocks.dart` files alongside each test file that uses `@GenerateMocks` annotation.

## Running Tests

### Run All Tests

```bash
flutter test
```

### Run Specific Test Files

```bash
# Test NetworkInfo implementation
flutter test test/core/network/network_info_impl_test.dart

# Test Local Data Source
flutter test test/features/product/data/datasources/product_local_data_source_impl_test.dart

# Test Remote Data Source
flutter test test/features/product/data/datasources/product_remote_data_source_impl_test.dart

# Test Repository Implementation
flutter test test/features/product/data/repositories/product_repository_impl_test.dart

# Test BLoC
flutter test test/features/product/presentation/bloc/product_bloc_test.dart
```

### Run Tests with Coverage

```bash
flutter test --coverage
```

To view coverage report:

```bash
# Install lcov if not already installed (macOS)
brew install lcov

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open coverage report in browser
open coverage/html/index.html
```

## Test Structure

The test suite includes:

1. **Core Layer Tests**
   - `network_info_impl_test.dart`: Tests network connectivity checking

2. **Data Layer Tests**
   - `product_local_data_source_impl_test.dart`: Tests local data persistence with SharedPreferences
   - `product_remote_data_source_impl_test.dart`: Tests remote API calls with HTTP client
   - `product_repository_impl_test.dart`: Tests repository logic and data source coordination

3. **Presentation Layer Tests**
   - `product_bloc_test.dart`: Tests BLoC events, states, and business logic

## Writing New Tests

When adding new tests:

1. Import required testing packages:
   ```dart
   import 'package:flutter_test/flutter_test.dart';
   import 'package:mockito/annotations.dart';
   import 'package:mockito/mockito.dart';
   ```

2. Add `@GenerateMocks` annotation for classes you want to mock:
   ```dart
   @GenerateMocks([YourClass, AnotherClass])
   import 'your_test_file.mocks.dart';
   ```

3. Regenerate mocks:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Write your tests following the AAA pattern:
   - **Arrange**: Set up test data and mocks
   - **Act**: Execute the code being tested
   - **Assert**: Verify the expected outcome

## Troubleshooting

### Mock files not found
If you get errors about missing `.mocks.dart` files, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Test dependencies missing
If tests fail due to missing dependencies, run:
```bash
flutter pub get
```

### Clean and rebuild
If you encounter persistent issues:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter test
```
