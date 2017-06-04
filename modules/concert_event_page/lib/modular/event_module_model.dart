// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:application.lib.app.dart/app.dart';
import 'package:application.services/service_provider.fidl.dart';
import 'package:apps.modular.services.module/module.fidl.dart';
import 'package:apps.modular.services.module/module_context.fidl.dart';
import 'package:apps.modular.services.module/module_controller.fidl.dart';
import 'package:apps.modular.services.story/link.fidl.dart';
import 'package:apps.mozart.lib.flutter/child_view.dart';
import 'package:apps.mozart.services.views/view_token.fidl.dart';
import 'package:concert_api/api.dart';
import 'package:concert_models/concert_models.dart';
import 'package:concert_widgets/concert_widgets.dart';
import 'package:lib.widgets/modular.dart';
import 'package:lib.fidl.dart/bindings.dart';

final String _kMapModuleUrl = 'file:///system/apps/map';
final String _kMapDocRoot = 'map-doc';
final String _kMapLocationKey = 'map-location-key';
final String _kMapHeightKey = 'map-height-key';
final String _kMapWidthKey = 'map-width-key';
final String _kMapZoomkey = 'map-zoom-key';
final String _kWeatherModuleUrl = 'file:///system/apps/weather';

/// [ModuleModel] that manages the state of the Event Module.
class EventModuleModel extends ModuleModel {
  /// The event for this given module
  Event _event;

  /// Child View Connection for the Map
  ChildViewConnection _mapConn;

  /// Child View Connection for Weather
  ChildViewConnection _weatherConn;

  /// Link for Embedded Map Module
  LinkProxy _mapLink;

  /// Link for Embedded Weather Module
  LinkProxy _weatherLink;

  /// API key for Songkick APIs
  final String apiKey;

  LoadingStatus _loadingStatus = LoadingStatus.inProgress;

  /// Constructor
  EventModuleModel({this.apiKey}) : super();

  /// Get the event
  Event get event => _event;

  /// Get the current loading status
  LoadingStatus get loadingStatus => _loadingStatus;

  ChildViewConnection get mapChildViewConn => _mapConn;

  ChildViewConnection get weatherChildViewConn => _weatherConn;

  /// Retrieves the full event based on the given ID
  Future<Null> fetchEvent(int eventId) async {
    try {
      _event = await Api.getEvent(eventId, apiKey);
      if (_event != null) {
        _loadingStatus = LoadingStatus.completed;
      } else {
        _loadingStatus = LoadingStatus.failed;
      }
    } catch (_) {
      _loadingStatus = LoadingStatus.failed;
    }
    _updateMapModule();
    _updateWeatherModule();
    notifyListeners();
  }

  /// Update the event ID
  @override
  void onNotify(String json) {
    final dynamic doc = JSON.decode(json);
    if (doc is Map && doc['songkick:eventId'] is int) {
      fetchEvent(doc['songkick:eventId']);
    }
  }

  String get _mapLinkData {
    if(event?.venue?.longitude != null && event?.venue?.latitude != null) {
      Map<String, dynamic> mapDoc = <String, dynamic>{
        _kMapZoomkey: 15,
        _kMapHeightKey: 250.0,
        _kMapWidthKey: 250.0,
        _kMapLocationKey: '${event.venue.latitude},${event.venue.longitude}',
      };
      return JSON.encode(mapDoc);
    } else {
      return '';
    }
  }

  String get _weatherLinkData {
    if(event?.venue?.longitude != null && event?.venue?.latitude != null) {
      Map<String, dynamic> weatherDoc = <String, dynamic>{
        'longitude': event.venue.longitude,
        'latitude': event.venue.latitude,
      };
      return JSON.encode(weatherDoc);
    } else {
      return '';
    }
  }

  void _updateMapModule() {
    if(_mapConn != null) {
      _mapLink.set(<String>[_kMapDocRoot], _mapLinkData);
    } else {
      _mapLink = new LinkProxy();
      moduleContext.getLink('map_link', _mapLink.ctrl.request());
      _mapLink.set(<String>[_kMapDocRoot], _mapLinkData);

      InterfacePair<ViewOwner> viewOwner = new InterfacePair<ViewOwner>();
      InterfacePair<ModuleController> moduleController =
          new InterfacePair<ModuleController>();
      moduleContext.startModule(
        'map',
        _kMapModuleUrl,
        'map_link',
        null,
        null,
        moduleController.passRequest(),
        viewOwner.passRequest(),
      );
      _mapConn = new ChildViewConnection(viewOwner.passHandle());
    }
    notifyListeners();
  }

  void _updateWeatherModule() {
    if(_weatherConn != null) {
      _weatherLink.set(<String>[], _weatherLinkData);
    } else {
      _weatherLink = new LinkProxy();
      moduleContext.getLink('weather_link', _weatherLink.ctrl.request());
      _weatherLink.set(<String>[], _weatherLinkData);

      InterfacePair<ViewOwner> viewOwner = new InterfacePair<ViewOwner>();
      InterfacePair<ModuleController> moduleController =
          new InterfacePair<ModuleController>();
      moduleContext.startModule(
        'weather',
        _kWeatherModuleUrl,
        'weather_link',
        null,
        null,
        moduleController.passRequest(),
        viewOwner.passRequest(),
      );
      _weatherConn = new ChildViewConnection(viewOwner.passHandle());
    }
    notifyListeners();
  }
}
