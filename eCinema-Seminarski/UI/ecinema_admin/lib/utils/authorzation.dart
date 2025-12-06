class Authorization {
  static String? token;

  static Map<String, String> createHeaders() {
    String jwtAuth = "Bearer $token";

    var headers = {"Content-Type": "application/json", "Authorization": jwtAuth};
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
