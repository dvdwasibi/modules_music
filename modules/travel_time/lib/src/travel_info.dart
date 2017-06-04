// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Model that respresents travel distance and time
class TravelInfo {

  /// Text representation of distance
  final String distanceText;

  /// Text representation of duration
  final String durationText;

  /// Constructor
  TravelInfo({
    this.distanceText,
    this.durationText,
  });

  /// Creates an Event from JSON data
  factory TravelInfo.fromJson(Map<String, dynamic> json) {
    return new TravelInfo(
      distanceText: json['distance']['text'],
      durationText: json['duration']['text'],
    );
  }
}
