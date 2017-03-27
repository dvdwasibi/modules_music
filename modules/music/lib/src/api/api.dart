// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show JSON;

import 'package:http/http.dart' as http;

import '../models.dart';

const String _kApiBaseUrl = 'api.spotify.com';

/// Client for Spotify APIs
class Api {
  /// Retrieves given artist based on id
  static Future<Artist> getArtistById(String id) async {
    Uri uri = new Uri.https(_kApiBaseUrl, '/v1/artists/$id');
    http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    return new Artist.fromJson(JSON.decode(response.body));
  }

  /// Retrieves related artists for given artist id
  static Future<List<Artist>> getRelatedArtists(String id) async {
    Uri uri = new Uri.https(_kApiBaseUrl, '/v1/artists/$id/related-artists');
    http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    dynamic jsonData = JSON.decode(response.body);
    List<Artist> artists = <Artist>[];
    if (jsonData['artists'] is List<dynamic>) {
      jsonData['artists'].forEach((dynamic artistJson) {
        artists.add(new Artist.fromJson(artistJson));
      });
    }
    return artists;
  }

  /// Retrieves the given album based on id
  static Future<Album> getAlbumById(String id) async {
    Uri uri = new Uri.https(_kApiBaseUrl, '/v1/albums/$id');
    http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    return new Album.fromJson(JSON.decode(response.body));
  }

  /// Retreives albums for given artist id
  static Future<List<Album>> getAlbumsForArtist(String id) async {
    Uri uri = new Uri.https(_kApiBaseUrl, '/v1/artists/$id/albums ');
    http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    dynamic jsonData = JSON.decode(response.body);
    List<Album> albums = <Album>[];
    if (jsonData['items'] is List<dynamic>) {
      jsonData['items'].forEach((dynamic albumJson) {
        albums.add(new Album.fromJson(albumJson));
      });
    }
    return albums;
  }
}
