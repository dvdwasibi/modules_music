// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../models/playlist.dart';

const double _kTopPadding = 36.0;
const double _kBackgroundBannerHeight = 100.0;
const double _kBannerInnerContentHeight = 50.0;

class PlaylistSurface extends StatelessWidget {
  /// The [Playlist] to represent for this [PlaylistSurface]
  final Playlist playlist;

  /// Constructor
  PlaylistSurface({
    Key key,
    @required this.playlist,
  })
      : super(key: key) {
    assert(playlist != null);
  }

  Widget _buildPlaylistDetails() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // TODO(dayang@): Get actual duration text
        new Text('Duration'),
        // TODO(dayang@): Get actual stuff here
        new Text('6 days ago'),
      ],
    );
  }

  Widget _buildHeaderContent() {
    return new Column(children: <Widget>[
      new Text(playlist.playlistType),
      new Expanded(
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(playlist.title),
            new Text('6 days ago'),
          ],
        ),
      ),
      new Expanded(
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text('Created by ${playlist.user.username}'),
            new RaisedButton(
              child: new Text('Following'),
              onPressed: () => {},
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildHeader(Color primaryColor) {
    return new Container(
      height: _kBackgroundBannerHeight,
      color: primaryColor,
      padding: const EdgeInsets.only(top: _kTopPadding),
      child: new Container(
        height: _kBannerInnerContentHeight,
        child: _buildHeaderContent(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return new Container(
      child: new Stack(
        children: <Widget>[],
      ),
    );
  }
}
