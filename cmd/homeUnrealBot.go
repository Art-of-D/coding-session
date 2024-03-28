/*
Copyright © 2024 NAME HERE <EMAIL ADDRESS>
*/
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
	appVersion = "1.0.0"
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

		unrealBot.Handle(telebot.OnText, func(m telebot.Context) error {
			log.Print(m.Message().Payload, m.Text())
			payload := m.Text()

			switch payload {
			case "hi":
				err = m.Send(fmt.Sprintf("Hello I'm UnrealBot %s!", appVersion))
			}

			return err
		})

		unrealBot.Start()
	},
}

func init() {
	rootCmd.AddCommand(homeUnrealBotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// homeUnrealBotCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// homeUnrealBotCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
