# Simple Setup Instructions
## EndTerm Activity 4 - Flutter + MySQL Project

**Project Name:** `endterm_activity4`  
**Tools:** HeidiSQL, FlutLab.io, Firebase Console

---

## 📋 What You Need

- ✅ **HeidiSQL** (for database)
- ✅ **FlutLab.io** account (for Flutter app)
- ✅ **Firebase Console** account
- ✅ **XAMPP** or **WAMP** (for PHP backend) OR **PHP** installed

---

## ⚠️ QUICK FIX: Getting 404 Error?

**If you see "404 Not Found" when testing the backend, use this EASIEST method:**

1. Open **Command Prompt**
2. Navigate to your backend public folder:
   ```bash
   cd "C:\Users\Orly\OneDrive\Documents\PROFE8\ENDTERMACTIVITY4\backend\public"
   ```
3. Run: `php -S localhost:8000`
4. Keep the window open
5. Test: `http://localhost:8000/api/entries`
6. ✅ Should work!

**Why?** XAMPP/WAMP only serve files from their own folders. PHP Built-in Server works from anywhere!

---

## Part 1: Database Setup (HeidiSQL)

### Step 1: Open HeidiSQL and Connect

1. Open **HeidiSQL**
2. Click **"New"** button (green + icon)
3. Enter your MySQL details:
   - **Hostname:** `127.0.0.1`
   - **User:** `root`
   - **Password:** (your MySQL password, or leave blank)
   - **Port:** `3306`
4. Click **"Open"** to connect

### Step 2: Create Database

1. In the left panel, right-click on any database
2. Select **"Create new → Database"**
3. Enter name: **`endterm_activity4`**
4. Select collation: **`utf8mb4_unicode_ci`**
5. Click **"OK"**
6. ✅ You should see `endterm_activity4` in the database list

### Step 3: Import Schema (Create Tables)

1. **IMPORTANT:** Click on `endterm_activity4` in the left panel to select it (it should be highlighted)
2. Go to **File → Load SQL file**
3. Navigate to: `ENDTERMACTIVITY4/database/schema.sql`
4. Click **"Open"**
5. Click the **"Execute SQL"** button (or press **F9**)
6. ✅ You should see "Query OK" messages
7. Check the left panel - expand `endterm_activity4` - you should see 4 tables:
   - `users`
   - `auth_tokens`
   - `entries`
   - `likes`

### Step 4: (Optional) Add Sample Data

1. Make sure `endterm_activity4` is selected
2. Go to **File → Load SQL file**
3. Navigate to: `ENDTERMACTIVITY4/database/seed.sql`
4. Click **"Open"**
5. Click **"Execute SQL"** (F9)
6. ✅ Sample data added!

**✅ Database is ready!**

---

## Part 2: Backend Setup (PHP)

### Step 1: Update Database Config

1. Open file: `ENDTERMACTIVITY4/backend/config.php`
2. Make sure it looks like this:
   ```php
   'db' => [
       'host' => '127.0.0.1',
       'port' => '3306',
       'name' => 'endterm_activity4',  // ← Your database name
       'user' => 'root',
       'pass' => '',  // ← Your MySQL password (if any)
   ],
   ```
3. Save the file

### Step 2: Choose Your Web Server Method

**⭐ RECOMMENDED: Option C (PHP Built-in Server) - Easiest!**

This method works from your current folder location - no need to move files!

**Option C: PHP Built-in Server (EASIEST - Use This!)**

1. Open **Command Prompt** (Press `Win + R`, type `cmd`, press Enter)
2. Navigate to your project's public folder:
   ```bash
   cd "C:\Users\Orly\OneDrive\Documents\PROFE8\ENDTERMACTIVITY4\backend\public"
   ```
   *(Replace with your actual path if different)*
3. Start the server:
   ```bash
   php -S 0.0.0.0:8000
   ```
   **IMPORTANT:** Use `0.0.0.0` instead of `localhost` so FlutLab can access it!
