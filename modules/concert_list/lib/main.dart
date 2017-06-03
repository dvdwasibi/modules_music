// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:application.lib.app.dart/app.dart';
import 'package:concert_widgets/concert_widgets.dart';
import 'package:config/config.dart';
import 'package:flutter/material.dart';
import 'package:lib.widgets/modular.dart';

import 'modular/event_list_model.dart';

/// Retrieves the Songkick API Key
Future<String> _readAPIKey() async {
  Config config = await Config.read('/system/data/modules/config.json');
  config.validate(<String>['songkick_api_key']);
  return config.get('songkick_api_key');
}

Future<Null> main() async {
  String apiKey = await _readAPIKey();

  ApplicationContext applicationContext =
      new ApplicationContext.fromStartupInfo();

  EventListModel eventListModel = new EventListModel(apiKey: apiKey);

  ModuleWidget<EventListModel> moduleWidget =
      new ModuleWidget<EventListModel>(
    applicationContext: applicationContext,
    moduleModel: eventListModel,
    child: new Scaffold(
      backgroundColor: Colors.grey[300],
      body: new SingleChildScrollView(
        controller: new ScrollController(),
        child: new ScopedModelDescendant<EventListModel>(builder: (
          BuildContext context,
          Widget child,
          EventListModel model,
        ) {
          return new Container(
            child: new EventList(
              events: model.events,
              selectedEvent: model.selectedEvent,
              onSelect: model.selectEvent,
            )
          );
        }),
      ),
    ),
  );

  runApp(moduleWidget);
  moduleWidget.advertise();
}
