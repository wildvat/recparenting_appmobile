/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
import 'package:recparenting/src/conference/models/video_tile.dart';
import 'dart:developer' as developer;

class VideoTileInterface {
  void videoTileDidAdd(String attendeeId, VideoTile videoTile) {
    // Gets called when a video tile is added
    developer.log('**************************************************');
    developer.log('************ videoTileDidAdd Video Tile Interface *************');
    developer.log('**************************************************');
  }

  void videoTileDidRemove(String attendeeId, VideoTile videoTile) {
    // Gets called when a video tile is removed
    developer.log('**************************************************');
    developer.log('************ videoTileDidRemove Video Tile Interface *************');
    developer.log('**************************************************');
  }
}
