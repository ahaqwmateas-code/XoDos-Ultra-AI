import 'package:flutter/material.dart';
import 'models.dart';
import 'add_profile_screen.dart';

class XodosDashboard extends StatefulWidget {
  @override
  State<XodosDashboard> createState() => _XodosDashboardState();
}

class _XodosDashboardState extends State<XodosDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("XoDos Workstation Profiles"),
        elevation: 0,
        centerTitle: true,
      ),
      body: userAdditions.isEmpty 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open,
                  size: 64,
                  color: Colors.grey.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  "No profiles yet.\nTap the + button to create one!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: userAdditions.length,
            itemBuilder: (context, index) {
              final profile = userAdditions[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      "${profile.quality}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    profile.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    profile.deviceId != null 
                        ? "Linked: ${profile.deviceId}" 
                        : "Virtual Controls",
                  ),
                  trailing: const Icon(Icons.play_circle_fill, color: Colors.green, size: 32),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Launching XoDos Profile: ${profile.name}")),
                    );
                  },
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          // Navigate to Add Profile Screen and refresh on return
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddProfileScreen()),
          );
          if (result != null) {
            setState(() {});
          }
        },
      ),
    );
  }
}
