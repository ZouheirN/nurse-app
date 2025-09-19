class GetDashboardModel {
  GetDashboardModel({
    required this.activeRequests,
    required this.recentServices,
  });

  final num? activeRequests;
  final List<RecentService> recentServices;

  GetDashboardModel copyWith({
    num? activeRequests,
    List<RecentService>? recentServices,
  }) {
    return GetDashboardModel(
      activeRequests: activeRequests ?? this.activeRequests,
      recentServices: recentServices ?? this.recentServices,
    );
  }

  factory GetDashboardModel.fromJson(Map<String, dynamic> json){
    return GetDashboardModel(
      activeRequests: json["active_requests"],
      recentServices: json["recent_services"] == null ? [] : List<RecentService>.from(json["recent_services"]!.map((x) => RecentService.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "active_requests": activeRequests,
    "recent_services": recentServices.map((x) => x?.toJson()).toList(),
  };

}

class RecentService {
  RecentService({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.problemDescription,
    required this.status,
    required this.createdAt,
    required this.service,
  });

  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final String? problemDescription;
  final String? status;
  final DateTime? createdAt;
  final Service? service;

  RecentService copyWith({
    int? id,
    String? fullName,
    String? phoneNumber,
    String? problemDescription,
    String? status,
    DateTime? createdAt,
    Service? service,
  }) {
    return RecentService(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      problemDescription: problemDescription ?? this.problemDescription,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      service: service ?? this.service,
    );
  }

  factory RecentService.fromJson(Map<String, dynamic> json){
    return RecentService(
      id: json["id"],
      fullName: json["full_name"],
      phoneNumber: json["phone_number"],
      problemDescription: json["problem_description"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      service: json["service"] == null ? null : Service.fromJson(json["service"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "problem_description": problemDescription,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "service": service?.toJson(),
  };

}

class Service {
  Service({
    required this.id,
    required this.name,
    required this.price,
  });

  final int? id;
  final String? name;
  final num? price;

  Service copyWith({
    int? id,
    String? name,
    num? price,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  factory Service.fromJson(Map<String, dynamic> json){
    return Service(
      id: json["id"],
      name: json["name"],
      price: json["price"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
  };

}
