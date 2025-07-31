// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ahmed ElSHORA Portfolio';

  @override
  String get aboutMeTitle => 'About Me';

  @override
  String get aboutMeContent => 'I am Ahmed ElSHORA, a passionate Flutter Developer based in Cairo, Egypt. Currently working at Tabibsoft Inc. since December 2024, I specialize in creating mobile and web applications using Flutter and Dart. With a B.S. in Information Technology from the Egyptian e-Learning University (2019-2023), I have developed a strong foundation in app development, including real-time chatting with WebSocket/SignalR, push notifications with Firebase (FCM), and deploying apps to the Google Play Store. My goal is to build intuitive and impactful solutions that enhance user experiences.';

  @override
  String get myProjectsTitle => 'My Projects';

  @override
  String get contactTitle => 'Contact Us';

  @override
  String get downloadCV => 'Download CV';

  @override
  String get nameLabel => 'Name';

  @override
  String get emailLabel => 'Email';

  @override
  String get messageLabel => 'Message';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get messageSent => 'Message sent successfully!';

  @override
  String get messageFailed => 'Failed to send message.';

  @override
  String get viewProject => 'View Project';

  @override
  String get m3ashedDescription => 'An educational app providing accessible learning resources in Arabic.';

  @override
  String get elGahribDescription => 'App for biology education with videos, documents, and chat features.';

  @override
  String get crmDescription => 'Internal app for TabibSoft to manage tasks and operations.';

  @override
  String get egyHealthDescription => 'A medical tourism app enhancing healthcare accessibility.';
}
