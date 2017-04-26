// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:concert_models/concert_models.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

final TextStyle _kMonthStyle = new TextStyle(
  fontWeight: FontWeight.w600,
  color: Colors.red[400],
);

final TextStyle _kDayStyle = _kMonthStyle.copyWith(fontSize: 24.0);

final TextStyle _kLightStyle = new TextStyle(
  fontSize: 13.0,
  fontWeight: FontWeight.w300,
  height: 1.2,
);

/// UI Widget that represents a card for an [Event]
class EventCard extends StatelessWidget {

  /// [Event] that this card represents
  final Event event;

  /// Constructor
  EventCard({
    Key key,
    @required this.event,
  }) : super(key: key) {
    assert(event != null);
  }

  Widget _buildInfoSection() {
    return new Container(
      margin: new EdgeInsets.all(16.0),
      child: new Row( //Concert card text
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text('${event.startTime.month}', style: _kMonthStyle),
                new Text('${event.startTime.day}', style: _kDayStyle),
              ],
            ),
          ),
          new Expanded(
            flex: 3,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  event.performances.first.artist.name,
                  style: new TextStyle(
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                new Text('${event.startTime}', style: _kLightStyle),
                new Text('${event.venue.name}', style: _kLightStyle),
              ],
            ),
          ),
          new RaisedButton(
            color: Colors.red[400],
            child: new Text('BUY'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return new Container(
      margin: new EdgeInsets.all(16.0),
      child: new Row(
        // TODO
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildInfoSection(),
          _buildAddressSection(),
          // TODO (dayang@): Add in maps and address
        ],
      ),
    );
  }
}
