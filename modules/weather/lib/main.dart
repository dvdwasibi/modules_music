// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:application.lib.app.dart/app.dart';
import 'package:config/config.dart';
import 'package:flutter/material.dart';
import 'package:lib.widgets/modular.dart';

import 'modular/weather_module_model.dart';
import 'src/forecast_card.dart';

/// Retrieves the Weahter API Key
Future<String> _readAPIKey() async {
  Config config = await Config.read('/system/data/modules/config.json');
  config.validate(<String>['weather_api_key']);
  return config.get('weather_api_key');
}

Future<Null> main() async {
  String apiKey = await _readAPIKey();

  ApplicationContext applicationContext =
      new ApplicationContext.fromStartupInfo();

  WeatherModuleModel eventModuleModel = new WeatherModuleModel(apiKey: apiKey);

  ModuleWidget<WeatherModuleModel> moduleWidget =
      new ModuleWidget<WeatherModuleModel>(
    applicationContext: applicationContext,
    moduleModel: eventModuleModel,
    child: new Scaffold(
      backgroundColor: Colors.white,
      body: new SingleChildScrollView(
        controller: new ScrollController(),
        child: new ScopedModelDescendant<WeatherModuleModel>(builder: (
          BuildContext context,
          Widget child,
          WeatherModuleModel model,
        ) {
          if(model.weather != null) {
            return new ForecastCard(weather: model.weather);
          } else {
            return new Container();
          }
        }),
      ),
    ),
  );

  runApp(moduleWidget);
  moduleWidget.advertise();
}
