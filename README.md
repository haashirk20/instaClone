<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/readme/hero-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="assets/readme/hero-light.svg">
    <img src="assets/readme/hero-dark.svg" width="880" alt="InstaClone: a Flutter and Firebase photo-sharing app that runs on web and mobile from one codebase, switching to a desktop layout above 600 px, with no custom backend.">
  </picture>
</p>

<p align="center">
  <strong>A photo-sharing app modelled on Instagram, built with Flutter and Firebase.</strong><br>
  <strong>Posts &middot; live feed &middot; likes and comments &middot; follows &middot; search</strong><br>
  <sub>One Dart codebase for web and mobile. Firebase handles accounts, data and image storage.</sub>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Dart-000000?style=flat-square&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Flutter-000000?style=flat-square&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore%20%7C%20Storage-000000?style=flat-square&logo=firebase&logoColor=white" alt="Firebase Auth, Firestore and Storage">
</p>

<!-- TODO: demo link or video -->

<p align="center">
  <img src="https://github.com/haashirk20/instaClone/assets/114118228/8881a242-dfe1-4bc2-8923-15ba174e9ed5" width="200" alt="Mobile home screen">
  <img src="https://github.com/haashirk20/instaClone/assets/114118228/7a784a99-547a-4730-a19e-9efe30f60729" width="200" alt="Web login screen">
  <img src="https://github.com/haashirk20/instaClone/assets/114118228/1cc44770-ce90-470e-be48-6c24f1180bca" width="200" alt="Mobile feed screen">
  <img src="https://github.com/haashirk20/instaClone/assets/114118228/713ab0db-2741-4ce3-9425-b7503e94255e" width="200" alt="Mobile profile screen">
</p>

---

Users sign up with a profile photo and bio, post pictures from the camera or gallery, and scroll a live feed. They can like posts with a double tap, comment, follow other users and search for them.

## Features

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/readme/features-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="assets/readme/features-light.svg">
    <img src="assets/readme/features-dark.svg" width="880" alt="Features: accounts with Firebase Auth, posting to Storage and Firestore, a live feed from a snapshots stream, likes and comments, follow and search with an explore grid, and a responsive desktop layout above 600 px.">
  </picture>
</p>

The app listens to `authStateChanges()` and switches between the login screen and the home screen on its own. Posts come from a Firestore `snapshots()` stream, so new ones appear without a refresh. The explore grid lays out all posts in a quilted 3-column layout, and your own profile has a Sign Out button.

## Data model

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/readme/data-model-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="assets/readme/data-model-light.svg">
    <img src="assets/readme/data-model-dark.svg" width="880" alt="Data model: a users collection keyed by uid with followers and following arrays, a posts collection keyed by postId with a likes array, a comments subcollection under each post, and Storage folders profilepics/uid and posts/uid/uuid.">
  </picture>
</p>

Likes and follows use Firestore's `FieldValue.arrayUnion` and `arrayRemove`. The update happens on the server, so two users liking the same post at once don't overwrite each other. Following updates both sides of the relationship: the target's `followers` array and the current user's `following` array.

Each user has one avatar file at `profilepics/<uid>` and as many post images as they upload at `posts/<uid>/<uuid>`, so nothing collides.

## Architecture

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/readme/architecture-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="assets/readme/architecture-light.svg">
    <img src="assets/readme/architecture-dark.svg" width="880" alt="Architecture: main.dart listens to authStateChanges, ResponsiveLayout picks the mobile or desktop layout, screens read the signed-in user from UserProvider, and the resources classes make every Firebase call.">
  </picture>
</p>

The UI is split into `screens/`, reusable `widgets/` and `responsive/` layouts. All Firebase calls go through three classes in `resources/` (`AuthMethods`, `FirestoreMethods` and `StorageMethods`), so screens never write to Firestore or Storage directly. The signed-in user's profile is loaded once into a `UserProvider` when the home layout mounts, and screens read it from there instead of fetching it again. `ResponsiveLayout` uses a `LayoutBuilder`, so resizing a browser window switches between the layouts live.

## Getting started

Requires the Flutter SDK (Dart 3.1.2 or later) and a Firebase project with Auth (email/password), Firestore and Storage turned on.

```sh
git clone https://github.com/haashirk20/instaClone.git
cd instaClone/insta_flutter
flutter pub get
flutter run -d chrome --web-renderer html
```

Newer Flutter releases removed the `--web-renderer` flag. On those, run `flutter run -d chrome`. <!-- verify: Flutter version that builds this project -->

The web Firebase config is set in `lib/main.dart` and the Android config in `android/app/google-services.json`. To use your own Firebase project, replace both. Running `flutterfire configure` is the usual way to generate them.

## Known limitations

- The delete option shows on every post, not only your own, and nothing in the client checks ownership. Firestore security rules would need to enforce it.
- The Favourites tab in the bottom bar is a placeholder.
