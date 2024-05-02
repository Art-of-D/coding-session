package cmd

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

var (
	// TeleToken bot
	TeleToken  = os.Getenv("TELE_TOKEN")
	appVersion = "1.1.1"
)

// homeUnrealBotCmd represents the homeUnrealBot command
var homeUnrealBotCmd = &cobra.Command{
	Use:     "UnrealBot",
	Aliases: []string{"start"},
	Short:   "UnrealBot is a Telegram bot",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("UnrealBot %s started", appVersion)
		unrealBot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		if err != nil {
			log.Fatalf("Please check TELE_TOKEN env variable. %s", err)
			return
		}

		unrealBot.Handle("/start", func(m telebot.Context) error {
			menu := &telebot.ReplyMarkup{
				ReplyKeyboard: [][]telebot.ReplyButton{
					{{Text: "Hello"}, {Text: "Help"}},
					{{Text: "Kyiv"}, {Text: "Boston"}, {Text: "London"}},
					{{Text: "Vienna"}, {Text: "Tbilisi"}, {Text: "Vancouver"}},
				},
			}
			return m.Send("Welcome to Kbot!", menu)
		})

		unrealBot.Handle(telebot.OnText, func(m telebot.Context) error {
			switch m.Text() {
			case "Hello":
				return m.Send(fmt.Sprintf("Hi! I'm Kbot %s! And I know what time it is!", appVersion))
			case "Help":
				return m.Send("This is the help message. Here you can find out the current time in the locations of your partners and team members: Kyiv, Boston, London, Vienna, Tbilisi or Vancouver")
			case "Kyiv":
				return m.Send("Current time in Kyiv: " + getTime("Kyiv"))
			case "Boston":
				return m.Send("Current time in Boston: " + getTime("Boston"))
			case "London":
				return m.Send("Current time in London: " + getTime("London"))
			case "Vienna":
				return m.Send("Current time in Vienna: " + getTime("Vienna"))
			case "Tbilisi":
				return m.Send("Current time in Tbilisi: " + getTime("Tbilisi"))
			case "Vancouver":
				return m.Send("Current time in Vancouver: " + getTime("Vancouver"))
			default:
				return m.Send("Unknown command. Please try again.")
			}
		})
		unrealBot.Start()
	},
}

func getTime(location string) string {
	var locName string
	switch location {
	case "Kyiv":
		locName = "Europe/Kiev"
	case "Boston":
		locName = "America/New_York"
	case "London":
		locName = "Europe/London"
	case "Vienna":
		locName = "Europe/Vienna"
	case "Tbilisi":
		locName = "Asia/Tbilisi"
	case "Vancouver":
		locName = "America/Vancouver"
	default:
		return "Invalid location"
	}

	loc, err := time.LoadLocation(locName)
	if err != nil {
		return "Invalid location"
	}
	return time.Now().In(loc).Format("15:04:05")
}

func init() {
	rootCmd.AddCommand(homeUnrealBotCmd)
}
