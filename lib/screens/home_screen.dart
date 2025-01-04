import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:type_tracker/screens/typing_text_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedDifficulty = 'Easy';
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          !isDarkMode ? Colors.lightBlueAccent : const Color(0xFF0A1736),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App title
            SizedBox(height: 20.h),
            Text(
              'Typing tracker',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // Spacer astronaut image
            SizedBox(height: 30.h),
            Image.asset(
              'assets/images/img1.png',
              width: 200.w,
              height: 200.h,
            ),

            // Card Section
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: const Color(0xFF102348),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 4),
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 4),
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "It's time to",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Typing",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF68A7E8),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Join millions of users worldwide to improve your typing speed and compete in exciting typing challenges.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Difficulty",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  DropdownButtonFormField<String>(
                    items: const [
                      DropdownMenuItem(
                        value: "Easy",
                        child: Text("Easy"),
                      ),
                      DropdownMenuItem(
                        value: "Medium",
                        child: Text("Medium"),
                      ),
                      DropdownMenuItem(
                        value: "Hard",
                        child: Text("Hard"),
                      ),
                    ],
                    value: "Easy",
                    dropdownColor: const Color(0xFF102348),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // Start Game Button
            SizedBox(
              width: 200.w,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => TypingTestScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF68A7E8),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Start Game",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
