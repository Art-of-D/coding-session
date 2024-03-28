# UnrealBot

This is a simple Telegram bot created using the Telebot library in Go.
You can find the bot at: https://t.me/art_unreal_bot
When you send him a message with text "hi" - you will get a message.

(But befor next next install Git and Go (Golang))
To compile this bot on your computer please do next in your terminal:
git clone https://github.com/Art-of-D/coding-session-1.git
go build -ldflags "-X="github.com/Art-of-D/coding-session-1/cmd.appVersion=v1.0.4
(create your bot in BotFather in Telegram)
read -s TELE_TOKEN
(Ctr+V and Enter)
echo $TELE_TOKEN
(You will see your token)
export TELE_TOKEN
./coding-session-1 start
(you will get message that bot is started)
