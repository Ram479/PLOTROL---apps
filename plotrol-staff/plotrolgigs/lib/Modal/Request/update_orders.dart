class UpdateOrdersRequest {
  int? orderheaderid;
  String? orderstatus;
  String? processing;
  String? ready;
  String? completed;
  List<String>? orderimages;

  UpdateOrdersRequest(
      {this.orderheaderid, this.orderstatus, this.processing, this.ready, this.completed, this.orderimages});

  UpdateOrdersRequest.fromJson(Map<String, dynamic> json) {
    orderheaderid = json['orderheaderid'];
    orderstatus = json['orderstatus'];
    processing = json['processing'];
    ready = json['ready'];
    completed = json['completed'];
    orderimages = json['orderimages']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderheaderid'] = this.orderheaderid;
    data['orderstatus'] = this.orderstatus;
    data['processing'] = this.processing;
    data['ready'] = this.ready;
    data['completed'] = this.completed;
    data['orderimages'] = this.orderimages;
    return data;
  }
}
