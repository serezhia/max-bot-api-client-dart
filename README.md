# Max Bot API Client for Dart

Фреймворк для создания ботов для мессенджера Max на языке Dart.

## Документация

В [документации](https://github.com/serezhia/max-bot-api-client-dart/tree/master/doc) вы можете найти подробные инструкции по использованию фреймворка.

## Быстрый старт

> Если вы новичок, то можете прочитать [официальную документацию](https://dev.max.ru/), написанную разработчиками Max

### Получение токена
Откройте диалог с [Master Bot](https://max.ru/masterbot), следуйте инструкциям и создайте нового бота. После создания бота Master Bot отправит вам токен.

### Установка

Добавьте пакет в ваш `pubspec.yaml`:

```yaml
dependencies:
  max_bot_api: ^0.2.1
```

Или установите с помощью команды:

```sh
dart pub add max_bot_api
```

### Пример

```dart
import 'dart:io';
import 'package:max_bot_api/max_bot_api.dart';

void main() async {
  final bot = Bot(Platform.environment['BOT_TOKEN']!);

  // Установка подсказок с доступными командами
  await bot.api.setMyCommands([
    const BotCommand(
      name: 'ping',
      description: 'Сыграть в пинг-понг',
    ),
  ]);

  // Обработчик события запуска бота
  bot.on(UpdateType.botStarted, [
    (ctx, next) => ctx.reply('Привет! Отправь мне команду /ping, чтобы сыграть в пинг-понг'),
  ]);

  // Обработчик команды '/ping'
  bot.command('ping', [(ctx, next) => ctx.reply('pong')]);

  // Обработчик для сообщения с текстом 'hello'
  bot.hears('hello', [(ctx, next) => ctx.reply('world')]);

  // Обработчик для всех остальных входящих сообщений
  bot.on(UpdateType.messageCreated, [
    (ctx, next) => ctx.reply(ctx.message?.body.text ?? ''),
  ]);

  await bot.start();
}
```

### Работа с клавиатурами

```dart
import 'dart:io';
import 'package:max_bot_api/max_bot_api.dart';

void main() async {
  final bot = Bot(Platform.environment['BOT_TOKEN']!);

  // Создание inline-клавиатуры
  bot.command('keyboard', [
    (ctx, next) {
      final keyboard = Keyboard.inlineKeyboard([
        [
          Keyboard.button.callback('Кнопка 1', 'button_1'),
          Keyboard.button.callback('Кнопка 2', 'button_2'),
        ],
        [Keyboard.button.link('Ссылка', 'https://dev.max.ru/')],
      ]);
      return ctx.reply('Клавиатура', SendMessageExtra(attachments: [keyboard]));
    },
  ]);

  // Обработка нажатия на кнопку
  bot.action('button_1', [
    (ctx, next) => ctx.answerOnCallback(
      const AnswerOnCallbackExtra(notification: 'Вы нажали кнопку 1'),
    ),
  ]);

  await bot.start();
}
```

### Обработка ошибок

Если во время обработки события произойдёт ошибка, Bot выбросит исключение. Вы можете переопределить это поведение, используя `bot.catch_`:

```dart
bot.catch_((error, ctx) {
  print('Ошибка: $error');
  // Обработка ошибки
});
```

> ⚠️ Завершайте работу программы при неизвестных ошибках, иначе бот может зависнуть в состоянии ошибки.

## API

### Bot

Основной класс для создания бота:

```dart
final bot = Bot(token);
```

### Методы Bot

- `on(filter, handlers)` - обработка обновлений по типу
- `command(trigger, handlers)` - обработка команд
- `hears(trigger, handlers)` - обработка текстовых сообщений
- `action(trigger, handlers)` - обработка callback-кнопок
- `start()` - запуск бота
- `stop()` - остановка бота
- `catch_(handler)` - установка обработчика ошибок

### Context

Контекст содержит информацию об обновлении и методы для ответа:

- `ctx.update` - исходное обновление
- `ctx.message` - сообщение (если есть)
- `ctx.chatId` - ID чата
- `ctx.user` - пользователь
- `ctx.reply(text, extra)` - отправить ответ
- `ctx.deleteMessage()` - удалить сообщение
- `ctx.answerOnCallback(extra)` - ответить на callback

### Keyboard

Помощник для создания клавиатур:

```dart
Keyboard.inlineKeyboard([
  [Keyboard.button.callback('Текст', 'payload')],
  [Keyboard.button.link('Ссылка', 'https://example.com')],
  [Keyboard.button.requestContact('Отправить контакт')],
  [Keyboard.button.requestGeoLocation('Отправить геолокацию')],
]);
```

## Требования

- Dart SDK 3.5.0 или выше

## Лицензия

MIT
