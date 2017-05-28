// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:application.lib.app.dart/app.dart';
import 'package:application.services/service_provider.fidl.dart';
import 'package:apps.modular.services.agent.agent_controller/agent_controller.fidl.dart';
import 'package:apps.modular.services.component/component_context.fidl.dart';
import 'package:apps.modular.services.module/module_context.fidl.dart';
import 'package:apps.modular.services.module/module_controller.fidl.dart';
import 'package:apps.modular.services.story/link.fidl.dart';
import 'package:apps.modules.music.services.player/player.fidl.dart'
    as player_fidl;
import 'package:apps.modules.music.services.player/track.fidl.dart'
    as track_fidl;
import 'package:lib.fidl.dart/bindings.dart';
import 'package:lib.widgets/modular.dart';
import 'package:music_api/api.dart';
import 'package:music_models/music_models.dart';
import 'package:music_widgets/music_widgets.dart';

const String _kPlayerUrl = 'file:///system/apps/music_playback_agent';

/// [ModuleModel] that manages the state of the Artist Module.
class PlaybackModuleModel extends ModuleModel {

  final AgentControllerProxy _playbackAgentController =
      new AgentControllerProxy();

  final player_fidl.PlayerProxy _player = new player_fidl.PlayerProxy();

  /// Current track being played
  Track _currentTrack;

  /// Playback position of current track.
  Duration _playbackPosition;

  Track get currentTrack => _currentTrack;

  Duration get playbackPosition => _playbackPosition;

  /// Toggle play/pause for the current track
  void togglePlayPause() => _player.togglePlayPause();

  @override
  void onReady(
    ModuleContext moduleContext,
    Link link,
    ServiceProvider incomingServices,
  ) {
    super.onReady(moduleContext, link, incomingServices);

    // Obtain the component context.
    ComponentContextProxy componentContext = new ComponentContextProxy();
    moduleContext.getComponentContext(componentContext.ctrl.request());

    // Obtain the Player service
    ServiceProviderProxy playerServices = new ServiceProviderProxy();
    componentContext.connectToAgent(
      _kPlayerUrl,
      playerServices.ctrl.request(),
      _playbackAgentController.ctrl.request(),
    );
    connectToService(playerServices, _player.ctrl);

    // Close all the unnecessary bindings.
    playerServices.ctrl.close();
    componentContext.ctrl.close();
  }

  @override
  Future<Null> onStop() async {
    _player.ctrl.close();
    _playbackAgentController.ctrl.close();
    super.onStop();
  }

  /// Update the artist ID
  @override
  Future<Null> onNotify(String json) async {
    //@TODO(dayang)
  }



}
