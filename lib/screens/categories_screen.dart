import 'package:flutter/material.dart';
import 'category_details_screen.dart';

class CategoriesScreen extends StatelessWidget {
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

  const CategoriesScreen({
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

  final List<Map<String, dynamic>> categories = const [
    {
      'id': 1,
      'name': 'Education',
      'icon': Icons.school,
    },
    {
      'id': 2,
      'name': 'Women Welfare',
      'icon': Icons.woman,
    },
    {
      'id': 3,
      'name': 'Employment',
      'icon': Icons.work_outline,
    },
    {
      'id': 4,
      'name': 'Agriculture',
      'icon': Icons.agriculture,
    },
    {
      'id': 5,
      'name': 'Health',
      'icon': Icons.health_and_safety,
    },
    {
      'id': 6,
      'name': 'Housing',
      'icon': Icons.home_outlined,
    },
    {
      'id': 7,
      'name': 'Social Security',
      'icon': Icons.security,
    },
    {
      'id': 8,
      'name': 'Differently Abled',
      'icon': Icons.accessible,
    },
    {
      'id': 9,
      'name': 'BC / MBC / Minorities',
      'icon': Icons.groups,
    },
    {
      'id': 10,
      'name': 'Children',
      'icon': Icons.child_care,
    },
  ];

  void openCategoryDetails(
    BuildContext context,
    int categoryId,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsScreen(
          categoryId: categoryId,

          email: email,
          name: name,
          dob: dob,
          age: age,
          gender: gender,
          maritalStatus: maritalStatus,
          educationLevel: educationLevel,
          currentlyStudying: currentlyStudying,
          course: course,
          occupation: occupation,
          annualFamilyIncome: annualFamilyIncome,
          state: state,
          district: district,
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
          'Categories',
          style: TextStyle(
            color: Color(0xFF102A5C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: GridView.builder(
          itemCount: categories.length,

          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.05,
          ),

          itemBuilder: (context, index) {
            final category = categories[index];

            final int categoryId = category['id'];

            return GestureDetector(
              onTap: () {
                openCategoryDetails(
                  context,
                  categoryId,
                );
              },

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.12),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),

                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    Container(
                      width: 55,
                      height: 55,

                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3FF),
                        borderRadius:
                            BorderRadius.circular(15),
                      ),

                      child: Icon(
                        category['icon'],
                        size: 30,
                        color: const Color(0xFF356AE6),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),

                      child: Text(
                        category['name'],
                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF102A5C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}