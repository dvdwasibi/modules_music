// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import './user.dart';

/// Model representing a SoundCloud track
///
/// https://developers.soundcloud.com/docs/api/reference#tracks
class Track {
  /// Title of the track
  final String title;

  /// Description for the track
  final String description;

  /// Duration of the track
  final Duration duration;

  /// ID for the track
  final String id;

  /// User who is the owner of this track
  final User user;

  /// Number of times this track has been favorited
  final int favoriteCount;

  /// Number of times this track has been played
  final int playbackCount;

  /// URL for artwork image of track
  final String artworkUrl;

  /// URL to stream this track
  final String streamUrl;

  /// URL of external video for this track
  final String videoUrl;

  /// Constructor
  Track({
    this.title,
    this.description,
    this.duration,
    this.id,
    this.user,
    this.favoriteCount,
    this.playbackCount,
    this.artworkUrl,
    this.streamUrl,
    this.videoUrl,
  });

  
}
