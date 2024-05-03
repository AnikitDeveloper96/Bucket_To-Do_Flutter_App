import 'package:buckettodoapp/constants/custom_color.dart';
import 'package:flutter/material.dart';

final lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.white,
  appBarTheme: AppBarTheme(
      color: AppColors.whiteColor,
      actionsIconTheme: IconThemeData(color: AppColors.backgroundColor)),
  scaffoldBackgroundColor: AppColors.whiteColor,
  listTileTheme: ListTileThemeData(
    textColor: AppColors.backgroundColor,
    iconColor: AppColors.backgroundColor,
  ),
  tabBarTheme: TabBarTheme(
      indicatorColor: AppColors.backgroundColor,
      labelColor: AppColors.backgroundColor),
  switchTheme: SwitchThemeData(
    // Change the track color and thumb color of the switch here
    thumbColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.whiteColor; // Selected thumb color
      }
      return AppColors.whiteColor; // Default thumb color
    }),
    trackColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.backgroundColor; // Selected track color
      }
      return AppColors.backgroundColor; // Default track color
    }),
  ),
  textTheme: TextTheme(
    titleMedium: TextStyle(
      color: AppColors.backgroundColor, // Change the title color for dark theme
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    ),
  ),
);

// Dark Theme
final darkTheme = ThemeData.dark().copyWith(
  primaryColor: AppColors.backgroundColor,
  appBarTheme: AppBarTheme(
      color: AppColors.backgroundColor,
      actionsIconTheme: IconThemeData(color: AppColors.whiteColor)),
  scaffoldBackgroundColor: AppColors.backgroundColor,
  listTileTheme: ListTileThemeData(
    textColor: AppColors.whiteColor,
    iconColor: AppColors.whiteColor,
  ),
  tabBarTheme: TabBarTheme(
      indicatorColor: AppColors.whiteColor, labelColor: AppColors.whiteColor),
  switchTheme: SwitchThemeData(
    // Change the track color and thumb color of the switch here
    thumbColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.backgroundColor; // Selected thumb color
      }
      return AppColors.backgroundColor; // Default thumb color
    }),
    trackColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return AppColors.whiteColor; // Selected track color
      }
      return AppColors.whiteColor; // Default track color
    }),
  ),
  textTheme: TextTheme(
    headline6: TextStyle(
      color: AppColors.backgroundColor, // Change the title color for dark theme
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    ),
  ),
);

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeData getTheme() {
    return _isDarkMode ? darkTheme : lightTheme;
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
