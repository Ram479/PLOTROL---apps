class GetProperties {
  int? code;
  List<PropertiesDetails>? details;
  String? message;
  bool? status;

  GetProperties({this.code, this.details, this.message, this.status});

  GetProperties.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['details'] != null) {
      details = <PropertiesDetails>[];
      json['details'].forEach((v) {
        details!.add(PropertiesDetails.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class PropertiesDetails {
  int? locationid;
  int? tenantid;
  int? applocationid;
  int? moduleid;
  String? locationname;
  String? email;
  String? contactno;
  String? latitude;
  String? longitude;
  String? address;
  List<String>? tenantimage;
  String? suburb;
  String? city;
  String? state;
  String? postcode;
  String? opentime;
  String? closetime;
  int? partnerid;
  int? deliveryradius;
  int? deliverymins;
  int? cancelsecs;
  String? notes;

  PropertiesDetails(
      {this.locationid,
        this.tenantid,
        this.applocationid,
        this.moduleid,
        this.locationname,
        this.email,
        this.contactno,
        this.latitude,
        this.longitude,
        this.address,
        this.tenantimage,
        this.suburb,
        this.city,
        this.state,
        this.postcode,
        this.opentime,
        this.closetime,
        this.partnerid,
        this.deliveryradius,
        this.deliverymins,
        this.cancelsecs,
        this.notes,
      });

  PropertiesDetails.fromJson(Map<String, dynamic> json) {
    locationid = json['locationid'];
    tenantid = json['tenantid'];
    applocationid = json['applocationid'];
    moduleid = json['moduleid'];
    locationname = json['locationname'];
    email = json['email'];
    contactno = json['contactno'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    tenantimage = json['tenantimage']?.cast<String>();
    suburb = json['suburb'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    opentime = json['opentime'];
    closetime = json['closetime'];
    partnerid = json['partnerid'];
    deliveryradius = json['deliveryradius'];
    deliverymins = json['deliverymins'];
    cancelsecs = json['cancelsecs'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locationid'] = locationid;
    data['tenantid'] = tenantid;
    data['applocationid'] = applocationid;
    data['moduleid'] = moduleid;
    data['locationname'] = locationname;
    data['email'] = email;
    data['contactno'] = contactno;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['tenantimage'] = tenantimage;
    data['suburb'] = suburb;
    data['city'] = city;
    data['state'] = state;
    data['postcode'] = postcode;
    data['opentime'] = opentime;
    data['closetime'] = closetime;
    data['partnerid'] = partnerid;
    data['deliveryradius'] = deliveryradius;
    data['deliverymins'] = deliverymins;
    data['cancelsecs'] = cancelsecs;
    data['notes'] = notes;
    return data;
  }
}
