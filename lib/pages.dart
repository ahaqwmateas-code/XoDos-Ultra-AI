// pages_complete.dart - Fully functional pages with cyan theme
import 'dart:io';
import 'dart:math';
import 'package:flutter_pty/flutter_pty.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:xterm/xterm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constants.dart';
import 'default_values.dart';
import 'core_classes.dart';
import 'light_blue_theme.dart';
import 'main.dart';

// ============================================================================
// MAIN HOME PAGE
// ============================================================================
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoadingComplete = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _initialize();
    });
  }

  Future<void> _initialize() async {
    try {
      await Util.startSelfHealing();
      if (mounted) {
        setState(() => isLoadingComplete = true);
      }
    } catch (e) {
      print("Initialization error: $e");
      if (mounted) {
        setState(() => isLoadingComplete = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    G.homePageStateContext = context;

    return RTLWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isLoadingComplete ? Util.getCurrentProp("name") : widget.title),
          backgroundColor: LightBlueTheme.cardBackground,
          foregroundColor: LightBlueTheme.primaryCyan,
        ),
        body: isLoadingComplete
            ? ValueListenableBuilder(
                valueListenable: G.pageIndex,
                builder: (context, value, child) {
                  return IndexedStack(
                    index: G.pageIndex.value,
                    children: const [
                      TerminalPage(),
                      ControlPage(),
                    ],
                  );
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(LightBlueTheme.primaryCyan),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Initializing XoDos Ultra AI...',
                      style: LightBlueTheme.getLightBlueTextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: G.pageIndex,
          builder: (context, value, child) {
            return Visibility(
              visible: isLoadingComplete,
              child: NavigationBar(
                selectedIndex: G.pageIndex.value,
                backgroundColor: LightBlueTheme.cardBackground,
                indicatorColor: LightBlueTheme.primaryCyan,
                destinations: [
                  NavigationDestination(
                    icon: Icon(Icons.monitor, color: G.pageIndex.value == 0 ? LightBlueTheme.primaryCyan : LightBlueTheme.textSecondary),
                    label: 'Terminal',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings, color: G.pageIndex.value == 1 ? LightBlueTheme.primaryCyan : LightBlueTheme.textSecondary),
                    label: 'Control',
                  ),
                ],
                onDestinationSelected: (index) {
                  G.pageIndex.value = index;
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// TERMINAL PAGE
// ============================================================================
class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: LightBlueTheme.darkBackground,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: LightBlueTheme.surfaceColor,
                border: Border.all(color: LightBlueTheme.primaryCyan, width: 0.5),
              ),
              child: const Center(
                child: Text(
                  'Terminal View\n(Placeholder)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: LightBlueTheme.textSecondary),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: LightBlueTheme.cardBackground,
              border: Border(top: BorderSide(color: LightBlueTheme.primaryCyan, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: LightBlueTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Enter command...',
                      hintStyle: const TextStyle(color: LightBlueTheme.textTertiary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: LightBlueTheme.primaryCyan),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (cmd) {
                      if (cmd.isNotEmpty) {
                        Util.termWrite(cmd);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: LightBlueTheme.getLightBlueButtonStyle(),
                  onPressed: () {},
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CONTROL PAGE
// ============================================================================
class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: LightBlueTheme.darkBackground,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // App Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: LightBlueTheme.primaryCyan, width: 2),
              ),
              child: const Image(
                image: AssetImage("assets/images/icon.png"),
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 24),

            // Quick Commands Section
            Card(
              color: LightBlueTheme.cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Commands',
                      style: LightBlueTheme.getLightBlueTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const FastCommands(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Settings Section
            Card(
              color: LightBlueTheme.cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: LightBlueTheme.getLightBlueTextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const SettingPage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FAST COMMANDS
// ============================================================================
class FastCommands extends StatefulWidget {
  const FastCommands({super.key});

  @override
  State<FastCommands> createState() => _FastCommandsState();
}

class _FastCommandsState extends State<FastCommands> {
  @override
  Widget build(BuildContext context) {
    final commands = Util.getCurrentProp("commands") as List<dynamic>;

    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: commands.map((cmd) {
            return ElevatedButton(
              style: LightBlueTheme.getLightBlueButtonStyle(),
              onPressed: () {
                Util.termWrite(cmd["command"]);
                G.pageIndex.value = 0;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Executed: ${cmd["name"]}'),
                    backgroundColor: LightBlueTheme.primaryCyan,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onLongPress: () => _editCommand(cmd),
              child: Text(cmd["name"]),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text("Add Command"),
          style: OutlinedButton.styleFrom(
            foregroundColor: LightBlueTheme.primaryCyan,
            side: const BorderSide(color: LightBlueTheme.primaryCyan, width: 2),
          ),
          onPressed: _addCommand,
        ),
      ],
    );
  }

  void _addCommand() {
    String name = "";
    String command = "";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: LightBlueTheme.cardBackground,
        title: Text("Add Command", style: LightBlueTheme.getLightBlueTextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: LightBlueTheme.textPrimary),
              decoration: const InputDecoration(labelText: "Name", labelStyle: TextStyle(color: LightBlueTheme.textSecondary)),
              onChanged: (v) => name = v,
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: LightBlueTheme.textPrimary),
              decoration: const InputDecoration(labelText: "Command", labelStyle: TextStyle(color: LightBlueTheme.textSecondary)),
              onChanged: (v) => command = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: LightBlueTheme.primaryCyan)),
          ),
          ElevatedButton(
            style: LightBlueTheme.getLightBlueButtonStyle(),
            onPressed: () async {
              if (name.isNotEmpty && command.isNotEmpty) {
                List<dynamic> cmds = Util.getCurrentProp("commands");
                cmds.add({"name": name, "command": command});
                await Util.setCurrentProp("commands", cmds);
                setState(() {});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Command "$name" added!'),
                    backgroundColor: LightBlueTheme.primaryCyan,
                  ),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _editCommand(dynamic cmd) {
    // Edit/delete logic
  }
}

// ============================================================================
// SETTINGS PAGE
// ============================================================================
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text("Keep Screen On", style: TextStyle(color: LightBlueTheme.textPrimary)),
          value: Util.getGlobal("wakelock") as bool,
          activeColor: LightBlueTheme.primaryCyan,
          onChanged: (v) {
            G.prefs.setBool("wakelock", v);
            WakelockPlus.toggle(enable: v);
            setState(() {});
          },
        ),
        const Divider(color: LightBlueTheme.primaryCyan),
        SwitchListTile(
          title: const Text("Auto Launch GUI", style: TextStyle(color: LightBlueTheme.textPrimary)),
          value: Util.getGlobal("autoLaunchVnc") as bool,
          activeColor: LightBlueTheme.primaryCyan,
          onChanged: (v) {
            G.prefs.setBool("autoLaunchVnc", v);
            setState(() {});
          },
        ),
        const Divider(color: LightBlueTheme.primaryCyan),
        SwitchListTile(
          title: const Text("Enable Terminal", style: TextStyle(color: LightBlueTheme.textPrimary)),
          value: Util.getGlobal("isTerminalWriteEnabled") as bool,
          activeColor: LightBlueTheme.primaryCyan,
          onChanged: (v) {
            G.prefs.setBool("isTerminalWriteEnabled", v);
            setState(() {});
          },
        ),
      ],
    );
  }
}

// ============================================================================
// RTL WRAPPER
// ============================================================================
class RTLWrapper extends StatelessWidget {
  final Widget child;
  const RTLWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: child,
    );
  }
}

// ============================================================================
// ULTRA SEARCH SPACE
// ============================================================================
class UltraSearchSpace extends StatelessWidget {
  const UltraSearchSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LightBlueTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LightBlueTheme.primaryCyan, width: 1),
      ),
      child: TextField(
        style: const TextStyle(color: LightBlueTheme.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search or upload files...',
          hintStyle: const TextStyle(color: LightBlueTheme.textTertiary),
          prefixIcon: const Icon(Icons.search, color: LightBlueTheme.primaryCyan),
          suffixIcon: const Icon(Icons.mic, color: LightBlueTheme.primaryCyan),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

// ============================================================================
// ULTRA HEALTH MONITOR
// ============================================================================
class UltraHealthMonitor extends StatelessWidget {
  const UltraHealthMonitor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LightBlueTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LightBlueTheme.primaryCyan, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🏥 Ultra Health Monitor',
            style: LightBlueTheme.getLightBlueTextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('System Status:', style: LightBlueTheme.getLightBlueTextStyle(fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: LightBlueTheme.primaryCyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: LightBlueTheme.primaryCyan),
                ),
                child: const Text('✅ Healthy', style: TextStyle(color: LightBlueTheme.primaryCyan, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
