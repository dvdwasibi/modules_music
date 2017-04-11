// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:lib.widgets/modular.dart';

import 'api/api.dart';
import 'models/album.dart';
import 'widgets/loading_status.dart';

/// [ModuleModel] that acts as a controller for managing the state of the
/// AlbumSurface.
class AlbumSurfaceController extends ModuleModel {
  /// ID of the album for this AlbumSurface
  final String albumId;

  /// The album for this given surface
  Album album;

  LoadingStatus _loadingStatus = LoadingStatus.inProgress;

  /// Constructor
  AlbumSurfaceController({
    this.albumId,
  }) {
    assert(albumId != null);
    _fetchAlbum();
  }

  /// Get the current loading status
  LoadingStatus get loadingStatus => _loadingStatus;

  /// Retrieves the full album based on the given ID
  Future<Null> _fetchAlbum() async {
    try {
      album = await Api.getAlbumById(albumId);
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
}
