import 'package:flutter/material.dart';
import 'models.dart';
import 'data_guard.dart';

/// Profile Manager - Handles profile persistence and lifecycle
class ProfileManager {
  static final ProfileManager _instance = ProfileManager._internal();
  
  factory ProfileManager() {
    return _instance;
  }
  
  ProfileManager._internal();

  /// Initialize profiles from storage
  Future<void> initialize() async {
    await DataGuard.loadProfiles();
    print("ProfileManager: Loaded ${userAdditions.length} profiles");
  }

  /// Save profiles to persistent storage
  Future<void> saveProfiles() async {
    await DataGuard.saveProfiles();
  }

  /// Add a new profile
  Future<void> addProfile(XodosProfile profile) async {
    userAdditions.add(profile);
    await saveProfiles();
  }

  /// Remove a profile by ID
  Future<void> removeProfile(String profileId) async {
    userAdditions.removeWhere((p) => p.id == profileId);
    await saveProfiles();
  }

  /// Update a profile
  Future<void> updateProfile(String profileId, XodosProfile updatedProfile) async {
    final index = userAdditions.indexWhere((p) => p.id == profileId);
    if (index != -1) {
      userAdditions[index] = updatedProfile;
      await saveProfiles();
    }
  }

  /// Get all profiles
  List<XodosProfile> getAllProfiles() => userAdditions;

  /// Get profile by ID
  XodosProfile? getProfileById(String profileId) {
    try {
      return userAdditions.firstWhere((p) => p.id == profileId);
    } catch (e) {
      return null;
    }
  }
}

/// Profile Provider Widget - Provides profile state to the app
class ProfileProvider extends ChangeNotifier {
  final ProfileManager _manager = ProfileManager();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  List<XodosProfile> get profiles => _manager.getAllProfiles();

  /// Initialize the profile system
  Future<void> initialize() async {
    if (_isInitialized) return;
    await _manager.initialize();
    _isInitialized = true;
    notifyListeners();
  }

  /// Add a new profile
  Future<void> addProfile(XodosProfile profile) async {
    await _manager.addProfile(profile);
    notifyListeners();
  }

  /// Remove a profile
  Future<void> removeProfile(String profileId) async {
    await _manager.removeProfile(profileId);
    notifyListeners();
  }

  /// Update a profile
  Future<void> updateProfile(String profileId, XodosProfile updatedProfile) async {
    await _manager.updateProfile(profileId, updatedProfile);
    notifyListeners();
  }
}
