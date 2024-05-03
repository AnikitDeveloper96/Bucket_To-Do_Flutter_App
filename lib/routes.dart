import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/homepage.dart';
import 'screens/rename_list.dart';
import 'splash_screen.dart';

 late User user;

Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  SplashScreen.splashscreen: ((context) => SplashScreen()),
  TodoBucketHomepage.todoHomepage: ((context) => TodoBucketHomepage(
    user: user,
  )),
  RenameList.renamelist: ((context) => const RenameList())
};
