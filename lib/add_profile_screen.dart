import 'package:flutter/material.dart';
import 'models.dart';

class AddProfileScreen extends StatefulWidget {
  @override
  _AddProfileScreenState createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  double _currentQuality = 1;
  String? _selectedDeviceId; // Stores the found Bluetooth ID
  String _statusMessage = "No controller linked";

  // Function to scan for Bluetooth controllers (simulated)
  void _scanController() async {
    try {
      // Simulated controller scan - in production, use platform channels
      // to access native Bluetooth APIs
      setState(() {
        _statusMessage = "Scanning for controllers...";
      });
      
      // Simulate scan delay
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _selectedDeviceId = "device_${DateTime.now().millisecondsSinceEpoch}";
        _statusMessage = "Controller linked successfully!";
      });
    } catch (e) {
      setState(() => _statusMessage = "Scan Error: $e");
    }
  }

  void _saveAddition() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a profile name')),
      );
      return;
    }

    // Save the profile with Name, Quality, and optional Bluetooth ID
    final newProfile = XodosProfile.createNew(
      name: _nameController.text,
      quality: _currentQuality.toInt(),
      deviceId: _selectedDeviceId, 
    );

    setState(() {
      userAdditions.add(newProfile);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile "${newProfile.name}" created successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New XoDos Profile"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Profile Name (e.g. Pro Gaming)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Quality Level: ${_currentQuality.toInt()}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _currentQuality,
              min: 1,
              max: 4,
              divisions: 3,
              onChanged: (val) => setState(() => _currentQuality = val),
            ),
            const Divider(),
            // --- Controller Linking Section ---
            Card(
              color: Colors.blue.withOpacity(0.1),
              child: ListTile(
                title: const Text("Controller Status"),
                subtitle: Text(_statusMessage),
                trailing: ElevatedButton(
                  onPressed: _scanController,
                  child: const Text("Scan"),
                ),
              ),
            ),
            // --------------------------------
            Spacer(),
            ElevatedButton(
              onPressed: _saveAddition,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("Save Profile"),
            )
          ],
        ),
      ),
    );
  }
}
