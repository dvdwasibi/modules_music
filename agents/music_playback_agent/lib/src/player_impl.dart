// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:application.lib.app.dart/app.dart';
import 'package:apps.media.lib.dart/audio_player_controller.dart';
import 'package:apps.modules.music.services.player/player.fidl.dart';
import 'package:apps.modules.music.services.player/status.fidl.dart';
import 'package:apps.modules.music.services.player/track.fidl.dart';
import 'package:lib.fidl.dart/bindings.dart';

/// Function signature for status callback
typedef void GetStatusCallback(int versionLastSeen, PlayerStatus status);

void _log(String msg) {
  print('[music_player] $msg');
}

/// Implementation of the [Player] fidl interface.
class PlayerImpl extends Player {
  // Keeps the list of bindings.
  final List<PlayerBinding> _bindings = <PlayerBinding>[];

  // The current track that the player is on
  Track _currentTrack;

  AudioPlayerController _audioPlayerController;

  /// Constructor
  PlayerImpl(ApplicationContext context) {
    _audioPlayerController = new AudioPlayerController(context.environmentServices);
  }

  @override
  void play(Track track) {
    _currentTrack = track;
    _audioPlayerController.open(Uri.parse(track.playbackUrl));
    _audioPlayerController.play();
    _log('Playing: ${_currentTrack.title}');
  }

  @override
  void next() {
    // TODO (dayang@): Play the current track
    _log('Next');
  }

  @override
  void previous() {
    // TODO (dayang@): Play the previous track
    _log('Previous');
  }

  @override
  void togglePlayPause() {
    _audioPlayerController.pause();
    _log('Toggle Play Pause');
  }

  @override
  void getStatus(int versionLastSeen, GetStatusCallback callback) {
    // TODO (dayang@): Get the status
    _log('Get Status');
  }

  @override
  void addPlayerListener(InterfaceHandle<PlayerStatusListener> listener) {
    // TODO (dayang@): Add listener to group
    _log('Add Player Listener');
  }

  @override
  void enqueue(List<String> trackIds) {
    // TODO (dayang@): Add tracks to queue
    _log('Enqueue');
  }

  @override
  void dequeue(List<String> trackIds) {
    // TODO (dayang@): Remove tracks from queue
    _log('Dequeue');
  }

  /// Bind this instance with the given request, and keep the binding object
  /// in the binding list.
  void addBinding(InterfaceRequest<Player> request) {
    _bindings.add(new PlayerBinding()..bind(this, request));
  }

  /// Close all the bindings.
  void close() {
    _bindings.forEach(
      (PlayerBinding binding) => binding.close(),
    );
  }
}
