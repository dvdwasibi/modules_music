// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:lib.widgets/modular.dart';
import 'package:meta/meta.dart';

import '../src/api.dart';
import '../src/weather.dart';


/// [ModuleModel] that manages the state of the Event Module.
class WeatherModuleModel extends ModuleModel {
  /// API key for openweathermap.org
  final String apiKey;

  Weather _weather;

  /// Constructor
  WeatherModuleModel({this.apiKey}) : super();

  /// Weather Data
  Weather get weather => _weather;

  /// Retrieves the full event based on the given ID
  Future<Null> _fetchWeather({
    @required double latitude,
    @required double longitude,
  }) async {
    try {
      _weather = await Api.getWeatherForGeo(
        apiKey: apiKey,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (_) {
      //TODO(dayang@) Handle error state
    }
    notifyListeners();
  }

  /// Update the event ID
  @override
  void onNotify(String json) {
    print('[weather] onNotify');
    final dynamic doc = JSON.decode(json);
    if (doc is Map && doc['longitude'] is double && doc['latitude'] is double) {
      _fetchWeather(
        latitude: doc['latitude'],
        longitude: doc['longitude'],
      );
    }
  }
}
