#!/usr/bin/env dart
// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart scripts/new_feature.dart <feature_name>');
    exit(1);
  }

  final featureName = args[0];
  final featureNameSnake = _toSnakeCase(featureName);
  final featureNamePascal = _toPascalCase(featureNameSnake);

  print('Creating feature: $featureNameSnake');

  final projectRoot = Directory.current;
  final libSrc = Directory('${projectRoot.path}/lib/src');
  final testSrc = Directory('${projectRoot.path}/test/src');

  final directories = [
    // Main feature directories
    // Domain
    '${libSrc.path}/$featureNameSnake/domain/entities',
    '${libSrc.path}/$featureNameSnake/domain/repositories',
    '${libSrc.path}/$featureNameSnake/domain/failures',
    // Data layer
    '${libSrc.path}/$featureNameSnake/data/datasources',
    '${libSrc.path}/$featureNameSnake/data/models',
    '${libSrc.path}/$featureNameSnake/data/repositories',
    '${libSrc.path}/$featureNameSnake/data/mappers',
    '${libSrc.path}/$featureNameSnake/data/exceptions',
    // Presentation layer
    '${libSrc.path}/$featureNameSnake/presentation/pages',
    '${libSrc.path}/$featureNameSnake/presentation/widgets',
    '${libSrc.path}/$featureNameSnake/presentation/blocs',
    // Test directories
    '${testSrc.path}/$featureNameSnake/domain',
    '${testSrc.path}/$featureNameSnake/data',
    '${testSrc.path}/$featureNameSnake/bloc',
    '${testSrc.path}/$featureNameSnake/presentation',
  ];

  // Create directories
  for (final dir in directories) {
    Directory(dir).createSync(recursive: true);
    print('Created: $dir');
  }

  // Create template files
  _createRepositoryInterface(libSrc.path, featureNameSnake, featureNamePascal);
  _createRepositoryImpl(libSrc.path, featureNameSnake, featureNamePascal);
  _createFeatureReadme(
    libSrc.path,
    featureNameSnake,
    featureNamePascal,
    featureName,
  );

  print('\n✅ Feature \'$featureNameSnake\' created successfully!');
  print('📁 Location: ${libSrc.path}/$featureNameSnake');
  print('📖 Documentation: ${libSrc.path}/$featureNameSnake/README.md');
  print('\n📋 Next steps:');
  print('1. Read the README.md for detailed guidance');
  print('2. Define your domain entities in domain/entities/');
  print('3. Create repository interfaces in domain/repositories/');
  print('4. Implement data sources in data/datasources/');
  print('5. Build your UI with Blocs in presentation/');
}

String _toSnakeCase(String input) {
  return input
      .replaceAllMapped(
        RegExp(r'[A-Z]'),
        (match) => '_${match.group(0)!.toLowerCase()}',
      )
      .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '')
      .toLowerCase();
}

String _toPascalCase(String snakeCase) {
  return snakeCase
      .split('_')
      .map(
        (word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
      )
      .join();
}

void _createRepositoryInterface(
  String libPath,
  String featureNameSnake,
  String featureNamePascal,
) {
  final content =
      '''
abstract class ${featureNamePascal}Repository {
  // TODO: Add repository methods
}
''';

  File(
    '$libPath/$featureNameSnake/domain/repositories/${featureNameSnake}_repository.dart',
  ).writeAsStringSync(content);
}

void _createRepositoryImpl(
  String libPath,
  String featureNameSnake,
  String featureNamePascal,
) {
  final content =
      '''
import '../../domain/repositories/${featureNameSnake}_repository.dart';

class ${featureNamePascal}RepositoryImpl implements ${featureNamePascal}Repository {
  // TODO: Implement repository methods
  // TODO: Add datasources as dependencies
  // TODO: Add mappers as dependencies
}
''';

  File(
    '$libPath/$featureNameSnake/domain/repositories/${featureNameSnake}_repository_impl.dart',
  ).writeAsStringSync(content);
}

void _createFeatureReadme(
  String libPath,
  String featureNameSnake,
  String featureNamePascal,
  String originalName,
) {
  final content =
      '''
# $originalName Feature

## Overview
This feature handles $originalName functionality in the Larvixon application.

## Architecture
This feature is structured into three main layers:

### Domain Layer (`domain/`)
- **entities/**: Core business objects (e.g., $featureNamePascal)
- **repositories/**: Abstract interfaces for data access
- **failures/**: Domain-specific error types

### Data Layer (`data/`)
- **models/**: DTOs for API responses and requests
- **datasources/**: Remote (API) and local (cache/database) data sources
- **repositories/**: Concrete implementations of domain repositories
- **mappers/**: Convert between DTOs and domain entities
- **exceptions/**: Data layer specific exceptions

### Presentation Layer (`presentation/`)
- **pages/**: Main screens and routes
- **widgets/**: UI components
- **blocs/**: State management (Bloc/Cubit)
''';

  File('$libPath/$featureNameSnake/README.md').writeAsStringSync(content);
}
