// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:concert_api/api.dart';
import 'package:concert_models/concert_models.dart';
import 'package:lib.widgets/modular.dart';


/// [ModuleModel] that manages the state of the Event Module.
class EventModuleModel extends ModuleModel {
  /// The album for this given module
  Event event;

  /// API key for Songkick APIs
  final String apiKey;

  /// Constructor
  EventModuleModel({this.apiKey}) : super();

  /// Retrieves the full event based on the given ID
  Future<Null> fetchEvent(int eventId) async {
    try {
      event = await Api.getEvent(eventId, apiKey);
    } catch (error) {
      print('ERROR');
    }
    notifyListeners();
  }

  /// Update the album ID
  @override
  void onNotify(String json) {
    final dynamic doc = JSON.decode(json);
    if (doc is Map && doc['songkick:eventId'] is int) {
      fetchEvent(doc['songkick:eventId']);
    }
  }
}
