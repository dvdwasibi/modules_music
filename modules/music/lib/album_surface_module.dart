// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:application.lib.app.dart/app.dart';
import 'package:flutter/widgets.dart';
import 'package:lib.widgets/modular.dart';

import 'src/album_surface_controller.dart';
import 'widgets.dart';

void main() {

  ApplicationContext applicationContext = new ApplicationContext.fromStartupInfo();

  // TODO(dayang@): Actually get the ID from the link store
  AlbumSurfaceController albumSurfaceController = new AlbumSurfaceController(
    albumId: 'random ID'
  );

  ModuleWidget<AlbumSurfaceController> moduleWidget = new ModuleWidget<AlbumSurfaceController>(
    applicationContext: applicationContext,
    moduleModel: albumSurfaceController,
    child: new ScopedModelDescendant<AlbumSurfaceController>(
      builder: (
        BuildContext context,
        Widget child,
        AlbumSurfaceController controller,
      ) {
        return new AlbumSurface(
          album: controller.album,
          loadingStatus: controller.loadingStatus,
          // TODO(dayang@): hook up other actions to real stuff
        );
      }
    ),
  );

  runApp(moduleWidget);
  moduleWidget.advertise();
}
