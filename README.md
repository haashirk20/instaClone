# InstaClone

A photo-sharing app modelled on Instagram, built with Flutter and Firebase. It runs on web and mobile from one codebase, with a separate layout for wide screens.

![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore%20%7C%20Storage-FFCA28?logo=firebase&logoColor=black)

> The app's source is on the [`develop`](https://github.com/haashirk20/instaClone/tree/develop) branch. `main` still holds the starter Flutter project.

## Demo

<!-- TODO: demo link or video -->

![Mobile home screen](https://github.com/haashirk20/instaClone/assets/114118228/8881a242-dfe1-4bc2-8923-15ba174e9ed5)
![Web login screen](https://github.com/haashirk20/instaClone/assets/114118228/7a784a99-547a-4730-a19e-9efe30f60729)
![Mobile feed screen](https://github.com/haashirk20/instaClone/assets/114118228/1cc44770-ce90-470e-be48-6c24f1180bca)
![Mobile profile screen](https://github.com/haashirk20/instaClone/assets/114118228/713ab0db-2741-4ce3-9425-b7503e94255e)

## Overview

InstaClone covers the core Instagram loop. Users sign up with a profile photo and bio, post pictures from the camera or gallery, and scroll a live feed. They can like posts with a double tap, comment, follow other users and search for them. Firebase handles accounts, data and image storage, so the app has no custom backend.

## Key features

- Email and password sign-up and login with Firebase Auth. The app listens to `authStateChanges()` and switches between the login screen and the home screen on its own.
- Posting from the camera or gallery with a caption. Images go to Firebase Storage and post records to Firestore.
- A real-time feed from a Firestore `snapshots()` stream, so new posts appear without a refresh.
- Double-tap to like with a heart animation, and a like button that toggles.
- Comments on each post in a subcollection, newest first, plus a comment count on the post card.
- Follow and unfollow, with follower and following lists kept on both user documents.
- User search by name, and an explore grid of all posts in a quilted 3-column layout.
- Profile pages with the user's posts, stats, and a Sign Out button on your own profile.
- Deleting a post from the menu on each post card.
- A responsive layout that switches to a desktop design above 600 px wide.

## Tech stack

| Area | Tools |
|---|---|
| Language and UI | Dart, Flutter (Material, dark theme) |
| Auth | Firebase Auth |
| Database | Cloud Firestore |
| File storage | Firebase Storage |
| State | Provider (`ChangeNotifier`) |
| Other packages | `image_picker`, `flutter_staggered_grid_view`, `flutter_svg`, `uuid`, `intl` |

## Architecture

The UI is split into `screens/`, reusable `widgets/` and `responsive/` layouts. All Firebase calls go through three classes in `resources/`, so screens never touch Firestore or Storage directly for writes.

```mermaid
flowchart LR
    main["main.dart<br/>authStateChanges()"] -- "signed out" --> login["Login / Sign-up screens"]
    main -- "signed in" --> resp["ResponsiveLayout<br/>> 600 px: desktop, else mobile"]
    resp --> screens["Feed, Search, Add Post,<br/>Profile, Comments"]
    screens --> prov["UserProvider<br/>(current user)"]
    screens --> res["resources/<br/>AuthMethods, FirestoreMethods,<br/>StorageMethods"]
    prov --> res
    res --> auth["Firebase Auth"]
    res --> fs[("Firestore<br/>users, posts, comments")]
    res --> st[("Firebase Storage<br/>profilepics/, posts/")]
```

## Technical highlights

- Likes and follows use Firestore's `FieldValue.arrayUnion` and `arrayRemove`. The update happens on the server, so two users liking the same post at once don't overwrite each other.
- Following updates both sides of the relationship: the target's `followers` array and the current user's `following` array.
- Storage paths are `profilepics/<uid>` for avatars and `posts/<uid>/<uuid>` for posts. Each user has one avatar file and as many post images as they upload, and nothing collides.
- The signed-in user's profile is loaded once into a `UserProvider` when the home layout mounts, and screens read it from there instead of fetching it again.
- `ResponsiveLayout` uses a `LayoutBuilder`, so resizing a browser window switches between the mobile and desktop layouts live.

## Getting started

Requires the Flutter SDK (Dart 3.1.2 or later) and a Firebase project with Auth (email/password), Firestore and Storage turned on.

```sh
git clone -b develop https://github.com/haashirk20/instaClone.git
cd instaClone/insta_flutter
flutter pub get
flutter run -d chrome --web-renderer html
```

Newer Flutter releases removed the `--web-renderer` flag. On those, run `flutter run -d chrome`. <!-- verify: Flutter version that builds this project -->

The web Firebase config is set in `lib/main.dart` and the Android config in `android/app/google-services.json`. To use your own Firebase project, replace both. Running `flutterfire configure` is the usual way to generate them.

## Known limitations

- The delete option shows on every post, not only your own, and nothing in the client checks ownership. Firestore security rules would need to enforce it.
- The Favourites tab in the bottom bar is a placeholder.
