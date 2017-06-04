  // Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:concert_models/concert_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'fallback_image.dart';
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
      List<Widget> children = <Widget>[];
      if(event.venue.name != null) {
        children.add(new Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: new Text(
            event.venue.name,
            style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ));
      }
      if(event.venue.street != null) {
        children.add(new Text(event.venue.street));
      }
      if(event.venue.city?.name != null || event.venue.city?.country != null || event.venue.zip != null) {
        children.add(new Text(
          '${event.venue.city?.name ?? ''}, ${event.venue.city?.country ?? ''} ${ event.venue.zip ?? ''}',
        ));
      }
      if(event.venue.phoneNumber != null) {
        children.add(new Text(event.venue.phoneNumber));
      }
      return new Container(
        margin: const EdgeInsets.only(top: 24.0),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
    } else {
      return new Container();
    }
  }

  Widget _buildOpeners() {
    if(event.performances.length > 1) {
      List<Widget> children = <Widget>[
        new Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: new Text(
            'Also Performing',
            style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ];

      for(int i=1; i<event.performances.length; i++) {
        Artist artist = event.performances[i].artist;
        children.add(new Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: new Row(
            children: <Widget>[
              new FallbackImage(
                height: 56.0,
                width: 56.0,
                artworkUrl: artist.imageUrl,
              ),
              new Expanded(
                child: new Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  child: new Text(
                    artist.name,
                  ),
                ),
              ),
            ],
          ),
        ));
      }

      return new Container(
        margin: const EdgeInsets.only(top: 24.0),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );
    } else {
      return new Container();
    }
  }

  Widget _buildMainSection() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.only(bottom: 4.0),
          child: new Text(
            _readableDate,
            style: new TextStyle(
              color: Colors.grey[500],
              fontSize: 16.0,
            ),
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(bottom: 24.0),
          child: new Text(
            event.performances.first?.artist?.name ?? '',
            style: new TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        new FallbackImage(
          artworkUrl: event.performances.first?.artist?.imageUrl,
          height: _kHeroImageHeight,
        ),
        _buildVenueSection(),
        _buildOpeners(),
      ],
    );
  }

  Widget _buildDetailSection() {
    return new Column(
      children: <Widget>[
        new Container(
          margin: const EdgeInsets.only(bottom: 24.0),
          child: new RaisedButton(
            color: Colors.pink[500],
            child: new Container(
              width: 200.0,
              child: new Text(
                'Buy Tickets (free with #plat)',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: (){},
          ),
        ),
        detailSlot ?? new Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Loader(
      child: event != null ? new Container(
        padding: const EdgeInsets.all(16.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(child: _buildMainSection()),
            new Container(
              width: 250.0,
              margin: const EdgeInsets.only(
                left: 24.0,
                top: 75.0,
              ),
              child: _buildDetailSection(),
            ),
          ],
        ),
      ) : new Container(),
      loadingStatus: loadingStatus,
    );
  }
}
