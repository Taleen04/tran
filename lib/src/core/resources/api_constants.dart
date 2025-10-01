// lib/src/core/constants/api_constants.dart
class ApiConstants {
  // 🔗 الرابط الأساسي
  static const String baseUrl =
      "https://parking.engmahmoudali.com/api/transport/";
  // =====================
  // 🟦 Authentication
  // =====================
  static const String login = 'auth/login';
  static const String logout = 'logout';
  static const String updatePassword = 'change-password';
  static const String changePhoto = 'profile/photo';

  // =====================
  // 🟩 Tickets
  // =====================
  static const String tickets = 'tickets';
  static String ticketsByVehicleType(String vehicleType) =>
      'tickets?vehicle_type=$vehicleType';
  static String ticketsByClientName(String name) => 'tickets?client_name=$name';
  static String ticketsSorted(String order) => 'tickets?sort=$order';
  static const String getMyRequests = 'requests/my-tasks';
  static const String cancellationReason = 'requests/cancellation-reasons';
  static const String locationStatus = 'profile/location-status';
  static const String onlineStatus = 'profile/online-status';
  static const String changePassword = "profile/change-password";
  // =====================
  // 🟨 Clients
  // =====================
  static String clientTickets(int clientId) => 'clients/$clientId/tickets';
  static String ordersList = 'requests/pool';
  static String acceptRequest(int id) => 'requests/$id/accept';
  static String cancelRequest(int id) => 'requests/$id/cancel';
  static String updateRequestStatus(int id) => 'requests/$id/status';
  static String takeoverRequest(int id) => 'requests/$id/takeover';
  static const String requestsStatus = 'requests/status';
  // =====================
  // 🟥 Employees
  // =====================
  static String employee(int id) => 'employee/$id';
  static String employees(int id) => 'employees/$id';
  static const String userProfile = 'profile';
  static const String editProfile = 'profile';
  static const String vehicleRegister = 'vehicle/register';
  static const String vehicles = 'vehicles';
  static String checkVehiclePlate(String plateNumber) =>
      'vehicle/check-plate/$plateNumber';
  static const String wallet = 'profile/wallet';
  //======================
  // 🟪 Calendar
  //======================
  static const String History = 'requests/my-tasks';
  //======================
  // 🟪 Chat
  //======================
  //======================
  // 🟪 Need Van
  //======================
  static String needVanRequest(int requestId) =>
      'requests/$requestId/need-van';
  //======================
  // 🟪 Chat
  //======================
  static String getChatConversation(int requestId) =>
      'requests/$requestId/chat';
  static String sendChatMessage(int requestId) =>
      'requests/$requestId/chat/messages';
  static String sendChatImage(int requestId) =>
      'requests/$requestId/chat/image';
  static const String getAllConversations = 'chat/conversations';
}
