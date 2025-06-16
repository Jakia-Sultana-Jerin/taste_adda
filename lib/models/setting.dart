import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';


class SettingModel {
  final String title;
  final String route;
  final IconData Icon;

  SettingModel({required this.title, required this.route, required this.Icon});


}

final List<SettingModel> settings = [
  SettingModel(title: 'General', route: '/', Icon:LucideIcons.settings ),
   SettingModel(title: 'Profile setting',route:'/',Icon:LucideIcons.userCircle),
    SettingModel(title: 'Account setup',route:'/',Icon:LucideIcons.userCog),
     SettingModel(title: 'Notofications',route:'/',Icon:LucideIcons.settings),
      SettingModel(title: 'Privacy policy',route:'/',Icon:LucideIcons.settings),
      SettingModel(title: 'Logout',route:'/',Icon:LucideIcons.settings),

];
