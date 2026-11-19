String translateErrorMessage(String message) {
  if (message.contains('User already registered') ||
      message.contains('23505') ||
      message.contains('already exists')) {
    return 'المستخدم موجود بالفعل';
  } else if (message.contains('Invalid login credentials')) {
    return 'خطأ في البريد الإلكتروني أو كلمة المرور';
  } else if (message.contains('Email not confirmed')) {
    return 'البريد الإلكتروني غير مؤكد';
  } else if (message.contains('network') ||
      message.contains('SocketException')) {
    return 'خطأ في الاتصال بالشبكة';
  }

  // Fallback: Return raw error for debugging
  return message;
}
