import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Asset loader that loads multiple JSON localization files
/// from a specified folder for a given locale.
class MultipleLocalizationAssetLoader extends AssetLoader {
  const MultipleLocalizationAssetLoader();

  Future<List<String>> _listJsonAssetsInFolder(String folder) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final manifestMap = jsonDecode(manifestContent) as Map<String, dynamic>;

    return manifestMap.keys
        .where((path) => path.startsWith(folder) && path.endsWith('.json'))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final localePath = '$path/${locale.toStringWithSeparator(separator: "-")}';

    EasyLocalization.logger.debug('Load asset from $localePath');

    final jsonPaths = await _listJsonAssetsInFolder(localePath);

    final data = <String, dynamic>{};

    for (final jsonPath in jsonPaths) {
      final asset = await rootBundle.loadString(jsonPath);

      final json = jsonDecode(asset) as Map<String, dynamic>;

      data.addAll(json);
    }

    return data;
  }
}
