// pages_fixed.dart
import 'dart:io';
import 'dart:math';
import 'package:flutter_pty/flutter_pty.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:xterm/xterm.dart';
import 'package:avnc_flutter/avnc_flutter.dart';
import 'package:x11_flutter/x11_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'constants.dart';
import 'default_values.dart';
import 'core_classes.dart';
import 'spirited_mini_games.dart';
import 'main.dart'; 
import 'ultra_ai.dart';

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
      await UltraAI().initialize();
      _initializeWorkflow();
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  Future<void> _initializeWorkflow() async {
    await Workflow.workflow();
    if (mounted) {
      setState(() {
        isLoadingComplete = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    G.homePageStateContext = context;

    return RTLWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isLoadingComplete ? Util.getCurrentProp("name") : widget.title),
        ),
        body: isLoadingComplete
            ? ValueListenableBuilder(
                valueListenable: G.pageIndex,
                builder: (context, value, child) {
                  return IndexedStack(
                    index: G.pageIndex.value,
                    children: const [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: UltraSearchSpace(),
                          ),
                          Expanded(child: TerminalPage()),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: FractionallySizedBox(
                                  widthFactor: 0.4,
                                  child: Image(image: AssetImage("assets/images/icon.png")),
                                ),
                              ),
                              FastCommands(),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        SettingPage(),
                                        SizedBox(height: 16),
                                        UltraHealthMonitor(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: G.pageIndex,
          builder: (context, value, child) {
            return Visibility(
              visible: isLoadingComplete,
              child: NavigationBar(
                selectedIndex: G.pageIndex.value,
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.monitor), label: 'Terminal'),
                  NavigationDestination(icon: Icon(Icons.video_settings), label: 'Control'),
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

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final List<bool> _expandState = [false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionPanelList(
          expansionCallback: (index, isExpanded) {
            setState(() {
              _expandState[index] = isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              isExpanded: _expandState[0],
              headerBuilder: (context, isExpanded) => const ListTile(title: Text("Global Settings")),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text("Keep Screen On"),
                      value: Util.getGlobal("wakelock") as bool,
                      onChanged: (v) {
                        G.prefs.setBool("wakelock", v);
                        WakelockPlus.toggle(enable: v);
                        setState(() {});
                      },
                    ),
                    SwitchListTile(
                      title: const Text("Auto Launch GUI"),
                      value: Util.getGlobal("autoLaunchVnc") as bool,
                      onChanged: (v) {
                        G.prefs.setBool("autoLaunchVnc", v);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            ExpansionPanel(
              isExpanded: _expandState[1],
              headerBuilder: (context, isExpanded) => const ListTile(title: Text("Ultra AI & Automation")),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text("Auto-Fix System Errors"),
                      value: UltraAI().autoFixEnabled,
                      onChanged: (v) {
                        setState(() => UltraAI().autoFixEnabled = v);
                        G.prefs.setBool('auto_fix', v);
                      },
                    ),
                    SwitchListTile(
                      title: const Text("Auto-Refresh Services"),
                      value: UltraAI().autoRefreshEnabled,
                      onChanged: (v) {
                        setState(() => UltraAI().autoRefreshEnabled = v);
                        G.prefs.setBool('auto_refresh', v);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

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
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Quick Commands", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: commands.map((cmd) {
            return ElevatedButton(
              onPressed: () {
                Util.termWrite(cmd["command"]);
                G.pageIndex.value = 0;
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
        title: const Text("Add Command"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: const InputDecoration(labelText: "Name"), onChanged: (v) => name = v),
            TextField(decoration: const InputDecoration(labelText: "Command"), onChanged: (v) => command = v),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              List<dynamic> cmds = Util.getCurrentProp("commands");
              cmds.add({"name": name, "command": command});
              await Util.setCurrentProp("commands", cmds);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _editCommand(dynamic cmd) {
    // Edit/Delete logic here
  }
}

class TerminalPage extends StatelessWidget {
  const TerminalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Terminal View (Placeholder)"));
  }
}
