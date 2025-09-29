#!/usr/bin/env dart
// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) {
  if (args.isNotEmpty && args[0] == '--help') {
    _showHelp();
    return;
  }

  final projectRoot = Directory.current;
  final libSrc = Directory('${projectRoot.path}/lib/src');
  final testSrc = Directory('${projectRoot.path}/test/src');

  // Parse feature name and options
  String? featureName;
  final nonOptionArgs = args.where((arg) => !arg.startsWith('--')).toList();

  if (nonOptionArgs.isNotEmpty) {
    featureName = _toSnakeCase(nonOptionArgs[0]);
  }

  // Options
  final bool dryRun = args.contains('--dry-run');
  final bool removeGitKeep = args.contains('--remove-gitkeep');
  final bool interactive = args.contains('--interactive');

  if (featureName == null) {
    _listFeatures(libSrc);
    print(
      '\nUsage: dart scripts/cleanup_features.dart <feature_name> [options]',
    );
    print('Or: dart scripts/cleanup_features.dart --help for more info');
    return;
  }

  print('🧹 Cleaning feature: $featureName\n');

  if (dryRun) {
    print('🔍 DRY RUN MODE - No files will be deleted\n');
  }

  int emptyDirsCount = 0;
  int gitKeepCount = 0;
  int emptyFilesCount = 0;

  // Clean specific feature in lib/src
  final libFeatureDir = Directory('${libSrc.path}/$featureName');
  if (libFeatureDir.existsSync()) {
    print('📂 Scanning lib/src/$featureName/...');
    final libResults = _cleanDirectory(
      libFeatureDir,
      dryRun,
      removeGitKeep,
      interactive,
    );
    emptyDirsCount += libResults.emptyDirs;
    gitKeepCount += libResults.gitKeepFiles;
    emptyFilesCount += libResults.emptyFiles;
  } else {
    print('❌ Feature "$featureName" not found in lib/src/');
    _suggestSimilarFeatures(libSrc, featureName);
    return;
  }

  // Clean specific feature in test/src
  final testFeatureDir = Directory('${testSrc.path}/$featureName');
  if (testFeatureDir.existsSync()) {
    print('📂 Scanning test/src/$featureName/...');
    final testResults = _cleanDirectory(
      testFeatureDir,
      dryRun,
      removeGitKeep,
      interactive,
    );
    emptyDirsCount += testResults.emptyDirs;
    gitKeepCount += testResults.gitKeepFiles;
    emptyFilesCount += testResults.emptyFiles;
  }

  // Summary
  print('\n📊 Cleanup Summary:');
  print('   Empty directories: $emptyDirsCount');
  if (removeGitKeep) print('   .gitkeep files: $gitKeepCount');
  print('   Empty files: $emptyFilesCount');

  if (dryRun) {
    print('\n💡 Run without --dry-run to actually delete files');
  } else {
    print('\n✅ Cleanup completed!');
  }
}

class CleanupResults {
  final int emptyDirs;
  final int gitKeepFiles;
  final int emptyFiles;

  CleanupResults(this.emptyDirs, this.gitKeepFiles, this.emptyFiles);
}

CleanupResults _cleanDirectory(
  Directory dir,
  bool dryRun,
  bool removeGitKeep,
  bool interactive,
) {
  int emptyDirsCount = 0;
  int gitKeepCount = 0;
  int emptyFilesCount = 0;

  final List<FileSystemEntity> toDelete = [];

  // Recursively scan directories
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is Directory) {
      if (_isDirectoryEmpty(entity, removeGitKeep)) {
        toDelete.add(entity);
        emptyDirsCount++;
        print('   📁 Empty directory: ${_getRelativePath(entity.path)}');
      }
    } else if (entity is File) {
      final fileName = entity.path.split(Platform.pathSeparator).last;

      // Check for .gitkeep files
      if (removeGitKeep && fileName == '.gitkeep') {
        toDelete.add(entity);
        gitKeepCount++;
        print('   🗑️  .gitkeep: ${_getRelativePath(entity.path)}');
      }
      // Check for empty files (except .gitkeep which is supposed to be empty)
      else if (fileName != '.gitkeep' && _isFileEmpty(entity)) {
        toDelete.add(entity);
        emptyFilesCount++;
        print('   📄 Empty file: ${_getRelativePath(entity.path)}');
      }
      // Check for common generated/temp files
      else if (_isTemporaryFile(fileName)) {
        toDelete.add(entity);
        emptyFilesCount++;
        print('   🗑️  Temp file: ${_getRelativePath(entity.path)}');
      }
    }
  }

  // Delete files/directories
  if (!dryRun && toDelete.isNotEmpty) {
    for (final entity in toDelete) {
      if (interactive) {
        stdout.write('Delete ${_getRelativePath(entity.path)}? (y/N): ');
        final input = stdin.readLineSync()?.toLowerCase() ?? 'n';
        if (input != 'y' && input != 'yes') {
          continue;
        }
      }

      try {
        if (entity is Directory) {
          entity.deleteSync(recursive: true);
        } else {
          entity.deleteSync();
        }
        print('   ✅ Deleted: ${_getRelativePath(entity.path)}');
      } catch (e) {
        print('   ❌ Failed to delete: ${_getRelativePath(entity.path)} - $e');
      }
    }
  }

  return CleanupResults(emptyDirsCount, gitKeepCount, emptyFilesCount);
}

