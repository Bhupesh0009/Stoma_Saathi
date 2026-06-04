import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/app_models.dart';
import 'screens/about_app_screen.dart';
import 'screens/disclaimer_screen.dart';
import 'screens/module_5/index.dart';
import 'screens/module_6/index.dart';

void main() {
  runApp(const StomaSaathiApp());
}

class StomaSaathiApp extends StatefulWidget {
  const StomaSaathiApp({super.key});

  @override
  State<StomaSaathiApp> createState() => _StomaSaathiAppState();
}

class _StomaSaathiAppState extends State<StomaSaathiApp> {
  AppLanguage _language = AppLanguage.english;
  bool _isInitialized = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final langCode = prefs.getString('stoma_language') ?? 'en';
      final isLoggedIn = prefs.getBool('stoma_logged_in') ?? false;
      final language = langCode == 'hi' ? AppLanguage.hindi : AppLanguage.english;
      setState(() {
        _language = language;
        _isLoggedIn = isLoggedIn;
        _isInitialized = true;
      });
      appLanguageNotifier.value = language;
    } catch (_) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _updateLanguage(AppLanguage language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('stoma_language', language == AppLanguage.hindi ? 'hi' : 'en');
    } catch (_) {}
    setState(() {
      _language = language;
    });
    appLanguageNotifier.value = language;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stoma Saathi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F7A8C),
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFF2E7D32),
          surface: const Color(0xFFF8FBFF),
        ),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F8FC),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            headlineMedium: TextStyle(fontWeight: FontWeight.w800),
            titleLarge: TextStyle(fontWeight: FontWeight.w800),
            titleMedium: TextStyle(fontWeight: FontWeight.w700),
            bodyLarge: TextStyle(height: 1.45),
            bodyMedium: TextStyle(height: 1.45),
          ),
        ),
      ),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1.06)),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: !_isInitialized
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SplashScreen(
              onDone: () {},
              child: _isLoggedIn
                  ? AppShell(
                      language: _language,
                      onLanguageChanged: _updateLanguage,
                      onLogout: () async {
                        try {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('stoma_logged_in', false);
                        } catch (_) {}
                        setState(() {
                          _isLoggedIn = false;
                        });
                      },
                    )
                  : LoginPage(
                      language: _language,
                      onLanguageChanged: _updateLanguage,
                      onLoginSuccess: () async {
                        try {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('stoma_logged_in', true);
                        } catch (_) {}
                        setState(() {
                          _isLoggedIn = true;
                        });
                      },
                    ),
            ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onDone, required this.child});

  final VoidCallback onDone;
  final Widget child;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showHome = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      widget.onDone();
      setState(() {
        _showHome = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showHome) {
      return widget.child;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FCFF), Color(0xFFE6F4F1), Color(0xFFF9EEF9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 180,
                height: 180,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(42),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Stoma Saathi',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF153A8A),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Care • Confidence • Companion',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blueGrey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),
              const SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(strokeWidth: 3.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.language,
    required this.onLanguageChanged,
    required this.onLoginSuccess,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final VoidCallback onLoginSuccess;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final isEnglish = widget.language == AppLanguage.english;
    setState(() {
      _errorMessage = null;
    });

    final rawUserId = _userIdController.text;
    final rawPassword = _passwordController.text;

    // Validation: Trim extra spaces in inputs
    final userId = rawUserId.trim().toLowerCase();
    final password = rawPassword.trim();

    if (userId.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = isEnglish
            ? 'Please enter both User ID and Password.'
            : 'कृपया यूज़र आईडी और पासवर्ड दोनों डालें।';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate secure network loading delay
    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      // User ID user1 to user40 validation
      bool isValidUser = false;
      if (userId.startsWith('user')) {
        final numberPart = userId.substring(4);
        final userNum = int.tryParse(numberPart);
        if (userNum != null && userNum >= 1 && userNum <= 40) {
          isValidUser = true;
        }
      }

      // Password validation
      final isValidPassword = password == 'User@1234';

      if (isValidUser && isValidPassword) {
        setState(() {
          _isLoading = false;
        });

        // Show successful login message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  isEnglish ? 'Login Successful!' : 'लॉगिन सफल रहा!',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );

        // Trigger onLoginSuccess to switch home root state and persist session
        widget.onLoginSuccess();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = isEnglish
              ? 'Invalid User ID or Password'
              : 'अमान्य यूज़र आईडी या पासवर्ड';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = widget.language == AppLanguage.english;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FCFF), Color(0xFFE6F4F1), Color(0xFFF0F4FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWide ? 460 : double.infinity,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: _LanguageChip(
                        language: widget.language,
                        onLanguageChanged: widget.onLanguageChanged,
                        visible: true,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Header Section (Logo, Name, Subtitle)
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(
                                color: const Color(0xFFE4EEF8),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isEnglish ? 'Stoma Saathi' : 'स्टोमा साथी',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF153A8A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isEnglish
                                ? 'Care • Confidence • Companion'
                                : 'देखभाल • आत्मविश्वास • साथी',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Rounded Login Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE4EEF8)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F3B8E).withValues(alpha: 0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              isEnglish ? 'Login to your account' : 'अपने खाते में लॉगिन करें',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A237E),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // User ID Input
                            Text(
                              isEnglish ? 'User ID' : 'यूज़र आईडी',
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF455A64),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _userIdController,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: isEnglish ? 'e.g., user15' : 'उदा., user15',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w500,
                                ),
                                prefixIcon: const Icon(
                                  Icons.person_outline_rounded,
                                  color: Color(0xFF1565C0),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8FBFF),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFCFD8DC)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFE1F5FE)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF1565C0),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Password Input
                            Text(
                              isEnglish ? 'Password' : 'पासवर्ड',
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF455A64),
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleLogin(),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: isEnglish ? 'Enter Password' : 'पासवर्ड डालें',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w500,
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color(0xFF1565C0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFF78909C),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8FBFF),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFCFD8DC)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFE1F5FE)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF1565C0),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Remember Me Checkbox
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (val) {
                                      setState(() {
                                        _rememberMe = val ?? false;
                                      });
                                    },
                                    activeColor: const Color(0xFF1565C0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  isEnglish ? 'Remember Me' : 'याद रखें',
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF546E7A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Error Display
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFFFCDD2)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline_rounded,
                                      color: Color(0xFFC62828),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: const TextStyle(
                                          color: Color(0xFFC62828),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Login Button
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1565C0),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 2,
                                shadowColor: const Color(0xFF1565C0).withValues(alpha: 0.3),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      isEnglish ? 'Login' : 'लॉगिन',
                                      style: const TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          ],
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
    required this.onLogout,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final VoidCallback onLogout;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final modules = buildModules();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      body: CustomScrollView(
        slivers: [
          // Modules 1 to 8 in a regular grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final module = modules[index];
                return ModuleCard(
                  module: module,
                  language: widget.language,
                  onTap: () => _openModule(context, module),
                );
              }, childCount: 8),
            ),
          ),
        ],
      ),
    );
  }

  void _openModule(BuildContext context, ModuleData module) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LanguageConsumer(
          builder: (context, language) => ModuleScreen(
            module: module,
            language: language,
            onLanguageChanged: widget.onLanguageChanged,
          ),
        ),
      ),
    );
  }
}


class ModuleCard extends StatefulWidget {
  const ModuleCard({
    super.key,
    required this.module,
    required this.language,
    required this.onTap,
  });

  final ModuleData module;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  State<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSeven = widget.module.number == 7;
    final scale = _isPressed ? 0.95 : 1.0;
    final shadowBlur = _isPressed ? 28.0 : 18.0;
    final shadowOpacity = _isPressed ? 0.16 : 0.07;
    final shadowOffset = _isPressed ? const Offset(0, 12) : const Offset(0, 8);

    Widget artwork;
    if (isSeven) {
      artwork = Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: Image.asset(
            'assets/images/module7_warning_triangle.png',
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      artwork = _ModuleArtwork(module: widget.module);
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: Transform.scale(
        scale: scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFEAF0F8), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0x120F172A).withValues(alpha: shadowOpacity),
                blurRadius: shadowBlur,
                offset: shadowOffset,
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          child: Column(
            children: [
              Expanded(child: artwork),
              const SizedBox(height: 12),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: widget.module.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.module.color.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '${widget.module.number}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.module.title.value(widget.language),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModuleScreen extends StatelessWidget {
  const ModuleScreen({
    super.key,
    required this.module,
    required this.language,
    required this.onLanguageChanged,
  });

  final ModuleData module;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      activeModuleNotifier.value = module;
    });
    return LanguageConsumer(
      builder: (context, language) {
        final text = AppText(language);

        if (module.number == 1) {
          return _ModuleOneScreen(
            module: module,
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }

        if (module.number == 2) {
          return _ModuleTwoScreen(
            module: module,
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }

        if (module.number == 3) {
          return _ModuleThreeScreen(
            module: module,
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }

        if (module.number == 4) {
          return _ModuleFourScreen(
            module: module,
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }

        if (module.number == 5) {
          return _ModuleFiveScreen(
            module: module,
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }

        if (module.number == 6) {
          return _ModuleSixScreen(
            module: module,
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }

        if (module.number == 7) {
          return _ModuleSevenScreen(
            module: module,
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }

        if (module.number == 8) {
          return _ModuleEightSupportScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 300,
                backgroundColor: module.color,
                foregroundColor: Colors.white,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _LanguageChip(
                      language: language,
                      onLanguageChanged: onLanguageChanged,
                      dark: true,
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              module.color.withValues(alpha: 0.92),
                              _darken(module.color, 0.18),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 96,
                        child: Container(
                          width: 132,
                          height: 132,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            module.imageAsset,
                            fit: BoxFit.cover,
                            alignment: module.headerImageAlignment,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 100, 168, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                '${text.module} ${module.number}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              module.title.value(language),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              module.subtitle.value(language),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoBanner(
                        color: module.color,
                        title: text.moduleOverview,
                        body: module.overview.value(language),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        text.lessons,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverList.separated(
                  itemCount: module.lessons.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final lesson = module.lessons[index];
                    return _LessonTile(
                      number: index + 1,
                      color: lesson.color,
                      title: lesson.title.value(language),
                      subtitle: lesson.summary.value(language),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LessonScreen(
                              module: module,
                              lesson: lesson,
                              language: language,
                              onLanguageChanged: onLanguageChanged,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ModuleEightSupportScreen extends StatelessWidget {
  const _ModuleEightSupportScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  static final _callUri = Uri.parse('tel:8882752099');
  static final _whatsAppUri = Uri.parse('https://wa.me/918882752099');

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  Future<void> _openLink(
    BuildContext context,
    Uri uri, {
    LaunchMode? mode,
  }) async {
    final isEnglish = language == AppLanguage.english;
    var success = false;
    try {
      success = await launchUrl(
        uri,
        mode: mode ?? LaunchMode.externalApplication,
      );
    } on PlatformException {
      success = false;
    }
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEnglish
                ? 'Please restart the app and try this support option.'
                : 'कृपया ऐप को पुनरारंभ करें और फिर से प्रयास करें।',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8F7),
        surfaceTintColor: const Color(0xFFF4F8F7),
        elevation: 0,
        title: Text(
          isEnglish ? 'Contact Support' : 'सहायता से संपर्क करें',
          style: const TextStyle(
            color: Color(0xFF14323A),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Text(
              isEnglish ? 'Need Help?' : 'सहायता चाहिए?',
              style: const TextStyle(
                color: Color(0xFF0F3B44),
                fontSize: 32,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isEnglish
                  ? 'Choose how you would like to connect with support.'
                  : 'चुनें कि आप सहायता से कैसे जुड़ना चाहते हैं।',
              style: const TextStyle(
                color: Color(0xFF52646B),
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final useColumns = constraints.maxWidth >= 560;
                final cards = [
                  _SupportOptionCard(
                    title: isEnglish ? 'Call' : 'कॉल करें',
                    subtitle: isEnglish ? 'Talk directly with support' : 'सहायता टीम से सीधे बात करें',
                    color: const Color(0xFF0E8A6A),
                    background: const Color(0xFFEAF8F3),
                    icon: Icons.phone_rounded,
                    onTap: () => _openLink(context, _callUri),
                  ),
                  _SupportOptionCard(
                    title: isEnglish ? 'WhatsApp' : 'व्हाट्सएप',
                    subtitle: isEnglish ? 'Chat with support instantly' : 'तुरंत चैट सहायता पाएं',
                    color: const Color(0xFF25D366),
                    background: const Color(0xFFE9FBF0),
                    customIcon: const _WhatsAppLogo(),
                    onTap: () => _openLink(
                      context,
                      _whatsAppUri,
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ];

                if (useColumns) {
                  return Row(
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 18),
                      Expanded(child: cards[1]),
                    ],
                  );
                }

                return Column(
                  children: [cards[0], const SizedBox(height: 18), cards[1]],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportOptionCard extends StatefulWidget {
  const _SupportOptionCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.background,
    required this.onTap,
    this.icon,
    this.customIcon,
  });

  final String title;
  final String subtitle;
  final Color color;
  final Color background;
  final VoidCallback onTap;
  final IconData? icon;
  final Widget? customIcon;

  @override
  State<_SupportOptionCard> createState() => _SupportOptionCardState();
}

class _SupportOptionCardState extends State<_SupportOptionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.985 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(24),
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          child: Container(
            constraints: const BoxConstraints(minHeight: 190),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE0ECE9)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: widget.background,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  alignment: Alignment.center,
                  child:
                      widget.customIcon ??
                      Icon(widget.icon, color: widget.color, size: 40),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF52646B),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: widget.color,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WhatsAppLogo extends StatelessWidget {
  const _WhatsAppLogo();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets/images/whatsapp_logo.png',
        width: 42,
        height: 42,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return CustomPaint(
            size: const Size(42, 42),
            painter: _WhatsAppLogoPainter(),
          );
        },
      ),
    );
  }
}

class _WhatsAppLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final green = Paint()..color = const Color(0xFF25D366);
    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(w * 0.5, h * 0.48), w * 0.42, green);
    final tail = Path()
      ..moveTo(w * 0.24, h * 0.75)
      ..lineTo(w * 0.18, h * 0.96)
      ..lineTo(w * 0.39, h * 0.83)
      ..close();
    canvas.drawPath(tail, green);

    canvas.drawArc(
      Rect.fromLTWH(w * 0.26, h * 0.22, w * 0.5, h * 0.5),
      2.4,
      2.5,
      false,
      white,
    );
    canvas.drawLine(
      Offset(w * 0.38, h * 0.42),
      Offset(w * 0.46, h * 0.55),
      white,
    );
    canvas.drawLine(
      Offset(w * 0.49, h * 0.57),
      Offset(w * 0.62, h * 0.63),
      white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModuleOneScreen extends StatelessWidget {
  const _ModuleOneScreen({
    required this.module,
    required this.language,
    required this.onLanguageChanged,
  });

  final ModuleData module;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final text = AppText(language);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24, right: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${text.module} ${module.number}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF151D67),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          module.title.value(language),
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF11195D),
                            height: 1.12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          module.subtitle.value(language),
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF171717),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 146,
                  height: 186,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/images/module1_header_person.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            for (var i = 0; i < module.lessons.length; i++) ...[
              _ReferenceLessonTile(
                number: i + 1,
                color: module.lessons[i].color,
                title: module.lessons[i].title.value(language),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(
                        module: module,
                        lesson: module.lessons[i],
                        language: language,
                        onLanguageChanged: onLanguageChanged,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _ModuleTwoScreen extends StatelessWidget {
  const _ModuleTwoScreen({
    required this.module,
    required this.language,
    required this.onLanguageChanged,
  });

  final ModuleData module;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final text = AppText(language);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FB),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${text.module} ${module.number}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFFE8F1F5)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 24,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 20, 18, 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  module.title.value(language),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF162E43),
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  module.subtitle.value(language),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.6,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF5F6B7B),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F8F4),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    language == AppLanguage.english
                                        ? 'Learn about the essential items for daily stoma care.'
                                        : 'रोज़ की स्टोमा देखभाल के लिए आवश्यक वस्तुओं के बारे में जानें।',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2E7D32),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                          const SizedBox(width: 18),
                          SizedBox(
                            width: 136,
                            height: 150,
                            child: _StomaCareKitIllustration(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),
                    Column(
                      children: [
                        for (var i = 0; i < module.lessons.length; i++) ...[
                          _ModuleTwoLessonTile(
                            number: i + 1,
                            color: module.lessons[i].color,
                            title: module.lessons[i].title.value(language),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LessonScreen(
                                    module: module,
                                    lesson: module.lessons[i],
                                    language: language,
                                    onLanguageChanged: onLanguageChanged,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                        _QuickTipsTile(
                          title: language == AppLanguage.english
                              ? 'Quick Help'
                              : 'त्वरित सहायता',
                          subtitle: language == AppLanguage.english
                              ? 'Need assistance? Call your nurse or check daily reminders.'
                              : 'सहायता चाहिए? अपनी नर्स को कॉल करें या दैनिक अनुस्मारक देखें।',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => _ModuleTwoQuickTipsScreen(
                                  language: language,
                                  onLanguageChanged: onLanguageChanged,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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

class _ModuleThreeScreen extends StatelessWidget {
  const _ModuleThreeScreen({
    required this.module,
    required this.language,
    required this.onLanguageChanged,
  });

  static const _navy = Color(0xFF10164F);
  static const _body = Color(0xFF111827);
  static const _items = [
    _ProcedureItemSpec(
      title: 'Removing the Old Pouch',
      hindiTitle: 'पुराना पाउच हटाना',
      color: Color(0xFF078B2F),
      icon: Icons.play_arrow_rounded,
      subtitle: 'Watch Video',
      hindiSubtitle: 'वीडियो देखें',
    ),
    _ProcedureItemSpec(
      title: 'Cleaning the Stoma & Skin',
      hindiTitle: 'स्टोमा और त्वचा साफ करना',
      color: Color(0xFF168AF2),
      icon: Icons.play_arrow_rounded,
      subtitle: 'Watch Video',
      hindiSubtitle: 'वीडियो देखें',
    ),
    _ProcedureItemSpec(
      title: 'Measuring the Stoma',
      hindiTitle: 'स्टोमा मापना',
      color: Color(0xFF7650D6),
      icon: Icons.play_arrow_rounded,
      subtitle: 'Watch Video',
      hindiSubtitle: 'वीडियो देखें',
    ),
    _ProcedureItemSpec(
      title: 'Cutting the Wafer',
      hindiTitle: 'वेफर काटना',
      color: Color(0xFFE93B55),
      icon: Icons.play_arrow_rounded,
      subtitle: 'Watch Video',
      hindiSubtitle: 'वीडियो देखें',
    ),
    _ProcedureItemSpec(
      title: 'Applying Skin Barrier',
      hindiTitle: 'स्किन बैरियर लगाना',
      color: Color(0xFFFF8700),
      icon: Icons.play_arrow_rounded,
      subtitle: 'Watch Video',
      hindiSubtitle: 'वीडियो देखें',
    ),
    _ProcedureItemSpec(
      title: 'Placing and Sealing the Pouch',
      hindiTitle: 'पाउच लगाना और सील करना',
      color: Color(0xFF1197A2),
      icon: Icons.play_arrow_rounded,
      subtitle: 'Watch Video',
      hindiSubtitle: 'वीडियो देखें',
    ),
    _ProcedureItemSpec(
      title: 'Checking for Leakage',
      hindiTitle: 'लीकेज जांचना',
      color: Color(0xFF111111),
      icon: Icons.visibility_rounded,
      subtitle: 'Read Only',
      hindiSubtitle: 'केवल पढ़ें',
    ),
    _ProcedureItemSpec(
      title: 'Emptying the Pouch',
      hindiTitle: 'पाउच खाली करना',
      color: Color(0xFF1178D9),
      icon: Icons.play_arrow_rounded,
      subtitle: 'Watch Video',
      hindiSubtitle: 'वीडियो देखें',
    ),
    _ProcedureItemSpec(
      title: 'Disposal of Used Materials',
      hindiTitle: 'उपयोग की चीजें फेंकना',
      color: Color(0xFF22B72E),
      icon: Icons.play_arrow_rounded,
      subtitle: 'Watch Video',
      hindiSubtitle: 'वीडियो देखें',
    ),
  ];

  final ModuleData module;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 390;
    final illustrationWidth = isCompact ? 150.0 : 182.0;
    final illustrationHeight = isCompact ? 232.0 : 260.0;
    final titleSize = isCompact ? 27.0 : 29.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
          children: [
            const _ModuleThreeBrandHeader(),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 46),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEnglish ? 'Module 3' : 'मॉड्यूल 3',
                          style: const TextStyle(
                            color: _navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isEnglish
                              ? 'Stoma Care\nProcedure'
                              : 'स्टोमा देखभाल\nप्रक्रिया',
                          style: TextStyle(
                            color: _navy,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w900,
                            height: 1.06,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          isEnglish
                              ? 'Learn the step-by-step process\nto care for your stoma safely\nat home.'
                              : 'घर पर अपने स्टोमा की\nसुरक्षित देखभाल करना\nआसान चरणों में सीखें।',
                          style: TextStyle(
                            color: _body,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            height: 1.52,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: illustrationWidth,
                  height: illustrationHeight,
                  child: Image.asset(
                    'assets/images/module3_patient.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.topRight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            for (var i = 0; i < _items.length; i++) ...[
              _ProcedureListTile(
                number: i + 1,
                spec: _items[i],
                language: language,
                onTap: () {
                  if (i >= module.lessons.length) {
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(
                        module: module,
                        lesson: module.lessons[i],
                        language: language,
                        onLanguageChanged: onLanguageChanged,
                      ),
                    ),
                  );
                },
              ),
              if (i != _items.length - 1) const SizedBox(height: 17),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProcedureItemSpec {
  const _ProcedureItemSpec({
    required this.title,
    required this.hindiTitle,
    required this.color,
    required this.icon,
    required this.subtitle,
    required this.hindiSubtitle,
  });

  final String title;
  final String hindiTitle;
  final Color color;
  final IconData icon;
  final String subtitle;
  final String hindiSubtitle;

  String titleFor(AppLanguage language) {
    return language == AppLanguage.english ? title : hindiTitle;
  }

  String subtitleFor(AppLanguage language) {
    return language == AppLanguage.english ? subtitle : hindiSubtitle;
  }
}

class _ModuleThreeBrandHeader extends StatelessWidget {
  const _ModuleThreeBrandHeader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _ModuleFourScreen extends StatelessWidget {
  const _ModuleFourScreen({
    required this.module,
    required this.language,
    required this.onLanguageChanged,
  });

  static const _navy = Color(0xFF10164F);
  static const _items = [
    _ModuleFourItemSpec(
      title: 'Diet Plan (First 4 Weeks)',
      hindiTitle: 'डाइट प्लान (पहले 4 सप्ताह)',
      color: Color(0xFF078B2F),
    ),
    _ModuleFourItemSpec(
      title: 'Hydration Guidelines',
      hindiTitle: 'पानी पीने के निर्देश',
      color: Color(0xFF168AF2),
    ),
    _ModuleFourItemSpec(
      title: 'Foods That Thicken Stool',
      hindiTitle: 'मल गाढ़ा करने वाले भोजन',
      color: Color(0xFF7650D6),
    ),
    _ModuleFourItemSpec(
      title: 'Foods That Loosen Stool',
      hindiTitle: 'मल पतला करने वाले भोजन',
      color: Color(0xFFE93B55),
    ),
    _ModuleFourItemSpec(
      title: 'Foods to Avoid Initially',
      hindiTitle: 'शुरुआत में न खाने वाली चीजें',
      color: Color(0xFFFF8700),
    ),
    _ModuleFourItemSpec(
      title: 'Tips to Reduce Odor & Gas',
      hindiTitle: 'गंध और गैस कम करने के सुझाव',
      color: Color(0xFF1197A2),
    ),
    _ModuleFourItemSpec(
      title: 'When to Contact Nurse',
      hindiTitle: 'नर्स से कब संपर्क करें',
      color: Color(0xFF0864B8),
    ),
    _ModuleFourItemSpec(
      title: 'Quick Tips',
      hindiTitle: 'Quick Tips',
      color: Color(0xFF087A24),
    ),
  ];

  final ModuleData module;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 390;
    final illustrationWidth = isCompact ? 150.0 : 178.0;
    final illustrationHeight = isCompact ? 226.0 : 252.0;
    final titleSize = isCompact ? 27.0 : 29.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
          children: [
            const _ModuleThreeBrandHeader(),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEnglish ? 'Module 4' : 'मॉड्यूल 4',
                          style: const TextStyle(
                            color: _navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isEnglish ? 'Diet & Fluids' : 'आहार और तरल',
                          style: TextStyle(
                            color: _navy,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w900,
                            height: 1.08,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          isEnglish
                              ? 'Learn how the right food\nand fluids help you stay\nhealthy and comfortable.'
                              : 'सही भोजन और पानी से\nस्वस्थ और आरामदायक\nरहना सीखें।',
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            height: 1.52,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: illustrationWidth,
                  height: illustrationHeight,
                  child: Image.asset(
                    'assets/images/module4_patient.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.topRight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 27),
            for (var i = 0; i < _items.length; i++) ...[
              _ModuleFourListTile(
                number: i + 1,
                spec: _items[i],
                language: language,
                onTap: () {
                  if (i >= module.lessons.length) {
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(
                        module: module,
                        lesson: module.lessons[i],
                        language: language,
                        onLanguageChanged: onLanguageChanged,
                      ),
                    ),
                  );
                },
              ),
              if (i != _items.length - 1) const SizedBox(height: 31),
            ],
          ],
        ),
      ),
    );
  }
}

class _ModuleFourItemSpec {
  const _ModuleFourItemSpec({
    required this.title,
    required this.hindiTitle,
    required this.color,
  });

  final String title;
  final String hindiTitle;
  final Color color;

  String titleFor(AppLanguage language) {
    return language == AppLanguage.english ? title : hindiTitle;
  }
}

class _ModuleFourListTile extends StatelessWidget {
  const _ModuleFourListTile({
    required this.number,
    required this.spec,
    required this.language,
    required this.onTap,
  });

  final int number;
  final _ModuleFourItemSpec spec;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: spec.color,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: spec.color.withValues(alpha: 0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Text(
              spec.titleFor(language),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF151515),
                fontSize: 16,
                fontWeight: FontWeight.w900,
                height: 1.18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: spec.color,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleFourDietPlanDetailScreen extends StatelessWidget {
  const _ModuleFourDietPlanDetailScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  static const _page = Color(0xFFF7FBFA);

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: _page,
        surfaceTintColor: _page,
        elevation: 0,
        title: const SizedBox.shrink(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 28),
          children: [_ModuleFourDietPlanChart(language: language)],
        ),
      ),
    );
  }
}

class _ModuleFourDietPlanChart extends StatelessWidget {
  const _ModuleFourDietPlanChart({required this.language});

  final AppLanguage language;

  static const _green = Color(0xFF078B2F);
  static const _red = Color(0xFFE51B48);

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE7F0EC)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10583B).withValues(alpha: 0.09),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DietPlanChartHeader(language: language),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 760;
              final left = _DietWeekChartSection(
                title: isEnglish ? 'Week 1–2 (Early Recovery)' : 'हफ्ता 1-2 (शुरुआती सुधार)',
                bullets: isEnglish
                    ? const [
                        'Take soft, low-fiber foods',
                        'Eat small and frequent meals',
                      ]
                    : const [
                        'नरम और कम फाइबर वाला भोजन लें',
                        'कम मात्रा में बार-बार खाएं',
                      ],
                children: [
                  _DietChartLabel(
                    icon: Icons.check_rounded,
                    color: _green,
                    text: isEnglish ? 'Recommended' : 'अनुशंसित',
                  ),
                  const SizedBox(height: 12),
                  _DietFoodGrid(
                    preferredColumns: 3,
                    items: [
                      _DietFoodSpec(
                        isEnglish ? 'Khichdi' : 'खिचड़ी',
                        _DietFoodKind.khichdi,
                      ),
                      _DietFoodSpec(
                        isEnglish ? 'Dal & Rice' : 'दाल और चावल',
                        _DietFoodKind.dalRice,
                      ),
                      _DietFoodSpec(
                        isEnglish ? 'Curd (Dahi)' : 'दही',
                        _DietFoodKind.curd,
                      ),
                      _DietFoodSpec(
                        isEnglish ? 'Banana' : 'केला',
                        _DietFoodKind.banana,
                      ),
                      _DietFoodSpec(
                        isEnglish ? 'Boiled Potato' : 'उबला हुआ आलू',
                        _DietFoodKind.potato,
                      ),
                      _DietFoodSpec(
                        isEnglish ? 'Toast,\nBiscuits' : 'टोस्ट,\nबिस्कुट',
                        _DietFoodKind.toast,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _DietChartLabel(
                    icon: Icons.close_rounded,
                    color: _red,
                    text: isEnglish ? 'Avoid' : 'बचें',
                  ),
                  const SizedBox(height: 12),
                  _DietFoodGrid(
                    preferredColumns: 2,
                    items: [
                      _DietFoodSpec(
                        isEnglish ? 'Raw\nVegetables' : 'कच्ची\nसब्जियां',
                        _DietFoodKind.rawVeg,
                      ),
                      _DietFoodSpec(
                        isEnglish ? 'Spicy & Oily\nFood' : 'मसालेदार और\nतैलीय भोजन',
                        _DietFoodKind.spicyFood,
                      ),
                    ],
                  ),
                ],
              );
              final right = _DietWeekChartSection(
                title: isEnglish ? 'Week 3–4 (Gradual Progression)' : 'हफ्ता 3-4 (धीरे-धीरे बदलाव)',
                bullets: isEnglish
                    ? const [
                        'Slowly add new foods one by one',
                        'Observe how your body reacts',
                      ]
                    : const [
                        'धीरे-धीरे एक-एक करके नए खाद्य पदार्थ जोड़ें',
                        'ध्यान दें कि आपका शरीर कैसी प्रतिक्रिया देता है',
                      ],
                children: [
                  const SizedBox(height: 38),
                  _DietChartLabel(
                    icon: Icons.check_rounded,
                    color: _green,
                    text: isEnglish ? 'Add' : 'शामिल करें',
                  ),
                  const SizedBox(height: 16),
                  _DietFoodGrid(
                    preferredColumns: 3,
                    items: [
                      _DietFoodSpec(
                        isEnglish ? 'Soft\nVegetables' : 'मुलायम\nसब्जियां',
                        _DietFoodKind.softVeg,
                      ),
                      _DietFoodSpec(
                        isEnglish ? 'Chapati' : 'चपाती / रोटी',
                        _DietFoodKind.chapati,
                      ),
                      _DietFoodSpec(
                        isEnglish ? 'Light\nFruits' : 'हल्के\nफल',
                        _DietFoodKind.fruits,
                      ),
                    ],
                  ),
                  const SizedBox(height: 52),
                  _DietChartTipBox(language: language),
                ],
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: left),
                    const SizedBox(width: 14),
                    Expanded(child: right),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [left, const SizedBox(height: 14), right],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DietPlanChartHeader extends StatelessWidget {
  const _DietPlanChartHeader({required this.language});

  final AppLanguage language;

  static const _green = Color(0xFF078B2F);

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;
    return Row(
      children: [
        Container(
          width: 49,
          height: 49,
          decoration: BoxDecoration(
            color: _green,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: _green.withValues(alpha: 0.18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            '1',
            style: TextStyle(
              color: Colors.white,
              fontSize: 31,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            isEnglish
                ? 'Diet Plan (First 4 Weeks After Surgery)'
                : 'डाइट प्लान (सर्जरी के बाद पहले 4 सप्ताह)',
            style: const TextStyle(
              color: _green,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
        ),
      ],
    );
  }
}

class _DietWeekChartSection extends StatelessWidget {
  const _DietWeekChartSection({
    required this.title,
    required this.bullets,
    required this.children,
  });

  static const _green = Color(0xFF078B2F);

  final String title;
  final List<String> bullets;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 19, 18, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE6EFEB)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B6445).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _green,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 13),
          for (final bullet in bullets) ...[
            _DietChartMiniBullet(text: bullet),
            const SizedBox(height: 9),
          ],
          const SizedBox(height: 17),
          ...children,
        ],
      ),
    );
  }
}

class _DietChartMiniBullet extends StatelessWidget {
  const _DietChartMiniBullet({required this.text});

  static const _ink = Color(0xFF161A24);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _ink,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _DietChartLabel extends StatelessWidget {
  const _DietChartLabel({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _DietFoodGrid extends StatelessWidget {
  const _DietFoodGrid({required this.preferredColumns, required this.items});

  final int preferredColumns;
  final List<_DietFoodSpec> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 310 && preferredColumns > 2
            ? 2
            : preferredColumns;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.86,
          ),
          itemBuilder: (context, index) => _DietFoodTile(spec: items[index]),
        );
      },
    );
  }
}

class _DietFoodTile extends StatelessWidget {
  const _DietFoodTile({required this.spec});

  static const _ink = Color(0xFF262A31);

  final _DietFoodSpec spec;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Image.asset(
            'assets/images/${spec.kind.assetName}',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          spec.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _ink,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
            height: 1.16,
          ),
        ),
      ],
    );
  }
}

class _DietChartTipBox extends StatelessWidget {
  const _DietChartTipBox({required this.language});

  final AppLanguage language;

  static const _blue = Color(0xFF1988D2);

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.fromLTRB(17, 13, 17, 13),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5F1FB)),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline_rounded, color: _blue, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              isEnglish
                  ? 'Introduce only one new food at a time'
                  : 'एक समय में केवल एक नया भोजन जोड़ें',
              style: const TextStyle(
                color: Color(0xFF154378),
                fontSize: 14.5,
                fontWeight: FontWeight.w900,
                height: 1.34,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DietFoodSpec {
  const _DietFoodSpec(this.label, this.kind);

  final String label;
  final _DietFoodKind kind;
}

enum _DietFoodKind {
  khichdi,
  dalRice,
  curd,
  banana,
  potato,
  toast,
  rawVeg,
  spicyFood,
  softVeg,
  chapati,
  fruits,
}

extension _DietFoodKindExtension on _DietFoodKind {
  String get assetName {
    switch (this) {
      case _DietFoodKind.khichdi:
        return 'module4_diet_khichdi.png';
      case _DietFoodKind.dalRice:
        return 'module4_diet_dal_rice.png';
      case _DietFoodKind.curd:
        return 'module4_diet_curd.png';
      case _DietFoodKind.banana:
        return 'module4_diet_banana.png';
      case _DietFoodKind.potato:
        return 'module4_diet_boiled_potato.png';
      case _DietFoodKind.toast:
        return 'module4_diet_toast.png';
      case _DietFoodKind.rawVeg:
        return 'module4_diet_raw_veg.png';
      case _DietFoodKind.spicyFood:
        return 'module4_diet_spicy_food.png';
      case _DietFoodKind.softVeg:
        return 'module4_diet_soft_veg.png';
      case _DietFoodKind.chapati:
        return 'module4_diet_chapati.png';
      case _DietFoodKind.fruits:
        return 'module4_diet_light_fruits.png';
    }
  }
}

class _ModuleFourHydrationDetailScreen extends StatelessWidget {
  const _ModuleFourHydrationDetailScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F5FBF),
        surfaceTintColor: const Color(0xFF2F5FBF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          isEnglish ? '2. HYDRATION GUIDELINES' : '2. जल सेवन दिशानिर्देश',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: _ModuleFourHydrationChart(language: language),
        ),
      ),
    );
  }
}

class _ModuleFourHydrationChart extends StatelessWidget {
  const _ModuleFourHydrationChart({required this.language});

  final AppLanguage language;

  Widget _buildHydrationItem({required String imagePath, required String text}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Image.asset(
            imagePath,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomRow({
    required String text,
    required String imagePath,
    required double imageSize,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '• ',
                style: TextStyle(
                  color: Color(0xFFD32F2F),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Image.asset(
          imagePath,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Two-column layout
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column (Illustration)
            Expanded(
              flex: 4,
              child: Image.asset(
                'assets/images/module4_hydration_main.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            // Right Column (Bullets & Items)
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Bullet 1
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          isEnglish
                              ? 'Drink 8–10 glasses of fluids daily'
                              : 'प्रतिदिन 8–10 गिलास तरल पदार्थ पिएं',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Bullet 2
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          isEnglish ? 'Include:' : 'शामिल करें:',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // List of items with thin vertical connector line
                  Stack(
                    children: [
                      // Thin vertical line in background
                      Positioned(
                        left: 20,
                        top: 20,
                        bottom: 20,
                        child: Container(
                          width: 1.5,
                          color: const Color(0xFFD1D5DB),
                        ),
                      ),
                      Column(
                        children: [
                          // Item 1: Water
                          _buildHydrationItem(
                            imagePath: 'assets/images/module4_hydration_droplet.png',
                            text: isEnglish ? 'Water' : 'पानी',
                          ),
                          const SizedBox(height: 16),
                          // Item 2: ORS
                          _buildHydrationItem(
                            imagePath: 'assets/images/module4_hydration_ors_icon.png',
                            text: isEnglish
                                ? 'ORS (oral rehydration solution)'
                                : 'ओआरएस (ओरल रिहाइड्रेशन सॉल्यूशन)',
                          ),
                          const SizedBox(height: 16),
                          // Item 3: Buttermilk
                          _buildHydrationItem(
                            imagePath: 'assets/images/module4_hydration_buttermilk.png',
                            text: isEnglish ? 'Buttermilk' : 'छाछ',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // Important Information Banner
        Container(
          margin: const EdgeInsets.symmetric(vertical: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF5FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD0E1F9)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFF2F5FBF),
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isEnglish
                      ? 'Especially important in ileostomy patients (risk of dehydration)'
                      : 'इलियोस्टोमी रोगियों में विशेष रूप से महत्वपूर्ण (निर्जलीकरण का जोखिम)',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E3A8A),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Signs of Dehydration Section
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5F5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFED7D7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  isEnglish ? 'SIGNS OF DEHYDRATION' : 'निर्जलीकरण के संकेत',
                  style: const TextStyle(
                    color: Color(0xFFD32F2F),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSymptomRow(
                text: isEnglish ? 'Dry mouth' : 'मुंह सूखना',
                imagePath: 'assets/images/module7_dehydration_dry_mouth.png',
                imageSize: 46,
              ),
              const Divider(height: 24, thickness: 1, color: Color(0xFFFEE2E2)),
              _buildSymptomRow(
                text: isEnglish ? 'Less urine' : 'पेशाब कम होना',
                imagePath: 'assets/images/module7_dehydration_urine.png',
                imageSize: 46,
              ),
              const Divider(height: 24, thickness: 1, color: Color(0xFFFEE2E2)),
              _buildSymptomRow(
                text: isEnglish ? 'Weakness or dizziness' : 'कमजोरी या चक्कर आना',
                imagePath: 'assets/images/module7_dehydration_dizzy.png',
                imageSize: 46,
              ),
              const Divider(height: 24, thickness: 1, color: Color(0xFFFEE2E2)),
              Row(
                children: [
                  const Text(
                    '👉 ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      isEnglish
                          ? 'Contact nurse if symptoms appear'
                          : 'लक्षण दिखाई देने पर नर्स से संपर्क करें',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModuleFourThickeningFoodsDetailScreen extends StatelessWidget {
  const _ModuleFourThickeningFoodsDetailScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  static const _page = Color(0xFFFAF7FF);

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: _page,
        surfaceTintColor: _page,
        elevation: 0,
        title: const SizedBox.shrink(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 28),
          children: [
            _ModuleFourThickeningFoodsChart(language: language),
          ],
        ),
      ),
    );
  }
}

class _ModuleFourThickeningFoodsChart extends StatelessWidget {
  const _ModuleFourThickeningFoodsChart({required this.language});

  final AppLanguage language;

  static const _purple = Color(0xFF5E20C7);
  static const _ink = Color(0xFF161A24);

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECE4F8)),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _purple,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _purple.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  isEnglish ? 'Foods That Thicken Stool' : 'मल गाढ़ा करने वाले भोजन',
                  style: const TextStyle(
                    color: _purple,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Food Items Row
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 24) / 5;
              final imageSize = itemWidth - 2;

              Widget buildFoodItem(String assetPath, String englishLabel, String hindiLabel) {
                return SizedBox(
                  width: itemWidth,
                  child: Column(
                    children: [
                      Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          assetPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEnglish ? englishLabel : hindiLabel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildFoodItem('assets/images/module4_thickening_banana.png', 'Banana', 'केला'),
                  buildFoodItem('assets/images/module4_thickening_rice.png', 'Rice', 'चावल'),
                  buildFoodItem('assets/images/module4_thickening_curd.png', 'Curd', 'दही'),
                  buildFoodItem(
                    'assets/images/module4_thickening_apple.png',
                    'Apple\n(without peel)',
                    'सेब\n(बिना छिलके के)',
                  ),
                  buildFoodItem('assets/images/module4_thickening_potato.png', 'Potato', 'आलू'),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Bottom Info Strip
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFBF8FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDE4FF)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.thumb_up_alt_outlined,
                  color: _purple,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    isEnglish ? 'Helpful in loose stools' : 'पतले दस्त में मददगार',
                    style: const TextStyle(
                      color: _purple,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _ModuleFourLooseningFoodsDetailScreen extends StatelessWidget {
  const _ModuleFourLooseningFoodsDetailScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  static const _page = Color(0xFFFFF7F8);

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: _page,
        surfaceTintColor: _page,
        elevation: 0,
        title: const SizedBox.shrink(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 28),
          children: [
            _ModuleFourLooseningFoodsChart(language: language),
          ],
        ),
      ),
    );
  }
}

class _ModuleFourLooseningFoodsChart extends StatelessWidget {
  const _ModuleFourLooseningFoodsChart({required this.language});

  final AppLanguage language;

  static const _red = Color(0xFFE51B48);
  static const _ink = Color(0xFF161A24);

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF7E3E7)),
        boxShadow: [
          BoxShadow(
            color: _red.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _red,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _red.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  '4',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  isEnglish ? 'Foods That Loosen Stool' : 'मल पतला करने वाले भोजन',
                  style: const TextStyle(
                    color: _red,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Food Items Row
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 24) / 4;
              final imageSize = itemWidth - 2;

              Widget buildFoodItem(String assetPath, String englishLabel, String hindiLabel) {
                return SizedBox(
                  width: itemWidth,
                  child: Column(
                    children: [
                      Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          assetPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEnglish ? englishLabel : hindiLabel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildFoodItem(
                    'assets/images/module4_loosening_green_veg.png',
                    'Green Leafy\nVegetables',
                    'हरी पत्तेदार\nसब्जियां',
                  ),
                  buildFoodItem(
                    'assets/images/module4_loosening_spicy.png',
                    'Spicy Food',
                    'मसालेदार\nभोजन',
                  ),
                  buildFoodItem(
                    'assets/images/module4_loosening_milk.png',
                    'Milk\n(in some\npatients)',
                    'दूध\n(कुछ\nरोगियों में)',
                  ),
                  buildFoodItem(
                    'assets/images/module4_loosening_fried.png',
                    'Fried Food',
                    'तला हुआ\nभोजन',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Bottom Warning Strip
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF3E7B7)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFFBC02D),
                  size: 24,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    isEnglish ? 'Limit if you have diarrhea' : 'दस्त होने पर सीमित करें',
                    style: const TextStyle(
                      color: _red,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleFourAvoidFoodsDetailScreen extends StatelessWidget {
  const _ModuleFourAvoidFoodsDetailScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  static const _page = Color(0xFFFFFAF4);

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: _page,
        surfaceTintColor: _page,
        elevation: 0,
        title: const SizedBox.shrink(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 28),
          children: [
            _ModuleFourAvoidFoodsChart(language: language),
          ],
        ),
      ),
    );
  }
}

class _ModuleFourAvoidFoodsChart extends StatelessWidget {
  const _ModuleFourAvoidFoodsChart({required this.language});

  final AppLanguage language;

  static const _orange = Color(0xFFFF8700);
  static const _ink = Color(0xFF161A24);

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDEEE1)),
        boxShadow: [
          BoxShadow(
            color: _orange.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _orange,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _orange.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  '5',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  isEnglish ? 'Foods to Avoid Initially' : 'शुरुआत में परहेज किए जाने वाले भोजन',
                  style: const TextStyle(
                    color: _orange,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Food Items Rows
          LayoutBuilder(
            builder: (context, constraints) {
              final width3 = (constraints.maxWidth - 24) / 3;
              final imageSize3 = width3 - 8;

              final width2 = (constraints.maxWidth - 16) / 2.3;
              final imageSize2 = width2 - 12;

              Widget buildFoodItem(
                String assetPath,
                String englishLabel,
                String hindiLabel,
                double width,
                double imageSize,
              ) {
                return SizedBox(
                  width: width,
                  child: Column(
                    children: [
                      Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFFDEEE1), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: _orange.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(4),
                        child: ClipOval(
                          child: Image.asset(
                            assetPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEnglish ? englishLabel : hindiLabel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  // Row 1 (3 items)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildFoodItem(
                        'assets/images/module4_avoid_nuts.png',
                        'Nuts, Corn,\nPopcorn',
                        'मेवे, मक्का,\nपॉपकॉर्न',
                        width3,
                        imageSize3,
                      ),
                      buildFoodItem(
                        'assets/images/module4_avoid_raw_veg.png',
                        'Raw\nVegetables',
                        'कच्ची\nसब्जियां',
                        width3,
                        imageSize3,
                      ),
                      buildFoodItem(
                        'assets/images/module4_avoid_cabbage.png',
                        'Cabbage,\nCauliflower',
                        'पत्तागोभी,\nफूलगोभी',
                        width3,
                        imageSize3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Row 2 (2 items)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildFoodItem(
                        'assets/images/module4_avoid_beans.png',
                        'Beans,\nOnions',
                        'बीन्स,\nप्याज',
                        width2,
                        imageSize2,
                      ),
                      const SizedBox(width: 16),
                      buildFoodItem(
                        'assets/images/module4_avoid_spicy.png',
                        'Very Spicy\nor Oily Food',
                        'बहुत मसालेदार\nया तैलीय भोजन',
                        width2,
                        imageSize2,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Bottom Warning Strip
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFCF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFF1D0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFFFC107),
                  size: 24,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    isEnglish
                        ? 'These may cause blockage, gas, or irritation'
                        : 'ये रुकावट, गैस या जलन पैदा कर सकते हैं',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFE88416),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _ModuleFourOdorGasDetailScreen extends StatelessWidget {
  const _ModuleFourOdorGasDetailScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4BAA),
        surfaceTintColor: const Color(0xFF7B4BAA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          isEnglish ? '6. TIPS TO REDUCE ODOR & GAS' : '6. गंध और गैस कम करने के उपाय',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: _ModuleFourOdorGasChart(language: language),
        ),
      ),
    );
  }
}

class _ModuleFourOdorGasChart extends StatelessWidget {
  const _ModuleFourOdorGasChart({required this.language});

  final AppLanguage language;

  Widget _buildTipItem(String imagePath, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 58,
          height: 58,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '• ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF161A24),
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF161A24),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColumnCard(BuildContext context, String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Heading Pill badge
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF4EFFB), // Very light purple
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8DFEE), width: 1),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6A3FA0), // Section Heading Purple
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Tip Items
          ...children.asMap().entries.map((entry) {
            int idx = entry.key;
            Widget child = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: idx == children.length - 1 ? 0 : 24),
              child: child,
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // TOP CARD: TO REDUCE GAS
        _buildColumnCard(
          context,
          isEnglish ? 'TO REDUCE GAS' : 'गैस कम करने के लिए',
          [
            _buildTipItem(
              'assets/images/module4_tips_gas_eat.png',
              isEnglish ? 'Eat slowly and chew properly' : 'धीरे-धीरे खाएं और भोजन को अच्छी तरह चबाएं',
            ),
            _buildTipItem(
              'assets/images/module4_tips_gas_carbonated.png',
              isEnglish ? 'Avoid carbonated drinks' : 'कार्बोनेटेड पेय से बचें',
            ),
            _buildTipItem(
              'assets/images/module4_tips_gas_limit.png',
              isEnglish
                  ? 'Limit gas-forming foods – beans, cruciferous vegetables, whole grains, sugar, alcohol'
                  : 'गैस बनाने वाले खाद्य पदार्थों को सीमित करें – बीन्स, पत्तागोभी वर्ग की सब्जियां, साबुत अनाज, चीनी, अल्कोहल',
            ),
          ],
        ),
        const SizedBox(height: 16),
        // BOTTOM CARD: TO REDUCE ODOR
        _buildColumnCard(
          context,
          isEnglish ? 'TO REDUCE ODOR' : 'गंध कम करने के लिए',
          [
            _buildTipItem(
              'assets/images/module4_tips_odor_curd.png',
              isEnglish ? 'Take curd/yogurt' : 'दही का सेवन करें',
            ),
            _buildTipItem(
              'assets/images/module4_tips_odor_water.png',
              isEnglish ? 'Drink enough water' : 'पर्याप्त पानी पिएं',
            ),
            _buildTipItem(
              'assets/images/module4_tips_odor_pouch.png',
              isEnglish ? 'Maintain pouch hygiene' : 'पाउच की स्वच्छता बनाए रखें',
            ),
          ],
        ),
      ],
    );
  }
}

class _ModuleFourContactNurseDetailScreen extends StatelessWidget {
  const _ModuleFourContactNurseDetailScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  static const _page = Color(0xFFF5FAFF);

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: _page,
        surfaceTintColor: _page,
        elevation: 0,
        title: const SizedBox.shrink(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 28),
          children: [
            _ModuleFourContactNurseChart(language: language),
          ],
        ),
      ),
    );
  }
}

class _ModuleFourContactNurseChart extends StatelessWidget {
  const _ModuleFourContactNurseChart({required this.language});

  final AppLanguage language;

  static const _blue = Color(0xFF0864B8);
  static const _ink = Color(0xFF161A24);

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    Widget buildHeader() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _blue,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: _blue.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              '7',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEnglish ? 'When to Contact Nurse' : 'नर्स से कब संपर्क करें',
                  style: const TextStyle(
                    color: _blue,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isEnglish ? '(Diet-Related Problems)' : '(आहार-संबंधी समस्याएं)',
                  style: const TextStyle(
                    color: _blue,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget buildSymptomRow(String assetPath, String englishLabel, String hindiLabel) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2EEF9), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: _blue.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                isEnglish ? englishLabel : hindiLabel,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2EEF9)),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          buildHeader(),
          const SizedBox(height: 24),

          // Intro Text
          Text(
            isEnglish ? 'Contact your nurse if you have:' : 'यदि आपको निम्नलिखित समस्याएं हैं तो अपनी नर्स से संपर्क करें:',
            style: TextStyle(
              color: _ink.withValues(alpha: 0.8),
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 20),

          // Symptoms Vertical List
          buildSymptomRow(
            'assets/images/module4_nurse_no_output.png',
            'No output for long time',
            'लंबे समय से कोई मल न आना',
          ),
          buildSymptomRow(
            'assets/images/module4_nurse_watery_stool.png',
            'Continuous watery stool',
            'लगातार पानी जैसा मल आना',
          ),
          buildSymptomRow(
            'assets/images/module4_nurse_abdominal_pain.png',
            'Severe abdominal pain',
            'पेट में गंभीर दर्द होना',
          ),
          buildSymptomRow(
            'assets/images/module4_nurse_vomiting.png',
            'Vomiting',
            'उल्टी होना',
          ),
          buildSymptomRow(
            'assets/images/module4_nurse_dehydration.png',
            'Signs of dehydration',
            'निर्जलीकरण (पानी की कमी) के लक्षण',
          ),
          const SizedBox(height: 8),

          // Bottom Info Section
          Container(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4FAFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2F0FB)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE2F0FB), width: 1),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/module4_nurse_nurse_support.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    isEnglish ? 'Early help prevents complications' : 'समय पर मदद जटिलताओं से बचाती है',
                    style: const TextStyle(
                      color: _blue,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
}
}

class _ModuleFourQuickTipsDetailScreen extends StatelessWidget {
  const _ModuleFourQuickTipsDetailScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  static const _page = Color(0xFFF4FBF4);

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: _page,
        surfaceTintColor: _page,
        elevation: 0,
        title: const SizedBox.shrink(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 28),
          children: [
            _ModuleFourQuickTipsChart(language: language),
          ],
        ),
      ),
    );
  }
}

class _ModuleFourQuickTipsChart extends StatelessWidget {
  const _ModuleFourQuickTipsChart({required this.language});

  final AppLanguage language;

  static const _green = Color(0xFF087A24);
  static const _ink = Color(0xFF161A24);

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    Widget buildHeader() {
      return Container(
        padding: const EdgeInsets.fromLTRB(18, 13, 18, 12),
        decoration: const BoxDecoration(
          color: _green,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.25),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Icon(
                Icons.lightbulb_outline_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              isEnglish ? 'Quick Tips' : 'त्वरित सुझाव',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ],
        ),
      );
    }

    Widget buildTipRow({
      required Widget leftIcon,
      required String englishLabel,
      required String hindiLabel,
      required String rightAssetPath,
      required double rightSize,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leftIcon,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isEnglish ? englishLabel : hindiLabel,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: rightSize,
              height: rightSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE3EFE5), width: 1),
              ),
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: Image.asset(
                  rightAssetPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final checklistColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildTipRow(
          leftIcon: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF2BAF2B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
          ),
          englishLabel: 'Eat small frequent meals',
          hindiLabel: 'थोड़ा-थोड़ा और बार-बार खाएं',
          rightAssetPath: 'assets/images/module4_quick_food_bowl.png',
          rightSize: 48,
        ),
        buildTipRow(
          leftIcon: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF2BAF2B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
          ),
          englishLabel: 'Chew food properly',
          hindiLabel: 'भोजन को ठीक से चबाएं',
          rightAssetPath: 'assets/images/module4_quick_chewing.png',
          rightSize: 52,
        ),
        buildTipRow(
          leftIcon: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF2BAF2B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
          ),
          englishLabel: 'Try new foods one at a time',
          hindiLabel: 'एक बार में एक ही नया भोजन आज़माएं',
          rightAssetPath: 'assets/images/module4_quick_plus.png',
          rightSize: 48,
        ),
        buildTipRow(
          leftIcon: SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
              'assets/images/module4_quick_notebook.png',
              fit: BoxFit.contain,
            ),
          ),
          englishLabel: 'Maintain food diary',
          hindiLabel: 'भोजन की डायरी बनाए रखें',
          rightAssetPath: 'assets/images/module4_quick_pen.png',
          rightSize: 48,
        ),
      ],
    );

    final characterColumn = Container(
      constraints: const BoxConstraints(maxHeight: 280),
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/module4_quick_character.png',
        fit: BoxFit.contain,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE3EFE5)),
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          buildHeader(),
          
          // Responsive Body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 550;

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: checklistColumn,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 4,
                        child: characterColumn,
                      ),
                    ],
                  );
                }

