// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:concert_models/concert_models.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

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

  String get _abbreviatedMonth => new DateFormat('MMM').format(event.startTime);

  String get _readableStartTime => new DateFormat('hh:mm aaa').format(event.startTime);

    Widget _buildInfoSection() {
    return new Container(
      margin: new EdgeInsets.all(16.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_abbreviatedMonth, style: _kMonthStyle),
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
                new Text(
                  '$_readableStartTime - ${event.venue.name}',
                  style: _kLightStyle,
                ),
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

  Widget _buildBillingSection() {
    return new Container(
      margin: new EdgeInsets.all(16.0),
      child: new Row(
        children: event.performances.map((Performance performance) {
          return new Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: new Column(
              children: <Widget>[
                new Image.network(
                  performance.artist.imageUrl,
                  height: 40.0,
                  width: 40.0,
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 4.0),
                  child: new Text(performance.artist.name),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVenueSection() {
    return new Container(
      margin: new EdgeInsets.all(16.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text('VENUE'),
                new Text('${event.venue.street}'),
                new Text('${event.venue.city}, ${event.venue.city.country}'),
                new Text('${event.venue.phoneNumber}'),
              ],
            ),
          ),
          new Expanded(
            // TODO (dayang@) Compose Maps Module here instead
            // https://fuchsia.atlassian.net/browse/SO-377
            child: new Image.network(
              event.venue.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            height: 160.0,
            child: new Image.network(
              event.performances.first.artist.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          _buildInfoSection(),
          new Divider(),
          _buildBillingSection(),
          _buildVenueSection(),
        ],
      ),
    );
  }
}
