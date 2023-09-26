class ApiResponse {
  final int code;
  final dynamic data;
  final String? error;


  ApiResponse({required this.code, required this.data, this.error});

  factory ApiResponse.fromJson(Map<String, dynamic> json){
    return ApiResponse(
      code: json['code'],
      data: json['data'],
      error: json['error']
    );
  }
}