                // Mobile stack vertical
                return Column(
                  children: [
                    checklistColumn,
                    const SizedBox(height: 16),
                    characterColumn,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



class _ModuleFiveScreen extends StatelessWidget {
  const _ModuleFiveScreen({
    required this.module,
    required this.language,
    required this.onLanguageChanged,
  });

  static const _navy = Color(0xFF10164F);
  static const _items = [
    _ModuleFiveItemSpec(
      title: 'Early Ambulation\n(Walking Guidelines)',
      hindiTitle: 'जल्दी चलना\n(चलने के निर्देश)',
      color: Color(0xFF078B2F),
      icon: Icons.looks_one_rounded,
    ),
    _ModuleFiveItemSpec(
      title: 'Abdominal Strengthening\nExercises',
      hindiTitle: 'पेट मजबूत करने वाली\nएक्सरसाइज',
      color: Color(0xFF168AF2),
      icon: Icons.looks_two_rounded,
    ),
    _ModuleFiveItemSpec(
      title: 'Hernia Prevention Techniques',
      hindiTitle: 'हर्निया से बचाव के तरीके',
      color: Color(0xFF5E43C8),
      icon: Icons.looks_3_rounded,
    ),
    _ModuleFiveItemSpec(
      title: 'Lifting & Straining Precautions',
      hindiTitle: 'वजन उठाने में सावधानी',
      color: Color(0xFFFF5A00),
      icon: Icons.looks_4_rounded,
    ),
    _ModuleFiveItemSpec(
      title: 'Activity Progression Timeline',
      hindiTitle: 'गतिविधि बढ़ाने की समयरेखा',
      color: Color(0xFFFF9700),
      icon: Icons.looks_5_rounded,
    ),
    _ModuleFiveItemSpec(
      title: 'When to Stop Exercise &\nContact Nurse',
      hindiTitle: 'एक्सरसाइज कब रोकें और\nनर्स से संपर्क करें',
      color: Color(0xFFE92F45),
      icon: Icons.warning_amber_rounded,
    ),
  ];

  final ModuleData module;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 390;
    final illustrationWidth = isCompact ? 166.0 : 192.0;
    final illustrationHeight = isCompact ? 218.0 : 246.0;
    final titleSize = isCompact ? 27.0 : 29.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
          children: [
            const _ModuleThreeBrandHeader(),
            const SizedBox(height: 13),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEnglish ? 'Module 5' : 'मॉड्यूल 5',
                          style: const TextStyle(
                            color: _navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isEnglish
                              ? 'Recovery\nExercises'
                              : 'रिकवरी\nएक्सरसाइज',
                          style: TextStyle(
                            color: _navy,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w900,
                            height: 1.06,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          isEnglish
                              ? 'Simple exercises and\nmovement tips for a\nsafe and faster recovery.'
                              : 'सुरक्षित और तेज रिकवरी\nके लिए आसान एक्सरसाइज\nऔर चलने के सुझाव।',
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            height: 1.52,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  width: illustrationWidth,
                  height: illustrationHeight,
                  child: Image.asset(
                    'assets/images/module5_walking.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 27),
            for (var i = 0; i < _items.length; i++) ...[
              _ModuleFiveListTile(
                spec: _items[i],
                language: language,
                onTap: () {
                  if (i >= module.lessons.length) {
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(
                        module: module,
                        lesson: module.lessons[i],
                        language: language,
                        onLanguageChanged: onLanguageChanged,
                      ),
                    ),
                  );
                },
              ),
              if (i != _items.length - 1) const SizedBox(height: 28),
            ],
          ],
        ),
      ),
    );
  }
}

class _ModuleFiveItemSpec {
  const _ModuleFiveItemSpec({
    required this.title,
    required this.hindiTitle,
    required this.color,
    required this.icon,
  });

  final String title;
  final String hindiTitle;
  final Color color;
  final IconData icon;

  String titleFor(AppLanguage language) {
    return language == AppLanguage.english ? title : hindiTitle;
  }
}

class _ModuleFiveListTile extends StatelessWidget {
  const _ModuleFiveListTile({
    required this.spec,
    required this.language,
    required this.onTap,
  });

  final _ModuleFiveItemSpec spec;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: spec.color,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: spec.color.withValues(alpha: 0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(spec.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              spec.titleFor(language),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF151515),
                fontSize: 16,
                fontWeight: FontWeight.w900,
                height: 1.42,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF123256),
            size: 28,
          ),
        ],
      ),
    );
  }
}

class _ModuleSixScreen extends StatelessWidget {
  const _ModuleSixScreen({
    required this.module,
    required this.language,
    required this.onLanguageChanged,
  });

  static const _navy = Color(0xFF10164F);
  static const _items = [
    _ModuleSixItemSpec(
      title: 'Travel Tips',
      hindiTitle: 'यात्रा के सुझाव',
      color: Color(0xFF078B2F),
    ),
    _ModuleSixItemSpec(
      title: 'Managing Ostomy During\nLong Travel',
      hindiTitle: 'लंबी यात्रा में\nओस्टॉमी संभालना',
      color: Color(0xFF168AF2),
    ),
    _ModuleSixItemSpec(
      title: 'Public Restroom\nManagement',
      hindiTitle: 'पब्लिक टॉयलेट\nका उपयोग',
      color: Color(0xFF5E43C8),
    ),
    _ModuleSixItemSpec(
      title: 'Transportation & Safety',
      hindiTitle: 'यातायात और सुरक्षा',
      color: Color(0xFFFF5A00),
    ),
    _ModuleSixItemSpec(
      title: 'Car Seat Belt Adjustment',
      hindiTitle: 'कार सीट बेल्ट ठीक करना',
      color: Color(0xFFFF9700),
    ),
    _ModuleSixItemSpec(
      title: 'Clothing Tips',
      hindiTitle: 'कपड़ों के सुझाव',
      color: Color(0xFF1197A2),
    ),
    _ModuleSixItemSpec(
      title: 'Intimacy & Relationships',
      hindiTitle: 'नजदीकी संबंध और रिश्ते',
      color: Color(0xFFE91E63),
    ),
    _ModuleSixItemSpec(
      title: 'Return to Work',
      hindiTitle: 'काम पर वापसी',
      color: Color(0xFF0864B8),
    ),
    _ModuleSixItemSpec(
      title: 'Carrying Supplies\nDiscreetly',
      hindiTitle: 'सामान चुपचाप\nसाथ रखना',
      color: Color(0xFF00897B),
    ),
    _ModuleSixItemSpec(
      title: 'Sports & Physical\nActivity',
      hindiTitle: 'खेल और शारीरिक\nगतिविधि',
      color: Color(0xFF5F9F99),
    ),
  ];

  final ModuleData module;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 390;
    final illustrationWidth = isCompact ? 150.0 : 176.0;
    final illustrationHeight = isCompact ? 236.0 : 276.0;
    final titleSize = isCompact ? 27.0 : 29.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
          children: [
            const _ModuleThreeBrandHeader(),
            const SizedBox(height: 13),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 43),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEnglish ? 'Module 6' : 'मॉड्यूल 6',
                          style: const TextStyle(
                            color: _navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isEnglish ? 'Everyday\nTips' : 'रोज़मर्रा\nके सुझाव',
                          style: TextStyle(
                            color: _navy,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w900,
                            height: 1.06,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          isEnglish
                              ? 'Daily life tips for travel,\nclothing, work, and living\nconfidently with a stoma.'
                              : 'यात्रा, कपड़े, काम और\nस्टोमा के साथ आत्मविश्वास\nसे रहने के आसान सुझाव।',
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            height: 1.52,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  width: illustrationWidth,
                  height: illustrationHeight,
                  child: Image.asset(
                    'assets/images/module6_everyday_tips.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 27),
            for (var i = 0; i < _items.length; i++) ...[
              _ModuleSixListTile(
                number: i + 1,
                spec: _items[i],
                language: language,
                onTap: () {
                  if (i >= module.lessons.length) {
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(
                        module: module,
                        lesson: module.lessons[i],
                        language: language,
                        onLanguageChanged: onLanguageChanged,
                      ),
                    ),
                  );
                },
              ),
              if (i != _items.length - 1) const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}

class _ModuleSixItemSpec {
  const _ModuleSixItemSpec({
    required this.title,
    required this.hindiTitle,
    required this.color,
  });

  final String title;
  final String hindiTitle;
  final Color color;

  String titleFor(AppLanguage language) {
    return language == AppLanguage.english ? title : hindiTitle;
  }
}

class _ModuleSixListTile extends StatelessWidget {
  const _ModuleSixListTile({
    required this.number,
    required this.spec,
    required this.language,
    required this.onTap,
  });

  final int number;
  final _ModuleSixItemSpec spec;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: spec.color,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: spec.color.withValues(alpha: 0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              spec.titleFor(language),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF151515),
                fontSize: 16,
                fontWeight: FontWeight.w900,
                height: 1.42,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF123256),
            size: 28,
          ),
        ],
      ),
    );
  }
}

class _ModuleSevenScreen extends StatelessWidget {
  const _ModuleSevenScreen({
    required this.module,
    required this.language,
    required this.onLanguageChanged,
  });

  static const _navy = Color(0xFF10164F);
  static const _items = [
    _ModuleSevenItemSpec(
      title: 'Stoma-Related Changes',
      hindiTitle: 'स्टोमा से जुड़े बदलाव',
      color: Color(0xFFE53935),
    ),
    _ModuleSevenItemSpec(
      title: 'Output Problems',
      hindiTitle: 'आउटपुट की समस्याएं',
      color: Color(0xFFF57C00),
    ),
    _ModuleSevenItemSpec(
      title: 'Signs of Dehydration',
      hindiTitle: 'डिहाइड्रेशन के संकेत',
      color: Color(0xFF168AF2),
    ),
    _ModuleSevenItemSpec(
      title: 'Skin Problems Around Stoma',
      hindiTitle: 'स्टोमा के आसपास की समस्याएं',
      color: Color(0xFF2E7D32),
    ),
    _ModuleSevenItemSpec(
      title: 'Pain & Discomfort',
      hindiTitle: 'दर्द और असुविधा',
      color: Color(0xFF5E43C8),
    ),
    _ModuleSevenItemSpec(
      title: 'Signs of Infection',
      hindiTitle: 'संक्रमण के संकेत',
      color: Color(0xFF00897B),
    ),
    _ModuleSevenItemSpec(
      title: 'Gastrointestinal Symptoms',
      hindiTitle: 'पाचन संबंधी लक्षण',
      color: Color(0xFF0864B8),
    ),
    _ModuleSevenItemSpec(
      title: 'Emergency Signs',
      hindiTitle: 'आपात संकेत',
      color: Color(0xFFD32F2F),
    ),
  ];

  final ModuleData module;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 390;
    final illustrationWidth = isCompact ? 150.0 : 176.0;
    final illustrationHeight = isCompact ? 176.0 : 202.0;
    final titleSize = isCompact ? 27.0 : 29.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
          children: [
            const _ModuleThreeBrandHeader(),
            const SizedBox(height: 13),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEnglish ? 'Module 7' : 'मॉड्यूल 7',
                          style: const TextStyle(
                            color: _navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isEnglish ? 'Warning\nSigns' : 'चेतावनी\nसंकेत',
                          style: TextStyle(
                            color: _navy,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w900,
                            height: 1.06,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          isEnglish
                              ? 'Recognize early danger\nsigns, stoma changes,\nand seek help quickly.'
                              : 'खतरे के शुरुआती संकेत,\nस्टोमा में बदलाव पहचानें\nऔर तुरंत सहायता लें।',
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            height: 1.52,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  width: illustrationWidth,
                  height: illustrationHeight,
                  child: Image.asset(
                    'assets/images/module7_patient.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 27),
            for (var i = 0; i < _items.length; i++) ...[
              _ModuleSevenListTile(
                number: i + 1,
                spec: _items[i],
                language: language,
                onTap: () {
                  if (i >= module.lessons.length) {
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(
                        module: module,
                        lesson: module.lessons[i],
                        language: language,
                        onLanguageChanged: onLanguageChanged,
                      ),
                    ),
                  );
                },
              ),
              if (i != _items.length - 1) const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}

class _ModuleSevenItemSpec {
  const _ModuleSevenItemSpec({
    required this.title,
    required this.hindiTitle,
    required this.color,
  });

  final String title;
  final String hindiTitle;
  final Color color;

  String titleFor(AppLanguage language) {
    return language == AppLanguage.english ? title : hindiTitle;
  }
}

class _ModuleSevenListTile extends StatelessWidget {
  const _ModuleSevenListTile({
    required this.number,
    required this.spec,
    required this.language,
    required this.onTap,
  });

  final int number;
  final _ModuleSevenItemSpec spec;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: spec.color,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: spec.color.withValues(alpha: 0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              spec.titleFor(language),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF151515),
                fontSize: 16,
                fontWeight: FontWeight.w900,
                height: 1.42,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF123256),
            size: 28,
          ),
        ],
      ),
    );
  }
}

class _ProcedureListTile extends StatelessWidget {
  const _ProcedureListTile({
    required this.number,
    required this.spec,
    required this.language,
    required this.onTap,
  });

  final int number;
  final _ProcedureItemSpec spec;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isReadOnly = spec.icon == Icons.visibility_rounded;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(
              color: spec.color,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: spec.color.withValues(alpha: 0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spec.titleFor(language),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF151515),
                    fontSize: 15.8,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  spec.subtitleFor(language),
                  style: const TextStyle(
                    color: Color(0xFF151515),
                    fontSize: 12.8,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: isReadOnly ? 34 : 31,
            height: isReadOnly ? 34 : 31,
            decoration: BoxDecoration(
              color: isReadOnly ? Colors.transparent : spec.color,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              spec.icon,
              color: isReadOnly ? spec.color : Colors.white,
              size: isReadOnly ? 25 : 22,
            ),
          ),
        ],
      ),
    );
  }
}



