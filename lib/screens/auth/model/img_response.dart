class UpdateImgResponse {
  String status;
  String response;
  int code;
  int data;

  UpdateImgResponse({this.status, this.response, this.code, this.data});

  UpdateImgResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'];
    code = json['code'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['response'] = this.response;
    data['code'] = this.code;
    data['data'] = this.data;
    return data;
  }
}
