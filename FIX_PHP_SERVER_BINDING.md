# Fix: PHP Server Not Accessible from FlutLab

## 🔍 The Problem

When you run `php -S localhost:8000`, the server only binds to `localhost` (127.0.0.1), which means:
- ✅ It works from your computer's browser
- ❌ It's NOT accessible from FlutLab web preview (which runs in a different environment)

---

## ✅ Solution: Bind to All Network Interfaces

### Step 1: Stop Current PHP Server

1. Go to your Command Prompt where PHP server is running
2. Press `Ctrl + C` to stop it

### Step 2: Start PHP Server on All Interfaces

Run this command instead:

```bash
cd "C:\Users\Orly\OneDrive\Documents\PROFE8\ENDTERMACTIVITY4\backend\public"
php -S 0.0.0.0:8000
```

**Important:** Use `0.0.0.0:8000` instead of `localhost:8000`

**What `0.0.0.0` means:**
- Binds to ALL network interfaces
- Makes server accessible from your computer's IP address
- Allows FlutLab to connect to it

---

## ✅ Alternative: Bind to Your Specific IP

If `0.0.0.0` doesn't work, use your actual IP:

```bash
php -S 192.168.1.38:8000
```
*(Replace with your actual IP from `ipconfig`)*

---

## ✅ Test It Works

1. **After starting with `0.0.0.0:8000`:**
   - Test in browser: `http://localhost:8000/api/entries` (should work)
   - Test with IP: `http://192.168.1.38:8000/api/entries` (should also work)

2. **If both work, FlutLab should be able to connect!**

---

## 📋 Complete Checklist

- [ ] Stopped old PHP server (Ctrl+C)
- [ ] Started new server with `php -S 0.0.0.0:8000`
- [ ] Tested `http://localhost:8000/api/entries` in browser (works)
- [ ] Tested `http://YOUR_IP:8000/api/entries` in browser (works)
- [ ] Updated FlutLab `api_client.dart` to `http://YOUR_IP:8000`
- [ ] Saved file in FlutLab
- [ ] Restarted FlutLab app

---

## 🔧 Still Not Working?

### Check Windows Firewall

1. Open **Windows Defender Firewall**
2. Click **"Allow an app or feature through Windows Firewall"**
3. Find **PHP** or add it
4. Make sure both **Private** and **Public** are checked
5. Click **OK**

### Or Temporarily Disable Firewall (for testing only)

1. Open **Windows Defender Firewall**
2. Click **"Turn Windows Defender Firewall on or off"**
3. Turn off firewall temporarily (just for testing)
4. Try connecting again
5. **Remember to turn it back on!**

---

## 💡 Why This Happens

- `localhost:8000` = Only accessible from same machine
- `0.0.0.0:8000` = Accessible from network (including FlutLab)
- Your IP `:8000` = Also accessible from network

**The key is using `0.0.0.0` or your IP instead of `localhost`!**

---

**After binding to `0.0.0.0:8000`, FlutLab should be able to connect! 🎉**
