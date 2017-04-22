// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show JSON;

import 'package:http/http.dart' as http;
import 'package:concert_models/concert_models.dart';

const String _kApiBaseUrl = 'api.songkick.com';

/// Client for Songkick APIs
class Api {

  /// Searches for artists given a name
  static Future<List<Artist>> searchArtist(String name, String apiKey) async {
    Map<String, String> query = new Map<String, String>();
    query['query'] = name;
    query['apikey'] = apiKey;
    Uri uri = new Uri.https(
      _kApiBaseUrl,
      '/api/3.0/search/artists.json',
      query,
    );
    http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    dynamic jsonData = JSON.decode(response.body);
    List<Artist> artist = <Artist>[];
    // if(jsonData['resultsPage'] is Map<String, dynamic &&
    //     jsonData['resultsPage']['status'] == 'ok' &&
    //     jsonData['resultsPage']['results'] ==
    // )
  }
}