class _StomaCareKitIllustration extends StatelessWidget {
  const _StomaCareKitIllustration();

  final double width = 150;
  final double height = 210;
  final bool showShadow = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Green care kit bag
          Container(
            width: 95,
            height: 85,
            margin: const EdgeInsets.only(left: 20, top: 35),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFF2E7D32),
                  size: 22,
                ),
              ),
            ),
          ),
          // Pouch 1 (beige/tan)
          Positioned(
            left: 5,
            top: 10,
            child: Container(
              width: 48,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFF5DEB3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD2B48C), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 6,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEB887),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF8B7355),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Pouch 2 (beige)
          Positioned(
            right: 5,
            top: 5,
            child: Container(
              width: 42,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFEAD9C3),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFC9B8A0), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCDB8A0),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF9B8B7B),
                      width: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // White bottle
          Positioned(
            right: 18,
            top: 15,
            child: Container(
              width: 22,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 4,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 8,
                    height: 6,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC0C0C0),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 3,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4F8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Blue wipes box
          Positioned(
            bottom: 25,
            left: 30,
            child: Container(
              width: 50,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'WIPES',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Scissors
          Positioned(
            bottom: 20,
            right: 10,
            child: Transform.rotate(
              angle: -0.5,
              child: Icon(
                Icons.content_cut_rounded,
                color: const Color(0xFFB0BEC5),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleTwoLessonTile extends StatefulWidget {
  const _ModuleTwoLessonTile({
    required this.number,
    required this.color,
    required this.title,
    required this.onTap,
  });

  final int number;
  final Color color;
  final String title;
  final VoidCallback onTap;

  @override
  State<_ModuleTwoLessonTile> createState() => _ModuleTwoLessonTileState();
}

class _ModuleTwoLessonTileState extends State<_ModuleTwoLessonTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(24),
          onTapDown: (_) {
            setState(() => _isPressed = true);
          },
          onTapCancel: () {
            setState(() => _isPressed = false);
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE8EEF3)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${widget.number}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF162E43),
                      height: 1.3,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: _darken(widget.color, 0.18),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleTwoDisposalBagsOption extends StatelessWidget {
  const _ModuleTwoDisposalBagsOption();

  static const _red = Color(0xFFE4003A);
  static const _softRed = Color(0xFFFFF5F7);
  static const _borderRed = Color(0xFFF9D8E1);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0F1F4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 330;
          final bagSize = compact ? 112.0 : 138.0;
          final badgeSize = compact ? 40.0 : 44.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: BoxDecoration(
                      color: _red,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x2EE4003A),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '4',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Disposal Bags',
                      style: TextStyle(
                        color: _red,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: bagSize,
                    height: bagSize * 1.08,
                    child: const CustomPaint(painter: _DisposalBagPainter()),
                  ),
                  SizedBox(width: compact ? 12 : 18),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DisposalBullet(
                          text: 'Used to safely throw away used pouches',
                        ),
                        SizedBox(height: 18),
                        _DisposalBullet(
                          text: 'Prevents odor and maintains hygiene',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: _softRed,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: _borderRed),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, color: _red, size: 29),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Always dispose in a clean and sealed manner',
                        style: TextStyle(
                          color: _red,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DisposalBullet extends StatelessWidget {
  const _DisposalBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            color: _ModuleTwoDisposalBagsOption._red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF15151B),
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              height: 1.42,
            ),
          ),
        ),
      ],
    );
  }
}

class _DisposalBagPainter extends CustomPainter {
  const _DisposalBagPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final body = Path()
      ..moveTo(w * 0.22, h * 0.25)
      ..quadraticBezierTo(w * 0.15, h * 0.58, w * 0.18, h * 0.88)
      ..quadraticBezierTo(w * 0.5, h * 0.99, w * 0.82, h * 0.88)
      ..quadraticBezierTo(w * 0.85, h * 0.58, w * 0.78, h * 0.25)
      ..close();

    final shadowPaint = Paint()
      ..color = const Color(0x220A629F)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(body.shift(Offset(0, h * 0.02)), shadowPaint);

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [Color(0xFF43C4FF), Color(0xFF0F8EDB), Color(0xFF0878C4)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(body, bodyPaint);

    final outline = Paint()
      ..color = const Color(0xFF056FB6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.025
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(body, outline);

    final top = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.16, h * 0.1, w * 0.68, h * 0.2),
      Radius.circular(w * 0.05),
    );
    final topPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF46C8FF), Color(0xFF0A86D4)],
      ).createShader(top.outerRect);
    canvas.drawRRect(top, topPaint);
    canvas.drawRRect(top, outline);

    final foldPaint = Paint()
      ..color = const Color(0xAA87DDFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.02
      ..strokeCap = StrokeCap.round;
    for (final x in [0.29, 0.42, 0.58, 0.71]) {
      canvas.drawLine(
        Offset(w * x, h * 0.13),
        Offset(w * (x - 0.05), h * 0.28),
        foldPaint,
      );
    }

    final highlight = Paint()
      ..color = const Color(0x4DFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.035
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.31, h * 0.36),
      Offset(w * 0.25, h * 0.76),
      highlight,
    );

    final symbol = TextPainter(
      text: TextSpan(
        text: '\u2623',
        style: TextStyle(
          color: const Color(0xFF061E43),
          fontSize: w * 0.32,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    symbol.paint(canvas, Offset((w - symbol.width) / 2, h * 0.43));

    final label = TextPainter(
      text: TextSpan(
        text: 'DISPOSAL\nBAG',
        style: TextStyle(
          color: const Color(0xFF061E43),
          fontSize: w * 0.11,
          fontWeight: FontWeight.w900,
          height: 1.05,
          letterSpacing: 0,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: w * 0.6);
    label.paint(canvas, Offset((w - label.width) / 2, h * 0.68));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModuleTwoAdhesiveRemoversOption extends StatelessWidget {
  const _ModuleTwoAdhesiveRemoversOption();

  static const _orange = Color(0xFFF57C00);
  static const _softOrange = Color(0xFFFFFBF0);
  static const _borderOrange = Color(0xFFF7E8BE);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0F1F4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 330;
          final bottleWidth = compact ? 104.0 : 126.0;
          final badgeSize = compact ? 40.0 : 44.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: BoxDecoration(
                      color: _orange,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33F57C00),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Adhesive Removers',
                      style: TextStyle(
                        color: _orange,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: bottleWidth,
                    height: bottleWidth * 1.38,
                    child: const CustomPaint(
                      painter: _AdhesiveRemoverBottlePainter(),
                    ),
                  ),
                  SizedBox(width: compact ? 12 : 18),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AdhesiveBullet(
                          text: 'Helps remove pouch easily without pain',
                        ),
                        SizedBox(height: 18),
                        _AdhesiveBullet(text: 'Prevents skin damage'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: _softOrange,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: _borderOrange),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: _orange,
                      size: 30,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Makes pouch removal more comfortable',
                        style: TextStyle(
                          color: _orange,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AdhesiveBullet extends StatelessWidget {
  const _AdhesiveBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            color: _ModuleTwoAdhesiveRemoversOption._orange,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF15151B),
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              height: 1.42,
            ),
          ),
        ),
      ],
    );
  }
}

class _AdhesiveRemoverBottlePainter extends CustomPainter {
  const _AdhesiveRemoverBottlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final shadow = Paint()
      ..color = const Color(0x16000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final outline = Paint()
      ..color = const Color(0xFFB8B8B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.025
      ..strokeJoin = StrokeJoin.round;

    final bottleRect = Rect.fromLTWH(w * 0.22, h * 0.36, w * 0.56, h * 0.56);
    final bottle = RRect.fromRectAndRadius(
      bottleRect,
      Radius.circular(w * 0.1),
    );
    canvas.drawRRect(bottle.shift(Offset(0, h * 0.02)), shadow);

    final bottlePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFFFF), Color(0xFFF1F3F4), Color(0xFFFFFFFF)],
      ).createShader(bottleRect);
    canvas.drawRRect(bottle, bottlePaint);
    canvas.drawRRect(bottle, outline);

    final shoulder = Path()
      ..moveTo(w * 0.3, h * 0.36)
      ..lineTo(w * 0.38, h * 0.28)
      ..lineTo(w * 0.62, h * 0.28)
      ..lineTo(w * 0.7, h * 0.36)
      ..close();
    canvas.drawPath(shoulder, bottlePaint);
    canvas.drawPath(shoulder, outline);

    final capRect = Rect.fromLTWH(w * 0.38, h * 0.12, w * 0.24, h * 0.17);
    final cap = RRect.fromRectAndRadius(capRect, Radius.circular(w * 0.025));
    canvas.drawRRect(cap, Paint()..color = const Color(0xFFF9FAFB));
    canvas.drawRRect(cap, outline);

    final ribPaint = Paint()
      ..color = const Color(0xFFC6C6C6)
      ..strokeWidth = w * 0.012
      ..strokeCap = StrokeCap.round;
    for (final x in [0.42, 0.47, 0.52, 0.57]) {
      canvas.drawLine(
        Offset(w * x, h * 0.14),
        Offset(w * x, h * 0.27),
        ribPaint,
      );
    }

    final neck = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.42, h * 0.05, w * 0.16, h * 0.08),
      Radius.circular(w * 0.018),
    );
    canvas.drawRRect(neck, Paint()..color = const Color(0xFFFDFDFD));
    canvas.drawRRect(neck, outline);

    final nozzle = Path()
      ..moveTo(w * 0.43, h * 0.05)
      ..lineTo(w * 0.46, h * 0.0)
      ..lineTo(w * 0.57, h * 0.0)
      ..lineTo(w * 0.58, h * 0.05)
      ..close();
    canvas.drawPath(nozzle, Paint()..color = const Color(0xFFFDFDFD));
    canvas.drawPath(nozzle, outline);

    final labelRect = Rect.fromLTWH(w * 0.24, h * 0.53, w * 0.52, h * 0.22);
    final label = RRect.fromRectAndRadius(
      labelRect,
      Radius.circular(w * 0.018),
    );
    final labelPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0AA4E8), Color(0xFF087AC5)],
      ).createShader(labelRect);
    canvas.drawRRect(label, labelPaint);

    final labelText = TextPainter(
      text: TextSpan(
        text: 'ADHESIVE\nREMOVER',
        style: TextStyle(
          color: Colors.white,
          fontSize: w * 0.105,
          fontWeight: FontWeight.w900,
          height: 1.08,
          letterSpacing: 0,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: labelRect.width * 0.94);
    labelText.paint(
      canvas,
      Offset(
        labelRect.left + (labelRect.width - labelText.width) / 2,
        labelRect.top + (labelRect.height - labelText.height) / 2,
      ),
    );

    final highlight = Paint()
      ..color = const Color(0x99FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.025
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.31, h * 0.43),
      Offset(w * 0.31, h * 0.83),
      highlight,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModuleTwoProtectiveSkinFilmsOption extends StatelessWidget {
  const _ModuleTwoProtectiveSkinFilmsOption();

  static const _teal = Color(0xFF008C8C);
  static const _softTeal = Color(0xFFF1FBF8);
  static const _borderTeal = Color(0xFFCBEFE8);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0F1F4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 330;
          final bottleWidth = compact ? 104.0 : 124.0;
          final badgeSize = compact ? 40.0 : 44.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: BoxDecoration(
                      color: _teal,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x33008C8C),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '6',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Protective Skin Films',
                      style: TextStyle(
                        color: _teal,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: bottleWidth,
                    height: bottleWidth * 1.42,
                    child: const CustomPaint(
                      painter: _ProtectiveSkinFilmSprayPainter(),
                    ),
                  ),
                  SizedBox(width: compact ? 12 : 18),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProtectiveFilmBullet(
                          text: 'Forms a protective layer on skin',
                        ),
                        SizedBox(height: 12),
                        _ProtectiveFilmBullet(
                          text: 'Reduces irritation and redness',
                        ),
                        SizedBox(height: 12),
                        _ProtectiveFilmBullet(text: 'Helps pouch stick better'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: _softTeal,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: _borderTeal),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.health_and_safety_outlined,
                      color: _teal,
                      size: 30,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Protects skin and improves pouch adhesion',
                        style: TextStyle(
                          color: _teal,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProtectiveFilmBullet extends StatelessWidget {
  const _ProtectiveFilmBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            color: _ModuleTwoProtectiveSkinFilmsOption._teal,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF15151B),
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              height: 1.42,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProtectiveSkinFilmSprayPainter extends CustomPainter {
  const _ProtectiveSkinFilmSprayPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final shadow = Paint()
      ..color = const Color(0x14000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final outline = Paint()
      ..color = const Color(0xFFB9B9B9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.024
      ..strokeJoin = StrokeJoin.round;

    final bottleRect = Rect.fromLTWH(w * 0.24, h * 0.4, w * 0.52, h * 0.52);
    final bottle = RRect.fromRectAndRadius(
      bottleRect,
      Radius.circular(w * 0.09),
    );
    canvas.drawRRect(bottle.shift(Offset(0, h * 0.02)), shadow);
    final bottlePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFFFF), Color(0xFFF4F5F6), Color(0xFFFFFFFF)],
      ).createShader(bottleRect);
    canvas.drawRRect(bottle, bottlePaint);
    canvas.drawRRect(bottle, outline);

    final shoulder = Path()
      ..moveTo(w * 0.31, h * 0.4)
      ..lineTo(w * 0.39, h * 0.32)
      ..lineTo(w * 0.61, h * 0.32)
      ..lineTo(w * 0.69, h * 0.4)
      ..close();
    canvas.drawPath(shoulder, bottlePaint);
    canvas.drawPath(shoulder, outline);

    final labelRect = Rect.fromLTWH(w * 0.27, h * 0.56, w * 0.46, h * 0.23);
    final label = RRect.fromRectAndRadius(labelRect, Radius.circular(w * 0.02));
    final labelPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFBE4), Color(0xFFFFF3A7)],
      ).createShader(labelRect);
    canvas.drawRRect(label, labelPaint);

    final labelText = TextPainter(
      text: TextSpan(
        text: 'SKIN\nPROTECTIVE\nFILM',
        style: TextStyle(
          color: const Color(0xFF101010),
          fontSize: w * 0.09,
          fontWeight: FontWeight.w900,
          height: 1.02,
          letterSpacing: 0,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: labelRect.width * 0.95);
    labelText.paint(
      canvas,
      Offset(
        labelRect.left + (labelRect.width - labelText.width) / 2,
        labelRect.top + (labelRect.height - labelText.height) / 2,
      ),
    );

    final neck = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.41, h * 0.23, w * 0.18, h * 0.1),
      Radius.circular(w * 0.02),
    );
    canvas.drawRRect(neck, Paint()..color = const Color(0xFFFDFDFD));
    canvas.drawRRect(neck, outline);

    final sprayerBase = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.36, h * 0.15, w * 0.28, h * 0.09),
      Radius.circular(w * 0.018),
    );
    canvas.drawRRect(sprayerBase, Paint()..color = const Color(0xFFF4F4F4));
    canvas.drawRRect(sprayerBase, outline);

    final sprayerHead = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.4, h * 0.05, w * 0.18, h * 0.11),
      Radius.circular(w * 0.02),
    );
    canvas.drawRRect(sprayerHead, Paint()..color = const Color(0xFFF8F8F8));
    canvas.drawRRect(sprayerHead, outline);

    final nozzle = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.54, h * 0.07, w * 0.1, h * 0.035),
      Radius.circular(w * 0.012),
    );
    canvas.drawRRect(nozzle, Paint()..color = const Color(0xFFEFEFEF));
    canvas.drawRRect(nozzle, outline);

    final dotPaint = Paint()..color = const Color(0xFF777777);
    canvas.drawCircle(Offset(w * 0.51, h * 0.1), w * 0.018, dotPaint);

    final highlight = Paint()
      ..color = const Color(0x99FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.024
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.32, h * 0.47),
      Offset(w * 0.32, h * 0.84),
      highlight,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModuleTwoCleaningMaterialsOption extends StatelessWidget {
  const _ModuleTwoCleaningMaterialsOption();

  static const _purple = Color(0xFF3F2DC7);
  static const _red = Color(0xFFD7192B);
  static const _softPurple = Color(0xFFF7F5FF);
  static const _borderPurple = Color(0xFFE2DCF8);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFECE9F8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 350;
          final iconSize = compact ? 60.0 : 72.0;
          final badgeSize = compact ? 40.0 : 44.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: BoxDecoration(
                      color: _purple,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x333F2DC7),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '7',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Cleaning Materials',
                      style: TextStyle(
                        color: _purple,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You can use:',
                            style: TextStyle(
                              color: _purple,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _CleaningMaterialItem(
                                  label: 'Clean\nwater',
                                  size: iconSize,
                                  painter: const _CleanWaterGlassPainter(),
                                ),
                              ),
                              Expanded(
                                child: _CleaningMaterialItem(
                                  label: 'Soft cloth\nor gauze',
                                  size: iconSize,
                                  painter: const _SoftClothPainter(),
                                ),
                              ),
                              Expanded(
                                child: _CleaningMaterialItem(
                                  label: 'Mild soap\n(if advised)',
                                  size: iconSize,
                                  painter: const _MildSoapPainter(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      color: const Color(0xFFE5E1F4),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Avoid:',
                            style: TextStyle(
                              color: _red,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _CleaningMaterialItem(
                                  label: 'Harsh\nchemicals',
                                  size: iconSize,
                                  painter: const _ProhibitedBottlePainter(
                                    bottleColor: Color(0xFF1377C9),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _CleaningMaterialItem(
                                  label: 'Alcohol-based\nproducts',
                                  size: iconSize,
                                  painter: const _ProhibitedBottlePainter(
                                    bottleColor: Color(0xFF18A652),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: _softPurple,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: _borderPurple),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.water_drop_outlined, color: _purple, size: 29),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Keep area clean and dry before applying pouch',
                        style: TextStyle(
                          color: _purple,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CleaningMaterialItem extends StatelessWidget {
  const _CleaningMaterialItem({
    required this.label,
    required this.size,
    required this.painter,
  });

  final String label;
  final double size;
  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFDCD7F2), width: 1.5),
          ),
          child: CustomPaint(painter: painter),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF252047),
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}

class _CleanWaterGlassPainter extends CustomPainter {
  const _CleanWaterGlassPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final outline = Paint()
      ..color = const Color(0xFF53586A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.035
      ..strokeJoin = StrokeJoin.round;
    final glass = Path()
      ..moveTo(w * 0.28, h * 0.22)
      ..lineTo(w * 0.72, h * 0.22)
      ..lineTo(w * 0.66, h * 0.78)
      ..lineTo(w * 0.34, h * 0.78)
      ..close();
    canvas.drawPath(glass, Paint()..color = Colors.white);
    canvas.drawPath(glass, outline);
    final water = Path()
      ..moveTo(w * 0.32, h * 0.48)
      ..quadraticBezierTo(w * 0.5, h * 0.43, w * 0.68, h * 0.48)
      ..lineTo(w * 0.63, h * 0.73)
      ..lineTo(w * 0.37, h * 0.73)
      ..close();
    canvas.drawPath(water, Paint()..color = const Color(0xFF8FE5FF));
    canvas.drawPath(
      water,
      Paint()
        ..color = const Color(0xFF1AA6D9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.018,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SoftClothPainter extends CustomPainter {
  const _SoftClothPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = const Color(0xFFBFC0C7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03
      ..strokeJoin = StrokeJoin.round;
    for (var i = 0; i < 4; i++) {
      final dy = h * (0.28 + i * 0.08);
      final cloth = Path()
        ..moveTo(w * 0.23, dy + h * 0.18)
        ..lineTo(w * 0.5, dy)
        ..lineTo(w * 0.78, dy + h * 0.16)
        ..lineTo(w * 0.5, dy + h * 0.34)
        ..close();
      canvas.drawPath(cloth, Paint()..color = Colors.white);
      canvas.drawPath(cloth, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MildSoapPainter extends CustomPainter {
  const _MildSoapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _drawBottle(canvas, size, const Color(0xFF5CC89B), false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProhibitedBottlePainter extends CustomPainter {
  const _ProhibitedBottlePainter({required this.bottleColor});

  final Color bottleColor;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBottle(canvas, size, bottleColor, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _drawBottle(Canvas canvas, Size size, Color color, bool prohibited) {
  final w = size.width;
  final h = size.height;
  final outline = Paint()
    ..color = const Color(0xFF636778)
    ..style = PaintingStyle.stroke
    ..strokeWidth = w * 0.025;
  final bodyRect = Rect.fromLTWH(w * 0.36, h * 0.36, w * 0.28, h * 0.42);
  final body = RRect.fromRectAndRadius(bodyRect, Radius.circular(w * 0.04));
  canvas.drawRRect(body, Paint()..color = Colors.white);
  canvas.drawRRect(body, outline);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.39, h * 0.52, w * 0.22, h * 0.18),
      Radius.circular(w * 0.02),
    ),
    Paint()..color = color,
  );
  canvas.drawRect(
    Rect.fromLTWH(w * 0.43, h * 0.28, w * 0.14, h * 0.08),
    Paint()..color = const Color(0xFFF3F4F6),
  );
  canvas.drawRect(
    Rect.fromLTWH(w * 0.43, h * 0.28, w * 0.14, h * 0.08),
    outline,
  );
  canvas.drawRect(
    Rect.fromLTWH(w * 0.47, h * 0.21, w * 0.06, h * 0.08),
    Paint()..color = const Color(0xFFEFF1F4),
  );
  if (!prohibited) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.39, h * 0.18, w * 0.22, h * 0.05),
        Radius.circular(w * 0.03),
      ),
      Paint()..color = const Color(0xFF90A4AE),
    );
    return;
  }
  final red = Paint()
    ..color = _ModuleTwoCleaningMaterialsOption._red
    ..style = PaintingStyle.stroke
    ..strokeWidth = w * 0.035
    ..strokeCap = StrokeCap.round;
  canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.38, red);
  canvas.drawLine(Offset(w * 0.25, h * 0.25), Offset(w * 0.75, h * 0.75), red);
}

class _ModuleTwoQuickTipsCard extends StatelessWidget {
  const _ModuleTwoQuickTipsCard({required this.language});

  final AppLanguage language;

  static const _green = Color(0xFF087A24);
  static const _softGreen = Color(0xFFF3FBF4);

  static const _tips = [
    _QuickTipSpec(
      text: LocalizedText(
        'Keep all supplies ready before starting care',
        'देखभाल शुरू करने से पहले सभी सामग्रियां तैयार रखें',
      ),
      icon: Icons.medical_services_outlined,
    ),
    _QuickTipSpec(
      text: LocalizedText(
        'Always check expiry of products',
        'हमेशा उत्पादों की समाप्ति तिथि (expiry) की जांच करें',
      ),
      icon: Icons.event_available_rounded,
    ),
    _QuickTipSpec(
      text: LocalizedText(
        'Store items in a clean and dry place',
        'सामग्रियों को साफ और सूखी जगह पर संग्रहीत करें',
      ),
      icon: Icons.inventory_2_outlined,
    ),
    _QuickTipSpec(
      text: LocalizedText(
        'Carry a small kit when going outside',
        'बाहर जाते समय एक छोटी किट साथ रखें',
      ),
      icon: Icons.business_center_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3EFE5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 370;
          final personWidth = compact ? 112.0 : 148.0;

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 11),
                decoration: const BoxDecoration(
                  color: _green,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      language == AppLanguage.english ? 'Important Reminder' : 'महत्वपूर्ण अनुस्मारक',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          for (var i = 0; i < _tips.length; i++) ...[
                            _QuickTipRow(spec: _tips[i], language: language),
                            if (i != _tips.length - 1)
                              const Divider(
                                height: 13,
                                thickness: 1,
                                color: Color(0xFFEFF3F0),
                              ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: compact ? 8 : 18),
                    SizedBox(
                      width: personWidth,
                      height: compact ? 200 : 230,
                      child: const CustomPaint(
                        painter: _QuickTipsPersonPainter(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuickTipSpec {
  const _QuickTipSpec({required this.text, required this.icon});

  final LocalizedText text;
  final IconData icon;
}

class _QuickTipRow extends StatelessWidget {
  const _QuickTipRow({required this.spec, required this.language});

  final _QuickTipSpec spec;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: Color(0xFF2BAF2B),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            spec.text.value(language),
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 14.2,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _ModuleTwoQuickTipsCard._softGreen,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFDCEFE0)),
          ),
          child: Icon(
            spec.icon,
            color: _ModuleTwoQuickTipsCard._green,
            size: 28,
          ),
        ),
      ],
    );
  }
}

class _QuickTipsPersonPainter extends CustomPainter {
  const _QuickTipsPersonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final green = Paint()..color = const Color(0xFF0E7D31);
    final darkGreen = Paint()..color = const Color(0xFF075F25);
    final skin = Paint()..color = const Color(0xFFFFC28D);
    final hair = Paint()..color = const Color(0xFF101827);
    final line = Paint()
      ..color = const Color(0xFF0B4520)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.018
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.27, h * 0.39, w * 0.5, h * 0.54),
        Radius.circular(w * 0.15),
      ),
      green,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.17, h * 0.42, w * 0.12, h * 0.48),
        Radius.circular(w * 0.06),
      ),
      skin,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.72, h * 0.42, w * 0.13, h * 0.31),
        Radius.circular(w * 0.06),
      ),
      skin,
    );

    canvas.drawCircle(Offset(w * 0.5, h * 0.22), w * 0.17, skin);
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.31, h * 0.16)
        ..quadraticBezierTo(w * 0.4, h * 0.01, w * 0.62, h * 0.08)
        ..quadraticBezierTo(w * 0.78, h * 0.15, w * 0.66, h * 0.27)
        ..quadraticBezierTo(w * 0.5, h * 0.19, w * 0.32, h * 0.22)
        ..close(),
      hair,
    );

    final faceLine = Paint()
      ..color = const Color(0xFF1F2937)
      ..strokeWidth = w * 0.014
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(w * 0.44, h * 0.22), w * 0.012, faceLine);
    canvas.drawCircle(Offset(w * 0.57, h * 0.22), w * 0.012, faceLine);
    canvas.drawArc(
      Rect.fromLTWH(w * 0.44, h * 0.27, w * 0.14, h * 0.07),
      0.15,
      2.8,
      false,
      faceLine,
    );

    canvas.drawLine(
      Offset(w * 0.33, h * 0.44),
      Offset(w * 0.5, h * 0.92),
      line,
    );
    canvas.drawLine(
      Offset(w * 0.69, h * 0.44),
      Offset(w * 0.5, h * 0.92),
      line,
    );

    final bagRect = Rect.fromLTWH(w * 0.3, h * 0.62, w * 0.55, h * 0.29);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bagRect, Radius.circular(w * 0.08)),
      darkGreen,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.39, h * 0.56, w * 0.28, h * 0.11),
        Radius.circular(w * 0.08),
      ),
      Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.035,
    );
    canvas.drawArc(
      Rect.fromLTWH(w * 0.39, h * 0.54, w * 0.28, h * 0.18),
      3.2,
      3.0,
      false,
      Paint()
        ..color = const Color(0xFF0B4520)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.035
        ..strokeCap = StrokeCap.round,
    );

    final heart = TextPainter(
      text: TextSpan(
        text: '\u2661',
        style: TextStyle(
          color: Colors.white,
          fontSize: w * 0.22,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    heart.paint(
      canvas,
      Offset(
        bagRect.center.dx - heart.width / 2,
        bagRect.center.dy - heart.height / 2,
      ),
    );

    canvas.drawCircle(Offset(w * 0.76, h * 0.62), w * 0.045, skin);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModuleTwoMeasuringGuideOption extends StatelessWidget {
  const _ModuleTwoMeasuringGuideOption();

  static const _purple = Color(0xFF5A35C8);
  static const _ink = Color(0xFF25185D);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7DDF8), width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _purple,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x245A35C8),
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    'Measuring Guide & Scissors',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.08,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 210,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _GuideColumn(
                    title: 'Measuring guide',
                    body: 'Helps check\nsize of stoma',
                    visual: CustomPaint(painter: _MeasuringGuidePainter()),
                  ),
                ),
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  color: const Color(0xFFE5E0EE),
                ),
                Expanded(
                  child: _GuideColumn(
                    title: 'Scissors',
                    body: 'Used to cut pouch\nopening to correct size',
                    visual: CustomPaint(painter: _ScissorsPainter()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.lightbulb_outline_rounded, color: _purple, size: 32),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Opening should fit closely - not too tight, not too loose.',
                  style: TextStyle(
                    color: _purple,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuideColumn extends StatelessWidget {
  const _GuideColumn({
    required this.title,
    required this.body,
    required this.visual,
  });

  final String title;
  final String body;
  final Widget visual;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _ModuleTwoMeasuringGuideOption._purple,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          body,
          style: const TextStyle(
            color: _ModuleTwoMeasuringGuideOption._ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            height: 1.35,
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.center,
          child: SizedBox(width: 135, height: 116, child: visual),
        ),
      ],
    );
  }
}

class _MeasuringGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.55, size.height * 0.48);
    final outline = Paint()
      ..color = const Color(0xFFD7D7D7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final mark = Paint()
      ..color = const Color(0xFF777777)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, size.width * 0.44, outline);
    for (final radius in [0.34, 0.27, 0.20]) {
      canvas.drawCircle(center, size.width * radius, mark);
    }
    canvas.drawCircle(center, size.width * 0.14, outline..strokeWidth = 2);
    canvas.drawCircle(center.translate(-size.width * 0.33, 0), 3.2, mark);
    canvas.drawCircle(center.translate(size.width * 0.33, 0), 3.2, mark);

    final labels = ['30', '40', '50', '60'];
    for (var i = 0; i < labels.length; i++) {
      final painter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: Color(0xFF5D5D5D),
            fontSize: 7,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset(center.dx - painter.width / 2, center.dy - 45 + (i * 16)),
      );
    }
    final mm = TextPainter(
      text: const TextSpan(
        text: 'mm',
        style: TextStyle(
          color: Color(0xFF444444),
          fontSize: 7,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    mm.paint(canvas, Offset(center.dx - mm.width / 2, center.dy + 55));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScissorsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final steel = Paint()
      ..color = const Color(0xFFD8D8D8)
      ..style = PaintingStyle.fill;
    final edge = Paint()
      ..color = const Color(0xFF4B4B4B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final black = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final cutout = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final bladeTop = Path()
      ..moveTo(size.width * 0.46, size.height * 0.45)
      ..lineTo(size.width * 0.98, size.height * 0.17)
      ..lineTo(size.width * 0.55, size.height * 0.56)
      ..close();
    final bladeBottom = Path()
      ..moveTo(size.width * 0.50, size.height * 0.55)
      ..lineTo(size.width * 0.98, size.height * 0.18)
      ..lineTo(size.width * 0.61, size.height * 0.67)
      ..close();
    canvas.drawPath(bladeTop, steel);
    canvas.drawPath(bladeBottom, steel);
    canvas.drawPath(bladeTop, edge);
    canvas.drawPath(bladeBottom, edge);

    final handle = Path()
      ..moveTo(size.width * 0.48, size.height * 0.48)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.50,
        size.width * 0.18,
        size.height * 0.66,
      )
      ..quadraticBezierTo(
        size.width * 0.03,
        size.height * 0.90,
        size.width * 0.30,
        size.height * 0.90,
      )
      ..quadraticBezierTo(
        size.width * 0.46,
        size.height * 0.89,
        size.width * 0.53,
        size.height * 0.70,
      )
      ..quadraticBezierTo(
        size.width * 0.58,
        size.height * 0.87,
        size.width * 0.76,
        size.height * 0.91,
      )
      ..quadraticBezierTo(
        size.width * 0.98,
        size.height * 0.94,
        size.width * 0.91,
        size.height * 0.75,
      )
      ..quadraticBezierTo(
        size.width * 0.84,
        size.height * 0.56,
        size.width * 0.59,
        size.height * 0.56,
      )
      ..lineTo(size.width * 0.60, size.height * 0.42)
      ..quadraticBezierTo(
        size.width * 0.54,
        size.height * 0.47,
        size.width * 0.48,
        size.height * 0.48,
      )
      ..close();
    canvas.drawPath(handle, black);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.24, size.height * 0.75),
        width: size.width * 0.26,
        height: size.height * 0.20,
      ),
      cutout,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.72, size.height * 0.76),
        width: size.width * 0.28,
        height: size.height * 0.20,
      ),
      cutout,
    );
    canvas.drawCircle(Offset(size.width * 0.61, size.height * 0.47), 4, edge);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QuickTipsTile extends StatefulWidget {
  const _QuickTipsTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<_QuickTipsTile> createState() => _QuickTipsTileState();
}

