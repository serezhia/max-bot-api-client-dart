# `3` Отправка сообщений с вложениями
Для упрощения работы с вложениями существуют классы-помощники в пакете `max_bot_api`, которые позволяют создавать вложения для отправки.

## Отправка файлов

### При помощи токена
Подходит для файлов, которые уже были загружены в Max:
```dart
final image = ImageAttachmentHelper(token: 'existingImageToken');
await ctx.reply('', SendMessageExtra(attachments: [image.toJson()]));

final video = VideoAttachmentHelper(token: 'existingVideoToken');
await ctx.reply('', SendMessageExtra(attachments: [video.toJson()]));

final audio = AudioAttachmentHelper(token: 'existingAudioToken');
await ctx.reply('', SendMessageExtra(attachments: [audio.toJson()]));

final file = FileAttachmentHelper(token: 'existingFileToken');
await ctx.reply('', SendMessageExtra(attachments: [file.toJson()]));
```

### При помощи ссылки
Доступно для изображений:
```dart
final image = await ctx.api.uploadImage(url: 'https://upload.wikimedia.org/wikipedia/commons/Image.png');
await ctx.reply('', SendMessageExtra(attachments: [image.toJson()]));
```

## Отправка других типов вложений
```dart
final sticker = StickerAttachmentHelper(code: 'stickerCode');
await ctx.reply('', SendMessageExtra(attachments: [sticker.toJson()]));

final location = LocationAttachmentHelper(latitude: 0, longitude: 0);
await ctx.reply('', SendMessageExtra(attachments: [location.toJson()]));

final share = ShareAttachmentHelper(url: 'messagePublicUrl', token: 'attachmentToken');
await ctx.reply('', SendMessageExtra(attachments: [share.toJson()]));
```
