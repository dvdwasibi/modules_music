// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:application.lib.app.dart/app.dart';
import 'package:concert_api/api.dart';
import 'package:concert_models/concert_models.dart';
import 'package:concert_widgets/concert_widgets.dart';
import 'package:lib.widgets/modular.dart';
import 'package:apps.modular.services.agent.agent_controller/agent_controller.fidl.dart';
import 'package:apps.modular.services.component/component_context.fidl.dart';
import 'package:apps.modular.services.module/module_context.fidl.dart';
import 'package:apps.modular.services.module/module_controller.fidl.dart';
import 'package:apps.modular.services.story/link.fidl.dart';
import 'package:apps.modular.services.story/surface.fidl.dart';
import 'package:lib.fidl.dart/bindings.dart';

/// [ModuleModel] that manages the state of the Event Module.
class EventListModel extends ModuleModel {
  /// List of upcoming events
  List<Event> _events;

  /// The currently selected event
  Event _selectedEvent;

  /// API key for Songkick APIs
  final String apiKey;

  LoadingStatus _loadingStatus = LoadingStatus.inProgress;

  LinkProxy _link;

  /// Constructor
  EventListModel({this.apiKey}) : super() {
    _fetchEvents();
  }

  /// Get the event
  List<Event> get events => _events;

  /// Get the current loading status
  LoadingStatus get loadingStatus => _loadingStatus;

  /// Get the currently selected event
  Event get selectedEvent => _selectedEvent;

  /// Retrieves the events
  Future<Null> _fetchEvents() async {
    try {
      _events = await Api.searchEventsByArtist(null, apiKey);
      if (_events != null) {
        _loadingStatus = LoadingStatus.completed;
      } else {
        _loadingStatus = LoadingStatus.failed;
      }
    } catch (_) {
      _loadingStatus = LoadingStatus.failed;
    }
    notifyListeners();
  }

  String get _selectedEventJson {
    if(_selectedEvent == null) {
      return '';
    } else {
      Map<String, dynamic> data = <String, dynamic>{};
      data['songkick:eventId'] = _selectedEvent.id;
      return JSON.encode(data);
    }
  }

  void selectEvent(Event event) {
    _selectedEvent = event;
    if(_link == null) {
      _link = new LinkProxy();
      moduleContext.getLink('event_link', _link.ctrl.request());
      _link.set(<String>[], _selectedEventJson);
      moduleContext.startModuleInShell(
        'event_module',
        'file:///system/apps/concert_event_page',
        'event_link',
        null, // outgoingServices,
        null, // incomingServices,
        new InterfacePair<ModuleController>().passRequest(),
        new SurfaceRelation()
            ..arrangement = SurfaceArrangement.copresent
            ..emphasis = 1.7
            ..dependency = SurfaceDependency.dependent,
      );
    } else {
      _link.set(<String>[], _selectedEventJson);
    }
    notifyListeners();
  }
}
