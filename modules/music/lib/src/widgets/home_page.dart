// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../models/fixtures.dart';
import 'player.dart';
import 'playlist.dart';

/// MyHomePage widget.
class MyHomePage extends StatelessWidget {
  /// MyHomePage constructor.
  MyHomePage({Key key, this.title}) : super(key: key);

  /// MyHomePage title.
  final String title;

  @override
  Widget build(BuildContext context) {
    MusicModelFixtures fixture = new MusicModelFixtures();
    final Widget player = new Player(
      currentTrack: fixture.track(),
      playbackPosition: new Duration(seconds: 60),
    );
    return new Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new PlaylistSurface(
            playlist: fixture.playlist(),
          ),
          player,
        ],
      ),
    );
  }
}
