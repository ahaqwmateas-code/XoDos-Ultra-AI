// auto_update_system.dart
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'core_classes.dart';

class AutoUpdateSystem {
  static const String _lastUpdateCheckKey = 'last_update_check';
  static const String _currentVersionKey = 'current_version';
  static const String _updateCheckUrlKey = 'update_check_url';
  static const String _updateIntervalDays = 365; // Check for updates every year
  
  static final AutoUpdateSystem _instance = AutoUpdateSystem._internal();
  
  factory AutoUpdateSystem() {
    return _instance;
  }
  
  AutoUpdateSystem._internal();
  
  /// Initialize the auto-update system
  Future<void> initialize() async {
    print("🚀 XoDos Ultra AI: Auto-Update System Initialized");
    _scheduleAnnualUpdateCheck();
  }
  
  /// Schedule the annual update check
  void _scheduleAnnualUpdateCheck() {
    // Check every 24 hours if an update is available
    Timer.periodic(const Duration(hours: 24), (timer) async {
      await checkForUpdates();
    });
    
    // Also check on startup
    checkForUpdates();
  }
  
  /// Check if an update is available
  Future<bool> checkForUpdates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastCheck = prefs.getInt(_lastUpdateCheckKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      
      // Only check if the last check was more than 24 hours ago
      if (now - lastCheck < Duration(hours: 24).inMilliseconds) {
        return false;
      }
      
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      
      print("📦 XoDos Ultra AI: Checking for updates...");
      print("   Current Version: $currentVersion");
      
      // Simulate checking GitHub API for latest release
      final latestVersion = await _fetchLatestVersion();
      
      if (latestVersion != null && _isNewerVersion(latestVersion, currentVersion)) {
        print("✅ XoDos Ultra AI: Update available! Version $latestVersion");
        await prefs.setInt(_lastUpdateCheckKey, now);
        await _notifyUpdateAvailable(latestVersion);
        return true;
      } else {
        print("✓ XoDos Ultra AI: Already on the latest version");
        await prefs.setInt(_lastUpdateCheckKey, now);
        return false;
      }
    } catch (e) {
      print("❌ XoDos Ultra AI: Error checking for updates: $e");
      return false;
    }
  }
  
  /// Fetch the latest version from GitHub
  Future<String?> _fetchLatestVersion() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/ahaqwmateas-code/XoDos-Ultra-AI/releases/latest'),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tagName = data['tag_name'] as String?;
        return tagName?.replaceAll('v', '');
      }
    } catch (e) {
      print("⚠️ XoDos Ultra AI: Failed to fetch latest version: $e");
    }
    return null;
  }
  
  /// Compare versions to determine if an update is needed
  bool _isNewerVersion(String latestVersion, String currentVersion) {
    try {
      final latest = latestVersion.split('.').map(int.parse).toList();
      final current = currentVersion.split('.').map(int.parse).toList();
      
      for (int i = 0; i < latest.length && i < current.length; i++) {
        if (latest[i] > current[i]) return true;
        if (latest[i] < current[i]) return false;
      }
      return latest.length > current.length;
    } catch (e) {
      print("⚠️ XoDos Ultra AI: Error comparing versions: $e");
      return false;
    }
  }
  
  /// Notify the user that an update is available
  Future<void> _notifyUpdateAvailable(String version) async {
    print("📢 XoDos Ultra AI: Update Notification - Version $version is available!");
    // In a real app, this would show a notification or dialog
    // For now, we just log it
  }
  
  /// Download and install the update
  Future<bool> downloadAndInstallUpdate(String downloadUrl) async {
    try {
      print("⬇️ XoDos Ultra AI: Downloading update from $downloadUrl...");
      
      final response = await http.get(Uri.parse(downloadUrl))
          .timeout(const Duration(minutes: 5));
      
      if (response.statusCode == 200) {
        final appDir = Directory('${G.dataPath}/updates');
        if (!await appDir.exists()) {
          await appDir.create(recursive: true);
        }
        
        final file = File('${appDir.path}/xodos_update.apk');
        await file.writeAsBytes(response.bodyBytes);
        
        print("✅ XoDos Ultra AI: Update downloaded successfully!");
        print("   Location: ${file.path}");
        
        // Trigger installation (would require platform-specific code)
        await _installUpdate(file.path);
        return true;
      }
    } catch (e) {
      print("❌ XoDos Ultra AI: Error downloading update: $e");
    }
    return false;
  }
  
  /// Install the downloaded update
  Future<void> _installUpdate(String apkPath) async {
    try {
      // On Android, this would typically use Intent to open the APK
      // For now, we just log the action
      print("🔧 XoDos Ultra AI: Installing update from $apkPath...");
      
      // In a real implementation, you would use platform channels to:
      // 1. Request installation permission
      // 2. Trigger the APK installation
      // 3. Handle the installation result
    } catch (e) {
      print("❌ XoDos Ultra AI: Error installing update: $e");
    }
  }
  
  /// Get the next scheduled update check time
  Future<DateTime?> getNextUpdateCheckTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastCheck = prefs.getInt(_lastUpdateCheckKey);
      
      if (lastCheck == null) return null;
      
      final lastCheckDate = DateTime.fromMillisecondsSinceEpoch(lastCheck);
      return lastCheckDate.add(const Duration(days: _updateIntervalDays));
    } catch (e) {
      print("⚠️ XoDos Ultra AI: Error getting next update check time: $e");
      return null;
    }
  }
}
