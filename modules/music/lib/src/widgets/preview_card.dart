// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'track_art.dart';



/// UI Widget that represents a "card" used to preview Albums & Playlists
class PreviewCard extends StatelessWidget {

  /// The URL of the artwork
  final String artworkUrl;

  /// Callback for when the [PreviewCard] is tapped
  final VoidCallback onTap;

  /// Main title for this card.
  ///
  /// This will usually be the title of the album or playlist
  final String title;

  /// Subtitle for this card.
  ///
  /// This will usually be the artist for an album or the creator of the
  /// playlist
  final String subtitle;

  /// The width for this card.
  ///
  /// The artwork will be sized as a square with width and height equal to the
  /// given width. The title and subtitle area will always have a constant
  /// height.
  ///
  /// Defaults to 100.0
  final double width;

  /// Constructor
  PreviewCard({
    Key key,
    @required this.title,
    @required this.subtitle,
    this.onTap,
    this.artworkUrl,
    this.width: 200.0,
  }) : super(key: key) {
    assert(title != null);
    assert(subtitle != null);
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: Colors.white,
      child: new Container(
        width: width,
        child: new CupertinoButton(
          activeOpacity: 0.5,
          padding: const EdgeInsets.all(0.0),
          onPressed: onTap,
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new TrackArt(
                size: width,
                artworkUrl: artworkUrl,
              ),
              new Container(
                width: width,
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: new Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    new Text(
                      subtitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
