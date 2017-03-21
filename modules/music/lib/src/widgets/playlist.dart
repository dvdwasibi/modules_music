// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../models/playlist.dart';
import '../utils.dart';

const double _kTopPadding = 36.0;
const double _kBackgroundBannerHeight = 175.0;
const double _kBannerInnerContentHeight = 120.0;
const double _kPlaylistDetailSectionHeight = 60.0;
const TextStyle _kHeaderTextStyle = const TextStyle(
  color: Colors.white,
  height: 1.5,
);

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


  Widget _buildHeaderSection({Widget child}) {
    return new Container(
      height: _kPlaylistDetailSectionHeight,
      child: child,
    );
  }

  Widget _buildPlaylistDetails() {
    return _buildHeaderSection(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(new DurationFormat(playlist.duration).totalText , style: _kHeaderTextStyle),
          new Text('${playlist.createdAt.year}' , style: _kHeaderTextStyle),
        ],
      ),
    );
  }

  Widget _buildPlayListMetrics() {
    return _buildHeaderSection(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Text('Tracks', style: _kHeaderTextStyle),
          new Text('${playlist.trackCount}', style: _kHeaderTextStyle),
        ],
      ),
    );
  }

  Widget _buildPlayListAttribution() {
    return _buildHeaderSection(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // TODO(dayang@): Formatting
          new Text('Created by ${playlist.user.username}'),
          new RaisedButton(
            child: new Text('Following'),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          playlist.playlistType.toUpperCase(),
          style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Expanded(
              child: _buildHeaderSection(
                child: new Text(
                  playlist.title,
                  style: new TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 32.0,
                  ),
                ),
              ),
            ),
            new Expanded(
              child: _buildHeaderSection(
                child: _buildPlaylistDetails()
              ),
            )
          ],
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Expanded(
              child: _buildPlayListAttribution(),
            ),
            new Expanded(
              child: _buildPlayListMetrics(),
            ),
          ],
        ),
      ],
    );
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
        children: <Widget>[
          _buildHeader(theme.primaryColor),
        ],
      ),
    );
  }
}
