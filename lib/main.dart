import 'package:elshora_portfolio/my_projects.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final locale = prefs.getString('locale') ?? 'en';
  runApp(MyApp(initialDarkMode: isDarkMode, initialLocale: locale));
}

class MyApp extends StatefulWidget {
  final bool initialDarkMode;
  final String initialLocale;
  const MyApp({super.key, required this.initialDarkMode, required this.initialLocale});
  @override
  _MyAppState createState() => _MyAppState();
  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;
  late String locale;
  bool _isSwitching = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.initialDarkMode;
    locale = widget.initialLocale;
  }

  Future<void> toggleTheme() async {
    setState(() => _isSwitching = true);
    await Future.delayed(const Duration(milliseconds: 300));
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
      prefs.setBool('isDarkMode', isDarkMode);
      _isSwitching = false;
    });
  }

  Future<void> toggleLanguage() async {
    setState(() => _isSwitching = true);
    await Future.delayed(const Duration(milliseconds: 300));
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      locale = locale == 'en' ? 'ar' : 'en';
      prefs.setString('locale', locale);
      _isSwitching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahmed ElSHORA Portfolio',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(locale),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      home: Skeletonizer(
        enabled: _isSwitching,
        child: PortfolioPage(),
      ),
    );
  }
}

class AppTheme {
  static const _fontFamily = 'Roboto';

