import 'dart:developer';

class DebugHelper {
  static void logApiRequest(String method, String url, {Map<String, dynamic>? data}) {
    log('🌐 API Request: $method $url');
    if (data != null) {
      log('📤 Request Data: $data');
    }
  }
  
  static void logApiResponse(int statusCode, dynamic response) {
    log('📥 API Response: $statusCode');
    log('📄 Response Data: $response');
  }
  
  static void logApiError(dynamic error) {
    log('❌ API Error: $error');
    if (error.toString().contains('DioException')) {
      log('🔍 DioException details: ${error.toString()}');
    }
  }
  
  static void logBlocEvent(String eventName, {Map<String, dynamic>? data}) {
    log('🎯 Bloc Event: $eventName');
    if (data != null) {
      log('📊 Event Data: $data');
    }
  }
  
  static void logBlocState(String stateName, {Map<String, dynamic>? data}) {
    log('🔄 Bloc State: $stateName');
    if (data != null) {
      log('📊 State Data: $data');
    }
  }
  
  static void logUserAction(String action, {Map<String, dynamic>? data}) {
    log('👤 User Action: $action');
    if (data != null) {
      log('📊 Action Data: $data');
    }
  }
}
