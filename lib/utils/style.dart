import 'package:cicd/constants/app_colors.dart';
import 'package:flutter/material.dart';

// TextStyle appBarTitleStyle(BuildContext context) => Theme.of(context).textTheme.headline6!.copyWith(
//       color: const Color(0xff233561),
//       fontWeight: FontWeight.normal,
//     );
//
// // Additional text themes
// TextStyle boldCaptionStyle(BuildContext context) => Theme.of(context).textTheme.caption!.copyWith(fontWeight: FontWeight.bold);
//
// TextStyle boldSubtitle(BuildContext context) => Theme.of(context).textTheme.subtitle1!.copyWith(
//       fontWeight: FontWeight.bold,
//       color: Colors.black,
//     );
//
// TextStyle loginButtonTextStyle(BuildContext context) => Theme.of(context).textTheme.button!.copyWith(color: Colors.black);
//
// TextStyle normalCaptionStyle(BuildContext context) => Theme.of(context).textTheme.caption!.copyWith(
//       color: Colors.grey,
//       fontSize: 14,
//     );
//
// TextStyle normalHeadingStyle(BuildContext context) => Theme.of(context).textTheme.headline6!.copyWith(
//       fontWeight: FontWeight.normal,
//     );
//
// TextStyle textFieldHintStyle(BuildContext context) => Theme.of(context).textTheme.caption!.copyWith(
//       color: Colors.grey[500],
//       fontWeight: FontWeight.normal,
//       fontSize: 15,
//     );
//
// TextStyle textFieldInputStyle(BuildContext context, FontWeight? fontWeight) => Theme.of(context).textTheme.bodyText1!.copyWith(
//       color: Colors.black,
//       fontSize: 18,
//       fontWeight: fontWeight ?? FontWeight.normal,
//     );
//
// TextStyle textFieldLabelStyle(BuildContext context) => Theme.of(context).textTheme.caption!.copyWith(
//       color: Theme.of(context).colorScheme.secondary,
//       fontSize: 16,
//       fontWeight: FontWeight.w600,
//     );
//
// TextStyle textFieldSuffixStyle(BuildContext context) => Theme.of(context).textTheme.caption!.copyWith(
//       fontWeight: FontWeight.bold,
//       color: Colors.black,
//     );

class ThemeUtils {
  static final ThemeData defaultAppThemeData = appTheme();

  static ThemeData appTheme() {
    // Color primaryColor = Color(0xffFF0000);
    Color primaryColor = AppColors.blueDark;

    return ThemeData(
        fontFamily: "Google-Sans",
        primaryColor: primaryColor,
        hintColor: const Color(0xFF999999),
        // Widget theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xffFFFFFF),
            backgroundColor: primaryColor,
            disabledForegroundColor: const Color(0xff707070).withOpacity(0.38),
            disabledBackgroundColor: const Color(0xff707070).withOpacity(0.12),
            // Disabled button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primaryColor),
        ),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: primaryColor),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.whiteColor,
          selectedItemColor: primaryColor,
          elevation: 5.0,
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all<Color>(primaryColor),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.primary,
          shape: const StadiumBorder(),
          disabledColor: const Color(0xFFE5E3DC),
          height: 50,
        ),
        sliderTheme: SliderThemeData(
          thumbColor: primaryColor,
          activeTrackColor: primaryColor,
        ),
        cardColor: Colors.white,
        cardTheme: const CardTheme(elevation: 5),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 18),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: primaryColor,
          opacity: 1.0,
        ),
        textTheme: TextTheme(
          headlineSmall: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          titleLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: primaryColor,
          ),
          titleSmall: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          bodySmall: const TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
          bodyLarge:
              const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          labelLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            counterStyle: TextStyle(),
            contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.gray,
              fontWeight: FontWeight.normal,
            )),
        colorScheme:
            ColorScheme.fromSwatch(accentColor: const Color(0x26dc2e45))
                .copyWith(background: AppColors.whiteColor));
  }
}
