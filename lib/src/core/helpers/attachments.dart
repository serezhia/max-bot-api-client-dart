/// Attachment helpers for Max Bot API
library;

/// Base attachment class (for creating attachments to send)
abstract class AttachmentHelper {
  Map<String, dynamic> toJson();
}

/// Media attachment with token
class MediaAttachmentHelper extends AttachmentHelper {
  final String? token;

  MediaAttachmentHelper({this.token});

  Map<String, dynamic> get payload => {
        if (token != null) 'token': token,
      };

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError('Subclasses must implement toJson');
  }
}

/// Video attachment helper
class VideoAttachmentHelper extends MediaAttachmentHelper {
  VideoAttachmentHelper({super.token});

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'video',
      'payload': payload,
    };
  }
}

/// Image photos type
typedef ImagePhotos = Map<String, Map<String, String>>;

/// Image attachment helper
class ImageAttachmentHelper extends MediaAttachmentHelper {
  final ImagePhotos? photos;
  final String? url;

  ImageAttachmentHelper({
    super.token,
    this.photos,
    this.url,
  });

  @override
  Map<String, dynamic> get payload {
    if (token != null) {
      return {'token': token};
    }
    if (url != null) {
      return {'url': url};
    }
    if (photos != null) {
      return {'photos': photos};
    }
    return {};
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'image',
      'payload': payload,
    };
  }
}

/// Audio attachment helper
class AudioAttachmentHelper extends MediaAttachmentHelper {
  AudioAttachmentHelper({super.token});

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'audio',
      'payload': payload,
    };
  }
}

/// File attachment helper
class FileAttachmentHelper extends MediaAttachmentHelper {
  FileAttachmentHelper({super.token});

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'file',
      'payload': payload,
    };
  }
}

/// Sticker attachment helper
class StickerAttachmentHelper extends AttachmentHelper {
  final String code;

  StickerAttachmentHelper({required this.code});

  Map<String, dynamic> get payload => {'code': code};

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'sticker',
      'payload': payload,
    };
  }
}

/// Location attachment helper
class LocationAttachmentHelper extends AttachmentHelper {
  final double latitude;
  final double longitude;

  LocationAttachmentHelper({
    required this.latitude,
    required this.longitude,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'location',
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

/// Share attachment helper
class ShareAttachmentHelper extends AttachmentHelper {
  final String? url;
  final String? token;

  ShareAttachmentHelper({this.url, this.token});

  Map<String, dynamic> get payload => {
        if (url != null) 'url': url,
        if (token != null) 'token': token,
      };

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'share',
      'payload': payload,
    };
  }
}
