class Authorization {
  static String? token;

  static Map<String, String> createHeaders() {
    String token = Authorization.token ?? '';

    var headers = {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token'
    };
    return headers;
  }

  static Map<String, String> buildHeaders({String? accessToken}) {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }
}
