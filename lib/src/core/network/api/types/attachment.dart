/// Attachment type definitions for Max Bot API
library;

import 'keyboard.dart';
import 'user.dart';

/// Base attachment class
sealed class Attachment {
  final String type;

  const Attachment({required this.type});

  Map<String, dynamic> toJson();

  static Attachment fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    return switch (type) {
      'image' => PhotoAttachment.fromJson(json),
      'video' => VideoAttachment.fromJson(json),
      'audio' => AudioAttachment.fromJson(json),
      'file' => FileAttachment.fromJson(json),
      'sticker' => StickerAttachment.fromJson(json),
      'contact' => ContactAttachment.fromJson(json),
      'share' => ShareAttachment.fromJson(json),
      'location' => LocationAttachment.fromJson(json),
      'inline_keyboard' => InlineKeyboardAttachment.fromJson(json),
      _ => throw ArgumentError('Unknown attachment type: $type'),
    };
  }
}

/// Media payload for attachments
class MediaPayload {
  final String url;
  final String token;

  const MediaPayload({required this.url, required this.token});

  factory MediaPayload.fromJson(Map<String, dynamic> json) {
    return MediaPayload(
      url: json['url'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'url': url, 'token': token};
}

/// Photo/Image attachment
class PhotoAttachment extends Attachment {
  final MediaPayload payload;
  final int? photoId;

  const PhotoAttachment({
    required this.payload,
    this.photoId,
  }) : super(type: 'image');

  factory PhotoAttachment.fromJson(Map<String, dynamic> json) {
    final payloadJson = json['payload'] as Map<String, dynamic>;
    return PhotoAttachment(
      payload: MediaPayload.fromJson(payloadJson),
      photoId: payloadJson['photo_id'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': {
        ...payload.toJson(),
        if (photoId != null) 'photo_id': photoId,
      },
    };
  }
}

/// Video attachment
class VideoAttachment extends Attachment {
  final MediaPayload payload;
  final String? thumbnail;
  final int? width;
  final int? height;
  final int? duration;

  const VideoAttachment({
    required this.payload,
    this.thumbnail,
    this.width,
    this.height,
    this.duration,
  }) : super(type: 'video');

  factory VideoAttachment.fromJson(Map<String, dynamic> json) {
    return VideoAttachment(
      payload: MediaPayload.fromJson(json['payload'] as Map<String, dynamic>),
      thumbnail: json['thumbnail'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      duration: json['duration'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': payload.toJson(),
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (duration != null) 'duration': duration,
    };
  }
}

/// Audio attachment
class AudioAttachment extends Attachment {
  final MediaPayload payload;

  const AudioAttachment({required this.payload}) : super(type: 'audio');

  factory AudioAttachment.fromJson(Map<String, dynamic> json) {
    return AudioAttachment(
      payload: MediaPayload.fromJson(json['payload'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': payload.toJson(),
    };
  }
}

/// File attachment
class FileAttachment extends Attachment {
  final MediaPayload payload;
  final String filename;
  final int size;

  const FileAttachment({
    required this.payload,
    required this.filename,
    required this.size,
  }) : super(type: 'file');

  factory FileAttachment.fromJson(Map<String, dynamic> json) {
    return FileAttachment(
      payload: MediaPayload.fromJson(json['payload'] as Map<String, dynamic>),
      filename: json['filename'] as String,
      size: json['size'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': payload.toJson(),
      'filename': filename,
      'size': size,
    };
  }
}

/// Sticker attachment
class StickerAttachment extends Attachment {
  final String url;
  final String code;
  final int width;
  final int height;

  const StickerAttachment({
    required this.url,
    required this.code,
    required this.width,
    required this.height,
  }) : super(type: 'sticker');

  factory StickerAttachment.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>;
    return StickerAttachment(
      url: payload['url'] as String,
      code: payload['code'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': {'url': url, 'code': code},
      'width': width,
      'height': height,
    };
  }
}

/// Contact attachment
class ContactAttachment extends Attachment {
  final String? vcfInfo;
  final User? tamInfo;

  const ContactAttachment({
    this.vcfInfo,
    this.tamInfo,
  }) : super(type: 'contact');

  factory ContactAttachment.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>;
    return ContactAttachment(
      vcfInfo: payload['vcf_info'] as String?,
      tamInfo: payload['tam_info'] != null
          ? User.fromJson(payload['tam_info'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'payload': {
        if (vcfInfo != null) 'vcf_info': vcfInfo,
        if (tamInfo != null) 'tam_info': tamInfo!.toJson(),
      },
    };
  }
}

/// Share attachment
class ShareAttachment extends Attachment {
  final String? url;
  final String? token;
  final String? title;
  final String? description;
  final String? imageUrl;

  const ShareAttachment({
    this.url,
    this.token,
    this.title,
    this.description,
    this.imageUrl,
  }) : super(type: 'share');

  factory ShareAttachment.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>?;
    return ShareAttachment(
      url: payload?['url'] as String?,
      token: payload?['token'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
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
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}

/// Location attachment
class LocationAttachment extends Attachment {
  final double latitude;
  final double longitude;

  const LocationAttachment({
    required this.latitude,
    required this.longitude,
  }) : super(type: 'location');

  factory LocationAttachment.fromJson(Map<String, dynamic> json) {
    return LocationAttachment(
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

/// Inline keyboard attachment
class InlineKeyboardAttachment extends Attachment {
  final List<List<Button>> buttons;

  const InlineKeyboardAttachment({required this.buttons})
      : super(type: 'inline_keyboard');

  factory InlineKeyboardAttachment.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>;
    final buttonsList = payload['buttons'] as List<dynamic>;
    return InlineKeyboardAttachment(
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
