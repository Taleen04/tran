import 'dart:async';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../domain/entities/chat_message_entity.dart';

class PusherService {
  // Singleton instance
  static PusherService? _instance;

  // Stream controllers for real-time data
  StreamController<ChatMessageEntity>? _messageController;
  StreamController<Map<String, dynamic>>? _eventController;

  // Connection state
  bool _isConnected = false;
  String? _currentChannel;
  Timer? _heartbeatTimer;
  PusherChannelsFlutter? _pusher;

  // Pusher configuration
  static const String _pusherKey = '61549ed0a2c8e226e9be';
  static const String _pusherCluster = 'mt1';
  static const String _channelName = 'transport.drivers';
  static const String _chatChannelPrefix = 'transport-chat';

  PusherService._();

  static PusherService get instance {
    _instance ??= PusherService._();
    return _instance!;
  }

  Stream<ChatMessageEntity> get messageStream {
    _messageController ??= StreamController<ChatMessageEntity>.broadcast();
    return _messageController!.stream;
  }

  Stream<Map<String, dynamic>> get eventStream {
    _eventController ??= StreamController<Map<String, dynamic>>.broadcast();
    return _eventController!.stream;
  }

  bool get isConnected => _isConnected;

  /// Initialize Pusher connection
  Future<void> initialize() async {
    try {
      _pusher = PusherChannelsFlutter.getInstance();

      await _pusher!.init(
        apiKey: _pusherKey,
        cluster: _pusherCluster,
        onConnectionStateChange: _onConnectionStateChange,
        onError: _onError,
        onSubscriptionSucceeded: _onSubscriptionSucceeded,
        onSubscriptionError: _onSubscriptionError,
        onEvent: _onEvent,
        onSubscriptionCount: _onSubscriptionCount,
      );

      await _pusher!.connect();
      _startHeartbeat();
      print('🔌 Pusher initialized successfully');
    } catch (e) {
      print('❌ Pusher initialization failed: $e');
      _isConnected = false;
    }
  }

  /// Handle connection state changes
  void _onConnectionStateChange(String currentState, String previousState) {
    print('🔌 Connection state: $previousState -> $currentState');
    _isConnected = currentState == 'connected';
  }

  /// Handle Pusher errors
  void _onError(String message, int? code, dynamic e) {
    print('❌ Pusher error: $message (Code: $code)');
  }

  /// Handle successful subscription
  void _onSubscriptionSucceeded(String channelName, dynamic data) {
    print('✅ Subscribed to channel: $channelName');
  }

  /// Handle subscription errors
  void _onSubscriptionError(String message, dynamic e) {
    print('❌ Subscription error: $message');
  }

  /// Handle subscription count updates
  void _onSubscriptionCount(String channelName, int subscriptionCount) {
    print('📊 Channel $channelName has $subscriptionCount subscribers');
  }

  // ==================== CHANNEL MANAGEMENT ====================

  /// Subscribe to a specific channel
  Future<void> subscribeToChannel(String channelName) async {
    try {
      if (!_isConnected) {
        await initialize();
      }

      if (_pusher != null) {
        await _pusher!.subscribe(channelName: channelName);
        _currentChannel = channelName;
        print('🔌 Subscribed to channel: $channelName');
      }
    } catch (e) {
      print('❌ Failed to subscribe to channel $channelName: $e');
    }
  }

  /// Subscribe to default driver channel
  Future<void> subscribeToDefaultChannel() async {
    await subscribeToChannel(_channelName);
  }

  /// Unsubscribe from a specific channel
  Future<void> unsubscribeFromChannel(String channelName) async {
    try {
      if (_pusher != null) {
        await _pusher!.unsubscribe(channelName: channelName);
        print('🔌 Unsubscribed from channel: $channelName');
      }
    } catch (e) {
      print('❌ Failed to unsubscribe from channel $channelName: $e');
    }
  }

  /// Unsubscribe from default channel
  Future<void> unsubscribeFromDefaultChannel() async {
    await unsubscribeFromChannel(_channelName);
  }

  // ==================== CHAT CHANNEL METHODS ====================

  /// Get chat channel name for a conversation
  String getChatChannelName(int conversationId) {
    return '$_chatChannelPrefix.$conversationId';
  }

  /// Extract conversation ID from channel name
  int? getConversationIdFromChannel(String channelName) {
    if (channelName.startsWith('$_chatChannelPrefix.')) {
      final parts = channelName.split('.');
      if (parts.length >= 2) {
        return int.tryParse(parts[1]);
      }
    }
    return null;
  }

  /// Check if channel is a chat channel
  bool isChatChannel(String channelName) {
    return channelName.startsWith('$_chatChannelPrefix.');
  }

  /// Subscribe to chat channel for specific conversation
  Future<void> subscribeToChatChannel(int conversationId) async {
    final channelName = getChatChannelName(conversationId);
    await subscribeToChannel(channelName);
  }

  /// Unsubscribe from chat channel
  Future<void> unsubscribeFromChatChannel(int conversationId) async {
    final channelName = getChatChannelName(conversationId);
    await unsubscribeFromChannel(channelName);
  }

  // ==================== EVENT HANDLING ====================

  /// Handle incoming Pusher events
  void _onEvent(PusherEvent event) {
    try {
      print('📨 Event: ${event.eventName} on channel: ${event.channelName}');
      print('📨 Data: ${event.data}');

      // Check if we should process this event
      if (_shouldProcessEvent(event)) {
        _processEvent(event);
      }
    } catch (e) {
      print('❌ Error handling Pusher event: $e');
    }
  }

