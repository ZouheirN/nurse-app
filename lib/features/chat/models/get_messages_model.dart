class GetMessagesModel {
  GetMessagesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  GetMessagesModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return GetMessagesModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory GetMessagesModel.fromJson(Map<String, dynamic> json){
    return GetMessagesModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };

}

class Data {
  Data({
    required this.messages,
    required this.nextCursor,
  });

  final List<Message> messages;
  final String? nextCursor;

  Data copyWith({
    List<Message>? messages,
    String? nextCursor,
  }) {
    return Data(
      messages: messages ?? this.messages,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      messages: json["messages"] == null ? [] : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
      nextCursor: json["nextCursor"],
    );
  }

  Map<String, dynamic> toJson() => {
    "messages": messages.map((x) => x.toJson()).toList(),
    "nextCursor": nextCursor,
  };

}

class Message {
  Message({
    required this.id,
    required this.type,
    required this.text,
    required this.lat,
    required this.lng,
    required this.mediaUrl,
    required this.senderId,
    required this.createdAt,
  });

  final int? id;
  final String? type;
  final String? text;
  final num? lat;
  final num? lng;
  final String? mediaUrl;
  final int? senderId;
  final DateTime? createdAt;

  Message copyWith({
    int? id,
    String? type,
    String? text,
    num? lat,
    num? lng,
    String? mediaUrl,
    int? senderId,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      senderId: senderId ?? this.senderId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
      id: json["id"],
      type: json["type"],
      text: json["text"],
      lat: json["lat"],
      lng: json["lng"],
      mediaUrl: json["media_url"],
      senderId: json["sender_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "text": text,
    "lat": lat,
    "lng": lng,
    "media_url": mediaUrl,
    "sender_id": senderId,
    "created_at": createdAt?.toIso8601String(),
  };

}
