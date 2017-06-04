// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:application.lib.app.dart/app.dart';
import 'package:config/config.dart';
import 'package:flutter/material.dart';
import 'package:lib.widgets/modular.dart';

import 'modular/travel_time_module_model.dart';
import 'src/travel_info_card.dart';

/// Retrieves the Weahter API Key
Future<String> _readAPIKey() async {
  Config config = await Config.read('/system/data/modules/config.json');
  config.validate(<String>['google_api_key']);
  return config.get('google_api_key');
}

Future<Null> main() async {
  String apiKey = await _readAPIKey();

  ApplicationContext applicationContext =
      new ApplicationContext.fromStartupInfo();

  TravelTimeModuleModel travelTimeModuleModel = new TravelTimeModuleModel(apiKey: apiKey);

  print('[travel_time] starting module');
  ModuleWidget<TravelTimeModuleModel> moduleWidget =
      new ModuleWidget<TravelTimeModuleModel>(
    applicationContext: applicationContext,
    moduleModel: travelTimeModuleModel,
    child: new Scaffold(
      backgroundColor: Colors.white,
      body: new SingleChildScrollView(
        controller: new ScrollController(),
        child: new ScopedModelDescendant<TravelTimeModuleModel>(builder: (
          BuildContext context,
          Widget child,
          TravelTimeModuleModel model,
        ) {
          if(model.travelInfo != null) {
            return new TravelInfoCard(
              travelInfo: model.travelInfo,
              travelMethod: model.travelMethod,
              onTapMode: model.toggleTravelMode,
            );
          } else {
            return new Container(child: new Text('travelTime!!'));
          }
        }),
      ),
    ),
  );

  runApp(moduleWidget);
  moduleWidget.advertise();
}
