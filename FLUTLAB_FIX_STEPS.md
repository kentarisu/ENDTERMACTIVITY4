# 🔧 Fix FlutLab Dependencies - Step by Step

**The error means:** Packages are not installed in FlutLab yet.

---

## ✅ Step 1: Copy pubspec.yaml to FlutLab

1. **Open this file on your computer:**
   - `flutter_app/pubspec.yaml`

2. **IMPORTANT:** Make sure line 22 says:
   ```yaml
   sdk: '>=3.0.0 <4.0.0'
   ```
   (NOT `^3.9.2` - FlutLab uses Dart 3.7.0)

3. **Select ALL content** (Ctrl+A)

4. **Copy it** (Ctrl+C)

5. **In FlutLab:**
   - Open `pubspec.yaml` file
   - Select ALL content (Ctrl+A)
   - **Delete it** (Delete key)
   - **Paste** your copied content (Ctrl+V)
   - **Save** (Ctrl+S or click Save button)

---

## ✅ Step 2: Install Dependencies

1. **In FlutLab, look at the BOTTOM panel**

2. **Click on "Pub Commands" tab** (or "Terminal" tab)

3. **Type this EXACT command:**
   ```
   flutter pub get
   ```

4. **Press Enter**

5. **Wait 1-2 minutes** - You'll see messages like:
   ```
   Running "flutter pub get"...
   Got dependencies!
   ```

---

## ✅ Step 3: Wait for Errors to Disappear

1. **After `flutter pub get` finishes:**
   - Wait 10-20 seconds
   - FlutLab needs to refresh

2. **Check the "Analyzer" tab:**
   - Click on "Analyzer" tab (bottom panel)
   - Errors should start disappearing

3. **If errors are still there:**
   - Click "Analyzer" tab again to refresh
   - Or wait a bit longer (FlutLab can be slow)

---

## ⚠️ Common Issues

### Issue: "Pub Commands" tab not found
**Solution:**
- Look for "Terminal" tab instead
- Or look for a command input at the bottom
- Some FlutLab versions have it in different places

### Issue: Command doesn't work
**Solution:**
- Make sure you're in the project root
- Try: `cd /` then `flutter pub get`
- Or try clicking a "Run" or "Execute" button if available

### Issue: "SDK version" error (Dart SDK 3.7.0 vs ^3.9.2)
**Solution:**
- FlutLab uses Dart SDK 3.7.0
- Change line 22 in `pubspec.yaml` from:
  ```yaml
  sdk: ^3.9.2
  ```
  To:
  ```yaml
  sdk: '>=3.0.0 <4.0.0'
  ```
- Save and run `flutter pub get` again

### Issue: Still getting errors after pub get
**Solution:**
1. Check `pubspec.yaml` has these lines:
   ```yaml
   dependencies:
     dio: ^5.4.0
     flutter_secure_storage: ^9.0.0
     provider: ^6.1.1
   ```
2. Make sure SDK version is `'>=3.0.0 <4.0.0'` (not `^3.9.2`)
3. Make sure you saved `pubspec.yaml` (Ctrl+S)
4. Run `flutter pub get` again
5. Wait longer (sometimes takes 30+ seconds)

### Issue: Can't find pubspec.yaml in FlutLab
**Solution:**
- It should be in the root folder (same level as `lib/`)
- If it doesn't exist, create it:
  - Right-click in file explorer → "New File" → Name: `pubspec.yaml`
  - Copy content from your local file

---

## 📋 Quick Checklist

- [ ] Opened `pubspec.yaml` in FlutLab
- [ ] Copied content from `flutter_app/pubspec.yaml` on your computer
- [ ] Pasted into FlutLab's `pubspec.yaml`
- [ ] Saved the file (Ctrl+S)
- [ ] Opened "Pub Commands" or "Terminal" tab in FlutLab
- [ ] Ran `flutter pub get`
- [ ] Waited for "Got dependencies!" message
- [ ] Waited 10-20 seconds for FlutLab to refresh
- [ ] Checked "Analyzer" tab - errors should be gone

---

## 🎯 What Should Happen

**Before:**
- ❌ Red errors everywhere
- ❌ "Target of URI doesn't exist"
- ❌ "The imported package 'provider' isn't a dependency"

**After:**
- ✅ No red errors
- ✅ All imports work
- ✅ App can run

---

## 💡 Still Not Working?

1. **Double-check pubspec.yaml:**
   - Open it in FlutLab
   - Make sure lines 37-40 show:
     ```yaml
     dio: ^5.4.0
     flutter_secure_storage: ^9.0.0
     provider: ^6.1.1
     ```

2. **Try restarting FlutLab:**
   - Close the browser tab
   - Reopen FlutLab
   - Run `flutter pub get` again

3. **Check FlutLab version:**
   - Make sure you're using a recent version
   - Some old versions have bugs

---

**Once `flutter pub get` completes successfully, all errors should disappear! 🎉**
