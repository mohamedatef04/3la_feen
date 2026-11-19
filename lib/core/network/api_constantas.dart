abstract class ApiConstants {
  static const String placesApiBaseUrl = 'https://nominatim.openstreetmap.org/';
  static const String placesApiSearchEndpoint = 'search';
  static const String placesApiUserAgentHeader =
      'my_postman_app/1.0 (mohamed.atef.developer@gmail.com)';

  static const String osrmApiBaseUrl = 'https://router.project-osrm.org/';
  static const String osrmApiRouteEndpoint = 'route/v1/driving/';

  static const String baseUrl =
      'https://rtxpmgwxndzuaxjajyni.supabase.co/rest/v1/';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0eHBtZ3d4bmR6dWF4amFqeW5pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY4NDk2NTcsImV4cCI6MjA4MjQyNTY1N30.w_mp6Vjti1K2XEV_ROsYa_cqx5Lo1MSe7FXLnZrgJYM';

  static const String tripsEndpoint = 'trips';
  static const String usersEndpoint = 'users';
  static const String offersEndpoint = 'offers';
}
