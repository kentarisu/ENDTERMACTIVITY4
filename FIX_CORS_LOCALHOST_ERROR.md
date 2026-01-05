# Fix: CORS Error - Still Using localhost:8000

## 🔴 Problem

The error shows:
```
Access to XMLHttpRequest at 'http://localhost:8000/api/auth/login' 
from origin 'https://preview.flutlab.io' has been blocked by CORS policy: 
Permission was denied for this request to access the `unknown` address space.
```

**This means:** FlutLab is still trying to use `http://localhost:8000` instead of the ngrok HTTPS URL.

## 🔍 Why This Happens

1. **FlutLab hasn't synced your local changes** - The file on your computer has the ngrok URL, but FlutLab still has the old `localhost:8000` value
2. **ngrok URL changed** - If you restarted ngrok, it generates a new URL
3. **Browser cache** - The old URL might be cached

## ✅ Solution Steps

### Step 1: Check if ngrok is running

1. Open a terminal/command prompt
2. Check if ngrok is running:
   ```powershell
   Get-Process | Where-Object {$_.ProcessName -like "*ngrok*"}
   ```

### Step 2: Start/Get ngrok URL

**If ngrok is NOT running:**

1. Open terminal in your project folder:
   ```powershell
   cd "c:\Users\Orly\OneDrive\Documents\PROFE8\ENDTERMACTIVITY4"
   ```

2. Start ngrok:
   ```powershell
   .\ngrok.exe http 8000
   ```

3. Copy the HTTPS URL (looks like: `https://xxxxx.ngrok-free.app`)

**If ngrok IS running:**

1. Open your browser and go to: `http://localhost:4040`
2. You'll see the ngrok dashboard
3. Copy the HTTPS Forwarding URL (looks like: `https://xxxxx.ngrok-free.app`)

### Step 3: Update API URL in FlutLab

**IMPORTANT:** You must update the URL **directly in FlutLab**, not just in your local file!

1. **In FlutLab:**
   - Open `lib/services/api_client.dart`
   - Find line 9: `static const String _baseUrl = '...';`
   - Change it to your current ngrok HTTPS URL:
     ```dart
     static const String _baseUrl = 'https://YOUR-NGROK-URL.ngrok-free.app';
     ```
   - **Save the file in FlutLab**

2. **Verify the change:**
   - Make sure line 9 shows the ngrok URL (starts with `https://`)
   - NOT `http://localhost:8000`

### Step 4: Restart FlutLab Preview

1. In FlutLab, stop the preview
2. Start it again
3. This ensures it picks up the new URL

### Step 5: Clear Browser Cache (if needed)

If it still doesn't work:
1. Open browser DevTools (F12)
2. Right-click the refresh button
3. Select "Empty Cache and Hard Reload"

## 🎯 Quick Checklist

- [ ] ngrok is running (check `http://localhost:4040`)
- [ ] Copied the current ngrok HTTPS URL
- [ ] Updated `_baseUrl` in FlutLab's `api_client.dart` (line 9)
- [ ] Saved the file in FlutLab
- [ ] Restarted FlutLab preview
- [ ] Verified the error is gone

## 📝 Example

**Before (WRONG):**
```dart
static const String _baseUrl = 'http://localhost:8000';
```

**After (CORRECT):**
```dart
static const String _baseUrl = 'https://d1b0ade205c4.ngrok-free.app';
```

## ⚠️ Important Notes

1. **ngrok URLs change** - If you restart ngrok, you get a new URL and must update FlutLab again
2. **Must update in FlutLab** - Local file changes don't automatically sync to FlutLab
3. **Always use HTTPS** - FlutLab web preview requires HTTPS URLs (that's why we use ngrok)

## 🔧 Alternative: Use ngrok with fixed domain (optional)

If you have a free ngrok account, you can set a fixed domain:
```powershell
.\ngrok.exe http 8000 --domain=your-fixed-domain.ngrok-free.app
```

This way the URL won't change when you restart ngrok.

---

**After following these steps, the CORS error should be resolved!** ✅
