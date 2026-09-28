import 'package:flutter/material.dart';
import 'category_selection_screen.dart';

class ProfileSetup3 extends StatefulWidget {
  final String email;
  final String name;
  final String dob;
  final String age;
  final String gender;
  final String maritalStatus;
  final String educationLevel;
  final String currentlyStudying;
  final String course;
  final String occupation;

  const ProfileSetup3({
    super.key,
    required this.email,
    required this.name,
    required this.dob,
    required this.age,
    required this.gender,
    required this.maritalStatus,
    required this.educationLevel,
    required this.currentlyStudying,
    required this.course,
    required this.occupation,
  });

  @override
  State<ProfileSetup3> createState() => _ProfileSetup3State();
}

class _ProfileSetup3State extends State<ProfileSetup3> {
  final TextEditingController incomeController =
      TextEditingController();

  String? selectedState;
  String? selectedDistrict;

  final List<String> states = [
    'Tamil Nadu',
    'Kerala',
    'Karnataka',
    'Andhra Pradesh',
    'Telangana',
    'Other',
  ];

  final List<String> districts = [
    'Chennai',
    'Coimbatore',
    'Madurai',
    'Erode',
    'Salem',
    'Thanjavur',
    'Tiruchirappalli',
    'Tirunelveli',
    'Vellore',
    'Other',
  ];

  @override
  void dispose() {
    incomeController.dispose();
    super.dispose();
  }

  void continueToCategorySelection() {
    // Check Annual Family Income
    if (incomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter annual family income'),
        ),
      );
      return;
    }

    // Check State
    if (selectedState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your state'),
        ),
      );
      return;
    }

    // Check District
    if (selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your district'),
        ),
      );
      return;
    }

    // Go to Category Selection
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategorySelectionScreen(
          email: widget.email,
          name: widget.name,
          dob: widget.dob,
          age: widget.age,
          gender: widget.gender,
          maritalStatus: widget.maritalStatus,
          educationLevel: widget.educationLevel,
          currentlyStudying: widget.currentlyStudying,
          course: widget.course,
          occupation: widget.occupation,
          annualFamilyIncome: incomeController.text.trim(),
          state: selectedState!,
          district: selectedDistrict!,
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
              'Location & Income',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF102A5C),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Almost done! Tell us a few more details.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF78909C),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Annual Family Income',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: incomeController,
              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                hintText: 'Enter annual family income',

                prefixIcon: const Icon(
                  Icons.currency_rupee,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'State',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedState,

              decoration: InputDecoration(
                hintText: 'Select state',

                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              items: states.map((state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedState = value;
                  selectedDistrict = null;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'District',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedDistrict,

              decoration: InputDecoration(
                hintText: 'Select district',

                prefixIcon: const Icon(
                  Icons.map_outlined,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              items: districts.map((district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                });
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: continueToCategorySelection,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF356AE6),
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}