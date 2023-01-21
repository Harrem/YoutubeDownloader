import 'package:flutter/material.dart';
import 'package:ytd/theme/app_colors.dart';

class CustomTheme {
  ThemeData get light {
    var theme = ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: const ColorScheme.light(primary: AppColors.primary));
    return theme;
  }

  ThemeData get dark {
    var theme = ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: AppColors.backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        onPrimary: Colors.white70,
        secondary: AppColors.secondaryDark,
        onSecondary: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // fillColor: ,
        // iconColor: C,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        // labelStyle: const TextStyle(
        //   color: Color.fromARGB(255, 209, 213, 219),
        // ),
      ),
    );

    return theme;

    // ThemeData(
    //   useMaterial3: true,
    //   scaffoldBackgroundColor: AppColors.backgroundColor,
    //   appBarTheme: const AppBarTheme(
    //     color: AppColors.containerColor,
    //     // iconTheme: IconThemeData(
    //     //   color: Color.fromARGB(255, 126, 126, 126),
    //     // ),
    //   ),
    //   colorScheme: const ColorScheme.dark(
    // primary: AppColors.primaryDark,
    // onPrimary: Colors.white70,
    // secondary: AppColors.secondaryDark,
    // onSecondary: Colors.white,

    //     // primaryContainer: AppColors.containerColor,
    //     // secondaryContainer: AppColors.containerColor,
    //     // surface: AppColors.surfaceColor,
    //     // tertiary: Colors.white,
    //     // onPrimaryContainer: Colors.grey,
    //     // onBackground: Colors.white,
    //     // onSecondary: Colors.blue,
    //     // onSurface: Colors.white,
    //     // onTertiary: Colors.white,
    //     // onError: Colors.red,
    //     // onErrorContainer: Colors.red,
    //     // onInverseSurface: Colors.white,
    //     // onSecondaryContainer: Colors.white,
    //     // onSurfaceVariant: Colors.white,
    //     // onTertiaryContainer: Colors.white,
    //   ),
    //   cardTheme: const CardTheme(
    //       // color: AppColors.containerColor,
    //       ),
    //   iconTheme: const IconThemeData(
    //       // color: Colors.white54,
    //       ),

    //   elevatedButtonTheme: ElevatedButtonThemeData(
    //       // style: ElevatedButton.styleFrom(
    //       //     // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    //       //     ),
    //       ),
    // );
  }
}
