import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_scanner_ims/loginpage.dart';
import 'package:qr_scanner_ims/scanner_page.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/raj.png', // Replace with the path to your background image
            fit: BoxFit.cover,
          ),
          // Apply blur effect to the background image
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.4), // Adjust the opacity as needed
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // Set the background color to transparent black
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/logo_2-removebg-preview.png", // Replace with the path to your logo
                        width: 200, // Set the width of the logo as per your requirement
                        height: 200, // Set the height of the logo as per your requirement
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'WELCOME TO  ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, decoration: TextDecoration.none),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'INVENTORY MANAGEMENT SYSTEM',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.black, decoration: TextDecoration.none),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'RAJ BHAWAN, UTTARKAHND',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black, decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 200, // Set the width of the button container
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6), // Set the background color to transparent black
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ScannerPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Make the button a square using BorderRadius
                        padding: const EdgeInsets.all(30),
                        primary: Colors.transparent,
                        elevation: 0,
                        onPrimary: Colors.white,
                      ),
                      child: const Text(
                        'SCAN QR',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white, decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                ),
              ),
              //LogoutButton
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 100, // Set the width of the button container
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6), // Set the background color to transparent black
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Make the button a square using BorderRadius
                      padding: const EdgeInsets.all(10),
                      primary: Colors.transparent,
                      elevation: 0,
                      onPrimary: Colors.white,
                    ),
                    child: const Text(
                      'Logout',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white, decoration: TextDecoration.none),
                    ),
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
