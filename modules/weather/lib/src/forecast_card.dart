// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'weather.dart';

/// UI Widget that represents a weather forecast card
class ForecastCard extends StatelessWidget {

  /// Weather data
  final Weather weather;

  /// Constructor
  ForecastCard({
    Key key,
    @required this.weather,
  }) : super(key: key) {
    assert(weather != null);
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text('Weather Forecast'),
            new Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Text(
                      '${weather.temperature.toInt()}°',
                      style: new TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  new Image.network(
                    weather.iconUrl,
                    height: 36.0,
                    width: 36.0
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
