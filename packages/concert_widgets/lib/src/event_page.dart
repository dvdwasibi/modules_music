  // Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:concert_models/concert_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'loader.dart';
import 'loading_status.dart';

const double _kHeroImageHeight = 240.0;

/// UI widget that represents an entire concert page
class EventPage extends StatelessWidget {

  /// The [Event] that this page renders
  final Event event;

  /// Current loading status of the event page
  final LoadingStatus loadingStatus;

  /// Slot for 'details modules'
  final Widget detailSlot;

  static final DateFormat _dateFormat = new DateFormat('EEEE, d LLLL y');

  static final DateFormat _timeFormat = new DateFormat('h:mm aaa');

  /// Constructor
  EventPage({
    Key key,
    @required this.event,
    this.loadingStatus: LoadingStatus.completed,
    this.detailSlot,
  }) : super(key: key);

  String get _readableDate {
    String date = _dateFormat.format(event.date);
    if(event.startTime != null) {
      date += ' ${_timeFormat.format(event.startTime)}';
    }
    return date;
  }

  Widget _buildVenueSection() {
    if(event.venue != null) {
      return new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(event.venue.name ?? ''),
          new Text(event.venue.city?.name ?? ''),
          new Text(event.venue.description ?? ''),
        ],
      );
    } else {
      return new Container();
    }
  }

  Widget _buildMainSection() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //TODO(dayang@): Text Styling
        new Text(_readableDate),
        //TODO(dayang@): Text Styling
        new Text(event.performances.first?.artist?.name ?? ''),
        new Image.network(
          event.performances.first?.artist?.imageUrl,
          height: _kHeroImageHeight,
          fit: BoxFit.cover,
        ),
        _buildVenueSection(),
      ],
    );
  }

  Widget _buildDetailSection() {
    return detailSlot ?? new Container();
  }

  @override
  Widget build(BuildContext context) {
    return new Loader(
      child: event != null ? new Container(
        padding: const EdgeInsets.all(32.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(flex: 3, child: _buildMainSection()),
            new Expanded(flex: 2, child: _buildDetailSection()),
          ],
        ),
      ) : new Container(),
      loadingStatus: loadingStatus,
    );
  }
}
