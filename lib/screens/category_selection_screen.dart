import 'package:flutter/material.dart';
import 'category_details_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
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
  final String annualFamilyIncome;
  final String state;
  final String district;

  const CategorySelectionScreen({
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
    required this.annualFamilyIncome,
    required this.state,
    required this.district,
  });

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState
    extends State<CategorySelectionScreen> {
  int? selectedCategoryId;

  final List<Map<String, dynamic>> categories = [
    {
      'id': 1,
      'name': 'Education',
      'icon': Icons.school_outlined,
    },
    {
      'id': 2,
      'name': 'Women Welfare',
      'icon': Icons.woman_outlined,
    },
    {
      'id': 3,
      'name': 'Employment',
      'icon': Icons.work_outline,
    },
    {
      'id': 4,
      'name': 'Agriculture',
      'icon': Icons.agriculture_outlined,
    },
    {
      'id': 5,
      'name': 'Health',
      'icon': Icons.health_and_safety_outlined,
    },
    {
      'id': 6,
      'name': 'Housing',
      'icon': Icons.home_outlined,
    },
    {
      'id': 7,
      'name': 'Social Security',
      'icon': Icons.security_outlined,
    },
    {
      'id': 8,
      'name': 'Differently Abled',
      'icon': Icons.accessible_outlined,
    },
    {
      'id': 9,
      'name': 'BC / MBC / Minorities',
      'icon': Icons.groups_outlined,
    },
    {
      'id': 10,
      'name': 'Children',
      'icon': Icons.child_care_outlined,
    },
  ];

  void continueToDetails() {
    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsScreen(
          categoryId: selectedCategoryId!,
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
          annualFamilyIncome: widget.annualFamilyIncome,
          state: widget.state,
          district: widget.district,
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
        automaticallyImplyLeading: false,
        title: const Text(
          'Select Category',
          style: TextStyle(
            color: Color(0xFF102A5C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What type of schemes are you looking for?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF102A5C),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Select one category to provide the details needed for scheme recommendations.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF78909C),
              ),
            ),

            const SizedBox(height: 25),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.15,
              ),

              itemBuilder: (context, index) {
                final category = categories[index];
                final int categoryId = category['id'];

                final bool isSelected =
                    selectedCategoryId == categoryId;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryId = categoryId;
                    });
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE7EEFF)
                          : Colors.white,

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF356AE6)
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(
                          category['icon'],
                          size: 38,
                          color: isSelected
                              ? const Color(0xFF356AE6)
                              : const Color(0xFF102A5C),
                        ),

                        const SizedBox(height: 10),

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),

                          child: Text(
                            category['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? const Color(0xFF356AE6)
                                  : const Color(0xFF263238),
                            ),
                          ),
                        ),

                        if (isSelected) ...[
                          const SizedBox(height: 6),

                          const Icon(
                            Icons.check_circle,
                            size: 20,
                            color: Color(0xFF356AE6),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: continueToDetails,

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