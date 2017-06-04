// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';

final Color _kBackgroundColor = Colors.grey[300];
final Color _kIconColor = Colors.grey[600];

/// Renders an image and provides a fallback for situations where the URL
/// is null
class FallbackImage extends StatelessWidget {
  /// Width of the [FallbackImage].
  final double width;

  /// Heigth of the [FallbackImage].
  final double height;

  /// Url of artwork
  final String artworkUrl;

  /// Constructor
  FallbackImage({
    Key key,
    this.artworkUrl,
    this.width,
    this.height,
  })
      : super(key: key);


  double get _iconSize {
    if(height == null && width == null) {
      return 40.0;
    } else {
      return max(
        height ?? double.NEGATIVE_INFINITY,
        width ?? double.NEGATIVE_INFINITY,
      )/2.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[
      new Container(
        height: height ?? double.INFINITY,
        width: width ?? double.INFINITY,
        color: _kBackgroundColor,
        child: new Center(
          child: new Icon(
            Icons.person,
            color: _kIconColor,
            size: _iconSize,
          ),
        ),
      ),
    ];

    if (artworkUrl != null) {
      children.add(
        new Container(
          height: height ?? double.INFINITY,
          width: width ?? double.INFINITY,
          child: new Image.network(
            artworkUrl,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        ),
      );
    }

    return new Stack(
      fit: StackFit.passthrough,
      children: children,
    );
  }
}
