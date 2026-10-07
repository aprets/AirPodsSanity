# AirPodsSanity

> Credit: AirPodsSanity is inspired by [milgra/airpodssoundqualityfixer](https://github.com/milgra/airpodssoundqualityfixer)

## About this fork

This is a fork of [Gaulomatic/AirPodsSanity](https://github.com/Gaulomatic/AirPodsSanity). The last upstream commit is from August 2025, and none of these changes are merged there.

- **A priority list of mics.** This comes from [upstream PR #23](https://github.com/Gaulomatic/AirPodsSanity/pull/23) by [@Zeko369](https://github.com/Zeko369). Upstream takes one preferred mic, and if that mic is unplugged it leaves you on the AirPods mic. With a list, say a desk mic and then the MacBook mic, you get the first one that's connected.
- **Plugging a listed mic back in switches to it.** macOS ranks inputs by which one was picked last. Once the app falls back to the MacBook mic, macOS ranks that first and ignores your desk mic when you plug it back in. The app now switches to a mic from your list when it's plugged in and ranks highest of the ones connected.
- **Picking the AirPods mic yourself sticks.** The app only overrides the AirPods mic within 10 seconds of a device connecting or disconnecting. Any other switch to the AirPods mic counts as your choice.
- **Builds without Xcode.** `./build.sh` needs only the Command Line Tools.

### Build and install

```sh
./build.sh
osascript -e 'quit app "AirPods Sanity"'
rm -rf "/Applications/AirPods Sanity.app"
ditto "build/AirPods Sanity.app" "/Applications/AirPods Sanity.app"
open "/Applications/AirPods Sanity.app"
```

The build is ad-hoc signed for your Mac's architecture. You built it locally, so macOS doesn't quarantine it.

Settings carry over from upstream. Your single preferred mic becomes the first entry in the list. Manage the list under "Preferred Input Devices" in the menu bar menu. If you hid the menu bar icon, open the app again and the icon shows for 10 seconds.

Keeps you from loosing your sanity when using AirPods with a Mac.

You ever wondered, why the audio quality of your beloved AirPods can get as bad as talking to people over some wire that was built during the Apollo missions took place in the 60s? Ask no further, you came to the right place!

## Because... reasons

The technical reason is simple: Bluetooth has a low bandwidth. So when Apple decided to set your AirPods microphone as the one in charge every. single. time. you connect them to your Mac, things go downhill - fast. Only Steve Jobs in his grave can answer the hard questions: Why, Apple?

## What it does

What this app does is super-duper simple and trivial: Mark one or more output device as "AirPods". Whenever those come online, either the first available input device from your priority list or the current system input device will be maintained.

## How it improves your life

So what that means is, you can live your life in peace, harmony and appreciate the rainbows and unicorns - once this app is installed.

## What it doesn't do

This piece of software is not cloud-native, has no micro service architecture, did not follow DDD principals, contains an algorithm designed by a fool, can not scale (neither vertically nor horizontally) and abuses your sense of humor.

## Features

- Keeps you healthy
- Makes life better
- Protects your sanity

## Roadmap

- Asking Steve in an upcoming session, why this is even a thing

# Installation

#### macOS

- Build from source, see [Build and install](#build-and-install). The `.dmg` on [upstream's release page](https://github.com/Gaulomatic/AirPodsSanity/releases) is upstream's build without this fork's changes.

#### Windows

- You are out of luck. On the other hand, this issue only applies to macOS, so....

#### Linux

- You are good to go. Essentially.


__Please feel free to download, fork and/or provide any feedback!__
