import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import 'animated_register_screen.dart';
import '../home/home_screen.dart';

class AnimatedLoginScreen extends StatefulWidget {
  const AnimatedLoginScreen({super.key});

  @override
  State<AnimatedLoginScreen> createState() => _AnimatedLoginScreenState();
}

class _AnimatedLoginScreenState extends State<AnimatedLoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  // Animation controllers
  late AnimationController _rocketController;
  late AnimationController _launchController;
  late Animation<double> _rocketPosition;
  late Animation<double> _rocketScale;
  late Animation<double> _smokeOpacity;
  
  double _completionLevel = 0.0; // 0.0 to 1.0 (0%, 50%, 100%)
  bool _isLaunching = false;

  @override
  void initState() {
    super.initState();
    
    // Rocket position controller
    _rocketController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _rocketPosition = Tween<double>(
      begin: 0.0,
      end: -200.0,
    ).animate(CurvedAnimation(
      parent: _rocketController,
      curve: Curves.easeInOut,
    ));
    
    // Launch animation
    _launchController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _rocketScale = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _launchController,
      curve: Curves.easeIn,
    ));
    
    _smokeOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _launchController,
      curve: Curves.easeOut,
    ));
    
    _emailController.addListener(_updateProgress);
    _passwordController.addListener(_updateProgress);
  }

  void _updateProgress() {
    int filledFields = 0;
    if (_emailController.text.isNotEmpty) filledFields++;
    if (_passwordController.text.isNotEmpty) filledFields++;
    
    setState(() {
      _completionLevel = filledFields / 2;
    });
    
    _rocketController.animateTo(_completionLevel);
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLaunching = true;
      });
      
      // Start launch animation
      await _launchController.forward();
      
      if (!mounted) return;
      
      final authProvider = context.read<AuthProviderApp>();
      final success = await authProvider.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      } else if (mounted) {
        setState(() {
          _isLaunching = false;
        });
        _launchController.reset();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? 'Login failed')),
        );
      }
    }
  }

  @override
  void dispose() {
    _rocketController.dispose();
    _launchController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
              ),
            ),
          ),
          
          // Smoke effect
          if (_isLaunching)
            AnimatedBuilder(
              animation: _smokeOpacity,
              builder: (context, child) {
                return Opacity(
                  opacity: _smokeOpacity.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        colors: [
                          Colors.white.withOpacity(0.8),
                          Colors.white.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          
          SafeArea(
            child: Column(
              children: [
                // Animated Rocket
                Expanded(
                  flex: 2,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_rocketController, _launchController]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          _rocketPosition.value + (_isLaunching ? -_launchController.value * 1000 : 0),
                        ),
                        child: Transform.scale(
                          scale: _isLaunching ? _rocketScale.value : 1.0,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.rocket_launch,
                                  size: 120,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _isLaunching ? 'Launching...' : 'SpaceX GO',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Track launches worldwide',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Progress
                                Container(
                                  width: 200,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: _completionLevel,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Form
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 24),
                            
                            Text(
                              'Welcome Back!',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            
                            // Email
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: _emailController.text.isNotEmpty
                                      ? Colors.green
                                      : null,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: _passwordController.text.isNotEmpty
                                      ? Colors.green
                                      : null,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            
                            // Login Button
                            ElevatedButton(
                              onPressed: _isLaunching ? null : _login,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLaunching
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Login & Launch 🚀',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Register link
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AnimatedRegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text("Don't have an account? Register"),
                            ),
                          ],
                        ),
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