  static MaterialColor _createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static final _primarySwatchLight = _createMaterialColor(const Color(0xFF3F51B5));
  static final _primarySwatchDark = _createMaterialColor(const Color(0xFF546E7A));

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primarySwatch: _primarySwatchLight,
        scaffoldBackgroundColor: const Color(0xFFE8EAF6),
        fontFamily: _fontFamily,
        textTheme: const TextTheme(
          displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF3F51B5)),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3F51B5),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          shadowColor: Colors.grey.withOpacity(0.3),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: const Color(0xFF3F51B5),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            elevation: 2,
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(MaterialState.hovered)) return Colors.indigo[600];
                if (states.contains(MaterialState.pressed)) return Colors.indigo[700];
                return null;
              },
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3F51B5), width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF3F51B5), size: 28),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: _primarySwatchDark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: _fontFamily,
        textTheme: const TextTheme(
          displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white70),
          bodyMedium: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF546E7A),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.4),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: const Color(0xFF1E1E1E),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: const Color(0xFF546E7A),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            elevation: 2,
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(MaterialState.hovered)) return Colors.blueGrey[600];
                if (states.contains(MaterialState.pressed)) return Colors.blueGrey[700];
                return null;
              },
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF546E7A), width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.white60),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF546E7A), size: 28),
      );
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  bool _showBackToTop = false;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _showBackToTop = _scrollController.offset > 150);
    });
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
    }
  }

  static void _launchCV() async {
    const url = 'https://drive.google.com/uc?export=download&id=1jVG_iF4HrtiGmrYem7P59KBIeFgz0nug';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: kToolbarHeight,
          child: AppBar(
            title: _isDrawerOpen
                ? Text('Ahmed ElSHORA', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white))
                : Text(l10n.appTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
            actions: isMobile && !_isDrawerOpen
                ? []
                : (!isMobile ? [
                    TextButton(
                      onPressed: () => _scrollTo(_aboutKey),
                      child: Text(l10n.aboutMeTitle, style: const TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () => _scrollTo(_projectsKey),
                      child: Text(l10n.myProjectsTitle, style: const TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () => _scrollTo(_contactKey),
                      child: Text(l10n.contactTitle, style: const TextStyle(color: Colors.white)),
                    ),
                    IconButton(
                      icon: Icon(isDark ? Icons.wb_sunny : Icons.nights_stay),
                      onPressed: () => MyApp.of(context)?.toggleTheme(),
                    ),
                    IconButton(
                      icon: Text(
                        Localizations.localeOf(context).languageCode == 'en' ? 'AR' : 'EN',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () => MyApp.of(context)?.toggleLanguage(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ElevatedButton(onPressed: _launchCV, child: Text(l10n.downloadCV)),
                    ),
                  ] : []),
          ),
        ),
      ),
      drawer: isMobile
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/images/me.jpg'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ahmed ElSHORA',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(l10n.aboutMeTitle),
                    onTap: () {
                      _scrollTo(_aboutKey);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(l10n.myProjectsTitle),
                    onTap: () {
                      _scrollTo(_projectsKey);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(l10n.contactTitle),
                    onTap: () {
                      _scrollTo(_contactKey);
                      Navigator.pop(context);
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(isDark ? Icons.wb_sunny : Icons.nights_stay),
                    title: Text(isDark ? 'Light Mode' : 'Dark Mode'),
                    onTap: () {
                      MyApp.of(context)?.toggleTheme();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text(Localizations.localeOf(context).languageCode == 'en' ? 'AR' : 'EN'),
                    onTap: () {
                      MyApp.of(context)?.toggleLanguage();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.download),
                    title: Text(l10n.downloadCV),
                    onTap: () {
                      _launchCV();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          : null,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            AboutMe(key: _aboutKey),
            const Divider(height: 1),
            MyProjects(key: _projectsKey),
            const Divider(height: 1),
            ContactForm(key: _contactKey),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: isDark ? const Color(0xFF121212) : const Color(0xFFE8EAF6),
              child: Center(
                child: Text(
                  '© 2025 Ahmed ElSHORA. All rights reserved.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: screenWidth > 600 ? 16 : 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _showBackToTop
          ? FloatingActionButton(
              onPressed: () => _scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 800), curve: Curves.easeInOut),
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
      onDrawerChanged: (isOpen) {
        setState(() => _isDrawerOpen = isOpen);
      },
    );
  }
}

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});
  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchSocialMedia(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final screenWidth = MediaQuery.of(context).size.width;

    // Breakpoints & responsive sizes
    final bool isMobile = screenWidth < 600;
    final double cardWidth = screenWidth > 1000 ? 1000 : screenWidth * 0.94;

    // Image sizing responsive
    final double desktopImageWidth = 300;
    final double tabletImageWidth = 220;
    final double mobileImageWidth = (screenWidth * 0.56).clamp(140.0, 240.0);

    final double imageWidth = screenWidth >= 1000
        ? desktopImageWidth
        : screenWidth >= 600
            ? tabletImageWidth
            : mobileImageWidth;

    final double imageHeight = imageWidth * 1.18; // portrait style

    // Card internal padding (smaller on mobile)
    final double cardInnerPadding = isMobile ? 18.0 : 28.0;

    Widget socialIcon(String assetPath, VoidCallback onTap, {String? tooltip}) {
      return Tooltip(
        message: tooltip ?? '',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark ? Colors.white10 : Colors.white,
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.10),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
              ],
            ),
            child: SizedBox(
              width: 28,
              height: 28,
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.link,
                    size: 20,
                    color: isDark ? Colors.white54 : Colors.indigo,
                  );
                },
              ),
            ),
          ),
        ),
      );
    }

    // Image widget with border & shadow
    Widget personImage() {
      return Container(
        width: imageWidth,
        height: imageHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.grey.shade900 : Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/me.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: isDark ? Colors.grey[850] : Colors.grey[200],
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: imageWidth * 0.45,
                    color: isDark ? Colors.white24 : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    // MAIN BUILD: different layout for mobile vs larger screens
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 12),
      color: isDark ? const Color(0xFF0F0F10) : const Color(0xFFF3F6FF),
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(opacity: _opacityAnimation.value, child: child),
            );
          },
          child: SizedBox(
            width: cardWidth,
            child: isMobile
                ? // ===== MOBILE LAYOUT =====
                Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Card (starts lower to make room for overlapping image)
                      Card(
                        elevation: 10,
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: imageHeight * 0.38 + cardInnerPadding,
                            left: cardInnerPadding,
                            right: cardInnerPadding,
                            bottom: cardInnerPadding,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: isArabic
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.aboutMeTitle,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                textAlign: isArabic ? TextAlign.end : TextAlign.start,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                l10n.aboutMeContent,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 14.5,
                                      height: 1.5,
                                      color: isDark ? Colors.white70 : Colors.black87,
                                    ),
                                textAlign: isArabic ? TextAlign.end : TextAlign.start,
                              ),
                              const SizedBox(height: 16),
                              // small divider accent
                              Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isDark
                                            ? [Colors.indigo.shade200, Colors.purple.shade200]
                                            : [Colors.indigo, Colors.purple],
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              // Social icons
                              Align(
                                alignment:
                                    isArabic ? Alignment.centerRight : Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    socialIcon('assets/images/whatsapp.png', () {
                                      _launchSocialMedia('https://wa.me/+201050815073');
                                    }, tooltip: 'WhatsApp'),
                                    socialIcon('assets/images/facebook.png', () {
                                      _launchSocialMedia('https://facebook.com/your_profile');
                                    }, tooltip: 'Facebook'),
                                    socialIcon('assets/images/instagram.png', () {
                                      _launchSocialMedia('https://instagram.com/your_profile');
                                    }, tooltip: 'Instagram'),
                                    socialIcon('assets/images/linkedin.png', () {
                                      _launchSocialMedia('https://linkedin.com/in/your_profile');
                                    }, tooltip: 'LinkedIn'),
                                    socialIcon('assets/images/github.png', () {
                                      _launchSocialMedia('https://github.com/A7medElshora/');
                                    }, tooltip: 'GitHub'),
                                    socialIcon('assets/images/twitter.png', () {
                                      _launchSocialMedia('https://x.com/your_profile');
                                    }, tooltip: 'Twitter'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Positioned centered image overlapping top of card
                      Positioned(
                        top: -(imageHeight * 0.38),
                        left: (cardWidth - imageWidth) / 2, // center horizontally
                        child: personImage(),
                      ),
                    ],
                  )
                : // ===== DESKTOP / TABLET LAYOUT =====
                Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Card(
                        elevation: 14,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        child: Padding(
                          padding: EdgeInsets.all(cardInnerPadding),
                          child: Row(
                            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Reserve inside space for the half overlay
                              SizedBox(width: imageWidth / 2 + 12),
                              const SizedBox(width: 18),
                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: isArabic
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.aboutMeTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(fontSize: 28, fontWeight: FontWeight.w800),
                                      textAlign: isArabic ? TextAlign.end : TextAlign.start,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.aboutMeContent,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontSize: 16.5,
                                            height: 1.5,
                                            color: isDark ? Colors.white70 : Colors.black87,
                                          ),
                                      textAlign: isArabic ? TextAlign.end : TextAlign.start,
                                    ),
                                    const SizedBox(height: 18),
                                    Row(
                                      children: [
                                        Container(
                                          width: 42,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: isDark
                                                  ? [Colors.indigo.shade200, Colors.purple.shade200]
                                                  : [Colors.indigo, Colors.purple],
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: [
                                        socialIcon('assets/images/whatsapp.png', () {
                                          _launchSocialMedia('https://wa.me/+201050815073');
                                        }, tooltip: 'WhatsApp'),
                                        socialIcon('assets/images/facebook.png', () {
                                          _launchSocialMedia('https://facebook.com/your_profile');
                                        }, tooltip: 'Facebook'),
                                        socialIcon('assets/images/instagram.png', () {
                                          _launchSocialMedia('https://instagram.com/your_profile');
                                        }, tooltip: 'Instagram'),
                                        socialIcon('assets/images/linkedin.png', () {
                                          _launchSocialMedia('https://linkedin.com/in/your_profile');
                                        }, tooltip: 'LinkedIn'),
                                        socialIcon('assets/images/github.png', () {
                                          _launchSocialMedia('https://github.com/A7medElshora/');
                                        }, tooltip: 'GitHub'),
                                        socialIcon('assets/images/twitter.png', () {
                                          _launchSocialMedia('https://x.com/your_profile');
                                        }, tooltip: 'Twitter'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Positioned image half-inside, half-outside (left or right depending on locale)
                      Positioned(
                        top: cardInnerPadding,
                        left: isArabic ? null : -(imageWidth / 2),
                        right: isArabic ? -(imageWidth / 2) : null,
                        child: personImage(),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '', _email = '', _message = '';
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final resp = await http.post(
      Uri.parse('https://formspree.io/f/xgvzyadj'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': _name, 'email': _email, 'message': _message, '_to': 'elshoraa14@gmail.com'}),
    );
    setState(() => _isSubmitting = false);
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    if (resp.statusCode == 200) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.messageSent)));
      _formKey.currentState!.reset();
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.messageFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth > 600 ? 500 : screenWidth * 0.9;

    return Container(
      padding: const EdgeInsets.all(32),
      color: isDark ? const Color(0xFF121212) : const Color(0xFFE8EAF6),
      child: Center(
        child: Container(
          width: formWidth,
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.contactTitle,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: screenWidth > 600 ? 32 : 24,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 28, color: Colors.indigo),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: l10n.nameLabel,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (v) => v!.isEmpty ? l10n.nameLabel : null,
                            onChanged: (v) => _name = v,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.email, size: 28, color: Colors.indigo),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: l10n.emailLabel,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (v) {
                              if (v!.isEmpty) return l10n.emailLabel;
                              if (!RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return l10n.emailLabel;
                              return null;
                            },
                            onChanged: (v) => _email = v,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.message, size: 28, color: Colors.indigo),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: l10n.messageLabel,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            maxLines: 5,
                            validator: (v) => v!.isEmpty ? l10n.messageLabel : null,
                            onChanged: (v) => _message = v,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(l10n.sendMessage),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}