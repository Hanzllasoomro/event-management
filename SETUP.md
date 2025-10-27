# Setup Instructions for Event Planner App

## Quick Start

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Add Required Assets**

   The app requires some image files and an animation file. Create the following structure:

   ```
   assets/
   └── images/
       ├── 1.jpg          # Wedding event image
       ├── 2.jpg          # Birthday event image
       ├── 3.jpg          # Engagement event image
       ├── 4.jpg          # Graduation Party event image
       ├── 5.jpg          # Farewell event image
       └── Animation.json # Lottie animation for splash screen
   ```

   **Where to get these files:**
   - For the images (1.jpg - 5.jpg): You can download any suitable images for each event type from free image sources like Unsplash, Pexels, or use your own images
   - For Animation.json: You can get free Lottie animations from [LottieFiles](https://lottiefiles.com/)

3. **Place the files in the correct location:**
   ```
   eventplannerapplication-main/
   └── assets/
       └── images/
           ├── 1.jpg
           ├── 2.jpg
           ├── 3.jpg
           ├── 4.jpg
           ├── 5.jpg
           └── Animation.json
   ```

4. **Run the App**
   ```bash
   flutter run
   ```

## Firebase Configuration

The app is already configured with a Firebase project. If you want to use your own Firebase project:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use existing one
3. Enable Authentication with Email/Password
4. Enable Cloud Firestore database
5. Run `flutterfire configure` in the project root

## Troubleshooting

### Error: "Unable to load asset: assets/images/..."
- **Solution**: Make sure you've added the image files to `assets/images/` folder with the exact filenames mentioned above.

### Firebase errors
- **Solution**: Ensure Firebase is properly configured and that Authentication and Firestore are enabled in Firebase Console.

### Build errors
- **Solution**: Run `flutter clean` and then `flutter pub get` again.

## Testing Without Assets

If you want to test the app quickly without adding assets, you can temporarily comment out or remove the image loading code in `Dashboard.dart` and the animation loading in `SplashScreen.dart`. However, this is not recommended for production.

## Next Steps

- Add your own custom images for events
- Configure your Firebase project
- Customize the theme colors
- Add more event types

Happy coding! 🎉

