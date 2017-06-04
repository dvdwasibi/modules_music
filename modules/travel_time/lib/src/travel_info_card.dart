// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'travel_method.dart';
import 'travel_info.dart';

/// UI Widget that represents a travel info card
class TravelInfoCard extends StatelessWidget {

  /// Weather data
  final TravelInfo travelInfo;

  final TravelMethod travelMethod;

  final VoidCallback onTapMode;

  /// Constructor
  TravelInfoCard({
    Key key,
    @required this.travelInfo,
    @required this.travelMethod,
    this.onTapMode,
  }) : super(key: key) {
    assert(travelInfo != null);
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Material(
        color: Colors.white,
        child: new Container(
          padding: const EdgeInsets.all(16.0),
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      travelInfo.durationText,
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    new Text(
                      travelInfo.distanceText,
                      style: new TextStyle(
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ),
              ),
              new IconButton(
                onPressed: () => onTapMode?.call(),
                icon: new Icon(
                  travelMethod == TravelMethod.car ? Icons.directions_car : Icons.directions_bus,
                  color: Colors.blue[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
