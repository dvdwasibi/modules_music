// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:concert_models/concert_models.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'event_list_item.dart';
import 'loading_status.dart';
import 'typedefs.dart';

/// Color for default failure message
final Color _kFailureTextColor = Colors.grey[500];

/// UI Widget that represents a list of [Event]s
class EventList extends StatelessWidget {

  /// [Event]s to list out
  final List<Event> events;

  /// The event that is selected
  final Event selectedEvent;

  /// Callback to fire when this event is selected
  final EventActionCallback onSelect;

  /// Current loading status of the list
  final LoadingStatus loadingStatus;

  /// Constructor
  EventList({
    Key key,
    @required this.events,
    this.selectedEvent,
    this.onSelect,
    this.loadingStatus: LoadingStatus.completed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget list;

    switch (loadingStatus) {
      case LoadingStatus.inProgress:
        list = new Center(
          child: new CircularProgressIndicator(
            value: null,
            valueColor: new AlwaysStoppedAnimation<Color>(
              Colors.pink[500],
            ),
          ),
        );
        break;
      case LoadingStatus.failed:
        list = new Center(
          child: new Column(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: new Icon(
                  Icons.sentiment_dissatisfied,
                  size: 48.0,
                  color: _kFailureTextColor,
                ),
              ),
              new Text(
                'Events failed to load',
                style: new TextStyle(
                  fontSize: 16.0,
                  color: _kFailureTextColor,
                ),
              ),
            ],
          ),
        );
        break;
      case LoadingStatus.completed:
        list = events != null ? new Column(
          children: events.map((Event event) => new EventListItem(
            event: event,
            onSelect: onSelect,
            isSelected: event == selectedEvent,
          )).toList(),
        ) : new Container();
        break;
    }
    return list;
  }
}
