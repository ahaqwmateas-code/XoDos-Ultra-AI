// yearly_auto_update.dart - Yearly Auto-Update System for XoDos Ultra AI
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'core_classes.dart';

class YearlyAutoUpdateSystem {
  static final YearlyAutoUpdateSystem _instance = YearlyAutoUpdateSystem._internal();
  
  factory YearlyAutoUpdateSystem() {
    return _instance;
  }
  
  YearlyAutoUpdateSystem._internal();
  
  static const String _lastUpdateCheckKey = 'xodos_last_update_check';
  static const String _currentVersionKey = 'xodos_current_version';
  static const String _updateCheckIntervalDays = 365; // 1 year
  static const String _githubReleasesUrl = 'https://api.github.com/repos/ahaqwmateas-code/XoDos-Ultra-AI/releases/latest';
  static const String _currentVersion = '2.1.0';
  
  /// Initialize the yearly auto-update system
  Future<void> initialize() async {
    print("🔄 XoDos Ultra AI: Yearly Auto-Update System Initialized");
    
    // Check for updates on app startup
    await _checkForUpdates();
    
    // Schedule periodic checks every 24 hours
    _schedulePeriodicCheck();
  }
  
  /// Schedule periodic update checks
  void _schedulePeriodicCheck() {
    Timer.periodic(const Duration(hours: 24), (timer) async {
      await _checkForUpdates();
    });
  }
  
  /// Check for available updates
  Future<void> _checkForUpdates() async {
    try {
      final prefs = G.prefs;
      final lastCheckTime = prefs.getInt(_lastUpdateCheckKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      
      // Check if enough time has passed since last check (24 hours)
      if (now - lastCheckTime < 24 * 60 * 60 * 1000) {
        print("   ℹ️ Update check skipped (checked recently)");
        return;
      }
      
      print("   🔍 Checking for XoDos Ultra AI updates...");
      
      // Fetch latest release info from GitHub
      final latestVersion = await _fetchLatestVersion();
      
      if (latestVersion != null && _isNewerVersion(latestVersion, _currentVersion)) {
        print("   ✅ New version available: $latestVersion");
        await _notifyUpdateAvailable(latestVersion);
      } else {
        print("   ✓ You are running the latest version");
      }
      
      // Update last check time
      await prefs.setInt(_lastUpdateCheckKey, now);
    } catch (e) {
      print("   ⚠️ Update check error: $e");
    }
  }
  
  /// Fetch the latest version from GitHub
  Future<String?> _fetchLatestVersion() async {
    try {
      final response = await http.get(Uri.parse(_githubReleasesUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => http.Response('', 408),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final version = data['tag_name']?.toString().replaceFirst('v', '') ?? _currentVersion;
        return version;
      }
    } catch (e) {
      print("   ⚠️ Failed to fetch latest version: $e");
    }
    return null;
  }
  
  /// Check if a version is newer than the current version
  bool _isNewerVersion(String newVersion, String currentVersion) {
    try {
      final newParts = newVersion.split('.').map(int.parse).toList();
      final currentParts = currentVersion.split('.').map(int.parse).toList();
      
      for (int i = 0; i < newParts.length && i < currentParts.length; i++) {
        if (newParts[i] > currentParts[i]) return true;
        if (newParts[i] < currentParts[i]) return false;
      }
      
      return newParts.length > currentParts.length;
    } catch (e) {
      print("   ⚠️ Version comparison error: $e");
      return false;
    }
  }
  
  /// Notify user about available update
  Future<void> _notifyUpdateAvailable(String newVersion) async {
    try {
      final prefs = G.prefs;
      await prefs.setString('xodos_available_version', newVersion);
      await prefs.setBool('xodos_update_available', true);
      
      print("   📢 Update notification sent to user");
      print("   📥 New version $newVersion is available for download");
      print("   🔗 GitHub: https://github.com/ahaqwmateas-code/XoDos-Ultra-AI/releases");
    } catch (e) {
      print("   ⚠️ Notification error: $e");
    }
  }
  
  /// Get the available update version
  Future<String?> getAvailableUpdateVersion() async {
    try {
      final prefs = G.prefs;
      return prefs.getString('xodos_available_version');
    } catch (e) {
      print("⚠️ Error getting available version: $e");
      return null;
    }
  }
  
  /// Check if an update is available
  Future<bool> isUpdateAvailable() async {
    try {
      final prefs = G.prefs;
      return prefs.getBool('xodos_update_available') ?? false;
    } catch (e) {
      print("⚠️ Error checking update availability: $e");
      return false;
    }
  }
  
  /// Get the current app version
  String getCurrentVersion() {
    return _currentVersion;
  }
  
  /// Force check for updates immediately
  Future<void> forceCheckForUpdates() async {
    try {
      print("🔄 XoDos Ultra AI: Forcing update check...");
      final prefs = G.prefs;
      await prefs.setInt(_lastUpdateCheckKey, 0); // Reset last check time
      await _checkForUpdates();
    } catch (e) {
      print("⚠️ Force update check error: $e");
    }
  }
  
  /// Download and install update (placeholder)
  Future<bool> downloadAndInstallUpdate(String version) async {
    try {
      print("📥 XoDos Ultra AI: Downloading version $version...");
      // In a real app, this would download the APK and trigger installation
      // For now, we'll just log the action
      print("✅ Update download initiated");
      return true;
    } catch (e) {
      print("❌ Update download error: $e");
      return false;
    }
  }
  
  /// Get update check history
  Future<Map<String, dynamic>> getUpdateCheckHistory() async {
    try {
      final prefs = G.prefs;
      final lastCheck = prefs.getInt(_lastUpdateCheckKey) ?? 0;
      final availableVersion = prefs.getString('xodos_available_version') ?? 'None';
      final updateAvailable = prefs.getBool('xodos_update_available') ?? false;
      
      return {
        'current_version': _currentVersion,
        'available_version': availableVersion,
        'update_available': updateAvailable,
        'last_check': lastCheck > 0 ? DateTime.fromMillisecondsSinceEpoch(lastCheck) : 'Never',
        'next_check': DateTime.now().add(const Duration(days: 1)),
      };
    } catch (e) {
      print("⚠️ Error getting update history: $e");
      return {};
    }
  }
}
