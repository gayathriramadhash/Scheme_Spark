import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'categories_screen.dart';
import 'chatbot_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
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

  const HomeScreen({
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeDashboard(
        email: widget.email,
      ),

      CategoriesScreen(
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

      const ChatbotScreen(),

      SavedScreen(
        email: widget.email,
      ),

      ProfileScreen(
  email: widget.email,
)
    ];

    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatefulWidget {
  final String email;

  const HomeDashboard({
    super.key,
    required this.email,
  });

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  late Future<List<dynamic>> recommendations;

  final Set<int> savedSchemeIds = {};

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
    _loadSavedSchemes();
  }

  void _loadRecommendations() {
    recommendations =
        ApiService.getRecommendations(widget.email);
  }

  Future<void> _loadSavedSchemes() async {
    try {
      final savedSchemes =
          await ApiService.getSavedSchemes(widget.email);

      if (!mounted) return;

      setState(() {
        savedSchemeIds.clear();

        for (final scheme in savedSchemes) {
          final id = int.tryParse(
            scheme['scheme_id'].toString(),
          );

          if (id != null) {
            savedSchemeIds.add(id);
          }
        }
      });
    } catch (e) {
      // Ignore saved schemes loading error
    }
  }

  Future<void> _toggleSaveScheme(
    int schemeId,
    String schemeName,
  ) async {
    final alreadySaved =
        savedSchemeIds.contains(schemeId);

    try {
      if (alreadySaved) {
        final result =
            await ApiService.unsaveScheme(
          widget.email,
          schemeId,
        );

        if (!mounted) return;

        setState(() {
          savedSchemeIds.remove(schemeId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message']?.toString() ??
                  '$schemeName removed from saved',
            ),
          ),
        );
      } else {
        final result =
            await ApiService.saveScheme(
          widget.email,
          schemeId,
        );

        if (!mounted) return;

        setState(() {
          savedSchemeIds.add(schemeId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message']?.toString() ??
                  '$schemeName saved successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to update saved scheme',
          ),
        ),
      );
    }
  }

  Future<void> _refreshRecommendations() async {
    setState(() {
      _loadRecommendations();
    });

    await recommendations;
    await _loadSavedSchemes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshRecommendations,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              18,
              18,
              18,
              25,
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(24),
                  border: Border.all(),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 45,
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Welcome to Scheme Spark',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                decoration: InputDecoration(
                  hintText:
                      'Search government schemes',
                  prefixIcon:
                      const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 30,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smart Recommendations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Schemes matched with your profile',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended For You',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'AI',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              FutureBuilder<List<dynamic>>(
                future: recommendations,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(35),
                      child: Center(
                        child:
                            CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return _buildErrorCard();
                  }

                  final schemes =
                      snapshot.data ?? [];

                  if (schemes.isEmpty) {
                    return _buildEmptyCard();
                  }

                  return Column(
                    children: schemes
                        .map(
                          (scheme) =>
                              _buildSchemeCard(
                            scheme,
                          ),
                        )
                        .toList(),
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Explore Categories',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: _categoryCard(
                      Icons.school,
                      'Education',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _categoryCard(
                      Icons.woman,
                      'Women Welfare',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _categoryCard(
                      Icons.work_outline,
                      'Employment',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _categoryCard(
                      Icons.agriculture,
                      'Agriculture',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(18),
                  border: Border.all(),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 30,
                    ),
                    SizedBox(width: 13),
                    Expanded(
                      child: Text(
                        'Complete your profile to discover more government schemes that match your details.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeCard(dynamic scheme) {
    final schemeId =
        int.tryParse(
              scheme['scheme_id'].toString(),
            ) ??
            0;

    final schemeName =
        scheme['scheme_name']?.toString() ??
            'Government Scheme';

    final description =
        scheme['description']?.toString() ?? '';

    final benefits =
        scheme['benefits']?.toString() ?? '';

    final eligibility =
        scheme['eligibility']?.toString() ?? '';

    final documents =
        scheme['documents']?.toString() ?? '';

    final officialLink =
        scheme['official_link']?.toString() ?? '';

    final isSaved =
        savedSchemeIds.contains(schemeId);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 18,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.account_balance,
                size: 35,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  schemeName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: schemeId == 0
                    ? null
                    : () {
                        _toggleSaveScheme(
                          schemeId,
                          schemeName,
                        );
                      },
                icon: Icon(
                  isSaved
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          if (description.isNotEmpty)
            _detailSection(
              'Description',
              description,
            ),

          if (benefits.isNotEmpty)
            _detailSection(
              'Benefits',
              benefits,
            ),

          if (eligibility.isNotEmpty)
            _detailSection(
              'Eligibility',
              eligibility,
            ),

          if (documents.isNotEmpty)
            _detailSection(
              'Required Documents',
              documents,
            ),

          const SizedBox(height: 5),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 19,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Matched with your profile',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (officialLink.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.only(top: 13),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _openOfficialWebsite(
                      officialLink,
                    );
                  },
                  icon: const Icon(
                    Icons.open_in_new,
                    size: 18,
                  ),
                  label: const Text(
                    'Official Website',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _detailSection(
    String title,
    String text,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openOfficialWebsite(
    String link,
  ) async {
    try {
      final uri = Uri.tryParse(link);

      if (uri == null) {
        _showMessage('Invalid official link');
        return;
      }

      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        _showMessage(
          'Could not open official website',
        );
      }
    } catch (e) {
      _showMessage(
        'Could not open official website',
      );
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 50,
          ),
          SizedBox(height: 12),
          Text(
            'Unable to load recommendations.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off,
            size: 50,
          ),
          SizedBox(height: 12),
          Text(
            'No matching schemes found.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try updating your profile or category details.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(
    IconData icon,
    String title,
  ) {
    return Container(
      height: 125,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 35,
          ),
          const SizedBox(height: 9),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}