class _QuickTipsTileState extends State<_QuickTipsTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: const Color(0xFFEFF7EE),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(24),
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapCancel: () => setState(() => _isPressed = false),
          onTapUp: (_) => setState(() => _isPressed = false),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEFF7EE),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFD4E8D8)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2E7D32),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: _darken(const Color(0xFF2E7D32), 0.22),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class _ReferenceLessonTile extends StatelessWidget {
  const _ReferenceLessonTile({
    required this.number,
    required this.color,
    required this.title,
    required this.onTap,
  });

  final int number;
  final Color color;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final referenceColor = switch (number) {
      1 => const Color(0xFF22B72E),
      2 => const Color(0xFF129BFF),
      3 => const Color(0xFF7B5CE8),
      4 => const Color(0xFFFF3B4F),
      5 => const Color(0xFFFFA515),
      6 => const Color(0xFF10AFC2),
      _ => color,
    };

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 2, 8, 2),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: referenceColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: referenceColor.withValues(alpha: 0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: number == 6
                  ? const Icon(
                      Icons.water_drop_rounded,
                      color: Colors.white,
                      size: 23,
                    )
                  : Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: number == 6 ? 15.2 : 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF171717),
                  height: 1.25,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: _darken(referenceColor, 0.18),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class LessonScreen extends StatelessWidget {
  const LessonScreen({
    super.key,
    required this.module,
    required this.lesson,
    required this.language,
    required this.onLanguageChanged,
  });

  final ModuleData module;
  final LessonData lesson;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      activeModuleNotifier.value = module;
    });
    return LanguageConsumer(
      builder: (context, language) {
        final lessonIndex = module.lessons.indexWhere((l) => l.title.en == lesson.title.en);

        if (module.number == 5 && (module.lessons.isEmpty || lessonIndex == 0 || lesson.title.en.contains('Early Ambulation'))) {
          return ModuleFiveEarlyAmbulationScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 5 && (lessonIndex == 1 || lesson.title.en.contains('Abdominal Strengthening'))) {
          return ModuleFiveAbdominalStrengtheningScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 5 && (lessonIndex == 2 || lesson.title.en.contains('Hernia Prevention'))) {
          return ModuleFiveHerniaPreventionScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 5 && (lessonIndex == 3 || lesson.title.en.contains('Lifting'))) {
          return ModuleFiveLiftingPrecautionsScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 5 && (lessonIndex == 4 || lesson.title.en.contains('Timeline') || lesson.title.en.contains('Progression'))) {
          return ModuleFiveActivityTimelineScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 5 && (lessonIndex == 5 || lesson.title.en.contains('Stop') || lesson.title.en.contains('Nurse'))) {
          return ModuleFiveStopExerciseScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 6 &&
            (lesson.title.en.toLowerCase().contains('travel tips') ||
             lesson.title.hi.contains('यात्रा के सुझाव'))) {
          return ModuleSixTravelTipsScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 6 &&
            (lesson.title.en.toLowerCase().contains('managing') ||
             lesson.title.en.toLowerCase().contains('long travel') ||
             lesson.title.hi.contains('लंबी यात्रा'))) {
          return ModuleSixManagingTravelScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 6 &&
            (lesson.title.en.toLowerCase().contains('restroom') ||
             lesson.title.hi.contains('शौचालय'))) {
          return ModuleSixRestroomManagementScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 6 &&
            (lesson.title.en.toLowerCase().contains('transportation') ||
             lesson.title.hi.contains('परिवहन') ||
             lesson.title.hi.contains('सुरक्षा'))) {
          return ModuleSixTransportationSafetyScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 6 &&
            (lesson.title.en.toLowerCase().contains('car seat belt') ||
             lesson.title.en.toLowerCase().contains('seat belt') ||
             lesson.title.hi.contains('सीट बेल्ट'))) {
          return ModuleSixSeatBeltAdjustmentScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 6 &&
            (lesson.title.en.toLowerCase().contains('sports') ||
             lesson.title.en.toLowerCase().contains('physical activity') ||
             lesson.title.hi.contains('खेल और शारीरिक'))) {
          return ModuleSixSportsActivityScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 6 &&
            (lesson.title.en.toLowerCase().contains('clothing') ||
             lesson.title.hi.contains('कपड़ों के सुझाव'))) {
          return ModuleSixClothingTipsScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 6 &&
            (lesson.title.en.toLowerCase().contains('intimacy') ||
             lesson.title.hi.contains('निकटता और रिश्ते'))) {
          return ModuleSixIntimacyRelationshipsScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 6 &&
            (lesson.title.en.toLowerCase().contains('return to work') ||
             lesson.title.hi.contains('काम पर वापसी'))) {
          return ModuleSixReturnToWorkScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 6 &&
            (lesson.title.en.toLowerCase().contains('carrying supplies') ||
             lesson.title.en.toLowerCase().contains('supplies discreetly') ||
             lesson.title.hi.contains('सामान को गोपनीय'))) {
          return ModuleSixCarryingSuppliesScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 1 && lessonIndex == 0) {
          return _ModuleOneOstomyLessonScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 1 && lessonIndex == 1) {
          return _ModuleOneTypesLessonScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 1 && lessonIndex == 2) {
          return _ModuleOneAnatomyLessonScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 1 && lessonIndex == 3) {
          return _ModuleOneLessonFourScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 1 && lessonIndex == 4) {
          return _ModuleOneExpectedChangesScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 1 && lessonIndex == 5) {
          return _ModuleOneOutputLessonScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 2 && lessonIndex == 0) {
          return _ModuleTwoTypesOstomyBagsScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 2 && lessonIndex == 1) {
          return _ModuleTwoSkinBarrierProductsScreen(
            language: language,
            lesson: lesson,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 2 && lessonIndex == 2) {
          return _ModuleTwoMeasuringGuideScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 2 && lessonIndex == 3) {
          return _ModuleTwoDisposalBagsScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 2 && lessonIndex == 4) {
          return _ModuleTwoAdhesiveRemoversScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 2 && lessonIndex == 5) {
          return _ModuleTwoProtectiveSkinFilmsScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 2 && lessonIndex == 6) {
          return _ModuleTwoCleaningMaterialsScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 4 && lessonIndex == 0) {
          return _ModuleFourDietPlanDetailScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 4 && lessonIndex == 1) {
          return _ModuleFourHydrationDetailScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 4 && lessonIndex == 2) {
          return _ModuleFourThickeningFoodsDetailScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 4 && lessonIndex == 3) {
          return _ModuleFourLooseningFoodsDetailScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 4 && lessonIndex == 4) {
          return _ModuleFourAvoidFoodsDetailScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 4 && lessonIndex == 5) {
          return _ModuleFourOdorGasDetailScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 4 && lessonIndex == 6) {
          return _ModuleFourContactNurseDetailScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 4 && lessonIndex == 7) {
          return _ModuleFourQuickTipsDetailScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        // Module 1 Option 4 is already handled above
        if (module.number == 7 && lessonIndex == 0) {
          return _ModuleSevenLessonOneScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 7 && lessonIndex == 1) {
          return _ModuleSevenLessonTwoScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 7 && lessonIndex == 2) {
          return _ModuleSevenLessonThreeScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 7 && lessonIndex == 3) {
          return _ModuleSevenLessonFourScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 7 && lessonIndex == 4) {
          return _ModuleSevenLessonFiveScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 7 && lessonIndex == 5) {
          return _ModuleSevenLessonSixScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 7 && lessonIndex == 6) {
          return _ModuleSevenLessonSevenScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }
        if (module.number == 7 && lessonIndex == 7) {
          return _ModuleSevenLessonEightScreen(
            language: language,
            onLanguageChanged: onLanguageChanged,
          );
        }

        final text = AppText(language);

        return Scaffold(
          appBar: AppBar(
            title: Text(lesson.title.value(language)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _LanguageChip(
                  language: language,
                  onLanguageChanged: onLanguageChanged,
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      lesson.color.withValues(alpha: 0.96),
                      _darken(lesson.color, 0.18),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title.value(language),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            lesson.summary.value(language),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        module.imageAsset,
                        fit: BoxFit.cover,
                        alignment: module.lessonImageAlignment,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _InfoBanner(
                color: lesson.color,
                title: text.quickSummary,
                body: lesson.summary.value(language),
              ),
              const SizedBox(height: 16),
              _TextCard(
                title: text.keyPoints,
                color: lesson.color,
                items: lesson.points.map((item) => item.value(language)).toList(),
              ),
              if (lesson.tips.isNotEmpty) ...[
                const SizedBox(height: 16),
                _TextCard(
                  title: text.tips,
                  color: const Color(0xFF2E7D32),
                  items: lesson.tips.map((item) => item.value(language)).toList(),
                  icon: Icons.lightbulb_outline,
                ),
              ],
              if (lesson.warnings.isNotEmpty) ...[
                const SizedBox(height: 16),
                _TextCard(
                  title: text.caution,
                  color: const Color(0xFFD84315),
                  items: lesson.warnings
                      .map((item) => item.value(language))
                      .toList(),
                  icon: Icons.warning_amber_rounded,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ModuleTwoDisposalBagsScreen extends StatelessWidget {
  const _ModuleTwoDisposalBagsScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        surfaceTintColor: const Color(0xFFF8FAFC),
        elevation: 0,
        title: Text(
          isEnglish ? 'Disposal Bags' : 'डिस्पोजल बैग',
          style: const TextStyle(
            color: Color(0xFF162E43),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: const [_ModuleTwoDisposalBagsOption()],
        ),
      ),
    );
  }
}

class _ModuleTwoAdhesiveRemoversScreen extends StatelessWidget {
  const _ModuleTwoAdhesiveRemoversScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        surfaceTintColor: const Color(0xFFF8FAFC),
        elevation: 0,
        title: Text(
          isEnglish ? 'Adhesive Removers' : 'एडहेसिव रिमूवर',
          style: const TextStyle(
            color: Color(0xFF162E43),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: const [_ModuleTwoAdhesiveRemoversOption()],
        ),
      ),
    );
  }
}

class _ModuleTwoProtectiveSkinFilmsScreen extends StatelessWidget {
  const _ModuleTwoProtectiveSkinFilmsScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        surfaceTintColor: const Color(0xFFF8FAFC),
        elevation: 0,
        title: Text(
          isEnglish ? 'Protective Skin Films' : 'प्रोटेक्टिव स्किन फिल्म',
          style: const TextStyle(
            color: Color(0xFF162E43),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: const [_ModuleTwoProtectiveSkinFilmsOption()],
        ),
      ),
    );
  }
}

class _ModuleTwoCleaningMaterialsScreen extends StatelessWidget {
  const _ModuleTwoCleaningMaterialsScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        surfaceTintColor: const Color(0xFFF8FAFC),
        elevation: 0,
        title: Text(
          isEnglish ? 'Cleaning Materials' : 'सफाई सामग्री',
          style: const TextStyle(
            color: Color(0xFF162E43),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: const [_ModuleTwoCleaningMaterialsOption()],
        ),
      ),
    );
  }
}

class _ModuleTwoQuickTipsScreen extends StatelessWidget {
  const _ModuleTwoQuickTipsScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        surfaceTintColor: const Color(0xFFF8FAFC),
        elevation: 0,
        title: Text(
          isEnglish ? 'Quick Help' : 'त्वरित सहायता',
          style: const TextStyle(
            color: Color(0xFF162E43),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          children: [
            _ModuleTwoQuickTipsCard(language: language),
          ],
        ),
      ),
    );
  }
}

class _ModuleOneOstomyLessonScreen extends StatelessWidget {
  const _ModuleOneOstomyLessonScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: _LanguageChip(
                language: language,
                onLanguageChanged: onLanguageChanged,
              ),
            ),
            const SizedBox(height: 12),
            _OstomyLessonHeader(language: language),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 10),
              child: Text(
                isEnglish
                    ? 'An ostomy is a surgical procedure in which an '
                          'opening (called a stoma) is made on the abdomen '
                          'to allow waste (stool) to come out of the body.'
                    : 'ओस्टॉमी एक सर्जिकल प्रक्रिया है जिसमें पेट पर एक '
                          'खुला भाग (जिसे स्टोमा कहते हैं) बनाया जाता है, '
                          'जिससे मल शरीर से बाहर आ सके।',
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.28,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _OstomyProcessRow(language: language),
            const SizedBox(height: 20),
            _OstomyLessonQuote(language: language),
          ],
        ),
      ),
    );
  }
}

class _OstomyLessonHeader extends StatelessWidget {
  const _OstomyLessonHeader({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF18A935),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: const Text(
            '1',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            isEnglish ? 'What is an Ostomy?' : 'ओस्टॉमी क्या है?',
            style: const TextStyle(
              color: Color(0xFF052C10),
              fontSize: 25,
              height: 1.1,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _OstomyProcessRow extends StatelessWidget {
  const _OstomyProcessRow({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _OstomyStep(
            visual: const _IntestineIllustration(),
            label: isEnglish
                ? 'The stoma is\nconnected to\nthe intestine'
                : 'स्टोमा\nआंत से\nजुड़ा होता है',
          ),
        ),
        const _GreenArrow(),
        Expanded(
          child: _OstomyStep(
            visual: const _StomaBagIllustration(),
            label: isEnglish
                ? 'Waste is collected\nin a stoma bag\n(pouch)'
                : 'मल स्टोमा बैग\n(पाउच) में\nइकट्ठा होता है',
          ),
        ),
        const _GreenArrow(),
        Expanded(
          child: _OstomyStep(
            visual: const _CalendarIllustration(),
            label: isEnglish
                ? 'It may be temporary\nor permanent,\ndepending on your\ncondition'
                : 'यह आपकी स्थिति\nके अनुसार अस्थायी\nया स्थायी हो\nसकता है',
          ),
        ),
      ],
    );
  }
}

class _OstomyStep extends StatelessWidget {
  const _OstomyStep({required this.visual, required this.label});

  final Widget visual;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFFEF8),
            border: Border.all(color: const Color(0xFF96D7A5), width: 1.2),
          ),
          alignment: Alignment.center,
          child: visual,
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13.5,
            height: 1.23,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _GreenArrow extends StatelessWidget {
  const _GreenArrow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Icon(
        Icons.arrow_forward_rounded,
        color: Color(0xFF16A334),
        size: 32,
      ),
    );
  }
}

class _IntestineIllustration extends StatelessWidget {
  const _IntestineIllustration();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(72, 72), painter: _IntestinePainter());
  }
}