  /// Determine if event should be processed
  bool _shouldProcessEvent(PusherEvent event) {
    // Always process chat channel events
    if (isChatChannel(event.channelName)) {
      print('💬 Processing chat channel event');
      return true;
    }

    // Process events from current active channel
    if (_currentChannel != null && event.channelName == _currentChannel) {
      return true;
    }

    return false;
  }

  /// Process the event based on its type
  void _processEvent(PusherEvent event) {
    switch (event.eventName) {
      // Chat Events
      case 'message.sent':
        _handleNewMessage(event.data);
        break;
      case 'message-updated':
        _handleMessageUpdated(event.data);
        break;
      case 'typing':
        _handleTypingEvent(event.data);
        break;

      // Request Events
      case 'request.created':
        _handleNewRequest(event.data);
        break;
      case 'request.accepted':
        _handleRequestAccepted(event.data);
        break;
      case 'request.status.updated':
        _handleStatusUpdate(event.data);
        break;
      case 'request.acceptance.countdown':
        _handleCountdownUpdate(event.data);
        break;
      case 'request.timing.warning':
        _handleTimingWarning(event.data);
        break;
      case 'request.timeout':
        _handleRequestTimeout(event.data);
        break;
      case 'additional.movement.detected':
        _handleAdditionalMovement(event.data);
        break;

      default:
        _handleUnknownEvent(event);
    }
  }

  /// Handle unknown events
  void _handleUnknownEvent(PusherEvent event) {
    print('❓ Unhandled event: ${event.eventName}');
    _eventController?.add({
      'eventName': event.eventName,
      'channelName': event.channelName,
      'conversationId': getConversationIdFromChannel(event.channelName),
      'data': event.data,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // ==================== EVENT HANDLERS ====================

  /// Handle new message events
  void _handleNewMessage(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        final message = ChatMessageEntity(
          id: data['id'] ?? DateTime.now().millisecondsSinceEpoch,
          conversationId: data['conversation_id'] ?? 0,
          senderType: data['sender_type'] ?? 'unknown',
          senderId: data['sender_id'] ?? 0,
          senderName: data['sender_name'] ?? 'Unknown',
          messageType: data['message_type'] ?? 'text',
          message: data['message'] ?? '',
          isRead: data['is_read'] ?? false,
          createdAt:
              DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now(),
        );
        _messageController?.add(message);
        print('📨 New message processed');
      }
    } catch (e) {
      print('❌ Error processing new message: $e');
    }
  }

  /// Handle message update events
  void _handleMessageUpdated(dynamic data) {
    try {
      print('📝 Message updated');
      _eventController?.add({
        'type': 'message_updated',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Error handling message update: $e');
    }
  }

  /// Handle typing events
  void _handleTypingEvent(dynamic data) {
    try {
      print('⌨️ Typing event');
      _eventController?.add({
        'type': 'typing',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Error handling typing event: $e');
    }
  }

  // ==================== REQUEST EVENT HANDLERS ====================

  /// Handle new request events
  void _handleNewRequest(dynamic data) {
    try {
      print('📋 New request created');
      _eventController?.add({
        'type': 'request_created',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Error handling new request: $e');
    }
  }

  /// Handle request accepted events
  void _handleRequestAccepted(dynamic data) {
    try {
      print('✅ Request accepted');
      _eventController?.add({
        'type': 'request_accepted',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Error handling request accepted: $e');
    }
  }

  /// Handle status update events
  void _handleStatusUpdate(dynamic data) {
    try {
      print('🔄 Request status updated');
      _eventController?.add({
        'type': 'status_updated',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Error handling status update: $e');
    }
  }

  /// Handle countdown update events
  void _handleCountdownUpdate(dynamic data) {
    try {
      print('⏰ Request acceptance countdown');
      _eventController?.add({
        'type': 'countdown_update',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Error handling countdown update: $e');
    }
  }

  /// Handle timing warning events
  void _handleTimingWarning(dynamic data) {
    try {
      print('⚠️ Request timing warning');
      _eventController?.add({
        'type': 'timing_warning',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Error handling timing warning: $e');
    }
  }

  /// Handle request timeout events
  void _handleRequestTimeout(dynamic data) {
    try {
      print('⏰ Request timeout');
      _eventController?.add({
        'type': 'request_timeout',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Error handling request timeout: $e');
    }
  }

  /// Handle additional movement events
  void _handleAdditionalMovement(dynamic data) {
    try {
      print('🚗 Additional movement detected');
      _eventController?.add({
        'type': 'additional_movement',
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Error handling additional movement: $e');
    }
  }

  // ==================== CONNECTION MANAGEMENT ====================

  /// Start heartbeat timer to monitor connection
  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected) {
        print('💓 Pusher heartbeat - connection active');
      } else {
        timer.cancel();
      }
    });
  }

  /// Disconnect from Pusher
  Future<void> disconnect() async {
    try {
      _heartbeatTimer?.cancel();
      if (_pusher != null) {
        await _pusher!.disconnect();
      }
      _isConnected = false;
      _currentChannel = null;
      print('🔌 Pusher disconnected');
    } catch (e) {
      print('❌ Error disconnecting Pusher: $e');
    }
  }

  /// Dispose of all resources
  void dispose() {
    disconnect();
    _messageController?.close();
    _eventController?.close();
    _messageController = null;
    _eventController = null;
    _pusher = null;
    print('🗑️ Pusher service disposed');
  }

  // ==================== LOCAL EVENT SIMULATION ====================

  /// Simulate receiving a message event locally
  void simulateMessageEvent(Map<String, dynamic> eventData) {
    try {
      print('📤 Simulating local message event');

      // Process the message directly
      _handleNewMessage(eventData);
    } catch (e) {
      print('❌ Error simulating message event: $e');
    }
  }
}
