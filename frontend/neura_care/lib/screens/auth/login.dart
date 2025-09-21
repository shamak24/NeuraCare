import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:neura_care/providers/daily_meals.dart';
import 'package:neura_care/providers/diet.dart';
import 'package:neura_care/providers/prev_history.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/providers/vitals.dart';
import 'package:neura_care/screens/auth/register.dart';
import 'package:neura_care/services/api.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscurePassword = true;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$";
    return RegExp(pattern).hasMatch(email);
  }

  void _login() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    
    setState(() {
      isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (!await InternetConnection().hasInternetAccess) {
        throw Exception('No internet connection');
      }

      final user = await login(email, password);
      
      // Load user data in parallel
      await Future.wait([
        _loadVitals(user.token!),
        _loadDiet(user.token!),
        _loadDailyMeals(user.token!),
        _loadPreviousHistory(user.token!),
        (() async {
          try {
            final healthInfo = await getScore(user.token!);
            user.healthScore = healthInfo['healthScore'].toDouble() ?? 0.0;
            user.preventiveMeasures = List<String>.from(healthInfo['preventiveMeasures'] ?? []);
            user.comorbidityAdvice = healthInfo['comorbidityAdvice'] ?? '';
            user.risks = List<String>.from(healthInfo['risks'] ?? []);
          } catch (e) {
            print('Error fetching score: $e');
          }
        })(),

      ]);
      
      ref.read(userProviderNotifier.notifier).setUser(user);
      
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(msg)),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadVitals(String token) async {
    try {
      final vitals = await getUserVitals(token);
      ref.read(vitalsProviderNotifier.notifier).setVitals(vitals);
    } catch (e) {
      print('Error fetching vitals: $e');
    }
  }

  Future<void> _loadDiet(String token) async {
    try {
      final diet = await getUserDiet(token);
      ref.read(dietProvider.notifier).setDiet(diet);
    } catch (e) {
      print('Error fetching diet: $e');
    }
  }

  Future<void> _loadDailyMeals(String token) async {
    try {
      final meals = await getDailyMealsData(token);
      ref.read(dailyMealsProviderNotifier.notifier).setDailyMeals(meals);
    } catch (e) {
      print('Error fetching daily meals: $e');
    }
  }

  Future<void> _loadPreviousHistory(String token) async {
    try {
      final history = await getPreviousHistory(token);
      ref.read(prevHistoryProviderNotifier.notifier).savePrevHistory(history);
    } catch (e) {
      print('Error fetching previous history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo and Welcome Section
                        _buildHeader(theme),
                        
                        const SizedBox(height: 48),
                        
                        // Login Form Card
                        _buildLoginForm(theme),
                        
                        const SizedBox(height: 24),
                        
                        // Register Link
                        _buildRegisterLink(theme),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        // App Logo/Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.favorite,
            size: 40,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Welcome Text
        Text(
          'Welcome to NeuraCare',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Your health companion',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(ThemeData theme) {
    return Card(
      elevation: 8,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form Title
              Text(
                'Sign In',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  prefixIcon: const Icon(Icons.email_outlined),
                  suffixIcon: _emailController.text.isNotEmpty && _isValidEmail(_emailController.text.trim())
                      ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                      : null,
                ),
                validator: (value) {
                  final email = (value ?? '').trim();
                  if (email.isEmpty) return 'Email is required';
                  if (!_isValidEmail(email)) return 'Enter a valid email address';
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              
              const SizedBox(height: 16),
              
              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (value) {
                  final password = value ?? '';
                  if (password.isEmpty) return 'Password is required';
                  if (password.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
                onFieldSubmitted: (_) => _login(),
              ),
              
              const SizedBox(height: 24),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    disabledBackgroundColor: theme.colorScheme.primary.withOpacity(0.6),
                    disabledForegroundColor: theme.colorScheme.onPrimary.withOpacity(0.6),
                    elevation: isLoading ? 0 : 4,
                    shadowColor: theme.colorScheme.primary.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(theme.colorScheme.onPrimary),
                          ),
                        )
                      : Text(
                          'Sign In',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimary,
                            fontSize: 16,
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

  Widget _buildRegisterLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
        TextButton(
          onPressed: isLoading
              ? null
              : () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const RegisterScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: animation.drive(
                            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                                .chain(CurveTween(curve: Curves.easeInOut)),
                          ),
                          child: child,
                        );
                      },
                    ),
                  );
                },
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            overlayColor: theme.colorScheme.primary.withOpacity(0.1),
          ),
          child: Text(
            'Register',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}