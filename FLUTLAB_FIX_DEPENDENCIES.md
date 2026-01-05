# Fix FlutLab Dependencies Error
## Quick Fix Guide

The errors you're seeing mean the packages aren't installed. Here's how to fix it:

---

## Step 1: Update pubspec.yaml in FlutLab

1. **In FlutLab, open `pubspec.yaml`**

2. **Find the `dependencies:` section** (around line 30)

3. **Make sure it looks EXACTLY like this:**

```yaml
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  dio: ^5.4.0
  flutter_secure_storage: ^9.0.0
  provider: ^6.1.1
  go_router: ^13.0.0
```

4. **Save the file** (Ctrl+S)

---

## Step 2: Install Dependencies

1. **In FlutLab, look at the bottom panel**
2. **Click on the "Pub Commands" tab**
3. **Type this command:**
   ```
   flutter pub get
   ```
4. **Press Enter**
5. **Wait for it to finish** (may take 1-2 minutes)
6. ✅ You should see: "Got dependencies!"

---

## Step 3: Verify It Worked

1. **Check the errors panel** - errors should disappear
2. **If errors are still there:**
   - Wait a few seconds (FlutLab needs to refresh)
   - Click "Analyzer" tab to refresh
   - Try running `flutter pub get` again

---

## If It Still Doesn't Work

### Option 1: Copy pubspec.yaml Again

1. Open your local file: `flutter_app/pubspec.yaml`
2. Copy ALL content (Ctrl+A, Ctrl+C)
3. In FlutLab, open `pubspec.yaml`
4. Select all (Ctrl+A)
5. Paste (Ctrl+V)
6. Save (Ctrl+S)
7. Run `flutter pub get` again

### Option 2: Check FlutLab Version

- Make sure you're using a recent version of FlutLab
- Some older versions have issues with dependencies

### Option 3: Restart FlutLab

- Close and reopen FlutLab
- Run `flutter pub get` again

---

## What Each Package Does

- **dio** - HTTP client for API calls
- **flutter_secure_storage** - Secure storage for tokens
- **provider** - State management
- **go_router** - Navigation (optional, not used in current code)

---

## After Fixing

Once dependencies are installed:
1. ✅ All red errors should disappear
2. ✅ You can run the app
3. ✅ Make sure API URL is set to `http://localhost:8000` in `api_client.dart`

---

**That's it! The errors should be gone after running `flutter pub get`! 🎉**
