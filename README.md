# rb-discord-gameinfo-bot
A simple Discord bot that allowed users search for games, gaming news, and the latest game
releases.

## Dependencies
* Ruby 2.1+
* [discordrb](https://github.com/meew0/discordrb)

## Setup
In order to get started, make sure you run bundler to install discordrb via the
include Gemfile. 

To use this bot, you'll need a Discord account with developer access 
(https://discordapp.com/developers/docs/intro) in addition to a Giant Bomb API
Key (https://www.giantbomb.com/api/), both of which can be obtained for free.

Once you have the accounts created, simply fill in the required info as shown in
the settings.yaml.example file, save it as settings.yaml, and run the 
main.rb file using 'ruby main.rb'. 

## Commands
Currently, the following commands are implemented:
- !find (args) will search the Giant Bomb Wiki and return the results, including the
name, release date, platforms, and a direct link to the entry.
  - Example: !find zelda

- !latest will return a list of game releases from today to ten days prior from Giant Bomb, 
including the same information as !find.

- !news (args) will return a list of gaming headlines. Currently, Gematsu is the 
default provider no arguments are provided, but Giant Bomb ('giant_bomb'), 
Game Informer ('game_informer'), and ResetERA ('era') are supported as well.


## License

All code is available under the terms of the 
[MIT License](http://opensource.org/licenses/MIT).