class _StomaBagIllustration extends StatelessWidget {
  const _StomaBagIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 56,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE6D2),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE9B483)),
          ),
        ),
        Positioned(
          top: 20,
          child: Container(
            width: 36,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF5E5D1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFC7A481)),
            ),
          ),
        ),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD71E24),
            border: Border.all(color: const Color(0xFFFFB2A8), width: 4),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF7A0308),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CalendarIllustration extends StatelessWidget {
  const _CalendarIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 62,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Column(
            children: [
              Container(
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4B50),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: _CalendarGrid(),
                ),
              ),
            ],
          ),
        ),
        const Positioned(top: -6, left: 10, child: _CalendarRing()),
        const Positioned(top: -6, right: 10, child: _CalendarRing()),
        Positioned(
          right: -8,
          bottom: -8,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF36BA5D),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        9,
        (_) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE9E9E9),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _CalendarRing extends StatelessWidget {
  const _CalendarRing();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 16,
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _OstomyLessonQuote extends StatelessWidget {
  const _OstomyLessonQuote({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFF9ED7A7)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: Color(0xFF25A347),
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isEnglish
                  ? '"A new way for your body to pass stool safely."'
                  : '"आपके शरीर से मल सुरक्षित रूप से बाहर आने का नया रास्ता।"',
              style: const TextStyle(
                color: Color(0xFF19803B),
                fontSize: 15,
                height: 1.2,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleOneTypesLessonScreen extends StatelessWidget {
  const _ModuleOneTypesLessonScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF1E2939),
                    size: 26,
                  ),
                ),
                _LanguageChip(
                  language: language,
                  onLanguageChanged: onLanguageChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomPaint(
                    size: const Size(28, 20),
                    painter: const _HeaderLeafPainter(isLeft: true),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isEnglish ? '2. TYPES OF OSTOMY' : '2. ओस्टॉमी के प्रकार',
                    style: const TextStyle(
                      color: Color(0xFF0F1A3C),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomPaint(
                    size: const Size(28, 20),
                    painter: const _HeaderLeafPainter(isLeft: false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: 180,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1.2,
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                    Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF94A3B8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1.2,
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                isEnglish
                    ? 'Ostomy is a surgically created opening (stoma) on the abdomen to help stool or waste pass out when the bowel cannot work normally.'
                    : 'ओस्टॉमी पेट पर शल्य चिकित्सा द्वारा बनाया गया एक मार्ग (स्टोमा) है जो आंत के सामान्य रूप से काम न करने पर मल या अपशिष्ट को बाहर निकालने में मदद करता है।',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 28),
            LayoutBuilder(
              builder: (context, constraints) {
                final useTwoColumns = constraints.maxWidth > 650;

                if (useTwoColumns) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildIleostomyCard(isEnglish),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildColostomyCard(isEnglish),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildIleostomyCard(isEnglish),
                      const SizedBox(height: 24),
                      _buildColostomyCard(isEnglish),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            _buildBottomBanner(isEnglish),
          ],
        ),
      ),
    );
  }

  Widget _buildIleostomyCard(bool isEnglish) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBF6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFCBE5CA),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 14),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6E9F6E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isEnglish ? 'ILEOSTOMY' : 'इलियोस्टॉमी',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 190,
              height: 195,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Image.asset(
                'assets/images/module1_ileostomy_anatomy.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                _buildInfoRow(
                  iconWidget: CustomPaint(
                    size: const Size(20, 20),
                    painter: const _IntestineIconPainter(),
                  ),
                  text: isEnglish
                      ? 'Opening made from the small intestine'
                      : 'छोटी आंत से बना हुआ मार्ग',
                  isGreen: true,
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  iconData: Icons.water_drop_rounded,
                  text: isEnglish
                      ? 'Output is liquid or semi-liquid'
                      : 'आउटपुट तरल या अर्ध-तरल होता है',
                  isGreen: true,
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  iconData: Icons.calendar_month_rounded,
                  text: isEnglish
                      ? 'Needs more frequent emptying'
                      : 'अधिक बार खाली करने की आवश्यकता होती है',
                  isGreen: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColostomyCard(bool isEnglish) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6FAFE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFCBE2F5),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 14),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF4D8AC8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isEnglish ? 'COLOSTOMY' : 'कोलोस्टॉमी',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 190,
              height: 195,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Image.asset(
                'assets/images/module1_colostomy_anatomy.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                _buildInfoRow(
                  iconWidget: CustomPaint(
                    size: const Size(22, 22),
                    painter: const _LargeBowelIconPainter(),
                  ),
                  text: isEnglish
                      ? 'Opening made from the large intestine'
                      : 'बड़ी आंत से बना हुआ मार्ग',
                  isGreen: false,
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  iconWidget: CustomPaint(
                    size: const Size(18, 18),
                    painter: const _StoolIconPainter(color: Color(0xFF2E7CCB)),
                  ),
                  text: isEnglish
                      ? 'Output is semi-solid or formed stool'
                      : 'आउटपुट अर्ध-ठोस या बना हुआ मल होता है',
                  isGreen: false,
                ),
                const SizedBox(height: 10),
                _buildInfoRow(
                  iconData: Icons.calendar_month_rounded,
                  text: isEnglish
                      ? 'Emptying is less frequent'
                      : 'कम बार खाली करने की आवश्यकता होती है',
                  isGreen: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    IconData? iconData,
    Widget? iconWidget,
    required String text,
    required bool isGreen,
  }) {
    final panelBgColor = isGreen ? const Color(0xFFECF6EC) : const Color(0xFFEBF3FC);
    final iconCircleBgColor = isGreen ? const Color(0xFFD3EBD2) : const Color(0xFFD0E3FA);
    final iconColor = isGreen ? const Color(0xFF4C9F4E) : const Color(0xFF2E7CCB);

    return Container(
      decoration: BoxDecoration(
        color: panelBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconCircleBgColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: iconWidget ??
                Icon(
                  iconData,
                  color: iconColor,
                  size: 20,
                ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF1E2939),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBanner(bool isEnglish) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF7C3AED),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isEnglish
                  ? 'Both types of ostomy help in living a healthy and active life with proper care and support.'
                  : 'दोनों प्रकार की ओस्टॉमी उचित देखभाल और सहायता के साथ स्वस्थ और सक्रिय जीवन जीने में मदद करती हैं।',
              style: const TextStyle(
                color: Color(0xFF5B21B6),
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntestineIconPainter extends CustomPainter {
  const _IntestineIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4C9F4E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.35, size.height * 0.25, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.65, size.height * 0.75, size.width * 0.8, size.height * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LargeBowelIconPainter extends CustomPainter {
  const _LargeBowelIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E7CCB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..lineTo(size.width * 0.2, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.2, size.width * 0.3, size.height * 0.2)
      ..lineTo(size.width * 0.7, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.2, size.width * 0.8, size.height * 0.3)
      ..lineTo(size.width * 0.8, size.height * 0.8);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeaderLeafPainter extends CustomPainter {
  const _HeaderLeafPainter({required this.isLeft});
  final bool isLeft;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final stemPaint = Paint()
      ..color = const Color(0xFFC2D9C6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()
      ..color = const Color(0xFFFCDFD2)
      ..style = PaintingStyle.fill;

    final leafOutlinePaint = Paint()
      ..color = const Color(0xFFF6C3AE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.save();
    if (isLeft) {
      final stemPath = Path()
        ..moveTo(w * 0.1, h * 0.8)
        ..quadraticBezierTo(w * 0.5, h * 0.5, w * 0.9, h * 0.2);
      canvas.drawPath(stemPath, stemPaint);

      final List<Offset> centers = [
        Offset(w * 0.4, h * 0.6),
        Offset(w * 0.7, h * 0.4),
        Offset(w * 0.9, h * 0.2),
      ];

      for (var i = 0; i < centers.length; i++) {
        canvas.drawOval(
          Rect.fromCenter(
            center: centers[i],
            width: 12 + i * 2,
            height: 6 + i * 1.5,
          ),
          leafPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: centers[i],
            width: 12 + i * 2,
            height: 6 + i * 1.5,
          ),
          leafOutlinePaint,
        );
      }
    } else {
      final stemPath = Path()
        ..moveTo(w * 0.9, h * 0.8)
        ..quadraticBezierTo(w * 0.5, h * 0.5, w * 0.1, h * 0.2);
      canvas.drawPath(stemPath, stemPaint);

      final List<Offset> centers = [
        Offset(w * 0.6, h * 0.6),
        Offset(w * 0.3, h * 0.4),
        Offset(w * 0.1, h * 0.2),
      ];

      for (var i = 0; i < centers.length; i++) {
        canvas.drawOval(
          Rect.fromCenter(
            center: centers[i],
            width: 12 + i * 2,
            height: 6 + i * 1.5,
          ),
          leafPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: centers[i],
            width: 12 + i * 2,
            height: 6 + i * 1.5,
          ),
          leafOutlinePaint,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AbdomenPainter extends CustomPainter {
  const _AbdomenPainter({required this.isIleostomy});
  final bool isIleostomy;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final torsoPaint = Paint()
      ..color = const Color(0xFFFFF3EB)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = const Color(0xFFFADCC9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final torsoPath = Path();
    torsoPath.moveTo(w * 0.18, 0);
    torsoPath.cubicTo(
      w * 0.18, h * 0.35,
      w * 0.08, h * 0.50,
      w * 0.10, h * 1.0,
    );
    torsoPath.lineTo(w * 0.90, h * 1.0);
    torsoPath.cubicTo(
      w * 0.92, h * 0.50,
      w * 0.82, h * 0.35,
      w * 0.82, 0,
    );
    torsoPath.close();

    canvas.drawPath(torsoPath, torsoPaint);
    canvas.drawPath(torsoPath, outlinePaint);

    final navelPaint = Paint()
      ..color = const Color(0xFFE8C2AC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.80),
        width: 10,
        height: 6,
      ),
      0.2,
      2.8,
      false,
      navelPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IntestinePainterDetailed extends CustomPainter {
  const _IntestinePainterDetailed();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = const Color(0xFFFFA8A0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final shadowPaint = Paint()
      ..color = const Color(0xFFE57373)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(w * 0.45, h * 0.40)
      ..quadraticBezierTo(w * 0.55, h * 0.37, w * 0.60, h * 0.42)
      ..quadraticBezierTo(w * 0.65, h * 0.47, w * 0.55, h * 0.48)
      ..quadraticBezierTo(w * 0.45, h * 0.49, w * 0.40, h * 0.44)
      ..quadraticBezierTo(w * 0.35, h * 0.39, w * 0.45, h * 0.38)
      ..quadraticBezierTo(w * 0.55, h * 0.37, w * 0.60, h * 0.42)
      ..moveTo(w * 0.40, h * 0.44)
      ..quadraticBezierTo(w * 0.38, h * 0.52, w * 0.46, h * 0.54)
      ..quadraticBezierTo(w * 0.54, h * 0.56, w * 0.60, h * 0.51)
      ..quadraticBezierTo(w * 0.66, h * 0.46, w * 0.62, h * 0.55)
      ..quadraticBezierTo(w * 0.58, h * 0.62, w * 0.48, h * 0.62)
      ..quadraticBezierTo(w * 0.38, h * 0.62, w * 0.38, h * 0.52);

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);

    final detailPaint = Paint()
      ..color = const Color(0xFFE57373)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, detailPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ColonPainterDetailed extends CustomPainter {
  const _ColonPainterDetailed();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final colonColor = const Color(0xFFFFA096);
    final colonOutline = const Color(0xFFE56A5F);

    final paint = Paint()
      ..color = colonColor
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = colonOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final List<Offset> ascending = [
      Offset(w * 0.32, h * 0.65),
      Offset(w * 0.31, h * 0.56),
      Offset(w * 0.30, h * 0.47),
      Offset(w * 0.31, h * 0.38),
    ];

    final List<Offset> transverse = [
      Offset(w * 0.35, h * 0.33),
      Offset(w * 0.44, h * 0.32),
      Offset(w * 0.53, h * 0.32),
      Offset(w * 0.62, h * 0.33),
    ];

    final List<Offset> descending = [
      Offset(w * 0.66, h * 0.38),
      Offset(w * 0.67, h * 0.47),
      Offset(w * 0.66, h * 0.56),
      Offset(w * 0.65, h * 0.65),
    ];

    final smallIntPaint = Paint()
      ..color = const Color(0xFFFFECEB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final smallIntPath = Path()
      ..moveTo(w * 0.45, h * 0.45)
      ..quadraticBezierTo(w * 0.52, h * 0.42, w * 0.55, h * 0.47)
      ..quadraticBezierTo(w * 0.58, h * 0.52, w * 0.50, h * 0.54)
      ..quadraticBezierTo(w * 0.42, h * 0.55, w * 0.43, h * 0.48)
      ..quadraticBezierTo(w * 0.45, h * 0.44, w * 0.52, h * 0.46);
    canvas.drawPath(smallIntPath, smallIntPaint);

    final allSegments = [...ascending, ...transverse, ...descending];
    for (final pt in allSegments) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: pt, width: 18, height: 14),
          const Radius.circular(5),
        ),
        paint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: pt, width: 18, height: 14),
          const Radius.circular(5),
        ),
        outlinePaint,
      );
    }

    final spinePaint = Paint()
      ..color = colonOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final spinePath = Path()
      ..moveTo(w * 0.32, h * 0.65)
      ..lineTo(w * 0.31, h * 0.38)
      ..quadraticBezierTo(w * 0.32, h * 0.33, w * 0.38, h * 0.33)
      ..lineTo(w * 0.62, h * 0.33)
      ..quadraticBezierTo(w * 0.66, h * 0.33, w * 0.66, h * 0.38)
      ..lineTo(w * 0.65, h * 0.65);
    canvas.drawPath(spinePath, spinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const double dashWidth = 4.0;
    const double dashSpace = 3.0;

    double currentAngle = 0.0;
    final double circumference = 2 * 3.14159 * radius;
    final int dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = currentAngle;
      final double sweepAngle = (dashWidth / circumference) * 2 * 3.14159;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      currentAngle += sweepAngle + ((dashSpace / circumference) * 2 * 3.14159);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AnatomyLinesPainter extends CustomPainter {
  const _AnatomyLinesPainter({required this.isIleostomy});
  final bool isIleostomy;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final linePaint = Paint()
      ..color = const Color(0xFF1E2939)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final dotPaint = Paint()
      ..color = const Color(0xFF1E2939)
      ..style = PaintingStyle.fill;

    if (isIleostomy) {
      final start1 = Offset(w * 0.5, h * 0.18);
      final end1 = Offset(w * 0.5, h * 0.36);
      canvas.drawCircle(start1, 2.5, dotPaint);
      canvas.drawLine(start1, end1, linePaint);
      final arrowPath = Path()
        ..moveTo(end1.dx - 3, end1.dy - 4)
        ..lineTo(end1.dx, end1.dy)
        ..lineTo(end1.dx + 3, end1.dy - 4);
      canvas.drawPath(arrowPath, linePaint);

      final start2 = Offset(w * 0.80, h * 0.76);
      final end2 = Offset(w * 0.69, h * 0.67);
      canvas.drawCircle(start2, 2.5, dotPaint);
      canvas.drawLine(start2, end2, linePaint);
    } else {
      final start1 = Offset(w * 0.5, h * 0.18);
      final end1 = Offset(w * 0.5, h * 0.34);
      canvas.drawCircle(start1, 2.5, dotPaint);
      canvas.drawLine(start1, end1, linePaint);
      final arrowPath = Path()
        ..moveTo(end1.dx - 3, end1.dy - 4)
        ..lineTo(end1.dx, end1.dy)
        ..lineTo(end1.dx + 3, end1.dy - 4);
      canvas.drawPath(arrowPath, linePaint);

      final start2 = Offset(w * 0.80, h * 0.76);
      final end2 = Offset(w * 0.70, h * 0.66);
      canvas.drawCircle(start2, 2.5, dotPaint);
      canvas.drawLine(start2, end2, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StoolIconPainter extends CustomPainter {
  const _StoolIconPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..lineTo(size.width * 0.8, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.65, size.width * 0.75, size.height * 0.6)
      ..lineTo(size.width * 0.25, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.1, size.height * 0.65, size.width * 0.2, size.height * 0.8)
      ..moveTo(size.width * 0.3, size.height * 0.6)
      ..lineTo(size.width * 0.7, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.45, size.width * 0.65, size.height * 0.4)
      ..lineTo(size.width * 0.35, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.45, size.width * 0.3, size.height * 0.6)
      ..moveTo(size.width * 0.4, size.height * 0.4)
      ..lineTo(size.width * 0.6, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.25, size.width * 0.5, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.25, size.width * 0.4, size.height * 0.4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StomaDot extends StatelessWidget {
  const _StomaDot({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFD71E24),
        border: Border.all(color: const Color(0xFFFFB2A8), width: 2),
      ),
      child: Center(
        child: Container(
          width: size * 0.32,
          height: size * 0.32,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF7A0308),
          ),
        ),
      ),
    );
  }
}

class _IntestinePainter extends CustomPainter {
  const _IntestinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF81C784)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.2, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.8, size.width * 0.8, size.height * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NumberTitleHeader extends StatelessWidget {
  const _NumberTitleHeader({
    required this.number,
    required this.color,
    required this.title,
  });

  final int number;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              height: 1,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 22,
              height: 1.12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _AnatomyReferenceFigure extends StatelessWidget {
  const _AnatomyReferenceFigure();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/module1_anatomy_figure.png',
      fit: BoxFit.contain,
    );
  }
}

class _IconPoint extends StatelessWidget {
  const _IconPoint({
    required this.color,
    required this.icon,
    required this.text,
  });

  final Color color;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStomaIcon extends StatelessWidget {
  const _SmallStomaIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(36, 36),
      painter: _SmallStomaPainter(color),
    );
  }
}

class _SmallStomaPainter extends CustomPainter {
  const _SmallStomaPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    _drawStoma(
      canvas,
      Offset(size.width / 2, size.height / 2),
      size.width * 0.42,
      color: color,
    );
  }

  @override
  bool shouldRepaint(covariant _SmallStomaPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ModuleOneAnatomyLessonScreen extends StatelessWidget {
  const _ModuleOneAnatomyLessonScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: _LanguageChip(
                language: language,
                onLanguageChanged: onLanguageChanged,
              ),
            ),
            const SizedBox(height: 12),
            _NumberTitleHeader(
              number: 3,
              color: const Color(0xFF5E24B6),
              title: isEnglish
                  ? 'Anatomy and Purpose of Stoma'
                  : 'स्टोमा की संरचना और उद्देश्य',
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 165,
                  height: 202,
                  child: _AnatomyReferenceFigure(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEnglish
                            ? 'The stoma is created to:'
                            : 'स्टोमा इसलिए बनाया जाता है:',
                        style: const TextStyle(
                          fontSize: 14.5,
                          height: 1.2,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _IconPoint(
                        color: const Color(0xFF5E24B6),
                        icon: Icons.check_rounded,
                        text: isEnglish
                            ? 'Allow stool to pass when normal bowel route is not possible'
                            : 'जब सामान्य आंत का रास्ता संभव न हो\nतब मल को बाहर आने देना',
                      ),
                      _IconPoint(
                        color: const Color(0xFF5E24B6),
                        icon: Icons.check_rounded,
                        text: isEnglish
                            ? 'Protect healing parts of intestine'
                            : 'ठीक हो रही आंत के हिस्सों की रक्षा करना',
                      ),
                      _IconPoint(
                        color: const Color(0xFF5E24B6),
                        icon: Icons.check_rounded,
                        text: isEnglish
                            ? 'Improve overall health and recovery'
                            : 'स्वास्थ्य और रिकवरी को बेहतर बनाना',
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isEnglish ? 'The stoma:' : 'स्टोमा:',
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: Color(0xFF5E24B6),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _IconPoint(
                        color: const Color(0xFF7E5AC9),
                        icon: Icons.shield_rounded,
                        text: isEnglish
                            ? 'Has no nerve endings (so it does not feel pain)'
                            : 'इसमें नसों के सिरे नहीं होते\n(इसलिए दर्द महसूस नहीं होता)',
                      ),
                      _IconPoint(
                        color: const Color(0xFF8E63D7),
                        icon: Icons.water_drop_rounded,
                        text: isEnglish
                            ? 'Is always moist and pink/red in color'
                            : 'हमेशा नम और\nगुलाबी/लाल रंग का होता है',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleOneAppearanceLessonScreen extends StatelessWidget {
  const _ModuleOneAppearanceLessonScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Top Navigation row (Back button + Language selector chip)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF1E2939),
                    size: 26,
                  ),
                ),
                _LanguageChip(
                  language: language,
                  onLanguageChanged: onLanguageChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Top Header: Red/pink rounded gradient banner
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF5B78), Color(0xFFD42F4D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF5B78).withValues(alpha: 0.16),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              alignment: Alignment.center,
              child: Text(
                isEnglish ? '4. NORMAL APPEARANCE OF STOMA' : '4. स्टोमा का सामान्य रूप',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Intro Centered text
            Center(
              child: Text(
                isEnglish ? 'A healthy stoma should look like:' : 'एक स्वस्थ स्टोमा ऐसा दिखना चाहिए:',
                style: const TextStyle(
                  color: Color(0xFF1E2939),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Decorative Divider with central dot
            Center(
              child: SizedBox(
                width: 140,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1.2,
                        color: const Color(0xFFFDA4AF),
                      ),
                    ),
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF5B78),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1.2,
                        color: const Color(0xFFFDA4AF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Responsive Layout with stoma image and stacked info cards
            LayoutBuilder(
              builder: (context, constraints) {
                final useTwoColumns = constraints.maxWidth > 650;

                if (useTwoColumns) {
                  return SizedBox(
                    height: 330,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            // Left Side Column: Centered Realistic Stoma Image
                            Expanded(
                              flex: 11,
                              child: Center(
                                child: _buildStomaCard(),
                              ),
                            ),
                            // Middle space for custom painter lines
                            const Expanded(
                              flex: 2,
                              child: SizedBox.shrink(),
                            ),
                            // Right Side Column: Stacked Cards
                            Expanded(
                              flex: 12,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildCard1(isEnglish),
                                  _buildCard2(isEnglish),
                                  _buildCard3(isEnglish),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Custom Painted Connector Lines sitting on top
                        Positioned.fill(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: const _StomaConnectorPainter(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Mobile vertical stack (hide connector lines to avoid clutter)
                  return Column(
                    children: [
                      _buildStomaCard(),
                      const SizedBox(height: 24),
                      _buildCard1(isEnglish),
                      const SizedBox(height: 14),
                      _buildCard2(isEnglish),
                      const SizedBox(height: 14),
                      _buildCard3(isEnglish),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 32),

            // Bottom Warning Strip Card
            _buildWarningStrip(isEnglish),
          ],
        ),
      ),
    );
  }

  // Realistic Stoma Avatar Card
  Widget _buildStomaCard() {
    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE54359).withValues(alpha: 0.12),
            blurRadius: 20,
            spreadRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(105),
        child: Image.asset(
          'assets/images/module1_stoma_appearance.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Color Card (Solid pink circle with white artist palette symbol)
  Widget _buildCard1(bool isEnglish) {
    return _buildInfoCard(
      title: isEnglish ? 'COLOR' : 'रंग',
      description: isEnglish
          ? 'Pink to red\n(like inside of your mouth)'
          : 'गुलाबी से लाल\n(आपके मुंह के अंदर जैसा)',
      iconCircleColor: const Color(0xFFE84C73),
      iconColor: Colors.white,
      iconData: Icons.palette_rounded,
      textColor: const Color(0xFFE84C73),
    );
  }

  // Texture Card (Solid blue circle with white water droplet symbol)
  Widget _buildCard2(bool isEnglish) {
    return _buildInfoCard(
      title: isEnglish ? 'TEXTURE' : 'बनावट',
      description: isEnglish ? 'Moist and shiny' : 'नम और चमकदार',
      iconCircleColor: const Color(0xFF4D89D8),
      iconColor: Colors.white,
      iconData: Icons.water_drop_rounded,
      textColor: const Color(0xFF4D89D8),
    );
  }

  // Shape/Size Card (Solid green circle with white oval/dashed circle symbol)
  Widget _buildCard3(bool isEnglish) {
    return _buildInfoCard(
      title: isEnglish ? 'SHAPE / SIZE' : 'आकार / साइज',
      description: isEnglish
          ? 'Round or oval\n(may be slightly swollen after surgery)'
          : 'गोल या अंडाकार\n(सर्जरी के बाद थोड़ा सूजा हो सकता है)',
      iconCircleColor: const Color(0xFF69B85A),
      iconColor: Colors.white,
      customIcon: CustomPaint(
        size: const Size(22, 22),
        painter: const _DashedCirclePainter(color: Colors.white),
      ),
      textColor: const Color(0xFF69B85A),
    );
  }

  // Base Info Card Widget
  Widget _buildInfoCard({
    required String title,
    required String description,
    required Color iconCircleColor,
    required Color iconColor,
    IconData? iconData,
    Widget? customIcon,
    required Color textColor,
  }) {
    return Container(
      height: 94,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Styled Solid Icon Circle
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconCircleColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: customIcon ??
                Icon(
                  iconData,
                  color: iconColor,
                  size: 22,
                ),
          ),
          const SizedBox(width: 16),

          // Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Warning Strip Widget
  Widget _buildWarningStrip(bool isEnglish) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF5), // Light cream yellow strip
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFEF3C7), // Subtle amber border
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          // Bold Warning Icon
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFF5B321), // exact Warning Yellow
            size: 34,
          ),
          const SizedBox(width: 16),

          // Warning Text
          Expanded(
            child: Text(
              isEnglish
                  ? 'Small bleeding while cleaning is normal.'
                  : 'सफाई करते समय थोड़ा रक्तस्राव सामान्य है।',
              style: const TextStyle(
                color: Color(0xFF78350F), // Deep amber text
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Tissue paper with blood spot image
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                'assets/images/module1_gauze_blood.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StomaConnectorPainter extends CustomPainter {
  const _StomaConnectorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Stoma image center and parameters relative to the layout
    final double stomaCenterX = w * 0.22;
    final double stomaCenterY = h * 0.50;
    final double cardLeftX = w * 0.52;

    // Y positions of stacked cards
    final card1Y = h * 0.14;
    final card2Y = h * 0.50;
    final card3Y = h * 0.86;

    // Paint configurations
    final whitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    
    // Pink Paint System (Top & Bottom Lines)
    final linePink = Paint()
      ..color = const Color(0xFFFDA4AF) // Soft pink color for elbow lines
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final dotPink = Paint()..color = const Color(0xFFE84C73)..style = PaintingStyle.fill;

    // Blue Paint System (Middle Line)
    final lineBlue = Paint()
      ..color = const Color(0xFF93C5FD) // Soft blue color for horizontal line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final dotBlue = Paint()..color = const Color(0xFF4D89D8)..style = PaintingStyle.fill;

    // 1. Draw Pink Line (COLOR Card)
    // Starts at top-right edge of stoma circle (approx -30 degrees)
    final start1 = Offset(stomaCenterX + 91, stomaCenterY - 52.5);
    final path1 = Path()
      ..moveTo(start1.dx, start1.dy)
      ..lineTo(stomaCenterX + 115, stomaCenterY - 52.5) // short horizontal segment
      ..lineTo(stomaCenterX + 160, card1Y)            // diagonal segment
      ..lineTo(cardLeftX, card1Y);                    // final horizontal segment
    canvas.drawPath(path1, linePink);

    // Draw Pink Start Dot on Stoma Side (Filled with white border)
    canvas.drawCircle(start1, 4.5, whitePaint);
    canvas.drawCircle(start1, 3.0, dotPink);

    // Draw Pink End Dot on Card Side (Filled with white border)
    canvas.drawCircle(Offset(cardLeftX, card1Y), 5.5, whitePaint);
    canvas.drawCircle(Offset(cardLeftX, card1Y), 3.5, dotPink);

    // 2. Draw Blue Line (TEXTURE Card)
    // Starts at middle-right edge of stoma circle (0 degrees)
    final start2 = Offset(stomaCenterX + 105, stomaCenterY);
    final path2 = Path()
      ..moveTo(start2.dx, start2.dy)
      ..lineTo(cardLeftX, card2Y); // straight horizontal line
    canvas.drawPath(path2, lineBlue);

    // Draw Blue Start Dot on Stoma Side (Filled with white border)
    canvas.drawCircle(start2, 4.5, whitePaint);
    canvas.drawCircle(start2, 3.0, dotBlue);

    // Draw Blue End Dot on Card Side (Filled with white border)
    canvas.drawCircle(Offset(cardLeftX, card2Y), 5.5, whitePaint);
    canvas.drawCircle(Offset(cardLeftX, card2Y), 3.5, dotBlue);

    // 3. Draw Pink Line (SHAPE / SIZE Card)
    // Starts at bottom-right edge of stoma circle (approx 30 degrees)
    final start3 = Offset(stomaCenterX + 91, stomaCenterY + 52.5);
    final path3 = Path()
      ..moveTo(start3.dx, start3.dy)
      ..lineTo(stomaCenterX + 115, stomaCenterY + 52.5) // short horizontal segment
      ..lineTo(stomaCenterX + 160, card3Y)            // diagonal segment
      ..lineTo(cardLeftX, card3Y);                    // final horizontal segment
    canvas.drawPath(path3, linePink);

    // Draw Pink Start Dot on Stoma Side (Filled with white border)
    canvas.drawCircle(start3, 4.5, whitePaint);
    canvas.drawCircle(start3, 3.0, dotPink);

    // Draw Pink End Dot on Card Side (Filled with white border)
    canvas.drawCircle(Offset(cardLeftX, card3Y), 5.5, whitePaint);
    canvas.drawCircle(Offset(cardLeftX, card3Y), 3.5, dotPink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModuleOneExpectedChangesScreen extends StatelessWidget {
  const _ModuleOneExpectedChangesScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: _LanguageChip(
                language: language,
                onLanguageChanged: onLanguageChanged,
              ),
            ),
            const SizedBox(height: 12),
            _NumberTitleHeader(
              number: 5,
              color: const Color(0xFFFF7900),
              title: isEnglish
                  ? 'Expected Changes (First 6-8 Weeks)'
                  : 'पहले 6-8 हफ्तों में अपेक्षित बदलाव',
            ),
            const SizedBox(height: 16),
            Text(
              isEnglish
                  ? 'After surgery, your stoma will gradually change:'
                  : 'सर्जरी के बाद आपका स्टोमा धीरे-धीरे बदलेगा:',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15.5,
                height: 1.2,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _GreenIconText(
                        icon: Icons.accessibility_new_rounded,
                        text: isEnglish
                            ? 'Swelling will reduce slowly'
                            : 'सूजन धीरे-धीरे कम होगी',
                      ),
                      _GreenIconText(
                        icon: Icons.timer_outlined,
                        text: isEnglish
                            ? 'Size of stoma will become smaller'
                            : 'स्टोमा का आकार छोटा होगा',
                      ),
                      _GreenIconText(
                        icon: Icons.text_increase_rounded,
                        text: isEnglish
                            ? 'Output pattern will stabilize'
                            : 'आउटपुट पैटर्न स्थिर होगा',
                      ),
                      _GreenIconText(
                        icon: Icons.favorite_rounded,
                        text: isEnglish
                            ? 'You will become more comfortable with care'
                            : 'देखभाल में आप अधिक सहज होंगे',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                SizedBox(
                  width: 240,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _WeekStoma(label: 'Week 1', size: 68),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFFFFA51E),
                            size: 34,
                          ),
                          _WeekStoma(label: 'Week 6-8', size: 56),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const _RulerGraphic(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _MeasureTipBox(
              text: isEnglish
                  ? 'Measure your stoma regularly during this period for proper fitting of pouch.'
                  : 'इस अवधि में पाउच की सही फिटिंग के लिए स्टोमा को नियमित रूप से मापें।',
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleOneOutputLessonScreen extends StatelessWidget {
  const _ModuleOneOutputLessonScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: _LanguageChip(
                language: language,
                onLanguageChanged: onLanguageChanged,
              ),
            ),
            const SizedBox(height: 12),
            _NumberTitleHeader(
              number: 6,
              color: const Color(0xFF008A96),
              title: isEnglish
                  ? 'Stoma Output (What to Expect)'
                  : 'स्टोमा आउटपुट: क्या अपेक्षा करें',
            ),
            const SizedBox(height: 28),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _OutputTypeColumn(
                    title: isEnglish ? 'Ileostomy:' : 'इलियोस्टॉमी:',
                    titleColor: const Color(0xFF168B28),
                    liquidColor: const Color(0xFF9AA000),
                    points: isEnglish
                        ? const [
                            'Liquid to semi-liquid stool',
                            'Frequent output',
                          ]
                        : const ['तरल से अर्ध-तरल मल', 'बार-बार आउटपुट'],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _OutputTypeColumn(
                    title: isEnglish ? 'Colostomy:' : 'कोलोस्टॉमी:',
                    titleColor: const Color(0xFF0068D9),
                    liquidColor: const Color(0xFF7A3D18),
                    points: isEnglish
                        ? const [
                            'Semi-solid to formed stool',
                            'Less frequent output',
                          ]
                        : const ['अर्ध-ठोस से बना हुआ मल', 'कम बार आउटपुट'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              isEnglish
                  ? 'Output may vary depending on:'
                  : 'आउटपुट इन बातों पर निर्भर कर सकता है:',
              style: const TextStyle(
                color: Color(0xFF007A7E),
                fontSize: 15.5,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _OutputFactor(
                  icon: Icons.apple,
                  label: isEnglish ? 'Diet' : 'आहार',
                ),
                _OutputFactor(
                  icon: Icons.local_drink_outlined,
                  label: isEnglish ? 'Fluid intake' : 'तरल सेवन',
                ),
                _OutputFactor(
                  icon: Icons.medication_rounded,
                  label: isEnglish ? 'Medications' : 'दवाएं',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleTwoTypesOstomyBagsScreen extends StatelessWidget {
  const _ModuleTwoTypesOstomyBagsScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translations
    final String screenTitle = isEnglish ? '1. TYPES OF OSTOMY BAGS (POUCHES)' : '1. ओस्टॉमी बैग (पाउच) के प्रकार';
    final String screenSubtitle = isEnglish 
        ? 'Ostomy pouches collect waste from your stoma. There are two main types:'
        : 'ओस्टॉमी पाउच आपके स्टोमा से अपशिष्ट एकत्र करते हैं। इसके दो मुख्य प्रकार हैं:';

    final String onePieceTitle = isEnglish ? 'ONE-PIECE SYSTEM' : 'वन-पीस सिस्टम';
    final String onePieceDesc = isEnglish 
        ? 'The bag and skin barrier are attached together.'
        : 'बैग और स्किन बैरियर एक साथ जुड़े होते हैं।';

    final String twoPieceTitle = isEnglish ? 'TWO-PIECE SYSTEM' : 'टू-पीस सिस्टम';
    final String twoPieceDesc = isEnglish 
        ? 'The bag and base plate (skin barrier) are separate.'
        : 'बैग और बेस प्लेट (स्किन बैरियर) अलग होते हैं।';


    final String onePiecePoint1 = isEnglish ? 'Bag and skin barrier are attached together' : 'बैग और स्किन बैरियर एक साथ जुड़े होते हैं';
    final String onePiecePoint2 = isEnglish ? 'Easy to use and simple' : 'उपयोग में आसान और सरल';
    final String onePiecePoint3 = isEnglish ? 'Needs full removal when changing' : 'बदलते समय पूरी तरह हटाना पड़ता है';

    final String twoPiecePoint1 = isEnglish ? 'Bag and base plate (skin barrier) are separate' : 'बैग और बेस प्लेट (स्किन बैरियर) अलग होते हैं';
    final String twoPiecePoint2 = isEnglish ? 'Bag can be removed without removing the base' : 'बेस हटाए बिना बैग बदला जा सकता है';
    final String twoPiecePoint3 = isEnglish ? 'More flexible and reusable base' : 'अधिक लचकदार और पुन: उपयोग योग्य बेस';

    final String bottomTip = isEnglish 
        ? 'Your stoma care nurse will help you choose the right pouch for your comfort and lifestyle.'
        : 'आपकी स्टोमा केयर नर्स आपके आराम और जीवनशैली के अनुसार सही पाउच चुनने में आपकी मदद करेंगी।';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Top Navigation Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF1E2939),
                    size: 26,
                  ),
                ),
                _LanguageChip(
                  language: language,
                  onLanguageChanged: onLanguageChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Header Section with decorative leaves
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomPaint(
                    size: const Size(28, 20),
                    painter: const _HeaderLeafPainter(isLeft: true),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      screenTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF0F1A3C),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomPaint(
                    size: const Size(28, 20),
                    painter: const _HeaderLeafPainter(isLeft: false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Divider with small circle in center
            Center(
              child: SizedBox(
                width: 180,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1.2,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF64748B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1.2,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Intro Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                screenSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ================= CARD 1 — ONE-PIECE SYSTEM =================
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A0F172A),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title Block (Green theme)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      onePieceTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    onePieceDesc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Custom Illustration Stack
                  Center(
                    child: Container(
                      width: 320,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/module2_one_piece_pouch_labeled.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Feature Cards
                  _buildFeatureTile(
                    icon: Icons.link_rounded,
                    text: onePiecePoint1,
                    color: const Color(0xFF2E7D32),
                  ),
                  const SizedBox(height: 10),
                  _buildFeatureTile(
                    icon: Icons.touch_app_rounded,
                    text: onePiecePoint2,
                    color: const Color(0xFF2E7D32),
                  ),
                  const SizedBox(height: 10),
                  _buildFeatureTile(
                    icon: Icons.delete_outline_rounded,
                    text: onePiecePoint3,
                    color: const Color(0xFF2E7D32),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ================= CARD 2 — TWO-PIECE SYSTEM =================
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A0F172A),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title Block (Blue theme)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      twoPieceTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    twoPieceDesc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Custom Separation Illustration Stack
                  Center(
                    child: Container(
                      width: 320,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/module2_two_piece_pouch_labeled.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Feature Cards
                  _buildFeatureTile(
                    icon: Icons.difference_rounded,
                    text: twoPiecePoint1,
                    color: const Color(0xFF1976D2),
                  ),
                  const SizedBox(height: 10),
                  _buildFeatureTile(
                    icon: Icons.cached_rounded,
                    text: twoPiecePoint2,
                    color: const Color(0xFF1976D2),
                  ),
                  const SizedBox(height: 10),
                  _buildFeatureTile(
                    icon: Icons.shield_outlined,
                    text: twoPiecePoint3,
                    color: const Color(0xFF1976D2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ================= BOTTOM INFORMATION STRIP =================
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5EEFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE7D8FF),
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B5CF6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lightbulb_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      bottomTip,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6D28D9),
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Feature list helper item
  Widget _buildFeatureTile({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnePieceConnectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFF475569)
      ..style = PaintingStyle.fill;

    // Line 1: Skin barrier (from left label "Skin barrier" to flange)
    canvas.drawLine(const Offset(105, 52), const Offset(142, 68), paint);
    canvas.drawCircle(const Offset(142, 68), 2.5, dotPaint);

    // Line 2: Pouch (from right label "Pouch" to pouch center body)
    canvas.drawLine(const Offset(235, 110), const Offset(192, 118), paint);
    canvas.drawCircle(const Offset(192, 118), 2.5, dotPaint);

    // Line 3: Clamp/closure (from right label to clamp area)
    canvas.drawLine(const Offset(210, 180), const Offset(174, 174), paint);
    canvas.drawCircle(const Offset(174, 174), 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TwoPieceConnectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFF475569)
      ..style = PaintingStyle.fill;

    // Line 1: Base plate (top-left label to base plate circle flange center)
    // Label is (10, 12) "Base plate\n(skin barrier)". Bottom-right is around (80, 36). Target center is (85, 80)
    canvas.drawLine(const Offset(80, 38), const Offset(85, 78), paint);
    canvas.drawCircle(const Offset(85, 78), 2.5, dotPaint);

    // Line 2: Pouch (top-right label to pouch flange center)
    // Label is (right: 15, top: 12). Start is around (240, 20). Target center is (233, 76)
    canvas.drawLine(const Offset(245, 20), const Offset(233, 74), paint);
    canvas.drawCircle(const Offset(233, 74), 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModuleTwoSkinBarrierProductsScreen extends StatelessWidget {
  const _ModuleTwoSkinBarrierProductsScreen({
    required this.language,
    required this.lesson,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final LessonData lesson;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Localized Strings
    final String screenTitle = isEnglish ? '2. SKIN BARRIER PRODUCTS' : '2. त्वचा सुरक्षा उत्पाद';
    final String infoText = isEnglish 
        ? 'These products protect the skin around your stoma and help prevent irritation.'
        : 'ये उत्पाद आपके स्टोमा के आसपास की त्वचा की रक्षा करते हैं और जलन को रोकने में मदद करते हैं।';

    final String ringTitle = isEnglish ? 'BARRIER RINGS' : 'बैरियर रिंग';
    final String ringDesc = isEnglish 
        ? 'Prevent leakage by creating a better seal around the stoma.'
        : 'स्टोमा के आसपास बेहतर सील बनाकर रिसाव को रोकें।';

    final String pasteTitle = isEnglish ? 'BARRIER PASTE' : 'बैरियर पेस्ट';
    final String pasteDesc = isEnglish 
        ? 'Fills gaps and uneven areas around the stoma for a secure seal.'
        : 'सुरक्षित सील के लिए स्टोमा के आसपास के अंतराल और असमान क्षेत्रों को भरता है।';

    final String wipesTitle = isEnglish ? 'BARRIER WIPES' : 'बैरियर वाइप्स';
    final String wipesDesc = isEnglish 
        ? 'Protect and clean the skin around the stoma.'
        : 'स्टोमा के आसपास की त्वचा की रक्षा और सफाई करें।';

    final String bottomText = isEnglish 
        ? 'Using these products helps prevent skin irritation and keeps the pouch sealed properly.'
        : 'इन उत्पादों का उपयोग करने से त्वचा की जलन को रोकने में मदद मिलती है और पाउच ठीक से सील रहता है।';

    const Color primaryGreen = Color(0xFF5F9E45);
    const Color lightGreenBg = Color(0xFFF5FAF2);
    const Color borderGreen = Color(0xFFD7E5CF);
    const Color darkGreenText = Color(0xFF3B6529);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Top Navigation Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF1E2939),
                    size: 26,
                  ),
                ),
                _LanguageChip(
                  language: language,
                  onLanguageChanged: onLanguageChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Large green rounded banner at the top with leaves
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(28, 24),
                      painter: const _GreenHeaderLeafPainter(isLeft: true),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F5F9E45),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        screenTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    CustomPaint(
                      size: const Size(28, 24),
                      painter: const _GreenHeaderLeafPainter(isLeft: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Information Card Below Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightGreenBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderGreen, width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.verified_user_rounded,
                    color: primaryGreen,
                    size: 40,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      infoText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: darkGreenText,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Product Card 1 — BARRIER RINGS
            _buildProductCard(
              illustration: const _BarrierRingIllustration(),
              iconData: Icons.circle_outlined,
              title: ringTitle,
              description: ringDesc,
              primaryGreen: primaryGreen,
              borderGreen: borderGreen,
              darkGreenText: darkGreenText,
            ),
            const SizedBox(height: 18),

            // Product Card 2 — BARRIER PASTE
            _buildProductCard(
              illustration: const _BarrierPasteIllustration(),
              iconData: Icons.colorize_rounded,
              title: pasteTitle,
              description: pasteDesc,
              primaryGreen: primaryGreen,
              borderGreen: borderGreen,
              darkGreenText: darkGreenText,
            ),
            const SizedBox(height: 18),

            // Product Card 3 — BARRIER WIPES
            _buildProductCard(
              illustration: const _BarrierWipesIllustration(),
              iconData: Icons.layers_rounded,
              title: wipesTitle,
              description: wipesDesc,
              primaryGreen: primaryGreen,
              borderGreen: borderGreen,
              darkGreenText: darkGreenText,
            ),
            const SizedBox(height: 24),

            // Bottom Information Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDFBF7),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFF5E6D3), width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Shield check inside dotted circle
                  CustomPaint(
                    size: const Size(40, 40),
                    painter: const _DottedCirclePainter(color: primaryGreen),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Icon(
                          Icons.verified_user_rounded,
                          color: primaryGreen,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Center Text
                  Expanded(
                    child: Text(
                      bottomText,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF5F503D),
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Stoma Appliance with Sparkles
                  const SizedBox(
                    width: 90,
                    height: 90,
                    child: _StomaApplianceBottomIllustration(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Product Card layout structure
  Widget _buildProductCard({
    required Widget illustration,
    required IconData iconData,
    required String title,
    required String description,
    required Color primaryGreen,
    required Color borderGreen,
    required Color darkGreenText,
  }) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            // Left light green illustration area
            Container(
              width: 120,
              height: double.infinity,
              color: const Color(0xFFF5FAF2),
              child: illustration,
            ),
            // Divider line
            Container(
              width: 1.2,
              height: double.infinity,
              color: borderGreen,
            ),
            // Right info area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Green circle icon
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            iconData,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Title
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: darkGreenText,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Dotted Divider
                    const _DashedDivider(),
                    const SizedBox(height: 10),
                    // Description
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF475569),
                      ),
                    ),
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

class _GreenHeaderLeafPainter extends CustomPainter {
  const _GreenHeaderLeafPainter({required this.isLeft});
  final bool isLeft;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final stemPaint = Paint()
      ..color = const Color(0xFF81C784)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()
      ..color = const Color(0xFFC8E6C9)
      ..style = PaintingStyle.fill;

    final leafOutlinePaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.save();
    if (isLeft) {
      final stemPath = Path()
        ..moveTo(w * 0.1, h * 0.8)
        ..quadraticBezierTo(w * 0.5, h * 0.5, w * 0.9, h * 0.2);
      canvas.drawPath(stemPath, stemPaint);

      final List<Offset> centers = [
        Offset(w * 0.4, h * 0.6),
        Offset(w * 0.7, h * 0.4),
        Offset(w * 0.9, h * 0.2),
      ];

      for (var i = 0; i < centers.length; i++) {
        canvas.drawOval(
          Rect.fromCenter(
            center: centers[i],
            width: 12 + i * 2,
            height: 6 + i * 1.5,
          ),
          leafPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: centers[i],
            width: 12 + i * 2,
            height: 6 + i * 1.5,
          ),
          leafOutlinePaint,
        );
      }
    } else {
      final stemPath = Path()
        ..moveTo(w * 0.9, h * 0.8)
        ..quadraticBezierTo(w * 0.5, h * 0.5, w * 0.1, h * 0.2);
      canvas.drawPath(stemPath, stemPaint);

      final List<Offset> centers = [
        Offset(w * 0.6, h * 0.6),
        Offset(w * 0.3, h * 0.4),
        Offset(w * 0.1, h * 0.2),
      ];

      for (var i = 0; i < centers.length; i++) {
        canvas.drawOval(
          Rect.fromCenter(
            center: centers[i],
            width: 12 + i * 2,
            height: 6 + i * 1.5,
          ),
          leafPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: centers[i],
            width: 12 + i * 2,
            height: 6 + i * 1.5,
          ),
          leafOutlinePaint,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DottedCirclePainter extends CustomPainter {
  const _DottedCirclePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final double dashWidth = 3.5;
    final double dashSpace = 2.5;
    final double circumference = 2 * 3.14159265 * radius;
    final int dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final double angleStart = (i * (dashWidth + dashSpace) / circumference) * 2 * 3.14159265;
      final double angleEnd = angleStart + (dashWidth / circumference) * 2 * 3.14159265;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        angleStart,
        angleEnd - angleStart,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarrierRingIllustration extends StatelessWidget {
  const _BarrierRingIllustration();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/module2_barrier_ring.png',
      fit: BoxFit.cover,
    );
  }
}

class _BarrierPasteIllustration extends StatelessWidget {
  const _BarrierPasteIllustration();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/module2_barrier_paste.png',
      fit: BoxFit.cover,
    );
  }
}

class _BarrierWipesIllustration extends StatelessWidget {
  const _BarrierWipesIllustration();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/module2_barrier_wipes.png',
      fit: BoxFit.cover,
    );
  }
}

class _StomaApplianceBottomIllustration extends StatelessWidget {
  const _StomaApplianceBottomIllustration();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/module2_stoma_appliance_bottom.png',
      fit: BoxFit.contain,
    );
  }
}

class _ModuleTwoMeasuringGuideScreen extends StatelessWidget {
  const _ModuleTwoMeasuringGuideScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;
    final String screenTitle = isEnglish ? '3. MEASURING GUIDE & SCISSORS' : '3. मापन गाइड और कैंची';
    final String subtitleText = isEnglish
        ? 'Helps check size of stoma and cut pouch opening to the right size.'
        : 'स्टोमा के आकार की जांच करने और पाउच के मुंह को सही आकार में काटने में मदद करता है।';

    final bool isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Top Navigation Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF1E2939),
                    size: 26,
                  ),
                ),
                _LanguageChip(
                  language: language,
                  onLanguageChanged: onLanguageChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Large rounded container for medical infographic matching reference layout
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFD8E5CB), width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Green Header Banner
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(28, 24),
                            painter: const _GreenHeaderLeafPainter(isLeft: true),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6A9F35),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1F6A9F35),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              screenTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          CustomPaint(
                            size: const Size(28, 24),
                            painter: const _GreenHeaderLeafPainter(isLeft: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Subtitle
                  Text(
                    subtitleText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Two columns side-by-side or stacked
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildMeasuringGuideSection(isEnglish)),
                        Container(
                          width: 1.2,
                          height: 380,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          color: const Color(0xFFD8E5CB),
                        ),
                        Expanded(child: _buildScissorsSection(isEnglish)),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _buildMeasuringGuideSection(isEnglish),
                        const SizedBox(height: 24),
                        Container(
                          height: 1.2,
                          width: double.infinity,
                          color: const Color(0xFFD8E5CB),
                        ),
                        const SizedBox(height: 24),
                        _buildScissorsSection(isEnglish),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasuringGuideSection(bool isEnglish) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3E7),
              border: Border.all(color: const Color(0xFFD8E5CB), width: 1.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isEnglish ? 'MEASURING GUIDE' : 'मापन गाइड',
              style: const TextStyle(
                color: Color(0xFF3B6529),
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/module2_measuring_guide_card.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScissorsSection(bool isEnglish) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3E7),
              border: Border.all(color: const Color(0xFFD8E5CB), width: 1.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isEnglish ? 'SCISSORS' : 'कैंची',
              style: const TextStyle(
                color: Color(0xFF3B6529),
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/module2_scissors.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/module2_baseplate_guide.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

class _BarrierProductCard extends StatelessWidget {
  const _BarrierProductCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFDCE9FF), width: 1.4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: icon,
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F3B78),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            height: 1.4,
            color: Color(0xFF4B5C7F),
          ),
        ),
      ],
    );
  }
}

class _BarrierRingIcon extends StatelessWidget {
  const _BarrierRingIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF6FF),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFB7D7FF), width: 10),
        ),
      ),
    );
  }
}

class _BarrierPasteIcon extends StatelessWidget {
  const _BarrierPasteIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 38,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFFDCEAFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFABC5FF), width: 2),
        ),
        child: const Center(
          child: Text(
            'PASTE',
            style: TextStyle(
              color: Color(0xFF1A4280),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _BarrierWipesIcon extends StatelessWidget {
  const _BarrierWipesIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 52,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFD7EBFF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFABC5FF), width: 2),
        ),
        child: const Center(
          child: Text(
            'WIPES',
            style: TextStyle(
              color: Color(0xFF1A4280),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _OstomySystemCard extends StatelessWidget {
  const _OstomySystemCard({
    required this.title,
    required this.color,
    required this.image,
    required this.points,
  });

  final String title;
  final Color color;
  final Widget image;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.22), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          image,
          const SizedBox(height: 18),
          ...points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreenIconText extends StatelessWidget {
  const _GreenIconText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF008A2E), size: 27),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.2,
                height: 1.18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 6.0;
        final dashCount = (constraints.maxWidth / (dashWidth * 2)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dashCount,
            (_) => Container(
              width: dashWidth,
              height: 1.4,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OnePiecePouchIllustration extends StatelessWidget {
  const _OnePiecePouchIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/module2_one_piece_pouch.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

class _TwoPiecePouchIllustration extends StatelessWidget {
  const _TwoPiecePouchIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFDCC7A5), width: 1.8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 12,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0D6BB),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD4B38F),
                    width: 1.6,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: 76,
            height: 108,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5EB),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFDABF97), width: 1.8),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 10,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFBA8D),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFCAA57A),
                        width: 1.4,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF1E0),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFD3B8A0),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ModuleTwoIntroIllustration extends StatelessWidget {
  const ModuleTwoIntroIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 0,
              top: 24,
              child: Container(
                width: 150,
                height: 170,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E4621),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29000000),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 24,
              top: 10,
              child: Container(
                width: 70,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF144018),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            Positioned(
              right: 30,
              top: 6,
              child: Container(
                width: 45,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned(
              right: 30,
              top: 20,
              child: Container(
                width: 36,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              right: 32,
              top: 50,
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            Positioned(
              right: 84,
              top: 82,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFF1E4621),
                  size: 20,
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 20,
              child: Container(
                width: 100,
                height: 170,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9D1),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color(0xFFD8B48A),
                    width: 1.8,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 26,
              bottom: 36,
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2C9A5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8A37A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              bottom: 112,
              child: Container(
                width: 44,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFDEC4A2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              left: 26,
              bottom: 152,
              child: Container(
                width: 48,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7E4D1),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 92,
              child: Container(
                width: 100,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB8E2FF), Color(0xFF76BBFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 14,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'WIPES',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 18,
              bottom: 24,
              child: Transform.rotate(
                angle: -0.65,
                child: Icon(
                  Icons.content_cut_rounded,
                  color: Colors.white.withValues(alpha: 0.95),
                  size: 30,
                ),
              ),
            ),
            Positioned(
              right: 18,
              top: 82,
              child: Container(
                width: 36,
                height: 62,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 20,
                      height: 12,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8E9F4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB3D9EA),
                        shape: BoxShape.circle,
                      ),
                    ),
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

class _WeekStoma extends StatelessWidget {
  const _WeekStoma({required this.label, required this.size});

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFFF7900),
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: size + 22,
          height: size + 22,
          child: CustomPaint(painter: _StomaCirclePainter(size)),
        ),
      ],
    );
  }
}

class _StomaCirclePainter extends CustomPainter {
  const _StomaCirclePainter(this.size);

  final double size;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    canvas.drawCircle(
      center,
      size / 2 + 10,
      Paint()..color = const Color(0xFFFFF4DC),
    );
    _drawStoma(canvas, center, size / 2);
  }

  @override
  bool shouldRepaint(covariant _StomaCirclePainter oldDelegate) =>
      oldDelegate.size != size;
}

class _RulerGraphic extends StatelessWidget {
  const _RulerGraphic();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(190, 34),
      painter: const _RulerPainter(),
    );
  }
}

class _RulerPainter extends CustomPainter {
  const _RulerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 6, size.width, 22),
      const Radius.circular(3),
    );
    canvas.drawRRect(rect, Paint()..color = const Color(0xFFFFD955));
    canvas.drawRRect(
      rect,
      Paint()
        ..color = const Color(0xFFD6A500)
        ..style = PaintingStyle.stroke,
    );
    final tickPaint = Paint()
      ..color = const Color(0xFFC58C00)
      ..strokeWidth = 1;
    for (var i = 0; i <= 24; i++) {
      final x = i * size.width / 24;
      final h = i % 4 == 0 ? 13.0 : 7.0;
      canvas.drawLine(Offset(x, 6), Offset(x, 6 + h), tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MeasureTipBox extends StatelessWidget {
  const _MeasureTipBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFEFE1A6)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 82, height: 52, child: _TapeMeasureGraphic()),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                height: 1.35,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TapeMeasureGraphic extends StatelessWidget {
  const _TapeMeasureGraphic();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: const _TapeMeasurePainter());
  }
}

class _TapeMeasurePainter extends CustomPainter {
  const _TapeMeasurePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final yellow = Paint()..color = const Color(0xFFFFD64D);
    final dark = Paint()
      ..color = const Color(0xFFB77700)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    canvas.drawOval(Rect.fromLTWH(6, 3, 46, 28), yellow);
    canvas.drawOval(
      Rect.fromLTWH(17, 10, 24, 12),
      Paint()..color = Colors.white,
    );
    canvas.drawOval(Rect.fromLTWH(6, 3, 46, 28), dark);
    final tape = Path()
      ..moveTo(28, 25)
      ..lineTo(size.width - 4, 25)
      ..lineTo(size.width - 4, 44)
      ..quadraticBezierTo(48, 42, 26, 34)
      ..close();
    canvas.drawPath(tape, yellow);
    canvas.drawPath(tape, dark);
    for (var x = 34.0; x < size.width - 6; x += 7) {
      canvas.drawLine(Offset(x, 25), Offset(x, 35), dark);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OutputTypeColumn extends StatelessWidget {
  const _OutputTypeColumn({
    required this.title,
    required this.titleColor,
    required this.liquidColor,
    required this.points,
  });

  final String title;
  final Color titleColor;
  final Color liquidColor;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(
                  width: 62,
                  height: 62,
                  child: _SmallStomaIcon(color: Color(0xFFE91E4D)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 72,
                  height: 125,
                  child: _OutputPouchGraphic(fillColor: liquidColor),
                ),
              ],
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 17,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13.8,
                      height: 1.28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OutputPouchGraphic extends StatelessWidget {
  const _OutputPouchGraphic({required this.fillColor});

  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _OutputPouchPainter(fillColor));
  }
}

class _OutputPouchPainter extends CustomPainter {
  const _OutputPouchPainter(this.fillColor);

  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final pouch = RRect.fromRectAndRadius(
      Rect.fromLTWH(8, 4, size.width - 16, size.height - 8),
      const Radius.circular(28),
    );
    canvas.drawRRect(pouch, Paint()..color = Colors.white);
    canvas.drawRRect(
      pouch,
      Paint()
        ..color = const Color(0xFF2B2B2B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.3,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.31, 18, size.width * 0.38, 24),
      Paint()
        ..color = const Color(0xFFBDBDBD)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final fillRect = Rect.fromLTWH(13, size.height * 0.55, size.width - 26, 44);
    canvas.drawRRect(
      RRect.fromRectAndRadius(fillRect, const Radius.circular(13)),
      Paint()..color = fillColor,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(fillRect, const Radius.circular(13)),
      Paint()
        ..color = fillColor == const Color(0xFF7A3D18)
            ? const Color(0xFF5B260C)
            : const Color(0xFF7D8500)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  bool shouldRepaint(covariant _OutputPouchPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor;
}

class _OutputFactor extends StatelessWidget {
  const _OutputFactor({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF008A96), size: 42),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF007A7E),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

void _drawStoma(
  Canvas canvas,
  Offset center,
  double radius, {
  Color color = const Color(0xFFD71E24),
}) {
  canvas.drawCircle(center, radius, Paint()..color = color);
  canvas.drawCircle(
    center,
    radius * 0.72,
    Paint()..color = const Color(0xFFFFB2A8).withValues(alpha: 0.55),
  );
  canvas.drawCircle(
    center,
    radius * 0.38,
    Paint()..color = const Color(0xFF7A0308),
  );
}

void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
  const dashWidth = 5.0;
  const dashSpace = 4.0;
  final delta = end - start;
  final distance = delta.distance;
  final direction = delta / distance;
  var drawn = 0.0;
  while (drawn < distance) {
    final dashEnd = (drawn + dashWidth).clamp(0.0, distance);
    canvas.drawLine(
      start + direction * drawn,
      start + direction * dashEnd,
      paint,
    );
    drawn += dashWidth + dashSpace;
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.number,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final int number;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.blueGrey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleArtwork extends StatelessWidget {
  const _ModuleArtwork({required this.module});

  final ModuleData module;

  @override
  Widget build(BuildContext context) {
    final isFirst = module.number == 1;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            module.color.withValues(alpha: 0.18),
            module.color.withValues(alpha: 0.05),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: EdgeInsets.all(isFirst ? 14 : 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                module.homeIconAsset,
                fit: isFirst ? BoxFit.contain : BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.color,
    required this.title,
    required this.body,
  });

  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}

class _TextCard extends StatelessWidget {
  const _TextCard({
    required this.title,
    required this.color,
    required this.items,
    this.icon = Icons.check_circle_outline,
  });

  final String title;
  final Color color;
  final List<String> items;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(Icons.circle, size: 8, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item, style: const TextStyle(fontSize: 15)),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.language,
    required this.onLanguageChanged,
    this.dark = false,
    this.visible = false,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final bool dark;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    final isEnglish = language == AppLanguage.english;
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final activeBgColor = dark ? Colors.white : const Color(0xFF1565C0);
    final activeTextColor = dark ? const Color(0xFF1565C0) : Colors.white;
    final inactiveTextColor = dark
        ? Colors.white.withValues(alpha: 0.6)
        : const Color(0xFF475569);

    final double height = isMobile ? 32.0 : 38.0;
    final double globeSize = isMobile ? 15.0 : 18.0;
    final double fontSize = isMobile ? 11.0 : 12.0;
    final EdgeInsets buttonPadding = isMobile
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    final EdgeInsets iconPadding = isMobile
        ? const EdgeInsets.only(left: 6, right: 4)
        : const EdgeInsets.only(left: 8, right: 6);

    return GestureDetector(
      onTap: () {
        onLanguageChanged(
          isEnglish ? AppLanguage.hindi : AppLanguage.english,
        );
      },
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: dark
              ? Colors.white.withValues(alpha: 0.12)
              : const Color(0xFFEBF2FC),
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(
            color: dark
                ? Colors.white.withValues(alpha: 0.25)
                : const Color(0xFFD3E2F8),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: iconPadding,
              child: Icon(
                Icons.language_rounded,
                size: globeSize,
                color: dark ? Colors.white : const Color(0xFF1565C0),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: buttonPadding,
              decoration: BoxDecoration(
                color: isEnglish ? activeBgColor : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'EN',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: isEnglish ? activeTextColor : inactiveTextColor,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: buttonPadding,
              decoration: BoxDecoration(
                color: !isEnglish ? activeBgColor : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'हिंदी',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: !isEnglish ? activeTextColor : inactiveTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderNavigationObserver extends NavigatorObserver {
  _HeaderNavigationObserver(this.onRouteChanged);
  final VoidCallback onRouteChanged;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    onRouteChanged();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    onRouteChanged();
  }
}

final ValueNotifier<AppLanguage> appLanguageNotifier = ValueNotifier(AppLanguage.english);
final ValueNotifier<ModuleData?> activeModuleNotifier = ValueNotifier<ModuleData?>(null);

class LanguageConsumer extends StatelessWidget {
  const LanguageConsumer({super.key, required this.builder});
  final Widget Function(BuildContext context, AppLanguage language) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguageNotifier,
      builder: (context, language, _) {
        return builder(context, language);
      },
    );
  }
}

class StickyStomaHeader extends StatelessWidget {
  const StickyStomaHeader({
    super.key,
    required this.language,
    required this.onLanguageChanged,
    required this.scaffoldKey,
    required this.canPop,
    required this.isScrolled,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool canPop;
  final bool isScrolled;

  @override
  Widget build(BuildContext context) {
    final text = AppText(language);
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final double headerHeight = canPop
        ? (isMobile ? 58.0 : 68.0)
        : (isMobile ? 90.0 : 102.0);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          height: headerHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: isScrolled
                    ? Colors.black.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: isScrolled ? 24.0 : 15.0,
                offset: Offset(0, isScrolled ? 8.0 : 4.0),
              ),
            ],
          ),
          child: canPop
              ? Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: ValueListenableBuilder<ModuleData?>(
                          valueListenable: activeModuleNotifier,
                          builder: (context, activeModule, _) {
                            final titleStr = activeModule != null
                                ? activeModule.title.value(language)
                                : '';
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                titleStr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isMobile ? 16.5 : 18.5,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF10164F),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                                    ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 3.0,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFB794F4),
                            Color(0xFF9F7AEA),
                            Color(0xFF805AD5),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 6.0 : 16.0,
                          vertical: 4.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left Section: Hamburger Menu or Back, and Logo
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: isMobile ? const EdgeInsets.all(4.0) : const EdgeInsets.all(8.0),
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    canPop ? Icons.arrow_back_rounded : Icons.menu_rounded,
                                    size: isMobile ? 24 : 28,
                                  ),
                                  color: const Color(0xFF153A8A),
                                  onPressed: () {
                                    if (canPop) {
                                      Navigator.of(context).pop();
                                    } else {
                                      scaffoldKey.currentState?.openDrawer();
                                    }
                                  },
                                ),
                                SizedBox(width: isMobile ? 4 : 6),
                                Container(
                                  width: isMobile ? 32 : 42,
                                  height: isMobile ? 32 : 42,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(width: isMobile ? 6 : 12),
                            
                            // Center Section: App Name and Tagline (Centered and Expanded)
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    text.appName,
                                    style: TextStyle(
                                      fontSize: isMobile ? 17.0 : 22.0,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFF153A8A),
                                      height: 1.1,
                                      letterSpacing: -0.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    text.tagline,
                                    style: TextStyle(
                                      fontSize: isMobile ? 9.0 : 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF6B7280),
                                      letterSpacing: 0.1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(width: isMobile ? 6 : 12),
                            
                            // Right Section: Language Toggle
                            Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: _LanguageChip(
                                language: language,
                                onLanguageChanged: onLanguageChanged,
                                visible: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 4.0,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFB794F4),
                            Color(0xFF9F7AEA),
                            Color(0xFF805AD5),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.language,
    required this.onLanguageChanged,
    required this.onLogout,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final VoidCallback onLogout;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<NavigatorState> _nestedNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _canPop = false;
  bool _isScrolled = false;
  late final NavigatorObserver _navObserver;

  @override
  void initState() {
    super.initState();
    _navObserver = _HeaderNavigationObserver(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final canPop = _nestedNavKey.currentState?.canPop() ?? false;
          if (!canPop) {
            activeModuleNotifier.value = null;
          }
          if (_canPop != canPop) {
            setState(() {
              _canPop = canPop;
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final modules = buildModules();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FC),
      drawer: _AppDrawer(
        language: widget.language,
        activeItem: _canPop ? '' : 'Home',
        onLogout: widget.onLogout,
        modules: modules,
        nestedNavKey: _nestedNavKey,
      ),
      body: SafeArea(
        child: PopScope(
          canPop: !_canPop,
          onPopInvoked: (didPop) {
            if (didPop) return;
            if (_nestedNavKey.currentState?.canPop() ?? false) {
              _nestedNavKey.currentState?.pop();
            }
          },
          child: Column(
            children: [
              StickyStomaHeader(
                language: widget.language,
                onLanguageChanged: widget.onLanguageChanged,
                scaffoldKey: _scaffoldKey,
                canPop: _canPop,
                isScrolled: _isScrolled,
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.axis == Axis.vertical) {
                      final isScrolled = notification.metrics.pixels > 5.0;
                      if (_isScrolled != isScrolled) {
                        setState(() {
                          _isScrolled = isScrolled;
                        });
                      }
                    }
                    return false;
                  },
                  child: ClipRect(
                    child: Navigator(
                      key: _nestedNavKey,
                      observers: [_navObserver],
                      onGenerateRoute: (settings) {
                        return MaterialPageRoute(
                          builder: (context) => LanguageConsumer(
                            builder: (context, language) => HomeScreen(
                              language: language,
                              onLanguageChanged: widget.onLanguageChanged,
                              onLogout: widget.onLogout,
                            ),
                          ),
                          settings: settings,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({
    required this.language,
    required this.activeItem,
    required this.onLogout,
    required this.modules,
    this.nestedNavKey,
  });

  final AppLanguage language;
  final String activeItem;
  final VoidCallback onLogout;
  final List<ModuleData> modules;
  final GlobalKey<NavigatorState>? nestedNavKey;

  @override
  Widget build(BuildContext context) {
    final text = AppText(language);

    // Filter modules to only contain 1 to 8
    final drawerModules = modules.where((m) => m.number >= 1 && m.number <= 8).toList();

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE8F0FE), Color(0xFFF4F8FC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFFE3EFFD),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          text.appName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF153A8A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          text.tagline,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blueGrey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Drawer Navigation List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  // About the App Nav Item
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.info_outline_rounded,
                    label: text.aboutAppTitle,
                    isActive: activeItem == 'About',
                    onTap: () {
                      Navigator.pop(context); // Close Drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LanguageConsumer(
                            builder: (context, language) => AboutAppScreen(language: language),
                          ),
                        ),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Divider(color: Color(0xFFECEFF1), height: 1),
                  ),

                  // Disclaimer Nav Item
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.gavel_rounded,
                    label: text.disclaimerTitle,
                    isActive: activeItem == 'Disclaimer',
                    onTap: () {
                      Navigator.pop(context); // Close Drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LanguageConsumer(
                            builder: (context, language) => DisclaimerScreen(language: language),
                          ),
                        ),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Divider(color: Color(0xFFECEFF1), height: 1),
                  ),
                  
                  // Home Nav Item
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.dashboard_rounded,
                    label: text.drawerHome,
                    isActive: activeItem == 'Home',
                    onTap: () {
                      Navigator.pop(context); // Close Drawer
                      if (nestedNavKey?.currentState?.canPop() ?? false) {
                        nestedNavKey?.currentState?.popUntil((route) => route.isFirst);
                      }
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: Divider(color: Color(0xFFECEFF1), height: 1),
                  ),
                  
                  // Module Items 1 to 8
                  for (final module in drawerModules)
                    _buildDrawerItem(
                      context: context,
                      icon: module.icon,
                      label: module.number == 1
                          ? text.drawerModule1
                          : module.number == 2
                              ? text.drawerModule2
                              : module.number == 3
                                  ? text.drawerModule3
                                  : module.number == 4
                                      ? text.drawerModule4
                                      : module.number == 5
                                          ? text.drawerModule5
                                          : module.number == 6
                                              ? text.drawerModule6
                                              : module.number == 7
                                                  ? text.drawerModule7
                                                  : text.drawerModule8,
                      isActive: activeItem == 'Module ${module.number}',
                      iconColor: module.color,
                      onTap: () {
                        Navigator.pop(context); // Close Drawer
                        _openModule(context, module);
                      },
                    ),
                ],
              ),
            ),
            
            // Drawer Footer / Logout Section
            const Divider(color: Color(0xFFECEFF1), height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
              child: _buildDrawerItem(
                context: context,
                icon: Icons.logout_rounded,
                label: text.drawerLogout,
                isActive: false,
                iconColor: const Color(0xFFD32F2F),
                textColor: const Color(0xFFD32F2F),
                onTap: () {
                  _showLogoutConfirmation(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    final activeBgColor = const Color(0xFFE8F0FE);
    final activeTextColor = const Color(0xFF1565C0);
    final activeIconColor = const Color(0xFF1565C0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: isActive ? activeBgColor : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        leading: Icon(
          icon,
          size: 22,
          color: isActive
              ? activeIconColor
              : (iconColor ?? const Color(0xFF546E7A)),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            color: isActive
                ? activeTextColor
                : (textColor ?? const Color(0xFF37474F)),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minLeadingWidth: 20,
      ),
    );
  }

  void _openModule(BuildContext context, ModuleData module) {
    final navState = nestedNavKey?.currentState ?? Navigator.of(context);
    if (nestedNavKey != null) {
      nestedNavKey!.currentState!.popUntil((route) => route.isFirst);
    }
    navState.push(
      MaterialPageRoute(
        builder: (_) => LanguageConsumer(
          builder: (context, language) => ModuleScreen(
            module: module,
            language: language,
            onLanguageChanged: (lang) {},
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final isEnglish = language == AppLanguage.english;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            isEnglish ? 'Logout' : 'लॉगआउट',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF153A8A),
            ),
          ),
          content: Text(
            isEnglish
                ? 'Are you sure you want to logout from Stoma Saathi?'
                : 'क्या आप स्टोमा साथी से लॉगआउट करना चाहते हैं?',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF546E7A),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                isEnglish ? 'Cancel' : 'रद्द करें',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF78909C),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
                Navigator.pop(context); // Close Drawer
                
                // Show SnackBar using the outer home screen's context
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          AppText(language).logoutSnackbar,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFF2E7D32),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                  ),
                );
                
                onLogout(); // Trigger logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text(
                isEnglish ? 'Logout' : 'लॉगआउट',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class LocalizedText {
  const LocalizedText(this.en, this.hi);

  final String en;
  final String hi;

  String value(AppLanguage language) {
    return language == AppLanguage.english ? en : hi;
  }
}

class LessonData {
  const LessonData({
    required this.title,
    required this.summary,
    required this.points,
    required this.color,
    this.tips = const [],
    this.warnings = const [],
  });

  final LocalizedText title;
  final LocalizedText summary;
  final List<LocalizedText> points;
  final List<LocalizedText> tips;
  final List<LocalizedText> warnings;
  final Color color;
}

class ModuleData {
  const ModuleData({
    required this.number,
    required this.color,
    required this.icon,
    required this.homeIconAsset,
    required this.title,
    required this.subtitle,
    required this.overview,
    required this.imageAsset,
    required this.cardImageAlignment,
    required this.headerImageAlignment,
    required this.lessonImageAlignment,
    required this.lessons,
  });

  final int number;
  final Color color;
  final IconData icon;
  final String homeIconAsset;
  final LocalizedText title;
  final LocalizedText subtitle;
  final LocalizedText overview;
  final String imageAsset;
  final Alignment cardImageAlignment;
  final Alignment headerImageAlignment;
  final Alignment lessonImageAlignment;
  final List<LessonData> lessons;
}

class AppText {
  const AppText(this.language);

  final AppLanguage language;

  String get appName =>
      language == AppLanguage.english ? 'Stoma Saathi' : 'स्टोमा साथी';
  String get tagline => language == AppLanguage.english
      ? 'Care • Confidence • Companion'
      : 'देखभाल • आत्मविश्वास • साथ';
  String get homeWelcome => language == AppLanguage.english
      ? 'Learn with confidence'
      : 'आत्मविश्वास के साथ सीखें';
  String get homeSubtitle => language == AppLanguage.english
      ? 'Easy stoma education, daily care guidance, warning signs and support in one place.'
      : 'स्टोमा की जानकारी, रोज़ की देखभाल, चेतावनी संकेत और सहायता एक ही जगह पर।';
  String get navHome => language == AppLanguage.english ? 'Home' : 'होम';
  String get navLearn => language == AppLanguage.english ? 'Learn' : 'सीखें';
  String get navCareTips =>
      language == AppLanguage.english ? 'Care Tips' : 'केयर टिप्स';
  String get navSupport =>
      language == AppLanguage.english ? 'Support' : 'सहायता';
  String get module => language == AppLanguage.english ? 'Module' : 'मॉड्यूल';
  String get moduleOverview =>
      language == AppLanguage.english ? 'Module Overview' : 'मॉड्यूल परिचय';
  String get lessons => language == AppLanguage.english ? 'Lessons' : 'पाठ';
  String get quickSummary =>
      language == AppLanguage.english ? 'Quick Summary' : 'संक्षिप्त सार';
  String get keyPoints =>
      language == AppLanguage.english ? 'Key Points' : 'मुख्य बिंदु';
  String get tips =>
      language == AppLanguage.english ? 'Helpful Tips' : 'उपयोगी सुझाव';
  String get caution => language == AppLanguage.english ? 'Caution' : 'सावधानी';

  String get drawerHome => language == AppLanguage.english ? 'Home' : 'होम';
  String get drawerModule1 => language == AppLanguage.english ? 'Module 1' : 'मॉड्यूल 1';
  String get drawerModule2 => language == AppLanguage.english ? 'Module 2' : 'मॉड्यूल 2';
  String get drawerModule3 => language == AppLanguage.english ? 'Module 3' : 'मॉड्यूल 3';
  String get drawerModule4 => language == AppLanguage.english
      ? 'Module 4 – Diet & Nutrition'
      : 'मॉड्यूल 4 – आहार और पोषण';
  String get drawerModule5 => language == AppLanguage.english
      ? 'Module 5 – Exercise & Recovery'
      : 'मॉड्यूल 5 – व्यायाम और रिकवरी';
  String get drawerModule6 => language == AppLanguage.english
      ? 'Module 6 – Travel & Lifestyle'
      : 'मॉड्यूल 6 – यात्रा और जीवनशैली';
  String get drawerModule7 => language == AppLanguage.english
      ? 'Module 7 – Warning Signs'
      : 'मॉड्यूल 7 – चेतावनी संकेत';
  String get drawerModule8 => language == AppLanguage.english
      ? 'Module 8 – Quick Help & Support'
      : 'मॉड्यूल 8 – त्वरित सहायता और समर्थन';
  String get drawerLogout => language == AppLanguage.english ? 'Logout' : 'लॉगआउट';
  String get loginCardTitle => language == AppLanguage.english ? 'Login to your account' : 'अपने खाते में लॉगिन करें';
  String get logoutSnackbar => language == AppLanguage.english ? 'Logged out successfully!' : 'लॉगआउट सफल रहा!';
  String get quickHelp => language == AppLanguage.english ? 'Quick Help' : 'त्वरित सहायता';
  String get needAssistance => language == AppLanguage.english ? 'Need Assistance?' : 'सहायता चाहिए?';
  String get callYourNurse => language == AppLanguage.english ? 'Call Your Nurse' : 'अपनी नर्स से संपर्क करें';
  String get emergencyContact => language == AppLanguage.english ? 'Emergency Contact' : 'आपातकालीन संपर्क';
  String get importantReminder => language == AppLanguage.english ? 'Important Reminder' : 'महत्वपूर्ण अनुस्मारक';

  // About App Screen Localizations
  String get aboutAppTitle => language == AppLanguage.english ? 'About the App' : 'ऐप के बारे में';
  String get aboutAppSubtitle => language == AppLanguage.english ? 'Your Companion in Self-Care' : 'स्व-देखभाल में आपका साथी';
  String get aboutDescription1 => language == AppLanguage.english 
      ? 'Stoma Saathi is an educational mobile application designed to help intestinal ostomy patients learn and practice self-care easily.' 
      : 'स्टोमा साथी एक शैक्षणिक मोबाइल एप्लिकेशन है जिसे आंतों के ऑस्टोमी रोगियों को स्वयं की देखभाल सीखने और उसका अभ्यास करने में सहायता के लिए विकसित किया गया है।';
  String get aboutDescription2 => language == AppLanguage.english
      ? 'It provides information on stoma care, pouch management, skin care, diet, activities, warning signs and emotional well-being through simple text and demonstration videos.'
      : 'यह स्टोमा देखभाल, पाउच प्रबंधन, त्वचा की देखभाल, आहार, गतिविधियाँ, चेतावनी संकेत तथा भावनात्मक स्वास्थ्य से संबंधित जानकारी सरल पाठ और प्रदर्शन वीडियो के माध्यम से प्रदान करता है।';
  String get aboutDevTitle => language == AppLanguage.english ? 'DEVELOPED BY' : 'विकसित किया गया';
  String get aboutDevName => language == AppLanguage.english ? 'Ms. Anjali' : 'सुश्री अंजलि';
  String get aboutDevDegree => language == AppLanguage.english ? 'MSc Nursing (Oncological Nursing)' : 'एमएससी नर्सिंग (ऑन्कोलॉजिकल नर्सिंग)';
  String get aboutDevInst => language == AppLanguage.english ? 'College of Nursing, AIIMS New Delhi' : 'कॉलेज ऑफ नर्सिंग, एम्स नई दिल्ली';
  String get aboutGuidanceTitle => language == AppLanguage.english ? 'ACADEMIC GUIDANCE' : 'शैक्षणिक मार्गदर्शन';
  String get aboutGuidanceText => language == AppLanguage.english ? 'Under the guidance of Faculty,' : 'फैकल्टी के मार्गदर्शन में,';
  String get aboutGuidanceInst => language == AppLanguage.english ? 'College of Nursing, AIIMS New Delhi' : 'कॉलेज ऑफ नर्सिंग, एम्स नई दिल्ली';
  String get aboutValidationTitle => language == AppLanguage.english ? 'CONTENT VALIDATION' : 'सामग्री सत्यापन';
  String get aboutValidationText => language == AppLanguage.english 
      ? 'The educational content of Stoma Saathi has been reviewed and validated by experts in stoma care and oncology departments to ensure accuracy and patient suitability.' 
      : 'स्टोमा साथी की शैक्षणिक सामग्री की समीक्षा और सत्यापन स्टोमा देखभाल तथा ऑन्कोलॉजी विशेषज्ञों द्वारा किया गया है ताकि इसकी सटीकता और रोगी उपयुक्तता सुनिश्चित की जा सके।';
  String get aboutSupportText1 => language == AppLanguage.english ? 'You are not alone in this journey.' : 'आप इस यात्रा में अकेले नहीं हैं।';
  String get aboutSupportText2 => language == AppLanguage.english ? 'Stoma Saathi is here to support you.' : 'स्टोमा साथी आपकी सहायता के लिए हमेशा साथ है।';

  // Disclaimer Screen Localizations
  String get disclaimerTitle => language == AppLanguage.english ? 'Disclaimer' : 'अस्वीकरण';
  String get disclaimerImportantNotice => language == AppLanguage.english ? 'IMPORTANT NOTICE' : 'महत्वपूर्ण सूचना';
  String get seekMedicalHelp => language == AppLanguage.english ? 'SEEK MEDICAL HELP IF YOU HAVE' : 'यदि आपको ये लक्षण हों तो तुरंत चिकित्सा सहायता लें';
  String get footerText => language == AppLanguage.english
      ? 'Your health and safety are important. When in doubt, always consult your healthcare provider.'
      : 'का स्वास्थ्य और सुरक्षा महत्वपूर्ण हैं। संदेह होने पर हमेशा अपने स्वास्थ्य सेवा प्रदाता से सलाह लें।';

  String get disclaimerNotice1Part1 => language == AppLanguage.english ? 'The information provided in Stoma Saathi is for ' : 'स्टोमा साथी में प्रदान की गई जानकारी केवल ';
  String get disclaimerNotice1Highlight => language == AppLanguage.english ? 'educational and self-care support' : 'शिक्षा और स्व-देखभाल सहायता';
  String get disclaimerNotice1Part2 => language == AppLanguage.english ? ' purposes only.' : ' के उद्देश्य से है।';

  String get disclaimerNotice2Part1 => language == AppLanguage.english ? 'This application ' : 'यह एप्लिकेशन ';
  String get disclaimerNotice2Highlight => language == AppLanguage.english ? 'does not replace' : 'चिकित्सा सलाह, निदान या उपचार का विकल्प नहीं है';
  String get disclaimerNotice2Part2 => language == AppLanguage.english 
      ? ' medical advice, diagnosis, or treatment provided by doctors, nurses, or healthcare professionals.' 
      : ' डॉक्टरों, नर्सों या स्वास्थ्य विशेषज्ञों द्वारा दी जाने वाली।';

  String get disclaimerNotice3Part1 => language == AppLanguage.english
      ? 'Patients are advised to follow the instructions given by their treating doctor or stoma nurse. If you experience '
      : 'रोगियों को अपने चिकित्सक या स्टोमा नर्स द्वारा दिए गए निर्देशों का पालन करना चाहिए। यदि आपको ';
  String get disclaimerNotice3Part2 => language == AppLanguage.english
      ? ', please contact your healthcare provider or visit the hospital immediately.'
      : ' दिखाई दें, तो तुरंत अपने स्वास्थ्य सेवा प्रदाता से संपर्क करें या अस्पताल जाएँ।';

  String get supportMessagePart1 => language == AppLanguage.english ? 'Use this application as a ' : 'स्टोमा स्व-देखभाल सीखने के लिए इस एप्लिकेशन का उपयोग एक ';
  String get supportMessageHighlight => language == AppLanguage.english ? 'supportive guide' : 'सहायक मार्गदर्शिका';
  String get supportMessagePart2 => language == AppLanguage.english ? ' for learning stoma self-care.' : ' के रूप में करें।';

  // Emergency Words (Red highlights)
  String get emWordPain => language == AppLanguage.english ? 'severe pain' : 'गंभीर दर्द';
  String get emWordBleeding => language == AppLanguage.english ? 'bleeding' : 'रक्तस्राव';
  String get emWordFever => language == AppLanguage.english ? 'fever' : 'बुखार';
  String get emWordLeakage => language == AppLanguage.english ? 'excessive leakage' : 'अत्यधिक रिसाव';
  String get emWordSkin => language == AppLanguage.english ? 'skin problems around the stoma' : 'स्टोमा के आसपास त्वचा संबंधी समस्या';
  String get emWordColor => language == AppLanguage.english ? 'sudden changes in stoma color' : 'स्टोमा के रंग में अचानक परिवर्तन';
  String get emWordEmergency => language == AppLanguage.english ? 'any emergency symptoms' : 'कोई भी आपातकालीन लक्षण';

  // Emergency Labels (Icon grids)
  String get labelPain => language == AppLanguage.english ? 'Severe\npain' : 'गंभीर\nदर्द';
  String get labelBleeding => language == AppLanguage.english ? 'Bleeding\nfrom stoma' : 'स्टोमा से\nरक्तस्राव';
  String get labelFever => language == AppLanguage.english ? 'Fever' : 'बुखार';
  String get labelLeakage => language == AppLanguage.english ? 'Excessive\nleakage' : 'अत्यधिक\nरिसाव';
  String get labelColor => language == AppLanguage.english ? 'Sudden change\nin stoma color' : 'स्टोमा के रंग में\nअचानक परिवर्तन';
  String get labelSkin => language == AppLanguage.english ? 'Skin problems\naround stoma' : 'स्टोमा के आसपास\nत्वचा समस्या';
}



Color _darken(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return darkened.toColor();
}

List<ModuleData> buildModules() {
  return [
    ModuleData(
      number: 1,
      color: const Color(0xFF2E7D32),
      icon: Icons.health_and_safety_rounded,
      homeIconAsset: 'assets/images/home_icons/home_1.jpg',
      title: const LocalizedText('Stoma Basics', 'स्टोमा की बुनियादी जानकारी'),
      subtitle: const LocalizedText(
        'Learn the basics of ostomy care and understanding.',
        'ओस्टॉमी और उसकी देखभाल की बुनियादी जानकारी सीखें।',
      ),
      overview: const LocalizedText(
        'This module explains what an ostomy is, its types, normal stoma appearance, expected early changes and what output to expect.',
        'इस मॉड्यूल में बताया गया है कि ओस्टॉमी क्या है, उसके प्रकार क्या हैं, स्टोमा सामान्य रूप से कैसा दिखता है और शुरुआती दिनों में क्या बदलाव हो सकते हैं।',
      ),
      imageAsset: 'assets/images/module_1.jpg',
      cardImageAlignment: const Alignment(-0.75, -0.55),
      headerImageAlignment: const Alignment(-0.9, -0.72),
      lessonImageAlignment: const Alignment(0.55, -0.72),
      lessons: [
        LessonData(
          title: const LocalizedText('What is an Ostomy?', 'ओस्टॉमी क्या है?'),
          summary: const LocalizedText(
            'An ostomy is a surgical opening made on the abdomen to pass stool safely out of the body.',
            'ओस्टॉमी पेट पर बनाया गया एक सर्जिकल रास्ता है जिससे मल सुरक्षित रूप से बाहर निकलता है।',
          ),
          points: const [
            LocalizedText(
              'The opening is called a stoma.',
              'इस खुले हिस्से को स्टोमा कहते हैं।',
            ),
            LocalizedText(
              'Waste is collected in a stoma bag or pouch.',
              'मल स्टोमा बैग या पाउच में एकत्र होता है।',
            ),
            LocalizedText(
              'It may be temporary or permanent depending on the condition.',
              'रोग की स्थिति के अनुसार यह अस्थायी या स्थायी हो सकता है।',
            ),
          ],
          color: const Color(0xFF2E7D32),
        ),
        LessonData(
          title: const LocalizedText('Types of Ostomy', 'ओस्टॉमी के प्रकार'),
          summary: const LocalizedText(
            'The two common types are ileostomy and colostomy.',
            'आम तौर पर दो प्रकार होते हैं: इलियोस्टॉमी और कोलोस्टॉमी।',
          ),
          points: const [
            LocalizedText(
              'Ileostomy output is usually liquid or semi-liquid.',
              'इलियोस्टॉमी में आउटपुट आमतौर पर पतला या अर्ध-पतला होता है।',
            ),
            LocalizedText(
              'Colostomy output is more semi-solid or formed.',
              'कोलोस्टॉमी में आउटपुट अधिक गाढ़ा या बना हुआ हो सकता है।',
            ),
            LocalizedText(
              'Emptying frequency depends on the type and your diet.',
              'पाउच खाली करने की आवृत्ति प्रकार और आहार पर निर्भर करती है।',
            ),
          ],
          color: const Color(0xFF1976D2),
        ),
        LessonData(
          title: const LocalizedText(
            'Anatomy and Purpose of Stoma',
            'स्टोमा की संरचना और उद्देश्य',
          ),
          summary: const LocalizedText(
            'A stoma helps stool pass when the normal bowel route cannot be used.',
            'जब सामान्य आंत का रास्ता उपयोग में नहीं लाया जा सकता, तब स्टोमा मल निकालने में मदद करता है।',
          ),
          points: const [
            LocalizedText(
              'It protects healing parts of the intestine after surgery.',
              'यह सर्जरी के बाद ठीक हो रही आंत की रक्षा करता है।',
            ),
            LocalizedText(
              'The stoma has no nerve endings, so touching it should not feel pain.',
              'स्टोमा में नसों के सिरे नहीं होते, इसलिए छूने पर दर्द नहीं होना चाहिए।',
            ),
            LocalizedText(
              'It usually stays moist and pink or red in color.',
              'यह सामान्यतः नम और गुलाबी या लाल रंग का होता है।',
            ),
          ],
          color: const Color(0xFF5E35B1),
        ),
        LessonData(
          title: const LocalizedText(
            'Normal Appearance of Stoma',
            'स्टोमा का सामान्य रूप',
          ),
          summary: const LocalizedText(
            'A healthy stoma is pink to red, moist and round or oval.',
            'स्वस्थ स्टोमा गुलाबी से लाल, नम और गोल या अंडाकार दिखता है।',
          ),
          points: const [
            LocalizedText(
              'Color should look like the inside of your mouth.',
              'रंग मुंह के अंदर की तरह गुलाबी-लाल होना चाहिए।',
            ),
            LocalizedText(
              'Texture should be moist and shiny.',
              'सतह नम और चमकदार होनी चाहिए।',
            ),
            LocalizedText(
              'Small bleeding while cleaning may happen and can be normal.',
              'साफ करते समय हल्का रक्तस्राव हो सकता है और यह सामान्य हो सकता है।',
            ),
          ],
          color: const Color(0xFFE91E63),
        ),
        LessonData(
          title: const LocalizedText(
            'Expected Changes (First 6–8 Weeks)',
            'पहले 6–8 हफ्तों में अपेक्षित बदलाव',
          ),
          summary: const LocalizedText(
            'Your stoma size and swelling usually improve gradually after surgery.',
            'सर्जरी के बाद स्टोमा की सूजन और आकार धीरे-धीरे बेहतर होते हैं।',
          ),
          points: const [
            LocalizedText(
              'Swelling reduces slowly over time.',
              'समय के साथ सूजन धीरे-धीरे कम होती है।',
            ),
            LocalizedText(
              'The size of the stoma may become smaller.',
              'स्टोमा का आकार छोटा हो सकता है।',
            ),
            LocalizedText(
              'Measure the stoma regularly for correct pouch fitting.',
              'सही पाउच फिटिंग के लिए स्टोमा को नियमित रूप से मापें।',
            ),
          ],
          color: const Color(0xFFFF9800),
        ),
        LessonData(
          title: const LocalizedText(
            'Stoma Output (What to Expect)',
            'स्टोमा आउटपुट: क्या अपेक्षा करें',
          ),
          summary: const LocalizedText(
            'Output amount and consistency vary depending on ostomy type, diet, fluid intake and medicines.',
            'आउटपुट की मात्रा और गाढ़ापन ओस्टॉमी के प्रकार, आहार, तरल सेवन और दवाओं पर निर्भर करता है।',
          ),
          points: const [
            LocalizedText(
              'Ileostomy usually gives liquid to semi-liquid stool.',
              'इलियोस्टॉमी में मल आमतौर पर पतला या अर्ध-पतला होता है।',
            ),
            LocalizedText(
              'Colostomy usually gives semi-solid to formed stool.',
              'कोलोस्टॉमी में मल अधिक गाढ़ा या बना हुआ हो सकता है।',
            ),
            LocalizedText(
              'Track changes related to food, fluids and medicines.',
              'भोजन, तरल और दवाओं से जुड़े बदलावों पर ध्यान रखें।',
            ),
          ],
          color: const Color(0xFF0097A7),
        ),
      ],
    ),
    ModuleData(
      number: 2,
      color: const Color(0xFF2E7D32),
      icon: Icons.medical_services_rounded,
      homeIconAsset: 'assets/images/home_icons/home_2.jpg',
      title: const LocalizedText('Stoma Care Kit', 'स्टोमा केयर किट'),
      subtitle: const LocalizedText(
        'Learn about the essential items for daily stoma care.',
        'रोज़ की स्टोमा देखभाल के लिए ज़रूरी सामान जानें।',
      ),
      overview: const LocalizedText(
        'This module introduces the pouch system, skin protection items, cutting tools, cleaning materials and quick care tips.',
        'इस मॉड्यूल में पाउच सिस्टम, त्वचा की सुरक्षा वाली वस्तुएं, काटने के उपकरण, सफाई सामग्री और देखभाल के सुझाव दिए गए हैं।',
      ),
      imageAsset: 'assets/images/module_2.jpg',
      cardImageAlignment: const Alignment(-0.7, -0.7),
      headerImageAlignment: const Alignment(-0.9, -0.78),
      lessonImageAlignment: const Alignment(0.55, -0.78),
      lessons: [
        LessonData(
          title: const LocalizedText(
            'Types of Ostomy Bags (Pouches)',
            'ओस्टॉमी बैग के प्रकार',
          ),
          summary: const LocalizedText(
            'One-piece and two-piece pouch systems are both commonly used.',
            'वन-पीस और टू-पीस दोनों तरह के पाउच सिस्टम उपयोग में आते हैं।',
          ),
          points: const [
            LocalizedText(
              'One-piece systems are simple and easy to use.',
              'वन-पीस सिस्टम सरल और उपयोग में आसान होता है।',
            ),
            LocalizedText(
              'Two-piece systems let you remove the bag without removing the base.',
              'टू-पीस सिस्टम में बेस हटाए बिना बैग बदला जा सकता है।',
            ),
            LocalizedText(
              'Choose the system recommended by your nurse or doctor.',
              'अपने नर्स या डॉक्टर की सलाह के अनुसार सिस्टम चुनें।',
            ),
          ],
          color: const Color(0xFF2E7D32),
        ),
        LessonData(
          title: const LocalizedText(
            'Skin Barrier Products',
            'स्किन बैरियर उत्पाद',
          ),
          summary: const LocalizedText(
            'Barrier rings, paste and wipes help protect skin around the stoma.',
            'बैरियर रिंग, पेस्ट और वाइप्स स्टोमा के आसपास की त्वचा की रक्षा करते हैं।',
          ),
          points: const [
            LocalizedText(
              'Barrier rings help prevent leakage.',
              'बैरियर रिंग रिसाव रोकने में मदद करती हैं।',
            ),
            LocalizedText(
              'Barrier paste fills uneven gaps.',
              'बैरियर पेस्ट खाली जगहों को भरता है।',
            ),
            LocalizedText(
              'Barrier wipes clean and protect the skin.',
              'बैरियर वाइप्स त्वचा को साफ और सुरक्षित रखते हैं।',
            ),
          ],
          color: const Color(0xFF1976D2),
        ),
        LessonData(
          title: const LocalizedText(
            'Measuring Guide and Scissors',
            'माप गाइड और कैंची',
          ),
          summary: const LocalizedText(
            'Accurate measurement helps you cut the opening to the correct size.',
            'सही माप से पाउच की खुली जगह सही आकार में काटी जाती है।',
          ),
          points: const [
            LocalizedText(
              'Measure the stoma before cutting the wafer.',
              'वेफर काटने से पहले स्टोमा को मापें।',
            ),
            LocalizedText(
              'The opening should fit snugly, not too tight.',
              'खुला हिस्सा ठीक से फिट हो, बहुत कसा हुआ न हो।',
            ),
            LocalizedText(
              'Use clean scissors only for stoma care items.',
              'स्टोमा केयर के लिए साफ कैंची का ही उपयोग करें।',
            ),
          ],
          color: const Color(0xFF5E35B1),
        ),
        LessonData(
          title: const LocalizedText('Disposal Bags', 'डिस्पोजल बैग'),
          summary: const LocalizedText(
            'Used pouches should be thrown away in a clean sealed bag.',
            'उपयोग किए गए पाउच को साफ और बंद बैग में फेंकना चाहिए।',
          ),
          points: const [
            LocalizedText(
              'They help prevent odor and maintain hygiene.',
              'ये दुर्गंध रोकते हैं और स्वच्छता बनाए रखते हैं।',
            ),
            LocalizedText(
              'Always seal the bag before disposal.',
              'फेंकने से पहले बैग को अच्छी तरह बंद करें।',
            ),
          ],
          color: const Color(0xFFE91E63),
        ),
        LessonData(
          title: const LocalizedText('Adhesive Removers', 'एडहेसिव रिमूवर'),
          summary: const LocalizedText(
            'Adhesive remover helps take off the pouch gently and with less pain.',
            'एडहेसिव रिमूवर पाउच हटाने को आसान और कम दर्द वाला बनाता है।',
          ),
          points: const [
            LocalizedText(
              'Use it if the pouch is sticking strongly to the skin.',
              'अगर पाउच त्वचा से अधिक चिपका हो तो इसका उपयोग करें।',
            ),
            LocalizedText(
              'It can reduce skin damage during removal.',
              'यह पाउच हटाते समय त्वचा को नुकसान से बचा सकता है।',
            ),
          ],
          color: const Color(0xFFFF9800),
        ),
        LessonData(
          title: const LocalizedText(
            'Protective Skin Films',
            'प्रोटेक्टिव स्किन फिल्म',
          ),
          summary: const LocalizedText(
            'A protective film creates a light shield on the skin.',
            'प्रोटेक्टिव फिल्म त्वचा पर हल्की सुरक्षा परत बनाती है।',
          ),
          points: const [
            LocalizedText(
              'It can reduce irritation and redness.',
              'यह जलन और लालिमा कम कर सकती है।',
            ),
            LocalizedText(
              'It may also improve pouch sticking.',
              'यह पाउच की चिपकने की क्षमता भी बेहतर कर सकती है।',
            ),
          ],
          color: const Color(0xFF0097A7),
        ),
        LessonData(
          title: const LocalizedText('Cleaning Materials', 'सफाई सामग्री'),
          summary: const LocalizedText(
            'Use simple and gentle materials while cleaning the stoma area.',
            'स्टोमा क्षेत्र की सफाई के लिए सरल और मुलायम सामग्री का उपयोग करें।',
          ),
          points: const [
            LocalizedText(
              'Clean water, soft cloth and mild soap are usually enough.',
              'साफ पानी, मुलायम कपड़ा और हल्का साबुन सामान्यतः पर्याप्त होते हैं।',
            ),
            LocalizedText(
              'Avoid harsh chemicals and alcohol-based products.',
              'कड़े केमिकल और अल्कोहल वाले उत्पादों से बचें।',
            ),
            LocalizedText(
              'Keep the area dry before applying a new pouch.',
              'नया पाउच लगाने से पहले क्षेत्र को अच्छी तरह सुखाएं।',
            ),
          ],
          color: const Color(0xFF3949AB),
        ),
      ],
    ),
    ModuleData(
      number: 3,
      color: const Color(0xFF1565C0),
      icon: Icons.fact_check_rounded,
      homeIconAsset: 'assets/images/home_icons/home_3.jpg',
      title: const LocalizedText(
        'Stoma Care Procedure',
        'स्टोमा देखभाल प्रक्रिया',
      ),
      subtitle: const LocalizedText(
        'Follow the step-by-step process for safe stoma care at home.',
        'घर पर सुरक्षित स्टोमा देखभाल के लिए चरण-दर-चरण प्रक्रिया अपनाएं।',
      ),
      overview: const LocalizedText(
        'This module gives the daily procedure from removing the old pouch to cleaning, measuring, sealing, emptying and disposal.',
        'इस मॉड्यूल में पुराना पाउच हटाने से लेकर सफाई, माप, सीलिंग, खाली करना और निपटान तक की पूरी प्रक्रिया दी गई है।',
      ),
      imageAsset: 'assets/images/module_3.jpg',
      cardImageAlignment: const Alignment(-0.78, -0.72),
      headerImageAlignment: const Alignment(-0.9, -0.82),
      lessonImageAlignment: const Alignment(0.55, -0.8),
      lessons: [
        LessonData(
          title: const LocalizedText(
            'Removing the Old Pouch',
            'पुराना पाउच हटाना',
          ),
          summary: const LocalizedText(
            'Remove the pouch slowly from top to bottom while supporting the skin.',
            'त्वचा को सहारा देते हुए पाउच को ऊपर से नीचे की ओर धीरे-धीरे हटाएं।',
          ),
          points: const [
            LocalizedText(
              'Wash your hands before starting.',
              'शुरू करने से पहले हाथ धोएं।',
            ),
            LocalizedText(
              'Use adhesive remover if needed.',
              'ज़रूरत हो तो एडहेसिव रिमूवर का उपयोग करें।',
            ),
            LocalizedText(
              'Support the skin with one hand.',
              'एक हाथ से त्वचा को सहारा दें।',
            ),
          ],
          warnings: const [
            LocalizedText(
              'Do not pull forcefully; it can damage the skin.',
              'जोर से न खींचें; इससे त्वचा को नुकसान हो सकता है।',
            ),
          ],
          color: const Color(0xFF2E7D32),
        ),
        LessonData(
          title: const LocalizedText(
            'Cleaning the Stoma and Skin',
            'स्टोमा और त्वचा की सफाई',
          ),
          summary: const LocalizedText(
            'Clean gently with warm water and pat dry.',
            'गुनगुने पानी से धीरे-धीरे साफ करें और थपथपाकर सुखाएं।',
          ),
          points: const [
            LocalizedText(
              'Use soft cloth or gauze.',
              'मुलायम कपड़ा या गॉज का उपयोग करें।',
            ),
            LocalizedText(
              'Use mild soap only if advised.',
              'हल्का साबुन केवल सलाह मिलने पर ही उपयोग करें।',
            ),
            LocalizedText('Do not rub the stoma.', 'स्टोमा को रगड़ें नहीं।'),
          ],
          tips: const [
            LocalizedText(
              'A little bleeding during cleaning may be normal.',
              'सफाई के दौरान थोड़ा रक्तस्राव सामान्य हो सकता है।',
            ),
          ],
          color: const Color(0xFF1976D2),
        ),
        LessonData(
          title: const LocalizedText('Measuring the Stoma', 'स्टोमा को मापना'),
          summary: const LocalizedText(
            'Measure the stoma regularly, especially in the first 6–8 weeks.',
            'स्टोमा को नियमित रूप से मापें, खासकर पहले 6–8 हफ्तों में।',
          ),
          points: const [
            LocalizedText(
              'Use the measuring guide to check exact size.',
              'सही आकार जानने के लिए माप गाइड का उपयोग करें।',
            ),
            LocalizedText(
              'Correct size helps prevent leakage.',
              'सही आकार रिसाव रोकने में मदद करता है।',
            ),
          ],
          color: const Color(0xFF5E35B1),
        ),
        LessonData(
          title: const LocalizedText('Cutting the Wafer', 'वेफर काटना'),
          summary: const LocalizedText(
            'Cut the wafer opening according to the measured size.',
            'मापे गए आकार के अनुसार वेफर की खुली जगह काटें।',
          ),
          points: const [
            LocalizedText(
              'The fit should be snug but not tight.',
              'फिटिंग ठीक हो, लेकिन बहुत कसी हुई न हो।',
            ),
            LocalizedText(
              'Too large can cause leakage.',
              'बहुत बड़ा कट रिसाव का कारण बन सकता है।',
            ),
            LocalizedText(
              'Too small can hurt the stoma.',
              'बहुत छोटा कट स्टोमा को चोट पहुंचा सकता है।',
            ),
          ],
          color: const Color(0xFFE91E63),
        ),
        LessonData(
          title: const LocalizedText(
            'Applying Skin Barrier',
            'स्किन बैरियर लगाना',
          ),
          summary: const LocalizedText(
            'Apply barrier ring, paste or wipe around the skin if advised.',
            'सलाह मिलने पर त्वचा के आसपास बैरियर रिंग, पेस्ट या वाइप लगाएं।',
          ),
          points: const [
            LocalizedText(
              'Cover the surrounding skin evenly.',
              'आसपास की त्वचा को समान रूप से ढकें।',
            ),
            LocalizedText(
              'This protects skin and improves sealing.',
              'यह त्वचा की रक्षा करता है और सीलिंग बेहतर बनाता है।',
            ),
          ],
          color: const Color(0xFFFF9800),
        ),
        LessonData(
          title: const LocalizedText(
            'Placing and Sealing the Pouch',
            'पाउच लगाना और सील करना',
          ),
          summary: const LocalizedText(
            'Place the pouch gently over the stoma and press firmly.',
            'स्टोमा पर पाउच धीरे से रखें और अच्छी तरह दबाएं।',
          ),
          points: const [
            LocalizedText(
              'Press for a few seconds to secure it.',
              'ठीक से चिपकाने के लिए कुछ सेकंड दबाकर रखें।',
            ),
            LocalizedText(
              'Ensure there are no gaps or folds.',
              'ध्यान रखें कि कहीं गैप या मोड़ न हों।',
            ),
          ],
          color: const Color(0xFF0097A7),
        ),
        LessonData(
          title: const LocalizedText('Checking for Leakage', 'रिसाव की जांच'),
          summary: const LocalizedText(
            'Check pouch edges and look for wetness or smell.',
            'पाउच के किनारों की जांच करें और नमी या गंध पर ध्यान दें।',
          ),
          points: const [
            LocalizedText(
              'Inspect the seal after applying the pouch.',
              'पाउच लगाने के बाद सील की जांच करें।',
            ),
            LocalizedText(
              'Leakage can irritate the surrounding skin.',
              'रिसाव आसपास की त्वचा को नुकसान पहुंचा सकता है।',
            ),
          ],
          color: const Color(0xFF3949AB),
        ),
        LessonData(
          title: const LocalizedText('Emptying the Pouch', 'पाउच खाली करना'),
          summary: const LocalizedText(
            'Empty the pouch when it is about one-third to half full.',
            'जब पाउच लगभग एक-तिहाई से आधा भर जाए, तब उसे खाली करें।',
          ),
          points: const [
            LocalizedText(
              'Sit or stand comfortably near the toilet.',
              'टॉयलेट के पास आराम से बैठें या खड़े हों।',
            ),
            LocalizedText(
              'Clean the outlet after emptying.',
              'खाली करने के बाद आउटलेट साफ करें।',
            ),
          ],
          color: const Color(0xFF1E88E5),
        ),
        LessonData(
          title: const LocalizedText(
            'Disposal of Used Materials',
            'उपयोग की गई सामग्री का निपटान',
          ),
          summary: const LocalizedText(
            'Wrap used materials in a disposal bag and throw away hygienically.',
            'उपयोग की गई सामग्री को डिस्पोजल बैग में लपेटकर स्वच्छ तरीके से फेंकें।',
          ),
          points: const [
            LocalizedText(
              'Seal the bag properly before disposal.',
              'फेंकने से पहले बैग को अच्छी तरह बंद करें।',
            ),
            LocalizedText(
              'Proper disposal helps avoid odor and infection.',
              'सही निपटान दुर्गंध और संक्रमण के जोखिम को कम करता है।',
            ),
          ],
          color: const Color(0xFF43A047),
        ),
      ],
    ),
    ModuleData(
      number: 4,
      color: const Color(0xFF2E7D32),
      icon: Icons.restaurant_rounded,
      homeIconAsset: 'assets/images/home_icons/home_4.jpg',
      title: const LocalizedText('Diet & Fluids', 'आहार और तरल'),
      subtitle: const LocalizedText(
        'Choose foods and fluids that help you stay comfortable.',
        'ऐसे भोजन और तरल चुनें जो आपको आरामदायक रखें।',
      ),
      overview: const LocalizedText(
        'This module explains recovery diet, hydration, stool-thickening foods, foods to limit and warning signs that need nurse support.',
        'इस मॉड्यूल में रिकवरी डाइट, पानी की मात्रा, मल को गाढ़ा करने वाले खाद्य पदार्थ, किन चीजों से बचना है और कब नर्स से संपर्क करना है, यह बताया गया है।',
      ),
      imageAsset: 'assets/images/module_4.jpg',
      cardImageAlignment: const Alignment(-0.74, -0.74),
      headerImageAlignment: const Alignment(-0.9, -0.82),
      lessonImageAlignment: const Alignment(0.62, -0.8),
      lessons: [
        LessonData(
          title: const LocalizedText(
            'Diet Plan (First 4 Weeks)',
            'पहले 4 हफ्तों की डाइट योजना',
          ),
          summary: const LocalizedText(
            'Start with soft, low-fiber foods and add new foods slowly.',
            'शुरुआत में नरम और कम फाइबर वाला भोजन लें और नए खाद्य पदार्थ धीरे-धीरे जोड़ें।',
          ),
          points: const [
            LocalizedText(
              'Week 1–2: soft food, small frequent meals.',
              'हफ्ता 1–2: नरम भोजन और कम मात्रा में बार-बार खाना।',
            ),
            LocalizedText(
              'Week 3–4: add one new food at a time.',
              'हफ्ता 3–4: एक समय में केवल एक नया भोजन जोड़ें।',
            ),
            LocalizedText(
              'Avoid raw vegetables and spicy oily food early on.',
              'शुरुआत में कच्ची सब्जियां और बहुत मसालेदार तैलीय भोजन से बचें।',
            ),
          ],
          color: const Color(0xFF2E7D32),
        ),
        LessonData(
          title: const LocalizedText(
            'Hydration Guidelines',
            'हाइड्रेशन दिशा-निर्देश',
          ),
          summary: const LocalizedText(
            'Drink enough fluids every day to avoid dehydration.',
            'डिहाइड्रेशन से बचने के लिए रोज़ पर्याप्त तरल लें।',
          ),
          points: const [
            LocalizedText(
              'Aim for about 8–10 glasses of fluids daily.',
              'रोज़ लगभग 8–10 गिलास तरल लेने का प्रयास करें।',
            ),
            LocalizedText(
              'Water, ORS and coconut water can help.',
              'पानी, ओआरएस और नारियल पानी मददगार हो सकते हैं।',
            ),
            LocalizedText(
              'Watch for dry mouth, less urine and dizziness.',
              'मुंह सूखना, पेशाब कम होना और चक्कर पर ध्यान दें।',
            ),
          ],
          color: const Color(0xFF1976D2),
        ),
        LessonData(
          title: const LocalizedText(
            'Foods That Thicken Stool',
            'मल को गाढ़ा करने वाले खाद्य पदार्थ',
          ),
          summary: const LocalizedText(
            'Some foods may help if stools are loose.',
            'अगर मल पतला हो तो कुछ खाद्य पदार्थ मदद कर सकते हैं।',
          ),
          points: const [
            LocalizedText(
              'Banana, rice, curd, apple and potato may help.',
              'केला, चावल, दही, सेब और आलू मदद कर सकते हैं।',
            ),
          ],
          color: const Color(0xFF5E35B1),
        ),
        LessonData(
          title: const LocalizedText(
            'Foods That Loosen Stool',
            'मल को पतला करने वाले खाद्य पदार्थ',
          ),
          summary: const LocalizedText(
            'Certain foods can make stools looser for some people.',
            'कुछ खाद्य पदार्थ कुछ लोगों में मल को और पतला कर सकते हैं।',
          ),
          points: const [
            LocalizedText(
              'Green leafy vegetables, spicy food and fried food may loosen stool.',
              'हरी पत्तेदार सब्जियां, मसालेदार और तली हुई चीजें मल को पतला कर सकती हैं।',
            ),
            LocalizedText(
              'Milk may cause problems in some patients.',
              'कुछ मरीजों में दूध से भी दिक्कत हो सकती है।',
            ),
          ],
          color: const Color(0xFFE91E63),
        ),
        LessonData(
          title: const LocalizedText(
            'Foods to Avoid Initially',
            'शुरुआत में किन खाद्य पदार्थों से बचें',
          ),
          summary: const LocalizedText(
            'Some foods can cause blockage, gas or irritation soon after surgery.',
            'सर्जरी के बाद शुरुआती समय में कुछ खाद्य पदार्थ रुकावट, गैस या जलन पैदा कर सकते हैं।',
          ),
          points: const [
            LocalizedText(
              'Avoid nuts, corn, popcorn and beans initially.',
              'शुरुआत में मेवे, मकई, पॉपकॉर्न और बीन्स से बचें।',
            ),
            LocalizedText(
              'Cabbage, cauliflower and onions can also trouble some people.',
              'पत्ता गोभी, फूलगोभी और प्याज भी कुछ लोगों को परेशानी दे सकते हैं।',
            ),
          ],
          color: const Color(0xFFFF9800),
        ),
        LessonData(
          title: const LocalizedText(
            'Tips to Reduce Odor and Gas',
            'गंध और गैस कम करने के उपाय',
          ),
          summary: const LocalizedText(
            'Simple food habits can reduce gas and odor.',
            'कुछ सरल आदतें गैस और गंध कम कर सकती हैं।',
          ),
          points: const [
            LocalizedText(
              'Eat slowly and chew your food well.',
              'धीरे खाएं और भोजन अच्छी तरह चबाएं।',
            ),
            LocalizedText(
              'Avoid carbonated drinks.',
              'कार्बोनेटेड ड्रिंक से बचें।',
            ),
            LocalizedText(
              'Drink enough water and keep the pouch clean.',
              'पर्याप्त पानी पिएं और पाउच साफ रखें।',
            ),
          ],
          color: const Color(0xFF0097A7),
        ),
        LessonData(
          title: const LocalizedText(
            'When to Contact Nurse',
            'नर्स से कब संपर्क करें',
          ),
          summary: const LocalizedText(
            'Seek help for no output, severe pain, vomiting or dehydration signs.',
            'आउटपुट बंद हो, तेज दर्द, उल्टी या डिहाइड्रेशन के लक्षण हों तो मदद लें।',
          ),
          points: const [
            LocalizedText(
              'No output for a long time.',
              'लंबे समय तक आउटपुट न आना।',
            ),
            LocalizedText(
              'Continuous watery stool or severe abdominal pain.',
              'लगातार बहुत पतला मल या तेज पेट दर्द।',
            ),
            LocalizedText(
              'Vomiting or signs of dehydration.',
              'उल्टी या डिहाइड्रेशन के लक्षण।',
            ),
          ],
          color: const Color(0xFF1565C0),
        ),
        LessonData(
          title: const LocalizedText('Quick Tips', 'Quick Tips'),
          summary: const LocalizedText(
            'Simple daily food habits can make diet changes safer and easier.',
            'Simple daily food habits can make diet changes safer and easier.',
          ),
          points: const [
            LocalizedText(
              'Eat small frequent meals.',
              'Eat small frequent meals.',
            ),
            LocalizedText('Chew food properly.', 'Chew food properly.'),
            LocalizedText(
              'Try new foods one at a time.',
              'Try new foods one at a time.',
            ),
            LocalizedText('Maintain food diary.', 'Maintain food diary.'),
          ],
          color: const Color(0xFF087A24),
        ),
      ],
    ),
    ModuleData(
      number: 5,
      color: const Color(0xFF2E7D32),
      icon: Icons.directions_walk_rounded,
      homeIconAsset: 'assets/images/home_icons/home_5.jpg',
      title: const LocalizedText('Recovery Exercises', 'रिकवरी एक्सरसाइज़'),
      subtitle: const LocalizedText(
        'Safe movement and exercises for a smoother recovery.',
        'सुरक्षित गतिविधि और व्यायाम से बेहतर रिकवरी करें।',
      ),
      overview: const LocalizedText(
        'This module covers early walking, gentle abdominal exercises, hernia prevention and safe activity progression after surgery.',
        'इस मॉड्यूल में शुरुआती चलना, हल्के पेट के व्यायाम, हर्निया से बचाव और सर्जरी के बाद सुरक्षित गतिविधि बढ़ाने की जानकारी है।',
      ),
      imageAsset: 'assets/images/module_5.jpg',
      cardImageAlignment: const Alignment(-0.72, -0.72),
      headerImageAlignment: const Alignment(-0.9, -0.8),
      lessonImageAlignment: const Alignment(0.62, -0.8),
      lessons: [
        LessonData(
          title: const LocalizedText(
            'Early Ambulation (Walking)',
            'शुरुआती चलना',
          ),
          summary: const LocalizedText(
            'Walking soon after surgery helps improve circulation and recovery.',
            'सर्जरी के बाद जल्दी चलना रक्त प्रवाह और रिकवरी में मदद करता है।',
          ),
          points: const [
            LocalizedText(
              'Start within 24–48 hours if advised.',
              'सलाह मिलने पर 24–48 घंटे के भीतर शुरू करें।',
            ),
            LocalizedText(
              'Begin with short distances and increase slowly.',
              'कम दूरी से शुरू करें और धीरे-धीरे बढ़ाएं।',
            ),
          ],
          warnings: const [
            LocalizedText(
              'Walk slowly and take support if needed.',
              'धीरे चलें और ज़रूरत हो तो सहारा लें।',
            ),
          ],
          color: const Color(0xFF2E7D32),
        ),
        LessonData(
          title: const LocalizedText(
            'Abdominal Strengthening Exercises',
            'पेट मजबूत करने वाले व्यायाम',
          ),
          summary: const LocalizedText(
            'Do only gentle exercises when your doctor allows them.',
            'डॉक्टर की सलाह मिलने पर ही हल्के व्यायाम करें।',
          ),
          points: const [
            LocalizedText(
              'Deep breathing and gentle abdominal tightening are common starting exercises.',
              'गहरी सांस लेना और हल्का पेट कसना शुरुआती व्यायाम हो सकते हैं।',
            ),
            LocalizedText(
              'Do 5–10 repetitions, 2–3 times daily if comfortable.',
              'आराम से हो तो 5–10 बार, दिन में 2–3 बार करें।',
            ),
          ],
          warnings: const [
            LocalizedText(
              'Stop if pain occurs.',
              'दर्द होने पर व्यायाम रोक दें।',
            ),
          ],
          color: const Color(0xFF1976D2),
        ),
        LessonData(
          title: const LocalizedText(
            'Hernia Prevention Techniques',
            'हर्निया से बचाव के तरीके',
          ),
          summary: const LocalizedText(
            'Support your abdomen and avoid sudden strain.',
            'पेट को सहारा दें और अचानक जोर लगाने से बचें।',
          ),
          points: const [
            LocalizedText(
              'Use a pillow while coughing or sneezing.',
              'खांसते या छींकते समय तकिया पकड़कर सहारा दें।',
            ),
            LocalizedText(
              'Maintain good posture and avoid sudden force.',
              'अच्छी बॉडी पोज़िशन रखें और अचानक जोर न लगाएं।',
            ),
          ],
          color: const Color(0xFF5E35B1),
        ),
        LessonData(
          title: const LocalizedText(
            'Lifting and Straining Precautions',
            'वज़न उठाने और ज़ोर लगाने में सावधानी',
          ),
          summary: const LocalizedText(
            'Avoid heavy lifting and unsafe body positions during early recovery.',
            'रिकवरी के शुरुआती समय में भारी वज़न और गलत बॉडी पोज़िशन से बचें।',
          ),
          points: const [
            LocalizedText(
              'Avoid heavy lifting above 5 kg initially.',
              'शुरुआत में 5 किलो से ज़्यादा वजन न उठाएं।',
            ),
            LocalizedText(
              'Avoid straining during bowel movements.',
              'मल त्याग के दौरान बहुत ज़ोर न लगाएं।',
            ),
            LocalizedText(
              'Bend your knees if you need to lift something light.',
              'हल्का वजन उठाते समय घुटनों को मोड़ें।',
            ),
          ],
          color: const Color(0xFFFF9800),
        ),
        LessonData(
          title: const LocalizedText(
            'Activity Progression Timeline',
            'गतिविधि बढ़ाने की समयरेखा',
          ),
          summary: const LocalizedText(
            'Return to daily routine gradually over the first few weeks.',
            'पहले कुछ हफ्तों में धीरे-धीरे रोज़मर्रा की गतिविधियों में लौटें।',
          ),
          points: const [
            LocalizedText(
              'After 2 weeks: light household work and walking.',
              '2 हफ्तों बाद: हल्का घरेलू काम और चलना।',
            ),
            LocalizedText(
              'After 6 weeks: moderate activity if approved.',
              '6 हफ्तों बाद: अनुमति मिलने पर मध्यम गतिविधि।',
            ),
          ],
          warnings: const [
            LocalizedText(
              'Avoid heavy exercise unless approved by your doctor.',
              'डॉक्टर की अनुमति के बिना भारी व्यायाम न करें।',
            ),
          ],
          color: const Color(0xFF0097A7),
        ),
        LessonData(
          title: const LocalizedText(
            'When to Stop Exercise & Contact Nurse',
            'व्यायाम कब रोकें और नर्स से संपर्क करें',
          ),
          summary: const LocalizedText(
            'Severe pain, dizziness, breathlessness or swelling near the stoma need attention.',
            'तेज दर्द, चक्कर, सांस फूलना या स्टोमा के पास सूजन होने पर ध्यान देना ज़रूरी है।',
          ),
          points: const [
            LocalizedText(
              'Stop exercising if you feel unwell.',
              'अगर अस्वस्थ महसूस हो तो व्यायाम रोक दें।',
            ),
            LocalizedText(
              'Contact your nurse immediately for severe symptoms.',
              'गंभीर लक्षण होने पर तुरंत नर्स से संपर्क करें।',
            ),
          ],
          color: const Color(0xFFE53935),
        ),
      ],
    ),
    ModuleData(
      number: 6,
      color: const Color(0xFF2E7D32),
      icon: Icons.tips_and_updates_rounded,
      homeIconAsset: 'assets/images/home_icons/home_6.jpg',
      title: const LocalizedText('Everyday Tips', 'रोज़मर्रा के सुझाव'),
      subtitle: const LocalizedText(
        'Travel, clothing, work and daily confidence with a stoma.',
        'स्टोमा के साथ यात्रा, कपड़े, काम और रोज़मर्रा के आत्मविश्वास के सुझाव।',
      ),
      overview: const LocalizedText(
        'This module helps you manage travel, public restrooms, safety, relationships, clothing and return to work.',
        'यह मॉड्यूल यात्रा, सार्वजनिक शौचालय, सुरक्षा, रिश्ते, कपड़े और काम पर वापसी को संभालने में मदद करता है।',
      ),
      imageAsset: 'assets/images/module6_everyday_tips.png',
      cardImageAlignment: const Alignment(-0.85, -0.86),
      headerImageAlignment: const Alignment(-0.95, -0.96),
      lessonImageAlignment: const Alignment(0.7, -0.94),
      lessons: [
        LessonData(
          title: const LocalizedText('Travel Tips', 'यात्रा के सुझाव'),
          summary: const LocalizedText(
            'Carry extra supplies and plan before leaving home.',
            'घर से निकलने से पहले अतिरिक्त सामान रखें और योजना बनाएं।',
          ),
          points: const [
            LocalizedText(
              'Carry 2–3 times the usual amount of supplies.',
              'आवश्यक सामान सामान्य मात्रा से 2–3 गुना रखें।',
            ),
            LocalizedText(
              'Keep supplies in hand luggage, not checked luggage.',
              'सामान को अपने साथ रखें, केवल बड़े बैग में न रखें।',
            ),
            LocalizedText(
              'If possible, carry a doctor’s note.',
              'यदि संभव हो तो डॉक्टर का नोट रखें।',
            ),
          ],
          color: const Color(0xFF1565C0),
        ),
        LessonData(
          title: const LocalizedText(
            'Managing Ostomy During Long Travel',
            'लंबी यात्रा में स्टोमा प्रबंधन',
          ),
          summary: const LocalizedText(
            'Empty the pouch regularly and stay hydrated.',
            'पाउच को समय-समय पर खाली करें और शरीर में पानी की कमी न होने दें।',
          ),
          points: const [
            LocalizedText(
              'Do not overeat before travel.',
              'यात्रा से पहले बहुत ज़्यादा न खाएं।',
            ),
            LocalizedText(
              'Keep a small emergency kit handy.',
              'एक छोटा इमरजेंसी किट साथ रखें।',
            ),
          ],
          color: const Color(0xFF00897B),
        ),
        LessonData(
          title: const LocalizedText(
            'Public Restroom Management',
            'सार्वजनिक शौचालय का उपयोग',
          ),
          summary: const LocalizedText(
            'Carry tissues, wipes and disposal bags while using public restrooms.',
            'सार्वजनिक शौचालय उपयोग करते समय टिश्यू, वाइप्स और डिस्पोजल बैग साथ रखें।',
          ),
          points: const [
            LocalizedText(
              'Use hand sanitizer.',
              'हैंड सैनिटाइज़र का उपयोग करें।',
            ),
            LocalizedText(
              'Take your time and stay calm.',
              'आराम से करें और घबराएं नहीं।',
            ),
          ],
          color: const Color(0xFF5E35B1),
        ),
        LessonData(
          title: const LocalizedText(
            'Transportation and Safety',
            'यातायात और सुरक्षा',
          ),
          summary: const LocalizedText(
            'Sit comfortably and keep supplies easy to reach.',
            'आराम से बैठें और ज़रूरी सामान पास में रखें।',
          ),
          points: const [
            LocalizedText(
              'Avoid direct pressure on the stoma.',
              'स्टोमा पर सीधा दबाव न पड़ने दें।',
            ),
            LocalizedText(
              'Avoid crowded travel in the beginning if possible.',
              'शुरुआत में बहुत भीड़भाड़ वाली यात्रा से बचें।',
            ),
          ],
          color: const Color(0xFFF4511E),
        ),
        LessonData(
          title: const LocalizedText(
            'Car Seat Belt Adjustment',
            'कार सीट बेल्ट समायोजन',
          ),
          summary: const LocalizedText(
            'Adjust the belt so it does not press directly on the stoma.',
            'सीट बेल्ट को इस तरह सेट करें कि वह स्टोमा पर सीधे दबाव न डाले।',
          ),
          points: const [
            LocalizedText(
              'Use a soft cloth or cushion if needed.',
              'ज़रूरत हो तो मुलायम कपड़ा या कुशन उपयोग करें।',
            ),
          ],
          color: const Color(0xFF1E88E5),
        ),
        LessonData(
          title: const LocalizedText('Clothing Tips', 'कपड़ों के सुझाव'),
          summary: const LocalizedText(
            'Loose and high-waist clothes are often more comfortable.',
            'ढीले और हाई-वेस्ट कपड़े अक्सर अधिक आरामदायक होते हैं।',
          ),
          points: const [
            LocalizedText(
              'Avoid tight belts and waistbands.',
              'बहुत टाइट बेल्ट और कमरबंद से बचें।',
            ),
            LocalizedText(
              'Choose what makes you feel confident.',
              'ऐसे कपड़े चुनें जिनमें आप आत्मविश्वास महसूस करें।',
            ),
          ],
          color: const Color(0xFF2E7D32),
        ),
        LessonData(
          title: const LocalizedText(
            'Intimacy and Relationships',
            'निकटता और रिश्ते',
          ),
          summary: const LocalizedText(
            'Open communication and comfort matter most.',
            'खुलकर बात करना और आरामदायक महसूस करना सबसे महत्वपूर्ण है।',
          ),
          points: const [
            LocalizedText(
              'Feeling nervous is normal.',
              'घबराहट होना सामान्य है।',
            ),
            LocalizedText(
              'Empty the pouch before intimate activity.',
              'निकटता से पहले पाउच खाली कर लें।',
            ),
            LocalizedText(
              'Choose comfortable positions and use a pouch cover if needed.',
              'आरामदायक स्थिति चुनें और ज़रूरत हो तो पाउच कवर उपयोग करें।',
            ),
          ],
          color: const Color(0xFFD81B60),
        ),
        LessonData(
          title: const LocalizedText('Return to Work', 'काम पर वापसी'),
          summary: const LocalizedText(
            'Many people return to work in 4–6 weeks when advised.',
            'सलाह मिलने पर बहुत से लोग 4–6 हफ्तों में काम पर लौट सकते हैं।',
          ),
          points: const [
            LocalizedText(
              'Avoid heavy lifting at work initially.',
              'शुरुआत में कार्यस्थल पर भारी वजन न उठाएं।',
            ),
            LocalizedText(
              'Take breaks if needed and maintain hygiene.',
              'ज़रूरत हो तो ब्रेक लें और स्वच्छता रखें।',
            ),
          ],
          color: const Color(0xFF3949AB),
        ),
        LessonData(
          title: const LocalizedText(
            'Carrying Supplies Discreetly',
            'सामान को सहजता से साथ रखना',
          ),
          summary: const LocalizedText(
            'Keep an extra pouch, wipes and disposal bags in a small bag.',
            'एक छोटे बैग में अतिरिक्त पाउच, वाइप्स और डिस्पोजल बैग रखें।',
          ),
          points: const [
            LocalizedText(
              'No one needs to know unless you want to share.',
              'जब तक आप न चाहें, किसी को बताना ज़रूरी नहीं है।',
            ),
          ],
          color: const Color(0xFF00796B),
        ),
        LessonData(
          title: const LocalizedText(
            'Sports & Physical Activity with Stoma',
            'खेल और शारीरिक गतिविधि',
          ),
          summary: const LocalizedText(
            'Staying active is good for your body and mind.',
            'शारीरिक रूप से सक्रिय रहना आपके शरीर और दिमाग के लिए अच्छा है।',
          ),
          points: const [
            LocalizedText(
              'Start slowly and listen to your body.',
              'धीरे-धीरे शुरुआत करें और अपने शरीर की सुनें।',
            ),
          ],
          color: const Color(0xFF5F9F99),
        ),
      ],
    ),
    ModuleData(
      number: 7,
      color: const Color(0xFFE53935),
      icon: Icons.warning_amber_rounded,
      homeIconAsset: 'assets/images/home_icons/home_7.jpg',
      title: const LocalizedText('Warning Signs', 'चेतावनी संकेत'),
      subtitle: const LocalizedText(
        'Recognize early danger signs and seek help quickly.',
        'खतरे के शुरुआती संकेत पहचानें और समय पर सहायता लें।',
      ),
      overview: const LocalizedText(
        'This module covers stoma color changes, output problems, dehydration, infection, pain and emergency signs that need immediate action.',
        'इस मॉड्यूल में स्टोमा के रंग में बदलाव, आउटपुट की समस्या, डिहाइड्रेशन, संक्रमण, दर्द और आपात संकेत शामिल हैं जिनमें तुरंत कार्रवाई ज़रूरी है।',
      ),
      imageAsset: 'assets/images/module7_patient.png',
      cardImageAlignment: const Alignment(-0.82, -0.82),
      headerImageAlignment: const Alignment(-0.92, -0.95),
      lessonImageAlignment: const Alignment(0.68, -0.92),
      lessons: [
        LessonData(
          title: const LocalizedText(
            'Stoma-Related Changes',
            'स्टोमा से जुड़े बदलाव',
          ),
          summary: const LocalizedText(
            'A black, pale, bluish or suddenly changed stoma should not be ignored.',
            'काला, पीला, नीला या अचानक बदला हुआ स्टोमा नज़रअंदाज़ नहीं करना चाहिए।',
          ),
          points: const [
            LocalizedText(
              'Watch for sudden change in size or shape.',
              'आकार या आकृति में अचानक बदलाव पर ध्यान दें।',
            ),
            LocalizedText(
              'Continuous or heavy bleeding needs review.',
              'लगातार या अधिक रक्तस्राव होने पर जांच कराएं।',
            ),
          ],
          color: const Color(0xFFE53935),
        ),
        LessonData(
          title: const LocalizedText('Output Problems', 'आउटपुट की समस्याएं'),
          summary: const LocalizedText(
            'No output, sudden decrease or very watery output can be serious.',
            'आउटपुट बंद होना, अचानक कम होना या बहुत पतला होना गंभीर हो सकता है।',
          ),
          points: const [
            LocalizedText(
              'No output for a long time, especially with pain, needs help.',
              'लंबे समय तक आउटपुट बंद हो और दर्द हो तो मदद लें।',
            ),
            LocalizedText(
              'Excessive watery output can cause dehydration.',
              'बहुत पतला आउटपुट डिहाइड्रेशन का कारण बन सकता है।',
            ),
          ],
          color: const Color(0xFFF57C00),
        ),
        LessonData(
          title: const LocalizedText(
            'Signs of Dehydration',
            'डिहाइड्रेशन के संकेत',
          ),
          summary: const LocalizedText(
            'Dry mouth, reduced urine and dizziness are common warning signs.',
            'मुंह सूखना, पेशाब कम होना और चक्कर डिहाइड्रेशन के सामान्य संकेत हैं।',
          ),
          points: const [
            LocalizedText('Drink plenty of fluids.', 'पर्याप्त तरल लें।'),
            LocalizedText(
              'Seek help if symptoms continue.',
              'लक्षण बने रहें तो मदद लें।',
            ),
          ],
          color: const Color(0xFF1E88E5),
        ),
        LessonData(
          title: const LocalizedText(
            'Skin Problems Around Stoma',
            'स्टोमा के आसपास त्वचा की समस्याएं',
          ),
          summary: const LocalizedText(
            'Redness, rash, swelling, pus or irritation need attention.',
            'लालिमा, रैश, सूजन, पस या जलन पर ध्यान देना ज़रूरी है।',
          ),
          points: const [
            LocalizedText(
              'Keep the area clean and dry.',
              'क्षेत्र को साफ और सूखा रखें।',
            ),
            LocalizedText(
              'Contact your nurse if the problem persists.',
              'समस्या बनी रहे तो नर्स से संपर्क करें।',
            ),
          ],
          color: const Color(0xFF2E7D32),
        ),
        LessonData(
          title: const LocalizedText('Pain and Discomfort', 'दर्द और असुविधा'),
          summary: const LocalizedText(
            'Persistent abdominal pain or pain around the stoma needs assessment.',
            'लगातार पेट दर्द या स्टोमा के आसपास दर्द होने पर जांच ज़रूरी है।',
          ),
          points: const [
            LocalizedText(
              'Do not ignore ongoing pain.',
              'लगातार दर्द को अनदेखा न करें।',
            ),
          ],
          color: const Color(0xFF5E35B1),
        ),
        LessonData(
          title: const LocalizedText('Signs of Infection', 'संक्रमण के संकेत'),
          summary: const LocalizedText(
            'Fever, warmth, swelling and foul-smelling discharge can mean infection.',
            'बुखार, गर्माहट, सूजन और बदबूदार स्राव संक्रमण का संकेत हो सकते हैं।',
          ),
          points: const [
            LocalizedText(
              'Infection can get serious if ignored.',
              'अनदेखा करने पर संक्रमण गंभीर हो सकता है।',
            ),
            LocalizedText('Seek help early.', 'जल्दी सहायता लें।'),
          ],
          color: const Color(0xFF00897B),
        ),
        LessonData(
          title: const LocalizedText(
            'Gastrointestinal Symptoms',
            'पाचन संबंधी लक्षण',
          ),
          summary: const LocalizedText(
            'Nausea, vomiting, bloating or swelling need attention.',
            'मितली, उल्टी, पेट फूलना या सूजन होने पर ध्यान दें।',
          ),
          points: const [
            LocalizedText(
              'These symptoms can lead to dehydration and other complications.',
              'ये लक्षण डिहाइड्रेशन और अन्य जटिलताओं का कारण बन सकते हैं।',
            ),
          ],
          color: const Color(0xFF1976D2),
        ),
        LessonData(
          title: const LocalizedText('Emergency Signs', 'आपात संकेत'),
          summary: const LocalizedText(
            'Black or pale stoma, no output with severe pain, heavy bleeding or persistent vomiting need urgent help.',
            'काला या पीला स्टोमा, तेज दर्द के साथ आउटपुट बंद होना, अधिक रक्तस्राव या लगातार उल्टी होने पर तुरंत मदद लें।',
          ),
          points: const [
            LocalizedText(
              'Go to hospital immediately for severe emergency signs.',
              'गंभीर आपात संकेत होने पर तुरंत अस्पताल जाएं।',
            ),
            LocalizedText(
              'Contact your nurse immediately if you are unsure.',
              'अगर संदेह हो तो तुरंत नर्स से संपर्क करें।',
            ),
          ],
          color: const Color(0xFFD32F2F),
        ),
      ],
    ),
    ModuleData(
      number: 8,
      color: const Color(0xFF3949AB),
      icon: Icons.support_agent_rounded,
      homeIconAsset: 'assets/images/home_icons/home_8.jpg',
      title: const LocalizedText('Nurse Help', 'नर्स सहायता'),
      subtitle: const LocalizedText(
        'Ask questions and share concerns through built-in support.',
        'इनबिल्ट सहायता के माध्यम से सवाल पूछें और अपनी समस्या साझा करें।',
      ),
      overview: const LocalizedText(
        'This module explains how the Ask-a-Nurse feature works, what you can send, response time, privacy and when urgent care is still needed.',
        'इस मॉड्यूल में बताया गया है कि Ask-a-Nurse फीचर कैसे काम करता है, आप क्या भेज सकते हैं, जवाब कब मिलेगा, गोपनीयता कैसे रखी जाएगी और कब तत्काल चिकित्सा सहायता चाहिए।',
      ),
      imageAsset: 'assets/images/module_8.jpg',
      cardImageAlignment: const Alignment(-0.82, -0.82),
      headerImageAlignment: const Alignment(-0.92, -0.95),
      lessonImageAlignment: const Alignment(0.68, -0.92),
      lessons: [
        LessonData(
          title: const LocalizedText(
            'What This Feature Does',
            'यह फीचर क्या करता है',
          ),
          summary: const LocalizedText(
            'You can ask stoma-related questions and share difficulties for guidance.',
            'आप स्टोमा से जुड़े सवाल पूछ सकते हैं और मार्गदर्शन के लिए अपनी समस्या साझा कर सकते हैं।',
          ),
          points: const [
            LocalizedText(
              'Ask questions about care, leakage or skin issues.',
              'देखभाल, रिसाव या त्वचा की समस्या से जुड़े सवाल पूछें।',
            ),
            LocalizedText(
              'Get guidance from a trained nurse or researcher.',
              'प्रशिक्षित नर्स या रिसर्चर से मार्गदर्शन पाएं।',
            ),
          ],
          color: const Color(0xFF3949AB),
        ),
        LessonData(
          title: const LocalizedText(
            'What You Can Send',
            'आप क्या भेज सकते हैं',
          ),
          summary: const LocalizedText(
            'Send text messages and images related to your concern.',
            'आप अपनी समस्या से जुड़ा टेक्स्ट संदेश और फोटो भेज सकते हैं।',
          ),
          points: const [
            LocalizedText(
              'Write your question clearly.',
              'अपना सवाल साफ़-साफ़ लिखें।',
            ),
            LocalizedText(
              'Upload a clear image if there is redness, leakage or skin change.',
              'लालिमा, रिसाव या त्वचा में बदलाव हो तो स्पष्ट फोटो अपलोड करें।',
            ),
          ],
          color: const Color(0xFF00897B),
        ),
        LessonData(
          title: const LocalizedText('Response Time', 'जवाब मिलने का समय'),
          summary: const LocalizedText(
            'The query is expected to be answered within 24 hours.',
            'आपके प्रश्न का उत्तर लगभग 24 घंटे के भीतर दिया जाएगा।',
          ),
          points: const [
            LocalizedText(
              'A nurse or researcher will review your issue first.',
              'नर्स या रिसर्चर पहले आपकी समस्या की समीक्षा करेंगे।',
            ),
          ],
          warnings: const [
            LocalizedText(
              'In urgent cases, contact a doctor or hospital immediately.',
              'आपात स्थिति में तुरंत डॉक्टर या अस्पताल से संपर्क करें।',
            ),
          ],
          color: const Color(0xFFF9A825),
        ),
        LessonData(
          title: const LocalizedText(
            'Privacy and Confidentiality',
            'गोपनीयता और निजता',
          ),
          summary: const LocalizedText(
            'Your information stays confidential and is used only for care purposes.',
            'आपकी जानकारी गोपनीय रखी जाएगी और केवल देखभाल के उद्देश्य से उपयोग होगी।',
          ),
          points: const [
            LocalizedText(
              'Only the assigned nurse or researcher can access your query.',
              'केवल संबंधित नर्स या रिसर्चर ही आपकी जानकारी देख सकते हैं।',
            ),
          ],
          color: const Color(0xFFD81B60),
        ),
        LessonData(
          title: const LocalizedText(
            'Important Instructions',
            'महत्वपूर्ण निर्देश',
          ),
          summary: const LocalizedText(
            'This feature is meant for non-emergency questions.',
            'यह फीचर गैर-आपात प्रश्नों के लिए है।',
          ),
          points: const [
            LocalizedText(
              'Do not wait for a reply if you have severe pain.',
              'तेज दर्द होने पर जवाब का इंतज़ार न करें।',
            ),
            LocalizedText(
              'Do not wait if there is no output, heavy bleeding or infection signs.',
              'आउटपुट बंद हो, अधिक रक्तस्राव हो या संक्रमण के संकेत हों तो प्रतीक्षा न करें।',
            ),
          ],
          color: const Color(0xFF5E35B1),
        ),
        LessonData(
          title: const LocalizedText('How It Works', 'यह कैसे काम करता है'),
          summary: const LocalizedText(
            'Open the feature, type or upload, send, and wait for review.',
            'फीचर खोलें, लिखें या फोटो अपलोड करें, भेजें और समीक्षा का इंतज़ार करें।',
          ),
          points: const [
            LocalizedText(
              'Step 1: Open Ask-a-Nurse.',
              'चरण 1: Ask-a-Nurse खोलें।',
            ),
            LocalizedText(
              'Step 2: Type your question or upload an image.',
              'चरण 2: सवाल लिखें या फोटो अपलोड करें।',
            ),
            LocalizedText(
              'Step 3: Send your query.',
              'चरण 3: अपना प्रश्न भेजें।',
            ),
            LocalizedText(
              'Step 4: Nurse reviews and responds.',
              'चरण 4: नर्स समीक्षा करके जवाब देती है।',
            ),
          ],
          color: const Color(0xFF1565C0),
        ),
        LessonData(
          title: const LocalizedText('Quick Tips', 'त्वरित सुझाव'),
          summary: const LocalizedText(
            'Ask whenever you feel unsure and share clear photos.',
            'जब भी संदेह हो, प्रश्न पूछें और स्पष्ट फोटो साझा करें।',
          ),
          points: const [
            LocalizedText(
              'No question is too small.',
              'कोई भी प्रश्न छोटा नहीं होता।',
            ),
            LocalizedText(
              'Clear information helps you get better guidance.',
              'स्पष्ट जानकारी से बेहतर मार्गदर्शन मिलता है।',
            ),
          ],
          color: const Color(0xFF2E7D32),
        ),
      ],
    ),
  ];
}

class _ModuleSevenLessonOneScreen extends StatelessWidget {
  const _ModuleSevenLessonOneScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Stoma-Related Changes' : 'स्टोमा से संबंधित परिवर्तन';
    
    final sign1Text = isEnglish 
        ? 'Stoma becomes black, pale, bluish, or dark' 
        : 'स्टोमा काला, फीका, नीला या गहरा रंग का हो जाए';
        
    final sign2Text = isEnglish 
        ? 'Sudden change in size or shape' 
        : 'आकार या आकृति में अचानक परिवर्तन';
        
    final sign3Text = isEnglish 
        ? 'Continuous or heavy bleeding from stoma' 
        : 'स्टोमा से लगातार या अधिक रक्तस्राव';
        
    final alertText = isEnglish 
        ? 'Any change in your stoma should never be ignored.' 
        : 'स्टोमा में किसी भी परिवर्तन को कभी नजरअंदाज न करें।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD60000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFFD60000),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 20),
                
                // Warning Sign 1
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        sign1Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: Image.asset(
                        'assets/images/module7_stoma_colors.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 20),
                
                // Warning Sign 2
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        sign2Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: Image.asset(
                        'assets/images/module7_stoma_size_shape.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 20),
                
                // Warning Sign 3
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        sign3Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: Image.asset(
                        'assets/images/module7_stoma_bleeding.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 28),
                
                // Bottom Emergency Alert Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6F6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFEE2E2), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD60000),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFFD60000),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleSevenLessonTwoScreen extends StatelessWidget {
  const _ModuleSevenLessonTwoScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Output Problems' : 'आउटपुट संबंधी समस्याएँ';
    
    final sign1Text = isEnglish 
        ? 'No output for a long time (especially with pain)' 
        : 'लंबे समय तक आउटपुट न आना (विशेषकर दर्द के साथ)';
        
    final sign2Text = isEnglish 
        ? 'Sudden decrease in output' 
        : 'आउटपुट में अचानक कमी';
        
    final sign3Text = isEnglish 
        ? 'Excessive watery output (diarrhea)' 
        : 'अत्यधिक पतला/पानी जैसा आउटपुट (दस्त)';
        
    final alertText = isEnglish 
        ? 'Call your nurse if output is not normal.' 
        : 'यदि आउटपुट सामान्य नहीं है तो अपनी नर्स से संपर्क करें।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF57C00),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFFF57C00),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 1
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_output_no_output.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign1Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 2
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_output_decrease.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign2Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 3
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_output_watery.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign3Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Warning Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x66FFD54F), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFF57C00),
                        size: 32,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFFD84315),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleSevenLessonThreeScreen extends StatelessWidget {
  const _ModuleSevenLessonThreeScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Signs of Dehydration' : 'निर्जलीकरण के संकेत';
    
    final sign1Text = isEnglish 
        ? 'Dry mouth' 
        : 'मुंह सूखना';
        
    final sign2Text = isEnglish 
        ? 'Reduced urine' 
        : 'पेशाब कम होना';
        
    final sign3Text = isEnglish 
        ? 'Weakness or dizziness' 
        : 'कमजोरी या चक्कर आना';
        
    final alertText = isEnglish 
        ? 'Drink plenty of fluids and seek help if symptoms continue.' 
        : 'पर्याप्त तरल पदार्थ पिएं और लक्षण बने रहने पर सहायता लें।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Image.asset(
                      'assets/images/module7_dehydration_droplet.png',
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 1 (Dry mouth)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_dehydration_dry_mouth.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign1Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 2 (Reduced urine)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_dehydration_urine.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign2Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 3 (Weakness/Dizziness)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_dehydration_dizzy.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign3Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Hydration Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF7FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x662196F3), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/module7_dehydration_droplet.png',
                        width: 26,
                        height: 26,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleSevenLessonFourScreen extends StatelessWidget {
  const _ModuleSevenLessonFourScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Skin Problems\nAround Stoma' : 'स्टोमा के आसपास\nत्वचा संबंधी समस्याएँ';
    
    final sign1Text = isEnglish 
        ? 'Redness, rash, or irritation' 
        : 'लालिमा, चकत्ते या जलन';
        
    final sign2Text = isEnglish 
        ? 'Swelling or pain' 
        : 'सूजन या दर्द';
        
    final sign3Text = isEnglish 
        ? 'Pus or discharge' 
        : 'मवाद या स्राव';
        
    final alertText = isEnglish 
        ? 'Keep the area clean and dry.\nContact nurse if problem persists.' 
        : 'क्षेत्र को साफ और सूखा रखें।\nसमस्या बनी रहे तो नर्स से संपर्क करें।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '4',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 1 (Redness)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_skin_redness.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign1Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 2 (Swelling)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_skin_swelling.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign2Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 3 (Discharge)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_skin_discharge.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign3Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Care Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF8EE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x6643A047), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/module7_shield.png',
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleSevenLessonFiveScreen extends StatelessWidget {
  const _ModuleSevenLessonFiveScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Pain & Discomfort' : 'दर्द और असुविधा';
    
    final sign1Text = isEnglish 
        ? 'Persistent abdominal pain' 
        : 'लगातार पेट दर्द';
        
    final sign2Text = isEnglish 
        ? 'Pain around stoma site' 
        : 'स्टोमा के आसपास दर्द';
        
    final alertText = isEnglish 
        ? 'Do not ignore ongoing pain.\nGet it checked.' 
        : 'लगातार दर्द को नजरअंदाज न करें।\nइसकी जांच करवाएं।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3F51B5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFF3F51B5),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 1 (Persistent abdominal pain)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_pain_patient.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign1Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 2 (Pain around stoma site)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_pain_stoma.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign2Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Warning Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x665C6BC0), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF5C6BC0),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFF3F51B5),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleSevenLessonSixScreen extends StatelessWidget {
  const _ModuleSevenLessonSixScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Signs of Infection' : 'संक्रमण के संकेत';
    
    final sign1Text = isEnglish 
        ? 'Fever' 
        : 'बुखार';
        
    final sign2Text = isEnglish 
        ? 'Warmth or swelling around stoma' 
        : 'स्टोमा के आसपास गर्माहट या सूजन';
        
    final sign3Text = isEnglish 
        ? 'Foul-smelling discharge' 
        : 'दुर्गंधयुक्त स्राव';
        
    final alertText = isEnglish 
        ? 'Infection can get serious.\nSeek help early.' 
        : 'संक्रमण गंभीर हो सकता है।\nसमय रहते सहायता लें।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00796B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '6',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFF00796B),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Image.asset(
                      'assets/images/module7_infection_germ.png',
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 1 (Fever)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_infection_thermometer.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign1Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 2 (Warmth or swelling)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_infection_warmth.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign2Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 3 (Foul discharge)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_infection_discharge.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign3Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Warning Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF9F8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x6600897B), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/module7_shield.png',
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFF00796B),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleSevenLessonSevenScreen extends StatelessWidget {
  const _ModuleSevenLessonSevenScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Gastrointestinal Symptoms' : 'जठरांत्र संबंधी लक्षण';
    
    final sign1Text = isEnglish 
        ? 'Nausea\nor vomiting' 
        : 'मतली या उल्टी';
        
    final sign2Text = isEnglish 
        ? 'Abdominal bloating\nor swelling' 
        : 'पेट फूलना या सूजन';
        
    final alertText = isEnglish 
        ? 'These symptoms can lead to dehydration and other complications.' 
        : 'ये लक्षण निर्जलीकरण और अन्य जटिलताओं का कारण बन सकते हैं।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '7',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Symptom Two-Column Layout
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left Column: Nausea
                      Expanded(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/module7_gi_nausea.png',
                              height: 140,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              sign1Text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: Color(0xFFEAEAEA),
                        thickness: 1.5,
                        width: 24,
                      ),
                      // Right Column: Bloating
                      Expanded(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/module7_gi_bloating.png',
                              height: 140,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              sign2Text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Warning Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF6FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x661E88E5), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E88E5),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleSevenLessonEightScreen extends StatelessWidget {
  const _ModuleSevenLessonEightScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Emergency Signs (Do NOT Delay)' : 'आपातकालीन संकेत (देरी न करें)';
    
    // Left card
    final leftHeader = isEnglish 
        ? 'Go to hospital\nIMMEDIATELY if you have:' 
        : 'यदि आपको ये लक्षण हैं तो तुरंत अस्पताल जाएँ:';
    final leftItem1 = isEnglish ? 'Black or pale stoma' : 'काला या फीका स्टोमा';
    final leftItem2 = isEnglish ? 'No output +\nsevere pain' : 'आउटपुट न होना +\nगंभीर दर्द';
    final leftItem3 = isEnglish ? 'Heavy bleeding' : 'अत्यधिक रक्तस्राव';
    final leftItem4 = isEnglish ? 'Persistent vomiting' : 'लगातार उल्टी';
    
    // Right card
    final rightHeader = isEnglish 
        ? 'Contact nurse\nIMMEDIATELY if you have:' 
        : 'यदि आपको ये लक्षण हैं तो तुरंत नर्स से संपर्क करें:';
    final rightItem1 = isEnglish ? 'Color change\nin stoma' : 'स्टोमा के रंग में बदलाव';
    final rightItem2 = isEnglish ? 'No output /\nexcessive output' : 'आउटपुट न होना /\nअत्यधिक आउटपुट';
    final rightItem3 = isEnglish ? 'Skin irritation\nor infection' : 'त्वचा में जलन या संक्रमण';
    final rightItem4 = isEnglish ? 'Severe pain\nor vomiting' : 'गंभीर दर्द या उल्टी';
    
    // Bottom banner
    final alertText = isEnglish 
        ? "When in doubt, ask for help. It's always better to be safe." 
        : 'संदेह होने पर सहायता लें। सुरक्षित रहना हमेशा बेहतर है।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD50000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '8',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text(
                            headerTitle,
                            style: const TextStyle(
                              color: Color(0xFFD50000),
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                            ),
                          ),
                          Image.asset(
                            'assets/images/module7_emergency_siren.png',
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Three-Column Layout
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left Card (Red)
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFD50000), width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD50000),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                child: Text(
                                  leftHeader,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    // Row 1
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_l1_black_stoma.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            leftItem1,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row 2
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_l2_no_output.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            leftItem2,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row 3
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_l3_blood.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            leftItem3,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row 4
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_l4_vomit.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            leftItem4,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Center Panel (Hospital & Cross)
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/module7_emergency_arrow_left.png',
                                  width: 14,
                                  height: 14,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 4),
                                Image.asset(
                                  'assets/images/module7_emergency_cross.png',
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 4),
                                Image.asset(
                                  'assets/images/module7_emergency_arrow_right.png',
                                  width: 14,
                                  height: 14,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Image.asset(
                              'assets/images/module7_emergency_hospital.png',
                              width: 84,
                              height: 84,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Right Card (Orange)
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFF57C00), width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF57C00),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                child: Text(
                                  rightHeader,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    // Row 1
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_r1_color_change.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rightItem1,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row 2
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_r2_excessive.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rightItem2,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row 3
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_r3_infection.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rightItem3,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row 4
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_r4_pain.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rightItem4,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Warning Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD50000),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.phone_in_talk_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleOneLessonFourScreen extends StatelessWidget {
  const _ModuleOneLessonFourScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final bannerTitle = isEnglish ? '4. NORMAL APPEARANCE OF STOMA' : '4. स्टोमा का सामान्य स्वरूप';
    final introText = isEnglish ? 'A healthy stoma should look like:' : 'एक स्वस्थ स्टोमा ऐसा दिखना चाहिए:';

    final colorTitle = isEnglish ? 'COLOR' : 'रंग';
    final colorBody = isEnglish ? 'Pink to red' : 'गुलाबी से लाल';
    final colorSub = isEnglish ? '(like inside of your mouth)' : '(मुंह के अंदर की तरह)';

    final textureTitle = isEnglish ? 'TEXTURE' : 'बनावट';
    final textureBody = isEnglish ? 'Moist and shiny' : 'नम और चमकदार';

    final shapeTitle = isEnglish ? 'SHAPE / SIZE' : 'आकार';
    final shapeBody = isEnglish ? 'Round or oval' : 'गोल या अंडाकार';
    final shapeSub = isEnglish ? '(may be slightly swollen after surgery)' : '(सर्जरी के बाद हल्की सूजन हो सकती है)';

    final warningText = isEnglish ? 'Small bleeding while cleaning is normal.' : 'सफाई करते समय थोड़ा रक्तस्राव सामान्य है।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Header Pink Gradient Banner
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF26885), Color(0xFFE24063)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x19E24063),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                alignment: Alignment.center,
                child: Text(
                  bannerTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 2. Intro Text
              Text(
                introText,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              
              const SizedBox(height: 10),
              
              // 3. Decorative Pink Divider
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: Color(0xFFF6C3CD), thickness: 1.5, endIndent: 8),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE84D73),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: Color(0xFFF6C3CD), thickness: 1.5, indent: 8),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 4. Two-Column Layout (Realistic Stoma on left, stacked cards on right)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Column: Stoma Image (with lines extending to right)
                  Expanded(
                    flex: 11,
                    child: Image.asset(
                      'assets/images/module1_normal_stoma.png',
                      height: 360,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Right Column: Stacked Cards Column
                  Expanded(
                    flex: 12,
                    child: SizedBox(
                      height: 360,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 36),
                          
                          // Card 1: Color (height 84)
                          Container(
                            height: 84,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF0E0E0), width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/module1_normal_color_icon.png',
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        colorTitle,
                                        style: const TextStyle(
                                          color: Color(0xFFE84D73),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        colorBody,
                                        style: const TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        colorSub,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 26),
                          
                          // Card 2: Texture (height 84)
                          Container(
                            height: 84,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF0E0E0), width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/module1_normal_texture_icon.png',
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        textureTitle,
                                        style: const TextStyle(
                                          color: Color(0xFF4A90E2),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        textureBody,
                                        style: const TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 26),
                          
                          // Card 3: Shape / Size (height 104)
                          Container(
                            height: 104,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF0E0E0), width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/module1_normal_shape_icon.png',
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        shapeTitle,
                                        style: const TextStyle(
                                          color: Color(0xFF63B45F),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        shapeBody,
                                        style: const TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        shapeSub,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          height: 1.15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 5. Bottom Warning Banner
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF0E0E0), width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/module1_normal_warning.png',
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        warningText,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Image.asset(
                      'assets/images/module1_normal_gauze.png',
                      width: 68,
                      height: 68,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





