# cryptstorage_app

Crypstorage app

## Crash course

If you are unfamiliar with Flutter, check out the following links for a quick crash course:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

## Requirements

Install [Flutter](https://flutter.dev/) following [this setup](https://docs.flutter.dev/get-started/install) based on your OS. Make sure that `flutter doctor` is giving the expected output.

While you are free to choose your own IDE, we prefer working with [IntelliJ Idea](https://www.jetbrains.com/idea/download/), preferably the Ultimate version. Follow [this guide](https://docs.flutter.dev/development/tools/android-studio) to configure it.

## Running the project

Assuming you have successfully set up Flutter and your IDE, in order to run the project you must:

1. AVD Manager - download and create a virtual device that you will use for emulation. Keep in mind that some dependencies in the future might depend on virtual device having Play Store installed
2. API client - since we use [OpenAPI](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md) for server&client code generation, you are required to generate the client code. One thing you must do is **make sure that backend and mobile projects are sibling folders** and run `flutter pub run build_runner build --delete-conflicting-outputs`.
3. Dependencies - make sure you ran `flutter pub get` to get all the dependencies from [pubspec.yaml](pubspec.yaml)

At this moment, the Dart code should compile, and you should be able to run the application.

## Guidelines

Make your best effort to follow **Clean Code** guidelines.

Make sure your code is **testable** and **tested**.

Make your best effort to write **reusable widgets** (when it's suitable), they ensure we follow the same design style across the entire application while also saving us time in the future.

[Figma](https://www.figma.com/) is our tool of choice when it comes to designing.

## Architecture Diagram

https://drive.google.com/file/d/1TZYXC4cuRho9CmUbjK4bo1Oafh6OMY0Y/view