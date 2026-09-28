import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SavedScreen extends StatefulWidget {
  final String email;

  const SavedScreen({
    super.key,
    required this.email,
  });

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<dynamic> savedSchemes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSavedSchemes();
  }

  Future<void> loadSavedSchemes() async {
    try {
      final result =
          await ApiService.getSavedSchemes(widget.email);

      if (!mounted) return;

      setState(() {
        savedSchemes = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load saved schemes'),
        ),
      );
    }
  }

  Future<void> removeSavedScheme(int schemeId) async {
    try {
      final result = await ApiService.unsaveScheme(
        widget.email,
        schemeId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'] ??
                'Scheme removed from saved',
          ),
        ),
      );

      await loadSavedSchemes();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to remove scheme'),
        ),
      );
    }
  }

  Widget buildInfo(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Text(
        '$title: $value',
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget buildSchemeCard(dynamic scheme) {
    final int schemeId =
        int.tryParse(
              scheme['scheme_id'].toString(),
            ) ??
            0;

    final String schemeName =
        scheme['scheme_name']?.toString() ??
            'Government Scheme';

    final String description =
        scheme['description']?.toString() ??
            'No description available';

    final String benefits =
        scheme['benefits']?.toString() ??
            'No benefits available';

    final String eligibility =
        scheme['eligibility']?.toString() ??
            'No eligibility details available';

    final String documents =
        scheme['documents']?.toString() ??
            'No document details available';

    return Card(
      margin: const EdgeInsets.only(
        bottom: 15,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              schemeName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            buildInfo(
              'Description',
              description,
            ),

            buildInfo(
              'Benefits',
              benefits,
            ),

            buildInfo(
              'Eligibility',
              eligibility,
            ),

            buildInfo(
              'Documents',
              documents,
            ),

            const SizedBox(height: 5),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  removeSavedScheme(schemeId);
                },
                child: const Text(
                  'Remove from Saved',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Schemes',
        ),
        actions: [
          IconButton(
            onPressed: loadSavedSchemes,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : savedSchemes.isEmpty
              ? const Center(
                  child: Text(
                    'No Saved Schemes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadSavedSchemes,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        'My Saved Schemes',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      ...savedSchemes.map(
                        (scheme) =>
                            buildSchemeCard(scheme),
                      ),
                    ],
                  ),
                ),
    );
  }
}