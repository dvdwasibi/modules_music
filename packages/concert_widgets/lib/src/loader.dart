// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'loading_status.dart';

/// Color for default failure message
final Color _kFailureTextColor = Colors.grey[500];

/// Widget that renders the correct loading affordance based on the given
/// [LoadingStatus]
class Loader extends StatelessWidget {

  /// Current loading status
  final LoadingStatus loadingStatus;

  /// Actual content to show when the loading is completed
  final Widget child;

  /// Constructor
  Loader({
    Key key,
    @required this.child,
    @required this.loadingStatus,
  }) : super(key: key) {
    assert(child != null);
    assert(loadingStatus != null);
  }

  @override
  Widget build(BuildContext context) {
    Widget output;
    switch (loadingStatus) {
      case LoadingStatus.inProgress:
        output = new Center(
          child: new CircularProgressIndicator(
            value: null,
            valueColor: new AlwaysStoppedAnimation<Color>(
              Colors.pink[500],
            ),
          ),
        );
        break;
      case LoadingStatus.failed:
        output = new Center(
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
                'Event failed to load',
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
        output = child;
        break;
    }
    return output;
  }
}
