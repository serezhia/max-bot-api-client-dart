# `2` Прослушивание обновлений и реакция на них

После запуска бота Max начнёт отправлять вам обновления.
> Подробности обо всех обновлениях смотрите в [официальной документации](https://dev.max.ru/).

Max Bot API позволяет прослушивать эти обновления, например:
```dart
// Обработчик начала диалога с ботом
bot.on(UpdateType.botStarted, [(ctx, next) {/* ... */}]);

// Обработчик новых сообщений
bot.on(UpdateType.messageCreated, [(ctx, next) {/* ... */}]);

// Обработчик добавления пользователя в беседу
bot.on(UpdateType.userAdded, [(ctx, next) {/* ... */}]);
```
Вы можете использовать подсказки в редакторе кода, чтобы увидеть все доступные типы обновлений (enum `UpdateType`).

## Получение сообщений
Вы можете подписаться на обновление `messageCreated`:
```dart
bot.on(UpdateType.messageCreated, [(ctx, next) {
  final message = ctx.message; // полученное сообщение
}]);
```
Или воспользоваться специальными методами:
```dart
// Обработчик команды '/start'
bot.command('start', [(ctx, next) async {/* ... */}]);

// Сравнение текста сообщения со строкой или регулярным выражением
bot.hears('hello', [(ctx, next) async {/* ... */}]);
bot.hears(RegExp(r'echo (.+)?'), [(ctx, next) async {/* ... */}]);

// Обработчик нажатия на callback-кнопку с указанным payload
bot.action('connect_wallet', [(ctx, next) async {/* ... */}]);
bot.action(RegExp(r'color:(.+)'), [(ctx, next) async {/* ... */}]);
```

## Отправка сообщений
Вы можете воспользоваться методами из `bot.api`:
```dart
// Отправить сообщение пользователю с id=12345
await bot.api.sendMessageToUser(12345, 'Привет!');
// Опционально вы можете передать дополнительные параметры
await bot.api.sendMessageToUser(12345, 'Привет!', SendMessageExtra(/* доп. параметры */));

// Отправить сообщение в чат с id=54321
await bot.api.sendMessageToChat(54321, 'Всем привет!');

// Получить отправленное сообщение
final message = await bot.api.sendMessageToUser(12345, 'Привет!');
print(message.body.mid);
```

Или воспользоваться методом контекста `reply`:
```dart
bot.hears('ping', [(ctx, next) async {
  // 'reply' — псевдоним метода 'ctx.api.sendMessageToChat' в этом же чате
  await ctx.reply('pong', SendMessageExtra(
    // 'link' прикрепляет оригинальное сообщение
    link: {'type': 'reply', 'mid': ctx.message?.body.mid},
  ));
}]);
```

## Форматирование сообщений
> Подробности про форматирование смотрите в [официальной документации](https://dev.max.ru/).

Вы можете отправлять сообщения, используя **жирный** или _курсивный_ текст, ссылки и многое другое. Есть два типа форматирования: `markdown` и `html`.
#### Markdown
```dart
await bot.api.sendMessageToChat(
  12345,
  '**Привет!** _Добро пожаловать_ в [Max](https://dev.max.ru).',
  SendMessageExtra(format: 'markdown'),
);
```
#### HTML
```dart
await bot.api.sendMessageToChat(
  12345,
  '<b>Привет!</b> <i>Добро пожаловать</i> в <a href="https://dev.max.ru">Max</a>.',
  SendMessageExtra(format: 'html'),
);
```
