// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:lib.widgets/modular.dart';
import 'package:music_api/api.dart';
import 'package:music_models/music_models.dart';
import 'package:music_widgets/music_widgets.dart';

/// [ModuleModel] that manages the state of the Artist Surface.
class ArtistSurfaceModel extends ModuleModel {
  /// The artist for this given surface
  Artist artist;

  /// Albums for the given artist
  List<Album> albums;

  /// List of relatedArtists for the given artist
  List<Artist> relatedArtists;

  LoadingStatus _loadingStatus = LoadingStatus.inProgress;


  /// Get the current loading status
  LoadingStatus get loadingStatus => _loadingStatus;

  /// Retrieves all the data necessary to render the artist surface
  Future<Null> fetchArtist(String artistId) async {
    try {
      List<dynamic> response = await Future.wait(<Future<Object>>[
        Api.getArtistById(artistId),
        Api.getAlbumsForArtist(artistId),
        Api.getRelatedArtists(artistId),
      ]);
      artist = response[0];
      albums = response[1];
      relatedArtists = response[2];
      if (artist != null && albums != null) {
        _loadingStatus = LoadingStatus.completed;
      } else {
        _loadingStatus = LoadingStatus.failed;
      }
    } catch (_) {
      _loadingStatus = LoadingStatus.failed;
    }
    notifyListeners();
  }

  /// Update the artist ID
  @override
  void onNotify(String json) {
    final dynamic doc = JSON.decode(json);
    if(doc is Map && doc['spotify:artistId'] is String) {
      fetchArtist(doc['spotify:artistId']);
    }
  }
}