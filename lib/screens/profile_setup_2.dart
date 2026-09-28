import 'package:flutter/material.dart';
import 'profile_setup_3.dart';

class ProfileSetup2 extends StatefulWidget {
  final String email;
  final String name;
  final String dob;
  final String age;
  final String gender;
  final String maritalStatus;

  const ProfileSetup2({
    super.key,
    required this.email,
    required this.name,
    required this.dob,
    required this.age,
    required this.gender,
    required this.maritalStatus,
  });

  @override
  State<ProfileSetup2> createState() => _ProfileSetup2State();
}

class _ProfileSetup2State extends State<ProfileSetup2> {
  String? selectedEducation;
  String? selectedStudying;
  String? selectedCourse;
  String? selectedOccupation;

  final List<String> educationLevels = [
    '10th',
    '12th',
    'Diploma',
    'Undergraduate',
    'Postgraduate',
    'Other',
  ];

  final List<String> studyingOptions = [
    'Yes',
    'No',
  ];

  final List<String> courses = [
    'B.Sc Computer Science',
    'BCA',
    'B.Com',
    'B.A',
    'B.E / B.Tech',
    'M.Sc',
    'MCA',
    'Other',
  ];

  final List<String> occupations = [
    'Student',
    'Farmer',
    'Private Employee',
    'Government Employee',
    'Business',
    'Self Employed',
    'Unemployed',
    'Other',
  ];

  void goNext() {
    if (selectedEducation == null ||
        selectedStudying == null ||
        selectedCourse == null ||
        selectedOccupation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the details'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSetup3(
          email: widget.email,
          name: widget.name,
          dob: widget.dob,
          age: widget.age,
          gender: widget.gender,
          maritalStatus: widget.maritalStatus,
          educationLevel: selectedEducation!,
          currentlyStudying: selectedStudying!,
          course: selectedCourse!,
          occupation: selectedOccupation!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FCFF),
        elevation: 0,
        title: const Text(
          'Profile Setup',
          style: TextStyle(
            color: Color(0xFF102A5C),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF102A5C),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Education & Work',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF102A5C),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Tell us about your education and occupation',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF78909C),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Education Level',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedEducation,
              decoration: InputDecoration(
                hintText: 'Select education level',
                prefixIcon: const Icon(Icons.school_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: educationLevels.map((education) {
                return DropdownMenuItem(
                  value: education,
                  child: Text(education),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedEducation = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Currently Studying',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedStudying,
              decoration: InputDecoration(
                hintText: 'Are you currently studying?',
                prefixIcon: const Icon(Icons.menu_book_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: studyingOptions.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStudying = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Course',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedCourse,
              decoration: InputDecoration(
                hintText: 'Select your course',
                prefixIcon: const Icon(Icons.book_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: courses.map((course) {
                return DropdownMenuItem(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Occupation',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedOccupation,
              decoration: InputDecoration(
                hintText: 'Select occupation',
                prefixIcon: const Icon(Icons.work_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: occupations.map((occupation) {
                return DropdownMenuItem(
                  value: occupation,
                  child: Text(occupation),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedOccupation = value;
                });
              },
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: goNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF356AE6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
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