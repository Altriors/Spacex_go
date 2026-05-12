import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../home/home_screen.dart';

class AnimatedRegisterScreen extends StatefulWidget {
  const AnimatedRegisterScreen({super.key});

  @override
  State<AnimatedRegisterScreen> createState() => _AnimatedRegisterScreenState();
}

class _AnimatedRegisterScreenState extends State<AnimatedRegisterScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Animation controllers
  late AnimationController _rocketController;
  late AnimationController _launchController;
  late Animation<double> _rocketPosition;
  late Animation<double> _rocketScale;
  late Animation<double> _rocketRotation;
  late Animation<double> _smokeOpacity;
  
  double _completionLevel = 0.0; // 0.0 to 1.0 (0%, 25%, 50%, 75%, 100%)
  bool _isLaunching = false;

  @override
  void initState() {
    super.initState();
    
    // Rocket position controller (rises as user fills form)
    _rocketController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _rocketPosition = Tween<double>(
      begin: 0.0,
      end: -300.0, // Move up 300 pixels
    ).animate(CurvedAnimation(
      parent: _rocketController,
      curve: Curves.easeInOut,
    ));
    
    // Launch animation controller
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
    
    _rocketRotation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _launchController,
      curve: Curves.easeInOut,
    ));
    
    _smokeOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _launchController,
      curve: Curves.easeOut,
    ));
    
    // Listen to text changes
    _nameController.addListener(_updateProgress);
    _emailController.addListener(_updateProgress);
    _passwordController.addListener(_updateProgress);
    _confirmPasswordController.addListener(_updateProgress);
  }

  void _updateProgress() {
    int filledFields = 0;
    if (_nameController.text.isNotEmpty) filledFields++;
    if (_emailController.text.isNotEmpty) filledFields++;
    if (_passwordController.text.isNotEmpty) filledFields++;
    if (_confirmPasswordController.text.isNotEmpty) filledFields++;
    
    setState(() {
      _completionLevel = filledFields / 4;
    });
    
    _rocketController.animateTo(_completionLevel);
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLaunching = true;
      });
      
      // Start launch animation
      await _launchController.forward();
      
      if (!mounted) return;
      
      // Register user
      final authProvider = context.read<AuthProviderApp>();
      final success = await authProvider.register(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
      );

      if (success && mounted) {
        // Navigate to home with fade transition
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
          SnackBar(content: Text(authProvider.errorMessage ?? 'Registration failed')),
        );
      }
    }
  }

  @override
  void dispose() {
    _rocketController.dispose();
    _launchController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          
          // Smoke/trail effect during launch
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
                          child: Transform.rotate(
                            angle: _isLaunching ? _rocketRotation.value : 0,
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
                                    _isLaunching ? 'Launching...' : 'Create Account',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Progress indicator
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
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(_completionLevel * 100).toInt()}% Complete',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Form Section
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
                            const SizedBox(height: 8),
                            
                            // Name Field
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: _nameController.text.isNotEmpty
                                      ? Colors.green
                                      : null,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Email Field
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
                            
                            // Password Field
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
                            const SizedBox(height: 16),
                            
                            // Confirm Password Field
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: _confirmPasswordController.text.isNotEmpty
                                      ? Colors.green
                                      : null,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
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
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            
                            // Register Button
                            ElevatedButton(
                              onPressed: _isLaunching ? null : _register,
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
                                      'Register & Launch 🚀',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Back to Login
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Already have an account? Login"),
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