// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:application.lib.app.dart/app.dart';
import 'package:apps.media.services/audio_renderer.fidl.dart';
import 'package:apps.media.services/media_service.fidl.dart';
import 'package:apps.media.services/media_renderer.fidl.dart';
import 'package:apps.media.services/media_player.fidl.dart' as mp;
import 'package:apps.media.services/net_media_player.fidl.dart';
import 'package:apps.media.services/net_media_service.fidl.dart';
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

  final MediaServiceProxy _mediaService = new MediaServiceProxy();

  final NetMediaServiceProxy _netMediaService = new NetMediaServiceProxy();

  final AudioRendererProxy _audioRenderer = new AudioRendererProxy();

  final NetMediaPlayerProxy _netMediaPlayer = new NetMediaPlayerProxy();

  bool _active = false;

  bool _isPlaying = false;

  Track _currentTrack;

  /// Constructor
  PlayerImpl(ApplicationContext context) {
    connectToService(context.environmentServices, _mediaService.ctrl);
    connectToService(context.environmentServices, _netMediaService.ctrl);
  }

  @override
  void play(Track track) {
    // TODO (dayang@): Play the current track
    // Make a call to the media service
    _currentTrack = track;
    if (!_active) {
      _createLocalPlayer();
      _netMediaPlayer.getStatus(0, _handlePlayerStatusUpdates);
      _active = true;
    }

    _netMediaPlayer.setUrl(track.playbackUrl);

    if (!_isPlaying) {
      _netMediaPlayer.play();
      _isPlaying = true;
    }

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
    // TODO (dayang@): Toggle the play / pause status
    _netMediaPlayer.pause();
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

  void _createLocalPlayer() {
    InterfacePair<MediaRenderer> audioMediaRenderer =
        new InterfacePair<MediaRenderer>();
    _mediaService.createAudioRenderer(
      _audioRenderer.ctrl.request(),
      audioMediaRenderer.passRequest(),
    );

    InterfacePair<mp.MediaPlayer> mediaPlayer =
        new InterfacePair<mp.MediaPlayer>();
    _mediaService.createPlayer(
      null,
      audioMediaRenderer.passHandle(),
      null,
      mediaPlayer.passRequest(),
    );

    _netMediaService.createNetMediaPlayer('media_player',
        mediaPlayer.passHandle(), _netMediaPlayer.ctrl.request());
  }

  void _handlePlayerStatusUpdates(int version, mp.MediaPlayerStatus status) {
    _log('Audio connected: ${status.audioConnected}');
    _log('Content has audio: ${status.contentHasAudio}');
    _log('End of stream: ${status.endOfStream}');

    _netMediaPlayer.getStatus(version, _handlePlayerStatusUpdates);
  }
}
