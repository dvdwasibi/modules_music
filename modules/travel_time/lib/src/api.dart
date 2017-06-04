// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show JSON;

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'travel_info.dart';
import 'travel_method.dart';

const String _kApiBaseUrl = 'maps.googleapis.com';

/// API client for Google Maps Distance Matrix
class Api {
  static Future<TravelInfo> getTravelInfo({
    @required String startLocation,
    @required String endLocation,
    @required TravelMethod travelMethod,
    @required String apiKey,
  }) async {
    assert(startLocation != null);
    assert(endLocation != null);
    assert(apiKey != null);
    print('[travel_time] getting travel info');
    Map<String, String> query = <String, String>{
      'origins': startLocation,
      'destinations': endLocation,
      'key': apiKey,
      'mode': travelMethod == TravelMethod.car ? 'driving' : 'transit',
      'units': 'imperial',
    };
    Uri uri = new Uri.https(
      _kApiBaseUrl,
      '/maps/api/distancematrix/json',
      query,
    );
    http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }
    dynamic jsonData = JSON.decode(response.body);
    print(jsonData);
    if(jsonData['status'] == 'OK'
        && jsonData['rows'] is List<dynamic>
        && jsonData['rows'][0]['elements'] is List<dynamic>) {
      print('[travel_time] data looks fine!');
      return new TravelInfo.fromJson(jsonData['rows'][0]['elements'][0]);
    } else {
      return null;
    }
  }
}