bool _isDirectoryEmpty(Directory dir, bool ignoreGitKeep) {
  try {
    final contents = dir.listSync();

    if (contents.isEmpty) return true;

    // If ignoring .gitkeep files, check if directory only contains .gitkeep
    if (ignoreGitKeep && contents.length == 1) {
      final entity = contents.first;
      if (entity is File && entity.path.endsWith('.gitkeep')) {
        return true;
      }
    }

    return false;
  } catch (e) {
    return false;
  }
}

bool _isFileEmpty(File file) {
  try {
    return file.lengthSync() == 0;
  } catch (e) {
    return false;
  }
}

bool _isTemporaryFile(String filename) {
  final tempPatterns = [
    '.DS_Store',
    'Thumbs.db',
    '.tmp',
    '.temp',
    '~',
    '.bak',
    '.cache',
    '.log',
  ];

  return tempPatterns.any((pattern) => filename.endsWith(pattern));
}

String _getRelativePath(String fullPath) {
  final current = Directory.current.path;
  if (fullPath.startsWith(current)) {
    return fullPath.substring(current.length + 1);
  }
  return fullPath;
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

void _listFeatures(Directory libSrc) {
  if (!libSrc.existsSync()) {
    print('❌ lib/src directory not found');
    return;
  }

  print('📂 Available features:');
  final features =
      libSrc
          .listSync()
          .whereType<Directory>()
          .map((entity) => entity.path.split(Platform.pathSeparator).last)
          .where((name) => !['common', 'core', 'shared'].contains(name))
          .toList()
        ..sort();

  if (features.isEmpty) {
    print('   No features found');
  } else {
    for (final feature in features) {
      final featureDir = Directory('${libSrc.path}/$feature');
      final hasFiles = _countFilesInDirectory(featureDir);
      print('   📁 $feature ${hasFiles > 0 ? "($hasFiles files)" : "(empty)"}');
    }
  }
}

void _suggestSimilarFeatures(Directory libSrc, String featureName) {
  final features = libSrc
      .listSync()
      .whereType<Directory>()
      .map((entity) => entity.path.split(Platform.pathSeparator).last)
      .toList();

  final similar = features
      .where((feature) => _levenshteinDistance(feature, featureName) <= 2)
      .toList();

  if (similar.isNotEmpty) {
    print('\n💡 Did you mean one of these?');
    for (final suggestion in similar) {
      print('   📁 $suggestion');
    }
  }
}

int _countFilesInDirectory(Directory dir) {
  if (!dir.existsSync()) return 0;

  return dir.listSync(recursive: true).whereType<File>().length;
}

int _levenshteinDistance(String a, String b) {
  if (a.length < b.length) return _levenshteinDistance(b, a);
  if (b.isEmpty) return a.length;

  List<int> previousRow = List.generate(b.length + 1, (i) => i);

  for (int i = 0; i < a.length; i++) {
    List<int> currentRow = [i + 1];

    for (int j = 0; j < b.length; j++) {
      int insertCost = previousRow[j + 1] + 1;
      int deleteCost = currentRow[j] + 1;
      int substituteCost = previousRow[j] + (a[i] == b[j] ? 0 : 1);

      currentRow.add(
        [
          insertCost,
          deleteCost,
          substituteCost,
        ].reduce((a, b) => a < b ? a : b),
      );
    }

    previousRow = currentRow;
  }

  return previousRow.last;
}

void _showHelp() {
  print('''
🧹 Feature Cleanup Script

Usage: dart scripts/cleanup_features.dart <feature_name> [options]

Commands:
  dart scripts/cleanup_features.dart                    # List all features
  dart scripts/cleanup_features.dart <feature_name>     # Clean specific feature

Options:
  --dry-run         Show what would be deleted without actually deleting
  --remove-gitkeep  Also remove .gitkeep files (use with caution)
  --interactive     Ask for confirmation before each deletion
  --help           Show this help message

Examples:
  # List all available features
  dart scripts/cleanup_features.dart
  
  # Preview cleanup for specific feature
  dart scripts/cleanup_features.dart analysis --dry-run
  
  # Clean specific feature
  dart scripts/cleanup_features.dart user_profile
  
  # Interactive cleanup with confirmations
  dart scripts/cleanup_features.dart analysis --interactive
  
  # Remove everything including .gitkeep files
  dart scripts/cleanup_features.dart analysis --remove-gitkeep

What gets cleaned:
  ✅ Empty directories
  ✅ Empty files (except .gitkeep)
  ✅ Temporary files (.DS_Store, Thumbs.db, etc.)
  ⚠️  .gitkeep files (only with --remove-gitkeep flag)

''');
}
