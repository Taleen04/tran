import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../domain/entities/chat_message_entity.dart';

class PusherService {
  // Singleton instance
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  Future<void> initPusher(dynamic Function(PusherEvent)? onEvent, int conversationId) async {

  }

  Future<void> disconnect() async {
    if(pusher.connectionState == "CONNECTED") {
      await pusher.disconnect();
    }
  }
}
