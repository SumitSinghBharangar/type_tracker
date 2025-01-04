import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:type_tracker/common/enum.dart';
import 'package:type_tracker/provider/typing_provider.dart';
import 'package:type_tracker/screens/typing_text_screen.dart';

class DifficultyTypeScreen extends StatelessWidget {
  const DifficultyTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Type Tracker',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Select difficulty level to start',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 40.h),
              _buildDifficultyCard(
                context,
                'Easy',
                '90 seconds',
                'Perfect for beginners',
                Colors.green,
                DifficultyLevel.easy,
              ),
              SizedBox(height: 16.h),
              _buildDifficultyCard(
                context,
                'Moderate',
                '60 seconds',
                'For intermediate typists',
                Colors.blue,
                DifficultyLevel.moderate,
              ),
              SizedBox(height: 16.h),
              _buildDifficultyCard(
                context,
                'Hard',
                '30 seconds',
                'Challenge yourself',
                Colors.orange,
                DifficultyLevel.hard,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyCard(
    BuildContext context,
    String title,
    String time,
    String description,
    Color color,
    DifficultyLevel level,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.grey[900],
      child: InkWell(
        onTap: () {
          final provider =
              Provider.of<TypingTestProvider>(context, listen: false);
          provider.setDifficulty(level);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TypingTestScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.keyboard,
                  color: color,
                  size: 30,
                ),
              ),
              SizedBox(width: 16.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
