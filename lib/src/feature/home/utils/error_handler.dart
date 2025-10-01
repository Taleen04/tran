class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('400')) {
      return 'الطلب غير صحيح أو غير متاح';
    } else if (errorString.contains('401')) {
      return 'غير مصرح لك بهذه العملية';
    } else if (errorString.contains('403')) {
      return 'غير مسموح لك بالوصول لهذا المورد';
    } else if (errorString.contains('404')) {
      return 'المورد المطلوب غير موجود';
    } else if (errorString.contains('409')) {
      return 'تعارض في البيانات، قد يكون الطلب مقبول من سائق آخر';
    } else if (errorString.contains('422')) {
      return 'البيانات المرسلة غير صحيحة';
    } else if (errorString.contains('500')) {
      return 'خطأ في الخادم، يرجى المحاولة لاحقاً';
    } else if (errorString.contains('timeout')) {
      return 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
    } else if (errorString.contains('network')) {
      return 'مشكلة في الاتصال بالإنترنت';
    } else if (errorString.contains('dioexception')) {
      return 'خطأ في الاتصال بالخادم';
    } else {
      // إزالة "Exception:" من بداية الرسالة
      String message = error.toString();
      if (message.startsWith('Exception: ')) {
        message = message.substring(11);
      }
      return message;
    }
  }
  
  static String getAcceptRequestErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('400')) {
      return 'الطلب غير متاح للقبول أو تم قبوله من سائق آخر';
    } else if (errorString.contains('409')) {
      return 'هذا الطلب مقبول بالفعل من سائق آخر';
    } else {
      return getErrorMessage(error);
    }
  }
  
  static String getTakeoverErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('400')) {
      return 'لا يمكن سحب هذا الطلب';
    } else if (errorString.contains('409')) {
      return 'الطلب غير متاح للسحب';
    } else {
      return getErrorMessage(error);
    }
  }
}
