import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons/lucide_icons.dart';

class generalPage extends StatefulWidget {
  const generalPage({super.key});
  @override
  State<generalPage> createState() => _generalPagestate();
}

enum Notification { a, b, c, d, nothing }

enum Language { a, b, nothing }

enum Location{a,nothing}

class _generalPagestate extends State<generalPage> {
  //  final controller = FSelectMenuTileController.radio(value: Notification.a);
  final reminderController = FSelectMenuTileController<Notification>.radio(
    value: Notification.a,
  );
  final languageController = FSelectMenuTileController<Language>.radio(
    value: Language.a,
  );
   final locationController = FSelectMenuTileController<Location>.radio(
    value: Location.a,
  );
  bool state = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("General settings")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FTileGroup(
              
              children: [
                
                FSelectMenuTile(
                  spacing: FPortalSpacing(20),
                  selectController: reminderController,
                  autoHide: true,
                  validator: (value) => value == null ? 'Select an item' : null,
                  prefixIcon: Icon(LucideIcons.alarmCheck),
                  title: Text(
                    'Reminder for break',
                    style: TextStyle(fontSize: 18),
                  ),
                  details: ListenableBuilder(
                    listenable: reminderController,
                    builder:
                        (context, _) =>
                            Text(switch (reminderController.value.firstOrNull) {
                              Notification.a => 'After 15 minutes',
                              Notification.b => 'After 30 minutes',
                              Notification.c => 'After 45 minutes',
                              Notification.d => 'After 1 hour',
            
                              null || Notification.nothing => 'None',
                            }),
                  ),
                  menu: [
                    FSelectTile(
                      title: const Text('After 15 minutes'),
                      value: Notification.a,
                    ),
                    FSelectTile(
                      title: const Text('After 30 minutes'),
                      value: Notification.b,
                    ),
                    FSelectTile(
                      title: const Text('After 45 minutes'),
                      value: Notification.c,
                    ),
                    FSelectTile(
                      title: const Text('After 1 hour'),
                      value: Notification.d,
                    ),
                  ],
                ),
              
             
                FSelectMenuTile(
                  selectController: languageController,
                  autoHide: true,
                  validator: (value) => value == null ? 'Select an item' : null,
                  prefixIcon: Icon(LucideIcons.languages),
                  title: Text('App Language', style: TextStyle(fontSize: 18)),
                  details: ListenableBuilder(
                    listenable: languageController,
                    builder:
                        (context, _) =>
                            Text(switch (languageController.value.firstOrNull) {
                              Language.a => 'Bangla',
                              Language.b => 'English',
            
                              null || Language.nothing => 'None',
                            }),
                  ),
                  menu: [
                    FSelectTile(title: const Text('English'), value: Language.a),
                    FSelectTile(title: const Text('Bangla'), value: Language.b),
                  ],
                ),

                  FSelectMenuTile(
                  selectController: locationController,
                  autoHide: true,
                  validator: (value) => value == null ? 'Select an item' : null,
                  prefixIcon: Icon(LucideIcons.locate),
                  title: Text('Location', style: TextStyle(fontSize: 18)),
                  details: ListenableBuilder(
                    listenable: locationController,
                    builder:
                        (context, _) =>
                            Text(switch (locationController.value.firstOrNull) {
                              Location.a => 'Bangladesh',
                             
            
                              null || Location.nothing => 'None',
                            }),
                  ),
                  menu: [
                    FSelectTile(title: const Text('Bangladesh'), value: Location.a),
                 
                  ],
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    reminderController.dispose();
    languageController.dispose();
    super.dispose();
  }
}
