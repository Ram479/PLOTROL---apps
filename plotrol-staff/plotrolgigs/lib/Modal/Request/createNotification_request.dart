class CreateNotificationRequest {
  String? token;
  Notifications? notification;

  CreateNotificationRequest({this.token, this.notification});

  CreateNotificationRequest.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    notification = json['notification'] != null
        ? new Notifications.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
    return data;
  }
}

class Notifications {
  String? title;
  String? body;
  String? sound;

  Notifications({this.title, this.body, this.sound});

  Notifications.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    sound = json['sound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['sound'] = this.sound;
    return data;
  }
}
