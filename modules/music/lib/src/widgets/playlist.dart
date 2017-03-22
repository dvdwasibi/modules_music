// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../models/playlist.dart';
import '../utils.dart';

const double _kTopPadding = 36.0;
const double _kHeaderHeight = 200.0;
const double _kHeaderPaddingHeight = 24.0;
const double _kHeaderBackgroundOverflow = 100.0;
const double _kArtworkSize = 225.0;
const double _kHeaderHorizontalPadding = 50.0;
const double _kMainContentMaxWidth = 900.0;
const TextStyle _kHeaderTextStyle = const TextStyle(
  color: Colors.white,
  height: 1.5,
);

class PlaylistSurface extends StatelessWidget {

  /// The [Playlist] to represent for this [PlaylistSurface]
  final Playlist playlist;

  /// [Color] used as the highlight.
  /// This is used for the background of the header and also as highlights
  /// to important UI elements such as primary buttons.
  ///
  /// Defaults to the theme primary color
  final Color highlightColor;

  /// Constructor
  PlaylistSurface({
    Key key,
    this.highlightColor,
    @required this.playlist,
  })
      : super(key: key) {
    assert(playlist != null);
  }

  Widget _buildHeaderDetails() {
    return new RichText(
      overflow: TextOverflow.ellipsis,
      text: new TextSpan(
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
        children: <TextSpan>[
          new TextSpan(
            text: 'by ',
            style: new TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          new TextSpan(
            text: '${playlist.user.username}  -  ',
            style: new TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          new TextSpan(
            text: '${playlist.trackCount} tracks, '
                '${new DurationFormat(playlist.duration).totalText}',
            style: new TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(Color highlightColor) {
    return new Material(
      borderRadius: const BorderRadius.all(const Radius.circular(24.0)),
      color: Colors.white,
      type: MaterialType.button,
      child: new InkWell(
        splashColor: highlightColor,
        onTap: () => {},
        child: new Container(
          width: 130.0,
          height: 40.0,
          child: new Center(
            child: new Text(
              'FOLLOWING',
              style: new TextStyle(
                color: highlightColor,
              ),
            ),
          ),
        )
      ),
    );
  }

  Widget _buildHeaderContent(Color highlightColor) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Playlist Type
        new Text(
          playlist.playlistType.toUpperCase(),
          style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        // Title
        new Text(
          playlist.title,
          style: new TextStyle(
            color: Colors.white,
            fontSize: 32.0,
          ),
        ),
        _buildHeaderDetails(),
        new Expanded(child:new Container()),
        _buildHeaderButton(highlightColor),
      ],
    );
  }

  Widget _buildHeader(Color highlightColor) {
    return new Container(
      height: _kHeaderHeight + _kHeaderBackgroundOverflow,
      color: highlightColor,
      alignment: FractionalOffset.topCenter,
      padding: const EdgeInsets.only(
        top: _kHeaderPaddingHeight,
      ),
      child: new Container(
        constraints: new BoxConstraints(
          maxWidth: _kMainContentMaxWidth-2*_kHeaderHorizontalPadding,
        ),
        padding: const EdgeInsets.only(left: _kArtworkSize + 32.0),
        height: _kHeaderHeight - (_kHeaderPaddingHeight * 2),
        child: _buildHeaderContent(highlightColor),
      ),
    );
  }

  Widget _buildListSection() {
    return new Container(
      margin: const EdgeInsets.only(top: _kHeaderHeight),
      alignment: FractionalOffset.topCenter,
      child: new Material(
        elevation: 4,
        type: MaterialType.card,
        color: Colors.white,
        child: new Column(
          children: <Widget>[
            new Container(
              height: 500.0,
              constraints: new BoxConstraints(
                maxWidth: _kMainContentMaxWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtwork() {
    return new Align(
      alignment: FractionalOffset.topCenter,
      child: new Container(
        margin: const EdgeInsets.only(top: _kHeaderPaddingHeight),
        constraints: new BoxConstraints(
          maxWidth: _kMainContentMaxWidth-2*_kHeaderHorizontalPadding,
        ),
        alignment: FractionalOffset.topLeft,
        child: new Material(
          elevation: 6,
          type: MaterialType.card,
          color: Colors.white,
          child: new Container(
            width: _kArtworkSize,
            height: _kArtworkSize,
            margin: const EdgeInsets.all(4.0),
            child: new Image.network(
              playlist.artworkUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return new Stack(
      children: <Widget>[
        _buildHeader(highlightColor ?? theme.primaryColor),
        new Container(
          margin: const EdgeInsets.only(top:  _kHeaderHeight + _kHeaderBackgroundOverflow,),
          color: Colors.grey[200],
        ),
        _buildListSection(),
        _buildArtwork(),
      ],
    );
  }
}
