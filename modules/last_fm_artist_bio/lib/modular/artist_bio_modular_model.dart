// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:lib.widgets/modular.dart';
import 'package:meta/meta.dart';
import 'package:last_fm_api/api.dart';
import 'package:last_fm_models/last_fm_models.dart';
import 'package:last_fm_widgets/last_fm_widgets.dart';

/// [ModuleModel] that manages the state of the Artist Bio Module.
class ArtistBioModularModel extends ModuleModel {

  /// Constructor
  ArtistBioModularModel({
    @required this.apiKey,
  }) {
    assert(apiKey != null);
  }

  /// The artist for this given module
  Artist album;

  /// Last FM API key
  final String apiKey;

  /// Get the current loading status
  LoadingStatus get loadingStatus => _loadingStatus;
  LoadingStatus _loadingStatus = LoadingStatus.inProgress;

  /// Retrieves the artist bio
  Future<Null> fetchAlbum(String albumId) async {
    LastFmApi api = new LastFmApi(apiKey: apiKey);
    try {
      album = await api.getAlbumById(albumId);
      if (album != null) {
        _loadingStatus = LoadingStatus.completed;
      } else {
        _loadingStatus = LoadingStatus.failed;
      }
    } catch (error) {
      _loadingStatus = LoadingStatus.failed;
    }
    notifyListeners();
  }

  /// Update the album ID
  @override
  void onNotify(String json) {
    final dynamic doc = JSON.decode(json);
    String albumId;

    try {
      final dynamic uri = doc['view'];
      if (uri['scheme'] == 'spotify' && uri['host'] == 'album') {
        albumId = uri['path segments'][0];
      } else if (uri['path segments'][0] == 'album') {
        albumId = uri['path segments'][1];
      } else {
        return;
      }
    } catch (_) {
      return;
    }

    fetchAlbum(albumId);
  }
}
