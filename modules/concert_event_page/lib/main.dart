// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:application.lib.app.dart/app.dart';
import 'package:apps.mozart.lib.flutter/child_view.dart';
import 'package:concert_widgets/concert_widgets.dart';
import 'package:config/config.dart';
import 'package:flutter/material.dart';
import 'package:lib.widgets/modular.dart';

import 'modular/event_module_model.dart';

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

  EventModuleModel eventModuleModel = new EventModuleModel(apiKey: apiKey);

  ModuleWidget<EventModuleModel> moduleWidget =
      new ModuleWidget<EventModuleModel>(
    applicationContext: applicationContext,
    moduleModel: eventModuleModel,
    child: new Scaffold(
      body: new SingleChildScrollView(
        controller: new ScrollController(),
        child: new ScopedModelDescendant<EventModuleModel>(builder: (
          BuildContext context,
          Widget child,
          EventModuleModel model,
        ) {
          List<Widget> embeds = <Widget>[];
          if(model.mapChildViewConn != null) {
            embeds.add(new Container(
              height: 200.0,
              width: 200.0,
              child: new ChildView(connection: model.mapChildViewConn),
            ));
          }
          if(model.weatherChildViewConn != null) {
            embeds.add(new Container(
              height: 200.0,
              width: 200.0,
              child: new ChildView(connection: model.weatherChildViewConn),
            ));
          }
          return new Material(
            child: new EventPage(
              event: model.event,
              loadingStatus: model.loadingStatus,
              detailSlot: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: embeds,
              ),
            ),
          );
        }),
      ),
    ),
  );

  runApp(moduleWidget);
  moduleWidget.advertise();
}
