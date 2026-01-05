# Fix "Could not connect to server" Error

## ✅ Database Status: RUNNING
Your database is running fine! The issue is the Flutter app can't reach the backend server.

---

## 🔍 The Problem

**Error:** "Could not connect to server. Please check if the backend is running."

**Why:**
1. ✅ Database is running (MySQL)
2. ✅ Backend was running (you saw `[200]: GET /api/entries` in terminal)
3. ❌ Flutter app can't connect (wrong URL or server stopped)

---

## ✅ Quick Fix

### Step 1: Make Sure PHP Server is Running

1. **Check your Command Prompt/Terminal window**
   - You should see: `Development Server started at http://localhost:8000`
   - If the window is closed or server stopped, restart it:
     ```bash
     cd "C:\Users\Orly\OneDrive\Documents\PROFE8\ENDTERMACTIVITY4\backend\public"
     php -S 0.0.0.0:8000
     ```
     **IMPORTANT:** Use `0.0.0.0` instead of `localhost` so FlutLab can access it!
   - **Keep this window open!** (Don't close it)

### Step 2: Update API URL in FlutLab

**For FlutLab Web Preview (Most Common Issue):**

1. **Find your computer's IP address:**
   - Open Command Prompt
   - Type: `ipconfig`
   - Look for **IPv4 Address** (e.g., `192.168.1.100`)

2. **In FlutLab, open `lib/services/api_client.dart`**

3. **Find line 9** and change it to use your IP:
   ```dart
   static const String _baseUrl = 'http://192.168.1.100:8000';
   ```
   *(Replace `192.168.1.100` with YOUR actual IP address)*

4. **Save the file** (Ctrl+S)

**Why?** FlutLab web preview runs in a browser, and `localhost` in the browser refers to FlutLab's server, not your computer. You need to use your computer's actual IP address.

---

## 🎯 Different Scenarios

### Scenario 1: FlutLab Web Preview
**Use:** `http://YOUR_COMPUTER_IP:8000`
- Example: `http://192.168.1.100:8000`
- Find IP: `ipconfig` in Command Prompt

### Scenario 2: Android Emulator
**Use:** `http://10.0.2.2:8000`
- This is a special address that Android emulator uses to reach your computer

### Scenario 3: iOS Simulator
**Use:** `http://localhost:8000`
- iOS simulator can use localhost directly

### Scenario 4: Physical Device
**Use:** `http://YOUR_COMPUTER_IP:8000`
- Same as FlutLab web preview
- Make sure phone and computer are on same WiFi network

---

## ✅ Test Connection

1. **Make sure PHP server is running** (Command Prompt shows it's active)

2. **Test in browser:**
   - Go to: `http://localhost:8000/api/entries`
   - Should see: `{"entries":[...]}` (JSON data)

3. **If browser works but FlutLab doesn't:**
   - Use your computer's IP instead of `localhost`
   - Example: `http://192.168.1.100:8000/api/entries`

---

## 📋 Checklist

- [ ] PHP server is running (`php -S localhost:8000` in terminal)
- [ ] Terminal shows "Development Server started"
- [ ] Browser can access `http://localhost:8000/api/entries`
- [ ] Found your computer's IP address (`ipconfig`)
- [ ] Updated `api_client.dart` with correct URL
- [ ] Saved the file in FlutLab
- [ ] Restarted FlutLab app (if needed)

---

## 🔧 Still Not Working?

### Problem: "Connection refused"
**Solution:**
- PHP server is not running OR bound to localhost only
- Restart with: `php -S 0.0.0.0:8000` in `backend/public` folder
- Use `0.0.0.0` instead of `localhost` to make it network-accessible

### Problem: "Could not connect" in FlutLab
**Solution:**
- FlutLab web preview can't use `localhost`
- Use your computer's IP address instead
- Make sure PHP server is running

### Problem: "CORS error"
**Solution:**
- CORS headers are already set in `backend/public/index.php`
- If still having issues, check the file has CORS headers

### Problem: Firewall blocking
**Solution:**
- Windows Firewall might be blocking port 8000
- Allow PHP through firewall, or use a different port

---

## 💡 Quick Test

**Test 1: Is backend running?**
- Open browser: `http://localhost:8000/api/entries`
- ✅ Should see JSON data
- ❌ If not, restart PHP server

**Test 2: Can FlutLab reach it?**
- Use your computer's IP: `http://YOUR_IP:8000/api/entries`
- ✅ Should work
- ❌ If not, check firewall or network

---

**Once you update the API URL to use your computer's IP address, the connection should work! 🎉**
