// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show JSON;

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'weather.dart';

const String _kApiBaseUrl = 'api.openweathermap.org';

/// API client for openweathermap.org
class Api {
  static Future<Weather> getWeatherForGeo({
    @required double longitude,
    @required double latitude,
    @required String apiKey,
  }) async {
    assert(longitude != null);
    assert(latitude != null);
    assert(apiKey != null);
    Map<String, String> query = <String, String>{
      'lat': latitude.toString(),
      'lon': longitude.toString(),
      'APPID': apiKey,
      'units': 'imperial',
    };
    Uri uri = new Uri.http(
      _kApiBaseUrl,
      '/data/2.5/weather',
      query,
    );
    http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    dynamic jsonData = JSON.decode(response.body);
    return new Weather.fromJson(jsonData);
  }
}
