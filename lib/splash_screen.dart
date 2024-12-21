import 'dart:async'; // To use Timer
import 'package:flutter/material.dart';
import 'create_profile_screen.dart'; // Ensure this is correctly imported

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconAnimation;
  late AnimationController _textController;
  late Animation<double> _textAnimation;

  late List<String> _backgroundImages; // List to store background images
  int _currentImageIndex = 0; // To keep track of the current image index
  late Timer _imageChangeTimer; // Timer to change background images

  @override
  void initState() {
    super.initState();

    // Initialize background images list
    _backgroundImages = [
      'assets/images/splash_background_1.jpg', // Add the image paths
      'assets/images/splash_background_2.jpg',
      'assets/images/splash_background_3.jpg',
    ];

    // Create animation for the icon and text
    _iconController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _iconAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeIn),
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    // Set up a timer to change the background image every 3 seconds
    _imageChangeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        // Cycle through the images
        _currentImageIndex =
            (_currentImageIndex + 1) % _backgroundImages.length;
        print("Current image index: $_currentImageIndex"); // Debugging line
      });
    });

    // Add a delay before navigating to the next screen
    Future.delayed(const Duration(seconds: 9), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateProfileScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    _imageChangeTimer.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                _backgroundImages[_currentImageIndex]), // Use the current image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Icon with a shadow effect to make it stand out
              FadeTransition(
                opacity: _iconAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Animated Text with shadow for better visibility
              FadeTransition(
                opacity: _textAnimation,
                child: Text(
                  'Welcome to Ajira Mtaani App',
                  style: TextStyle(
                    fontSize: screenWidth * 0.08, // Responsive font size
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Elevated button with custom style and hover effects
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateProfileScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Create Profile',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
