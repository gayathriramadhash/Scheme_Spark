import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  const ProfileScreen({
    super.key,
    required this.email,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profile;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final result = await ApiService.getProfile(widget.email);

      if (!mounted) return;

      setState(() {
        profile = Map<String, dynamic>.from(
          result['profile'] ?? {},
        );
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Unable to load profile';
      });
    }
  }

  String getValue(String key) {
    final value = profile?[key];

    if (value == null || value.toString().trim().isEmpty) {
      return 'Not provided';
    }

    return value.toString();
  }

  Widget profileItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });

                          loadProfile();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadProfile,
                  child: SingleChildScrollView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 45,
                          child: Icon(
                            Icons.person,
                            size: 50,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          getValue('name'),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          getValue('email'),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Personal Details
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Personal Details',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        profileItem(
                          Icons.person_outline,
                          'Name',
                          getValue('name'),
                        ),

                        profileItem(
                          Icons.email_outlined,
                          'Email',
                          getValue('email'),
                        ),

                        profileItem(
                          Icons.cake_outlined,
                          'Date of Birth',
                          getValue('dob'),
                        ),

                        profileItem(
                          Icons.numbers,
                          'Age',
                          getValue('age'),
                        ),

                        profileItem(
                          Icons.wc_outlined,
                          'Gender',
                          getValue('gender'),
                        ),

                        profileItem(
                          Icons.family_restroom,
                          'Marital Status',
                          getValue('marital_status'),
                        ),

                        const SizedBox(height: 15),

                        // Education Details
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Education Details',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        profileItem(
                          Icons.school_outlined,
                          'Education Level',
                          getValue(
                            'education_level',
                          ),
                        ),

                        profileItem(
                          Icons.menu_book_outlined,
                          'Currently Studying',
                          getValue(
                            'currently_studying',
                          ),
                        ),

                        profileItem(
                          Icons.book_outlined,
                          'Course',
                          getValue('course'),
                        ),

                        profileItem(
                          Icons.work_outline,
                          'Occupation',
                          getValue('occupation'),
                        ),

                        profileItem(
                          Icons.currency_rupee,
                          'Annual Family Income',
                          getValue(
                            'annual_family_income',
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Location
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Location',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        profileItem(
                          Icons.location_city_outlined,
                          'State',
                          getValue('state'),
                        ),

                        profileItem(
                          Icons.location_on_outlined,
                          'District',
                          getValue('district'),
                        ),

                        const SizedBox(height: 20),

                        // Refresh button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: loadProfile,
                            icon: const Icon(
                              Icons.refresh,
                            ),
                            label: const Text(
                              'Refresh Profile',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}