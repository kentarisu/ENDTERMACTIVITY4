# Fix: Mixed Content & CORS "Unknown Address Space" Error

## 🔍 The Problem (From Browser Console)

**Error 1: Mixed Content**
```
Mixed Content: The page at 'https://preview.flutlab.io' was loaded over HTTPS, 
but requested an insecure XMLHttpRequest endpoint 'http://192.168.1.38:8000'.
```

**Error 2: CORS Unknown Address Space**
```
Access to XMLHttpRequest at 'http://192.168.1.38:8000/api/auth/register' 
from origin 'https://preview.flutlab.io' has been blocked by CORS policy: 
Permission was denied for this request to access the `unknown` address space.
```

**Why?**
- FlutLab web preview runs on **HTTPS** (`https://preview.flutlab.io`)
- Your backend is **HTTP** (`http://192.168.1.38:8000`)
- Browsers **block HTTP requests from HTTPS pages** (security)
- Browsers **block private IPs from public HTTPS origins**

---

## ✅ Solution: Use ngrok (HTTPS Tunnel)

ngrok creates a **public HTTPS URL** that tunnels to your local server.

### Step 1: Download ngrok

1. Go to: https://ngrok.com/download
2. Download for **Windows**
3. Extract the ZIP file
4. You'll get `ngrok.exe`

### Step 2: Start Your PHP Server

1. Open **Command Prompt**
2. Navigate to your backend:
   ```bash
   cd "C:\Users\Orly\OneDrive\Documents\PROFE8\ENDTERMACTIVITY4\backend\public"
   ```
3. Start PHP server:
   ```bash
   php -S 0.0.0.0:8000
   ```
4. **Keep this window open!**

### Step 3: Start ngrok

1. Open a **NEW Command Prompt** window
2. Navigate to where you extracted ngrok (or add to PATH)
3. Run:
   ```bash
   ngrok http 8000
   ```
4. You'll see something like:
   ```
   Forwarding   https://abc123.ngrok-free.app -> http://localhost:8000
   ```
5. **Copy the HTTPS URL** (e.g., `https://abc123.ngrok-free.app`)
6. **Keep this window open!**

### Step 4: Update FlutLab

1. In FlutLab, open `lib/services/api_client.dart`
2. Find line 9:
   ```dart
   static const String _baseUrl = 'http://192.168.1.38:8000';
   ```
3. Change it to your ngrok URL:
   ```dart
   static const String _baseUrl = 'https://abc123.ngrok-free.app';
   ```
   *(Replace with YOUR actual ngrok URL)*
4. **Save the file**
5. **Restart the app** in FlutLab

### Step 5: Test

1. Try to register/login
2. ✅ Should work now!

---

## ⚠️ Important Notes

### ngrok Free Version:
- **URL changes** each time you restart ngrok
- You'll need to update `api_client.dart` each time
- For testing, this is fine!

### ngrok Paid Version:
- **Fixed URL** that doesn't change
- Better for development

### Keep Both Windows Open:
- **Window 1:** PHP server (`php -S 0.0.0.0:8000`)
- **Window 2:** ngrok (`ngrok http 8000`)
- If you close either, it stops working!

---

## 🔄 Alternative: Use Android Emulator

If you don't want to use ngrok, use FlutLab's Android emulator:

1. **In FlutLab, click "Run"**
2. **Select "Android Emulator"** (not Web)
3. **Update `api_client.dart`:**
   ```dart
   static const String _baseUrl = 'http://10.0.2.2:8000';
   ```
   *(Android emulator uses `10.0.2.2` to reach your computer's localhost)*
4. **Save and test**

**Why this works:**
- Android emulator doesn't have mixed content restrictions
- `10.0.2.2` is a special address that maps to your computer's localhost

---

## 📋 Quick Checklist

- [ ] Downloaded ngrok
- [ ] PHP server running (`php -S 0.0.0.0:8000`)
- [ ] ngrok running (`ngrok http 8000`)
- [ ] Copied ngrok HTTPS URL
- [ ] Updated `api_client.dart` with ngrok URL
- [ ] Saved file in FlutLab
- [ ] Restarted app in FlutLab
- [ ] Tested registration/login

---

## 🎯 Summary

**The Problem:**
- HTTPS page (FlutLab) can't access HTTP backend (your server)
- Browser security blocks it

**The Solution:**
- Use ngrok to create HTTPS tunnel → `https://your-url.ngrok-free.app`
- OR use Android emulator with `http://10.0.2.2:8000`

**ngrok is the easiest fix for web preview!** 🚀
