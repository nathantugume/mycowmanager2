
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycowmanager/presentation/views/login_screen.dart';
import 'package:mycowmanager/presentation/views/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (kDebugMode) {
      print("welcome screen");
    }

    return Scaffold(

      body: Stack(
        children: [
          // Top wave background
          Positioned(
            top: 0,
            left: 0,
            right: 0,

            child: Image.asset(
              'assets/images/top_bg.png',
              width: size.width,
              fit: BoxFit.cover,
              height: 200,


            ),
          ),

          // Bottom wave background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bottom_bg.png',
              width: size.width,
              fit: BoxFit.cover,
              height: 300,
            ),
          ),

          // Page content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),

                // App logo
                Align(
                  alignment: Alignment.topLeft,
                 child:  Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: SvgPicture.asset(
                      'assets/images/logo.svg',
                      height: 120,
                    ),
                 ),

                ),

                const SizedBox(height: 32),

                // Title

                  Center(
                    child: Text(
                      'Welcome to My Cow Monitor',

                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,

                      ),
                    ),
                  ),


                const SizedBox(height: 10),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Hello there, Farmer! 🐄\nWelcome to My Cow Monitor — your smart companion for livestock, farm, and record management. Track births, vaccinations, and farm activities with ease. Let’s get started!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 10,),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const LoginScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF617A1F),
                            // olive green
                          ),
                          child: const Text('LOGIN', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const RegisterScreen()));
                          },
                          style: ElevatedButton.styleFrom(

                            backgroundColor: const Color(0xFF34A853), // bright green
                          ),
                          child: const Text('Sign Up Now',style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      const SizedBox(height: 56),
                    ],
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

