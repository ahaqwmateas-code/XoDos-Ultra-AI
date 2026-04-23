import 'dart:io';
import 'dart:convert';
import 'package:gamepads/gamepads.dart'; // Ensure this is in your pubspec.yaml

// --- NEW ENUMS ADDED ---
enum ControllerType { virtual, bluetooth, usb }

// --- UPDATED WORKSTATION PROFILE ---
// Merged your new logic with the existing connection logic
class WorkstationProfile {
  final String id;
  final String name;
  final String host;
  final int port;
  final String? username;
  final String? password;
  final String protocol;
  final int qualityLevel; // From your new file
  final ControllerType controllerType; // From your new file
  final String? bluetoothDeviceId; // From your new file
  final Map<String, int> buttonMapping; // From your new file
  final List<XodosFile> savedFiles; // From your new file
  final Map<String, String> customEnv; // From your new file
  final DateTime createdAt;
  final bool isActive;

  const WorkstationProfile({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.protocol,
    this.username,
    this.password,
    this.qualityLevel = 1,
    this.controllerType = ControllerType.virtual,
    this.bluetoothDeviceId,
    this.buttonMapping = const {},
    this.savedFiles = const [],
    this.customEnv = const {},
    required this.createdAt,
    this.isActive = false,
  });

  // --- UPDATED TOJSON ---
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'host': host,
    'port': port,
    'protocol': protocol,
    'quality': qualityLevel,
    'controller': controllerType.index,
    'deviceId': bluetoothDeviceId,
    'mapping': buttonMapping,
    'env': customEnv,
    'createdAt': createdAt.toIso8601String(),
  };

  // --- UPDATED FROMJSON ---
  factory WorkstationProfile.fromJson(Map<String, dynamic> json) => WorkstationProfile(
    id: json['id'] ?? '',
    name: json['name'] ?? 'Unknown',
    host: json['host'] ?? '',
    port: json['port'] ?? 0,
    protocol: json['protocol'] ?? 'VNC',
    qualityLevel: json['quality'] ?? 1,
    controllerType: ControllerType.values[json['controller'] ?? 0],
    bluetoothDeviceId: json['deviceId'],
    buttonMapping: Map<String, int>.from(json['mapping'] ?? {}),
    customEnv: Map<String, String>.from(json['env'] ?? {}),
    createdAt: DateTime.parse(json['createdAt']),
  );
}

// --- NEW CLOUD STORAGE CLASSES (Added below Profile) ---

class XodosStorageProvider {
  final String providerId;     
  final String? oauthToken;
  final int freeQuotaGB;
  final int usedGB;
  final bool isConnected;

  XodosStorageProvider({
    required this.providerId,
    this.oauthToken,
    this.freeQuotaGB = 15,
    this.usedGB = 0,
    this.isConnected = false,
  });
}

class XodosFile {
  final String id;
  final String name;
  final int totalSize;
  final List<XodosFileChunk> chunks;
  final String masterKey;
  final DateTime createdAt;

  XodosFile({
    required this.id,
    required this.name,
    required this.totalSize,
    required this.chunks,
    required this.masterKey,
    required this.createdAt,
  });
}

class XodosFileChunk {
  final String chunkId;
  final String fileId;
  final String providerId;
  final String remotePath;
  final int size;
  final String checksum;
  final String encryptionKey;

  XodosFileChunk({
    required this.chunkId,
    required this.fileId,
    required this.providerId,
    required this.remotePath,
    required this.size,
    required this.checksum,
    required this.encryptionKey,
  });
}

// --- XODOS PROFILE CLASS (For Gaming/Workstation Profiles) ---
class XodosProfile {
  final String id;
  final String name;
  final int quality;
  final String? deviceId;
  final DateTime createdAt;

  XodosProfile({
    required this.id,
    required this.name,
    required this.quality,
    this.deviceId,
    required this.createdAt,
  });

  // Factory constructor to create a new profile
  factory XodosProfile.createNew({
    required String name,
    required int quality,
    String? deviceId,
  }) {
    return XodosProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      quality: quality,
      deviceId: deviceId,
      createdAt: DateTime.now(),
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quality': quality,
    'deviceId': deviceId,
    'createdAt': createdAt.toIso8601String(),
  };

  // Create from JSON
  factory XodosProfile.fromJson(Map<String, dynamic> json) => XodosProfile(
    id: json['id'] ?? '',
    name: json['name'] ?? 'Unknown Profile',
    quality: json['quality'] ?? 1,
    deviceId: json['deviceId'],
    createdAt: json['createdAt'] != null 
      ? DateTime.parse(json['createdAt'])
      : DateTime.now(),
  );
}

// --- MASTER DATA LISTS ---
List<XodosProfile> userAdditions = [];

List<XodosStorageProvider> connectedClouds = [
  XodosStorageProvider(providerId: 'google', freeQuotaGB: 15),
  XodosStorageProvider(providerId: 'onedrive', freeQuotaGB: 5),
  XodosStorageProvider(providerId: 'dropbox', freeQuotaGB: 2),
  XodosStorageProvider(providerId: 'cloudgate', freeQuotaGB: 1000), 
];
