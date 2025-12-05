# `5` Расширение контекста

Вы можете расширить контекст, создав свой класс, унаследованный от `Context`:
```dart
class MyContext extends Context {
  bool isAdmin = false;

  MyContext(super.update, super.api, [super.botInfo]);
}

const adminId = 12345;

void main() async {
  final bot = Bot<MyContext>(
    Platform.environment['BOT_TOKEN']!,
    config: BotConfig(
      contextFactory: (update, api, botInfo) => MyContext(update, api, botInfo),
    ),
  );

  bot.use([
    (ctx, next) async {
      ctx.isAdmin = ctx.user?.userId == adminId;
      return next();
    },
  ]);

  bot.command('start', [
    (ctx, next) async {
      if (ctx.isAdmin) {
        return ctx.reply('Привет, админ!');
      }
      return ctx.reply('Привет!');
    },
  ]);

  await bot.start();
}
```
