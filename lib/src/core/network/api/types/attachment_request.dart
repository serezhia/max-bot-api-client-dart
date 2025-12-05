/// Attachment request type definitions for Max Bot API
library;

import 'keyboard.dart';

/// Base attachment request class
sealed class AttachmentRequest {
  final String type;

  const AttachmentRequest({required this.type});

  Map<String, dynamic> toJson();

  static AttachmentRequest fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    return switch (type) {
      'image' => ImageAttachmentRequest.fromJson(json),
      'video' => VideoAttachmentRequest.fromJson(json),
      'audio' => AudioAttachmentRequest.fromJson(json),
      'file' => FileAttachmentRequest.fromJson(json),
      'sticker' => StickerAttachmentRequest.fromJson(json),
      'contact' => ContactAttachmentRequest.fromJson(json),
      'inline_keyboard' => InlineKeyboardAttachmentRequest.fromJson(json),
      'share' => ShareAttachmentRequest.fromJson(json),
      'location' => LocationAttachmentRequest.fromJson(json),
      _ => throw ArgumentError('Unknown attachment request type: $type'),
    };
  }
}

/// Image attachment request
class ImageAttachmentRequest extends AttachmentRequest {
  final String? token;
  final String? url;
  final Map<String, Map<String, String>>? photos;

  const ImageAttachmentRequest({
    this.token,
    this.url,
    this.photos,
  }) : super(type: 'image');

  factory ImageAttachmentRequest.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>?;
    return ImageAttachmentRequest(
      token: payload?['token'] as String?,
      url: payload?['url'] as String?,
      photos: (payload?['photos'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, Map<String, String>.from(v as Map)),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': {
        if (token != null) 'token': token,
        if (url != null) 'url': url,
        if (photos != null) 'photos': photos,
      },
    };
  }
}

/// Video attachment request
class VideoAttachmentRequest extends AttachmentRequest {
  final String? token;

  const VideoAttachmentRequest({this.token}) : super(type: 'video');

  factory VideoAttachmentRequest.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>?;
    return VideoAttachmentRequest(
      token: payload?['token'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': {
        if (token != null) 'token': token,
      },
    };
  }
}

/// Audio attachment request
class AudioAttachmentRequest extends AttachmentRequest {
  final String? token;

  const AudioAttachmentRequest({this.token}) : super(type: 'audio');

  factory AudioAttachmentRequest.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>?;
    return AudioAttachmentRequest(
      token: payload?['token'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': {
        if (token != null) 'token': token,
      },
    };
  }
}

/// File attachment request
class FileAttachmentRequest extends AttachmentRequest {
  final String? token;

  const FileAttachmentRequest({this.token}) : super(type: 'file');

  factory FileAttachmentRequest.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>?;
    return FileAttachmentRequest(
      token: payload?['token'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': {
        if (token != null) 'token': token,
      },
    };
  }
}

/// Contact attachment request
class ContactAttachmentRequest extends AttachmentRequest {
  final String? name;
  final int? contactId;
  final String? vcfInfo;
  final String? vcfPhone;

  const ContactAttachmentRequest({
    this.name,
    this.contactId,
    this.vcfInfo,
    this.vcfPhone,
  }) : super(type: 'contact');

  factory ContactAttachmentRequest.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>?;
    return ContactAttachmentRequest(
      name: payload?['name'] as String?,
      contactId: payload?['contact_id'] as int?,
      vcfInfo: payload?['vcf_info'] as String?,
      vcfPhone: payload?['vcf_phone'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': {
        if (name != null) 'name': name,
        if (contactId != null) 'contact_id': contactId,
        if (vcfInfo != null) 'vcf_info': vcfInfo,
        if (vcfPhone != null) 'vcf_phone': vcfPhone,
      },
    };
  }
}

/// Sticker attachment request
class StickerAttachmentRequest extends AttachmentRequest {
  final String code;

  const StickerAttachmentRequest({required this.code}) : super(type: 'sticker');

  factory StickerAttachmentRequest.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>;
    return StickerAttachmentRequest(
      code: payload['code'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': {'code': code},
    };
  }
}

/// Inline keyboard attachment request
class InlineKeyboardAttachmentRequest extends AttachmentRequest {
  final List<List<Button>> buttons;

  const InlineKeyboardAttachmentRequest({required this.buttons})
      : super(type: 'inline_keyboard');

  factory InlineKeyboardAttachmentRequest.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>;
    final buttonsList = payload['buttons'] as List<dynamic>;
    return InlineKeyboardAttachmentRequest(
      buttons: buttonsList
          .map((row) => (row as List<dynamic>)
              .map((btn) => Button.fromJson(btn as Map<String, dynamic>))
              .toList())
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': {
        'buttons': buttons.map((row) => row.map((b) => b.toJson()).toList()).toList(),
      },
    };
  }
}

/// Location attachment request
class LocationAttachmentRequest extends AttachmentRequest {
  final double latitude;
  final double longitude;

  const LocationAttachmentRequest({
    required this.latitude,
    required this.longitude,
  }) : super(type: 'location');

  factory LocationAttachmentRequest.fromJson(Map<String, dynamic> json) {
    return LocationAttachmentRequest(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

/// Share attachment request
class ShareAttachmentRequest extends AttachmentRequest {
  final String? url;
  final String? token;

  const ShareAttachmentRequest({
    this.url,
    this.token,
  }) : super(type: 'share');

  factory ShareAttachmentRequest.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>?;
    return ShareAttachmentRequest(
      url: payload?['url'] as String?,
      token: payload?['token'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': {
        if (url != null) 'url': url,
        if (token != null) 'token': token,
      },
    };
  }
}

/// Photo attachment request payload
class PhotoAttachmentRequestPayload {
  final String? url;
  final String? token;
  final Map<String, String>? photos;

  const PhotoAttachmentRequestPayload({
    this.url,
    this.token,
    this.photos,
  });

  factory PhotoAttachmentRequestPayload.fromJson(Map<String, dynamic> json) {
    return PhotoAttachmentRequestPayload(
      url: json['url'] as String?,
      token: json['token'] as String?,
      photos: (json['photos'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as String),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (url != null) 'url': url,
      if (token != null) 'token': token,
      if (photos != null) 'photos': photos,
    };
  }
}