4. ✅ You should see: "Development Server started at http://localhost:8000"
5. **Keep this window open!** (Don't close it)
6. Test in browser: `http://localhost:8000/api/entries`
7. ✅ Should see: `{"entries":[]}`

**Option A: Using XAMPP (Requires Moving Files)**

1. **Copy your project folder:**
   - Copy `ENDTERMACTIVITY4` folder to: `C:\xampp\htdocs\`
   - Final path: `C:\xampp\htdocs\ENDTERMACTIVITY4\backend\public\`

2. Open **XAMPP Control Panel**
3. Start **Apache** (click "Start")
4. Start **MySQL** (click "Start")
5. Both should turn green ✅
6. Test: `http://localhost/ENDTERMACTIVITY4/backend/public/api/entries`

**Option B: Using WAMP (Requires Moving Files)**

1. **Copy your project folder:**
   - Copy `ENDTERMACTIVITY4` folder to: `C:\wamp64\www\`
   - Final path: `C:\wamp64\www\ENDTERMACTIVITY4\backend\public\`

2. Open **WAMP Server**
3. Wait for icon to turn green
4. Click icon → **"Start All Services"**
5. Test: `http://localhost/ENDTERMACTIVITY4/backend/public/api/entries`

### Step 3: Test Backend

**If using PHP Built-in Server (Option C):**
- Go to: `http://localhost:8000/api/entries`
- ✅ Should see: `{"entries":[]}`

**If using XAMPP/WAMP (Options A or B):**
- Go to: `http://localhost/ENDTERMACTIVITY4/backend/public/api/entries`
- ✅ Should see: `{"entries":[]}`

**✅ Backend is ready!**

---

## Part 3: Flutter App Setup (FlutLab.io)

### Step 1: Open FlutLab.io

1. Go to: https://flutlab.io
2. Sign in or create account
3. Your project should be named: **`endterm_activity4`**

### Step 2: Upload Project Files

1. In FlutLab, click **"Upload"** or **"Import"**
2. Upload your `flutter_app` folder OR
3. If project already exists, make sure all files are there:
   - `lib/main.dart`
   - `lib/models/` folder
   - `lib/services/` folder
   - `lib/providers/` folder
   - `lib/screens/` folder
   - `pubspec.yaml`

### Step 3: Install Dependencies

1. In FlutLab, open the **"Pub Commands"** tab (bottom panel)
2. Run: `flutter pub get`
3. ✅ Wait for dependencies to install

### Step 4: Update API URL

1. Open file: `lib/services/api_client.dart`
2. Find this line (around line 9):
   ```dart
   static const String _baseUrl = 'http://localhost/ENDTERMACTIVITY4/backend/public';
   ```
3. **IMPORTANT:** Change it based on how you'll test:
   
   **For FlutLab Web Preview:**
   ```dart
   static const String _baseUrl = 'http://localhost/ENDTERMACTIVITY4/backend/public';
   ```
   
   **For Android Emulator (if using):**
   ```dart
   static const String _baseUrl = 'http://10.0.2.2/ENDTERMACTIVITY4/backend/public';
   ```
   
   **For Physical Device:**
   - Find your computer's IP: Open Command Prompt, type `ipconfig`, look for IPv4 Address
   - Example: `http://192.168.1.100/ENDTERMACTIVITY4/backend/public`
   
   **For PHP Built-in Server (port 8000) - RECOMMENDED:**
   ```dart
   static const String _baseUrl = 'http://localhost:8000';
   ```
   *(This is the easiest method - use this if you get 404 errors!)*

4. Save the file

### Step 5: Run the App

1. In FlutLab, click the **"Run"** button (▶) at the top
2. Select device: **Web**, **Android Emulator**, or **Physical Device**
3. ✅ App should launch!

**✅ Flutter app is ready!**

---

## Part 4: Firebase Console Setup (Optional)

### Step 1: Open Firebase Console

1. Go to: https://console.firebase.google.com
2. Sign in with Google account
3. Your project: **ENDTERMACTIVITY4** should be visible

### Step 2: Add Flutter App to Firebase

1. In Firebase Console, click **"+ Add app"**
2. Choose **Android** or **iOS** icon
3. **Package name:** Find in `flutter_app/android/app/build.gradle`
   - Look for `applicationId` (usually `com.example.flutter_app`)
4. Click **"Register app"**
5. Download **`google-services.json`** (for Android)
6. Upload it to: `flutter_app/android/app/google-services.json`

**Note:** Firebase is optional. Your app works without it!

**✅ Firebase setup complete (if needed)!**

---

## Part 5: Test Everything

### Test 1: Database ✅
1. Open HeidiSQL
2. Select `endterm_activity4` database
3. Right-click `users` table → **"Select top 1000 rows"**
4. ✅ Should see data (if you ran seed.sql)

### Test 2: Backend ✅
1. Open browser
2. **If using PHP Built-in Server:**
   - Go to: `http://localhost:8000/api/entries`
3. **If using XAMPP/WAMP:**
   - Go to: `http://localhost/ENDTERMACTIVITY4/backend/public/api/entries`
4. ✅ Should see: `{"entries":[]}` (JSON response)

### Test 3: Flutter App ✅
1. Run app in FlutLab
2. Try to **Register** a new user:
   - Display Name: `Test User`
   - Email: `test@example.com`
   - Password: `password123`
3. ✅ Should register and go to home screen
4. Try to **Create Entry**:
   - Tap **"+"** button
   - Fill in title, year, status, rating
   - Tap **"Create Entry"**
5. ✅ Entry should appear in list!

---

## 🐛 Common Problems & Fixes

### Problem: "Table doesn't exist" in HeidiSQL
**Fix:**
- Make sure you **selected** `endterm_activity4` database BEFORE running schema.sql
- Click on `endterm_activity4` in left panel (it should be highlighted)
- Then run schema.sql again

### Problem: "Connection refused" in Flutter app
**Fix:**
- Check backend URL in `api_client.dart` is correct
- Make sure Apache/MySQL are running (green in XAMPP/WAMP)
- For Android emulator, use `10.0.2.2` instead of `localhost`

### Problem: "404 Not Found" when testing backend
**This is the most common issue! Here are the fixes:**

**Fix 1: Use PHP Built-in Server (EASIEST)**
- Your files are in: `C:\Users\Orly\OneDrive\Documents\PROFE8\ENDTERMACTIVITY4\`
- XAMPP/WAMP can't access files outside their folders
- **Solution:** Use PHP Built-in Server (Option C above)
  1. Open Command Prompt
  2. Run: `cd "C:\Users\Orly\OneDrive\Documents\PROFE8\ENDTERMACTIVITY4\backend\public"`
  3. Run: `php -S localhost:8000`
  4. Test: `http://localhost:8000/api/entries`

**Fix 2: Move Files to XAMPP/WAMP Folder**
- Copy `ENDTERMACTIVITY4` folder to `C:\xampp\htdocs\` (for XAMPP)
- OR copy to `C:\wamp64\www\` (for WAMP)
- Then test: `http://localhost/ENDTERMACTIVITY4/backend/public/api/entries`

**Fix 3: Check File Exists**
- Make sure `backend/public/index.php` exists
- Verify the file path is correct

**Fix 4: Check Apache is Running**
- In XAMPP: Apache should be green
- In WAMP: Icon should be green
- Try restarting Apache

### Problem: Can't connect to database
**Fix:**
- Check MySQL is running (green in XAMPP/WAMP)
- Verify username/password in `config.php`
- Check database name is `endterm_activity4` (not `flicklog`)

### Problem: Flutter app shows "Unauthorized"
**Fix:**
- Try logging in again
- Token might have expired
- Check secure storage permissions

---

## 📝 Quick Checklist

Before testing, make sure:

- [ ] Database `endterm_activity4` exists in HeidiSQL
- [ ] All 4 tables created (users, auth_tokens, entries, likes)
- [ ] `config.php` has correct database name: `endterm_activity4`
- [ ] Apache and MySQL are running (green)
- [ ] Backend URL works: 
  - PHP Built-in: `http://localhost:8000/api/entries` OR
  - XAMPP/WAMP: `http://localhost/ENDTERMACTIVITY4/backend/public/api/entries`
- [ ] Flutter app has correct API URL in `api_client.dart`
- [ ] Dependencies installed: `flutter pub get` completed

---

## 🎯 Quick Reference

### Important File Locations:
- **Database Config:** `backend/config.php`
- **API Router:** `backend/public/index.php`
- **Flutter API Client:** `flutter_app/lib/services/api_client.dart`
- **Database Schema:** `database/schema.sql`

### Important URLs:
- **Backend API (PHP Built-in):** `http://localhost:8000/api/`
- **Backend API (XAMPP/WAMP):** `http://localhost/ENDTERMACTIVITY4/backend/public/api/`
- **Test Entries (PHP Built-in):** `http://localhost:8000/api/entries`
- **Test Entries (XAMPP/WAMP):** `http://localhost/ENDTERMACTIVITY4/backend/public/api/entries`
- **FlutLab:** https://flutlab.io
- **Firebase:** https://console.firebase.google.com

### Database Name:
- **Always use:** `endterm_activity4` (not `flicklog`)

---

## ✅ You're Done!

If all tests pass, your app is ready to use! 🎉

**Need Help?**
- Check the troubleshooting section above
- Make sure all services are running
- Verify file paths are correct
- Check database name is `endterm_activity4` everywhere

**Good luck! 🚀**
