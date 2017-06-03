// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:concert_models/concert_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'typedefs.dart';

const double _kHeight = 72.0;

/// UI Widget that represents a list item for an [Event]
class EventListItem extends StatelessWidget {

  /// [Event] to represent
  final Event event;

  /// Callback to fire when this event is selected
  final EventActionCallback onSelect;

  static final DateFormat _dateFormat = new DateFormat('MMM D');

  /// True if this [EventListItem] is selected
  final bool isSelected;

  // static final DateFormat _monthFormat = new DateFormat('MMM');
  //
  // static final DateFormat _timeFormat = new DateFormat('h:mm aaa');

  /// Constructor
  EventListItem({
    Key key,
    @required this.event,
    this.isSelected: false,
    this.onSelect,
  }) : super(key: key);

  String get _eventImage {
    return event.performances.first?.artist?.imageUrl;
  }

  String get _readableDate =>
      event.startTime != null ? _dateFormat.format(event.startTime) : '';

  Widget _buildTextSection() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(_readableDate),
        new Text(event.name ?? ''),
        new Text(event.venue?.name ?? ''),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO(dayang@) make this responsive
    return new InkWell(
      onTap: () => onSelect?.call(event),
      child: new Container(
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image.network(
              _eventImage,
              fit: BoxFit.cover,
              height: _kHeight,
              width: _kHeight,
            ),
            new Expanded(
              child: _buildTextSection(),
            ),
          ],
        ),
      ),
    );
  }
}
