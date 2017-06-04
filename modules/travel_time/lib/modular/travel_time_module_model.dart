// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:lib.widgets/modular.dart';
import 'package:meta/meta.dart';

import '../src/api.dart';
import '../src/travel_info.dart';
import '../src/travel_method.dart';

const String _kDefaultStartLocation = '56 Henry San Francisco';

/// [ModuleModel] that manages the state of the Travel Time Module
class TravelTimeModuleModel extends ModuleModel {
  /// API key for google maps
  final String apiKey;

  TravelInfo _travelInfo;

  TravelMethod _travelMethod = TravelMethod.car;

  String _location;

  /// Constructor
  TravelTimeModuleModel({this.apiKey}) : super();

  /// TravelInfo
  TravelInfo get travelInfo => _travelInfo;

  TravelMethod get travelMethod => _travelMethod;

  /// Retrieves the full event based on the given ID
  Future<Null> _fetchTravelInfo({
    @required String startLocation,
    @required String endLocation,
  }) async {
    try {
      _travelInfo = await Api.getTravelInfo(
        apiKey: apiKey,
        startLocation: startLocation,
        endLocation: endLocation,
        travelMethod: _travelMethod,
      );
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      //TODO(dayang@) Handle error state
    }
    notifyListeners();
  }

  void toggleTravelMode() {
    if(_travelMethod == TravelMethod.car) {
      _travelMethod = TravelMethod.publicTransit;
    } else {
      _travelMethod = TravelMethod.car;
    }
    _fetchTravelInfo(
      startLocation: _kDefaultStartLocation,
      endLocation: _location,
    );
    notifyListeners();
  }

  /// Update the event ID
  @override
  void onNotify(String json) {
    print('[travel_time] onNotify');
    final dynamic doc = JSON.decode(json);
    if (doc is Map && doc['longitude'] is double && doc['latitude'] is double) {
      try{
        _location = '${doc['latitude']},${doc['longitude']}';
        _fetchTravelInfo(
          startLocation: _kDefaultStartLocation,
          endLocation: _location,
        );
      } catch(_) {
        notifyListeners();
      }
    }
    notifyListeners();
  }
}
