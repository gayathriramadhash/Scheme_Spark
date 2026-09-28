import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../services/api_service.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final int categoryId;

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

  const CategoryDetailsScreen({
    super.key,
    required this.categoryId,
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
  State<CategoryDetailsScreen> createState() =>
      _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState
    extends State<CategoryDetailsScreen> {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, String?> values = {};

  bool isLoading = false;

  TextEditingController controller(String name) {
    controllers[name] ??= TextEditingController();
    return controllers[name]!;
  }

  void setValue(String field, String? value) {
    setState(() {
      values[field] = value;
    });
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // ==========================================================
  // CATEGORY NAME
  // ==========================================================

  String get categoryName {
    switch (widget.categoryId) {
      case 1:
        return 'Education';
      case 2:
        return 'Women Welfare';
      case 3:
        return 'Employment';
      case 4:
        return 'Agriculture';
      case 5:
        return 'Health';
      case 6:
        return 'Housing';
      case 7:
        return 'Social Security';
      case 8:
        return 'Differently Abled';
      case 9:
        return 'BC / MBC / Minorities';
      case 10:
        return 'Children';
      default:
        return 'Category';
    }
  }

  // ==========================================================
  // HELP DIALOG
  // ==========================================================

  void showHelp(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFF356AE6),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // LABEL WITH INFO BUTTON
  // ==========================================================

  Widget labelWithHelp({
    required String label,
    String? helpText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (helpText != null)
          InkWell(
            onTap: () {
              showHelp(label, helpText);
            },
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.info_outline,
                size: 20,
                color: Color(0xFF356AE6),
              ),
            ),
          ),
      ],
    );
  }

  // ==========================================================
  // TEXT FIELD
  // ==========================================================

  Widget textField({
    required String field,
    required String label,
    String? hint,
    String? helpText,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelWithHelp(
            label: label,
            helpText: helpText,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller(field),
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon:
                  icon != null ? Icon(icon) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DROPDOWN
  // ==========================================================

  Widget dropdown({
    required String field,
    required String label,
    required List<String> items,
    String? helpText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelWithHelp(
            label: label,
            helpText: helpText,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: values[field],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) {
              setValue(field, value);
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // EDUCATION
  // ==========================================================

  Widget educationDetails() {
    return Column(
      children: [
        dropdown(
          field: 'school_type',
          label: 'School Type',
          items: [
            'Government',
            'Government Aided',
            'Private',
          ],
          helpText:
              'Select the type of school where you are studying or studied.',
        ),
        dropdown(
          field: 'school_medium',
          label: 'School Medium',
          items: [
            'Tamil',
            'English',
          ],
          helpText:
              'Select the main language used for teaching in your school.',
        ),
        dropdown(
          field: 'school_class',
          label: 'School Class',
          items: [
            '10',
            '11',
            '12',
          ],
          helpText:
              'Select the school class you are currently studying.',
        ),
        dropdown(
          field: 'studied_govt_school_6_12',
          label:
              'Studied in Government School from 6th to 12th?',
          items: [
            'Yes',
            'No',
          ],
          helpText:
              'Select Yes if you studied in a Tamil Nadu Government School continuously from Class 6 to Class 12.',
        ),
        dropdown(
          field: 'currently_in_higher_education',
          label: 'Currently in Higher Education?',
          items: [
            'Yes',
            'No',
          ],
          helpText:
              'Higher education means college, university, diploma or other education after school.',
        ),
        dropdown(
          field: 'college_type',
          label: 'College Type',
          items: [
            'Government',
            'Government Aided',
            'Private',
          ],
          helpText:
              'Select whether your college or institution is Government, Government Aided or Private.',
        ),
        dropdown(
          field: 'hostel_required',
          label: 'Hostel Required?',
          items: [
            'Yes',
            'No',
          ],
          helpText:
              'Select Yes if you need or require hostel accommodation for your studies.',
        ),
        textField(
          field: 'academic_marks',
          label: 'Academic Marks',
          hint: 'Enter marks',
          keyboardType: TextInputType.number,
          icon: Icons.percent,
          helpText:
              'Enter your recent academic marks or percentage.',
        ),
        dropdown(
          field: 'learning_support_required',
          label: 'Learning Support Required?',
          items: [
            'Yes',
            'No',
          ],
          helpText:
              'Select Yes if you need additional educational or learning support.',
        ),
      ],
    );
  }

  // ==========================================================
  // WOMEN WELFARE
  // ==========================================================

  Widget womenDetails() {
    return Column(
      children: [
        dropdown(
          field: 'is_family_head',
          label: 'Are you the Family Head?',
          items: ['Yes', 'No'],
          helpText:
              'A family head is the person who is mainly responsible for managing and supporting the family.',
        ),
        dropdown(
          field: 'has_ration_card',
          label: 'Do you have a Ration Card?',
          items: ['Yes', 'No'],
          helpText:
              'A ration card is a Government-issued card used by eligible families to receive food and other benefits.',
        ),
        dropdown(
          field: 'ration_card_type',
          label: 'Ration Card Type',
          items: [
            'PHH',
            'AAY',
            'NPHH',
            'Other',
          ],
          helpText:
              'Select the category/type printed on your ration card. If you are not sure, choose Other.',
        ),
        dropdown(
          field: 'is_shg_member',
          label: 'Are you an SHG Member?',
          items: ['Yes', 'No'],
          helpText:
              'SHG means Self Help Group. It is a group of people who work together, often for savings, loans or livelihood activities.',
        ),
        textField(
          field: 'shg_size',
          label: 'SHG Size',
          hint: 'Enter SHG size',
          keyboardType: TextInputType.number,
          helpText:
              'Enter the number of members in your Self Help Group.',
        ),
        dropdown(
          field: 'shg_regular_savings',
          label: 'SHG Regular Savings?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if your Self Help Group regularly saves money as a group.',
        ),
        dropdown(
          field: 'is_orphan',
          label: 'Are you an Orphan?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if both of your parents are deceased or you do not have parental care.',
        ),
        dropdown(
          field: 'is_widow',
          label: 'Are you a Widow?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if your husband has passed away.',
        ),
        dropdown(
          field: 'is_unmarried_woman',
          label: 'Are you an Unmarried Woman?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you have never been married.',
        ),
        dropdown(
          field: 'is_deserted_woman',
          label: 'Are you a Deserted Woman?',
          items: ['Yes', 'No'],
          helpText:
              'A deserted woman is a married woman who has been left by her husband and is living without his support.',
        ),
        textField(
          field: 'years_deserted',
          label: 'Years Deserted',
          hint: 'Enter years',
          keyboardType: TextInputType.number,
          helpText:
              'Enter approximately how many years you have been living without your husband\'s support.',
        ),
        dropdown(
          field: 'legal_separation_status',
          label: 'Legal Separation Status',
          items: [
            'Yes',
            'No',
            'Not Applicable',
          ],
          helpText:
              'Select Yes if you have legally separated from your spouse through a recognised legal process.',
        ),
        dropdown(
          field: 'has_girl_child',
          label: 'Do you have a Girl Child?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you have one or more girl children.',
        ),
        textField(
          field: 'girl_child_count',
          label: 'Girl Child Count',
          hint: 'Enter count',
          keyboardType: TextInputType.number,
          helpText:
              'Enter the total number of girl children in your family.',
        ),
        dropdown(
          field: 'has_male_child',
          label: 'Do you have a Male Child?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you have one or more male children.',
        ),
        dropdown(
          field: 'sterilization_status',
          label: 'Sterilization Status',
          items: [
            'Done',
            'Not Done',
            'Not Applicable',
          ],
          helpText:
              'Select whether a permanent family-planning sterilization procedure has been completed.',
        ),
        dropdown(
          field: 'is_pregnant',
          label: 'Are you Pregnant?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you are currently pregnant.',
        ),
        dropdown(
          field: 'pregnancy_registered',
          label: 'Pregnancy Registered?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if your pregnancy has been registered with a Government health centre or health worker.',
        ),
        textField(
          field: 'delivery_count',
          label: 'Delivery Count',
          hint: 'Enter count',
          keyboardType: TextInputType.number,
          helpText:
              'Enter the total number of times you have given birth.',
        ),
        dropdown(
          field: 'is_lactating',
          label: 'Are you Lactating?',
          items: ['Yes', 'No'],
          helpText:
              'Lactating means currently breastfeeding a baby.',
        ),
        dropdown(
          field: 'is_inter_caste_marriage',
          label: 'Inter-Caste Marriage?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if the marriage is between two people belonging to different caste communities.',
        ),
        dropdown(
          field: 'marriage_assistance_required',
          label: 'Marriage Assistance Required?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you need Government financial assistance or support related to marriage.',
        ),
      ],
    );
  }

  // ==========================================================
  // EMPLOYMENT
  // ==========================================================

  Widget employmentDetails() {
    return Column(
      children: [
        dropdown(
          field: 'employment_registered',
          label: 'Employment Registration?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you have registered your details with a Government employment or employment exchange service.',
        ),
        textField(
          field: 'employment_registration_years',
          label: 'Employment Registration Years',
          hint: 'Enter years',
          keyboardType: TextInputType.number,
          helpText:
              'Enter how many years you have been registered for employment.',
        ),
        dropdown(
          field: 'currently_employed',
          label: 'Currently Employed?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you currently have a job or are working for an employer.',
        ),
        dropdown(
          field: 'job_seeking',
          label: 'Looking for a Job?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you are currently looking for a job.',
        ),
        textField(
          field: 'technical_qualification',
          label: 'Technical Qualification',
          hint: 'Enter qualification',
          helpText:
              'Enter any technical, vocational or professional qualification you have completed.',
        ),
        dropdown(
          field: 'business_interest',
          label: 'Interested in Business?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you are interested in starting or running your own business.',
        ),
        textField(
          field: 'proposed_business',
          label: 'Proposed Business',
          hint: 'Enter proposed business',
          helpText:
              'Enter the type of business you would like to start.',
        ),
      ],
    );
  }

  // ==========================================================
  // AGRICULTURE
  // ==========================================================

  Widget agricultureDetails() {
    return Column(
      children: [
        dropdown(
          field: 'is_farmer',
          label: 'Are you a Farmer?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you are involved in farming or agricultural activities.',
        ),
        dropdown(
          field: 'has_agricultural_land',
          label: 'Do you have Agricultural Land?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you own, lease or otherwise have land that is used for agriculture.',
        ),
        dropdown(
          field: 'land_ownership',
          label: 'Land Ownership',
          items: [
            'Own',
            'Lease',
            'Other',
          ],
          helpText:
              'Select whether the agricultural land belongs to you, is leased by you, or comes under another arrangement.',
        ),
        textField(
          field: 'land_area',
          label: 'Land Area',
          hint: 'Enter land area',
          keyboardType: TextInputType.number,
          helpText:
              'Enter the approximate size of your agricultural land.',
        ),
        dropdown(
          field: 'cultivation_status',
          label: 'Cultivation Status',
          items: [
            'Cultivating',
            'Not Cultivating',
          ],
          helpText:
              'Select whether you are currently growing crops or doing farming activities on the land.',
        ),
        textField(
          field: 'crop_type',
          label: 'Crop Type',
          hint: 'Enter crop type',
          helpText:
              'Enter the main crop or crops that you grow on your agricultural land.',
        ),
        dropdown(
          field: 'farmer_identity_card',
          label: 'Farmer Identity Card?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you have a Government-issued Farmer Identity Card.',
        ),
        dropdown(
          field: 'farmer_group_member',
          label: 'Farmer Group Member?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you are a member of a farmer group, association or producer group.',
        ),
        dropdown(
          field: 'needs_farm_machinery',
          label: 'Need Farm Machinery?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you need agricultural machines or equipment for farming.',
        ),
        dropdown(
          field: 'agriculture_degree',
          label: 'Agriculture Degree?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you have completed a degree related to Agriculture or a related agricultural field.',
        ),
        dropdown(
          field: 'agri_business',
          label: 'Interested in Agri Business?',
          items: ['Yes', 'No'],
          helpText:
              'Agri business means business activities related to agriculture, farming, food processing or agricultural products.',
        ),
        dropdown(
          field: 'landless_agricultural_labourer',
          label: 'Landless Agricultural Labourer?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you work in agricultural activities but do not own agricultural land.',
        ),
      ],
    );
  }

  // ==========================================================
  // HEALTH
  // ==========================================================

  Widget healthDetails() {
    return Column(
      children: [
        dropdown(
          field: 'cmchis_eligible',
          label: 'CMCHIS Eligible?',
          items: ['Yes', 'No'],
          helpText:
              'CMCHIS stands for Chief Minister\'s Comprehensive Health Insurance Scheme. It is a Tamil Nadu Government health insurance scheme that helps eligible families receive medical treatment. If you have CMCHIS coverage or card, select Yes.',
        ),
        textField(
          field: 'health_condition',
          label: 'Health Condition',
          hint: 'Enter health condition',
          helpText:
              'Enter the health problem or medical condition for which you need support, if any.',
        ),
        dropdown(
          field: 'needs_home_healthcare',
          label: 'Need Home Healthcare?',
          items: ['Yes', 'No'],
          helpText:
              'Home healthcare means receiving medical or health-related care at your home instead of visiting a hospital or clinic.',
        ),
        dropdown(
          field: 'medical_screening_required',
          label: 'Medical Screening Required?',
          items: ['Yes', 'No'],
          helpText:
              'Medical screening means checking your health through medical tests or examinations to identify health problems.',
        ),
        dropdown(
          field: 'accident_case',
          label: 'Accident Case?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if your current medical treatment or health need is related to an accident.',
        ),
      ],
    );
  }

  // ==========================================================
  // HOUSING
  // ==========================================================

  Widget housingDetails() {
    return Column(
      children: [
        dropdown(
          field: 'rural_urban',
          label: 'Rural / Urban',
          items: [
            'Rural',
            'Urban',
          ],
          helpText:
              'Select whether your home is located in a village/rural area or a town/city/urban area.',
        ),
        dropdown(
          field: 'owns_house',
          label: 'Do you Own a House?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you or your family owns the house where you currently live.',
        ),
        dropdown(
          field: 'hut_house',
          label: 'Do you Live in a Hut House?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if your current house is a hut or a temporary/simple structure.',
        ),
        textField(
          field: 'house_condition',
          label: 'House Condition',
          hint: 'Enter house condition',
          helpText:
              'Describe the current condition of your house, such as good, damaged, weak or needing repair.',
        ),
        dropdown(
          field: 'house_damage',
          label: 'House Damaged?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if your house has been damaged and needs repair or reconstruction.',
        ),
        dropdown(
          field: 'has_house_site',
          label: 'Do you have a House Site?',
          items: ['Yes', 'No'],
          helpText:
              'A house site means a piece of land available for constructing a house.',
        ),
        dropdown(
          field: 'owns_land',
          label: 'Do you Own Land?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you or your family owns land.',
        ),
        dropdown(
          field: 'land_patta',
          label: 'Land Patta Available?',
          items: ['Yes', 'No'],
          helpText:
              'Patta is a Government land ownership/revenue document. Select Yes if you have a Patta document for your land.',
        ),
        dropdown(
          field: 'deprivation_criteria_met',
          label: 'Deprivation Criteria Met?',
          items: ['Yes', 'No'],
          helpText:
              'This refers to whether your family meets Government-defined conditions showing a need for housing or welfare assistance.',
        ),
        dropdown(
          field: 'housing_board_registered',
          label: 'Housing Board Registered?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you have registered with the Government Housing Board for housing-related assistance.',
        ),
        dropdown(
          field: 'unorganised_worker_registered',
          label: 'Unorganised Worker Registered?',
          items: ['Yes', 'No'],
          helpText:
              'Unorganised workers are people working outside regular organised employment, such as some daily-wage, domestic or informal workers. Select Yes if you are registered under a Government unorganised-worker scheme.',
        ),
      ],
    );
  }

  // ==========================================================
  // SOCIAL SECURITY
  // ==========================================================

  Widget socialSecurityDetails() {
    return Column(
      children: [
        dropdown(
          field: 'is_destitute',
          label: 'Are you Destitute?',
          items: ['Yes', 'No'],
          helpText:
              'A destitute person is someone who has very little or no financial support and is unable to meet basic needs.',
        ),
        dropdown(
          field: 'is_bpl',
          label: 'Are you BPL?',
          items: ['Yes', 'No'],
          helpText:
              'BPL means Below Poverty Line. Select Yes if your family is officially classified under the Government BPL category.',
        ),
      ],
    );
  }

  // ==========================================================
  // DIFFERENTLY ABLED
  // ==========================================================

  Widget differentlyAbledDetails() {
    return Column(
      children: [
        dropdown(
          field: 'is_differently_abled',
          label: 'Are you Differently Abled?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you have a physical, visual, hearing, intellectual or other recognised disability.',
        ),
        textField(
          field: 'disability_type',
          label: 'Disability Type',
          hint: 'Enter disability type',
          helpText:
              'Enter the type of disability mentioned in your medical or disability certificate, if applicable.',
        ),
        textField(
          field: 'disability_percentage',
          label: 'Disability Percentage',
          hint: 'Enter percentage',
          keyboardType: TextInputType.number,
          helpText:
              'Enter the disability percentage mentioned in your official disability certificate.',
        ),
        dropdown(
          field: 'has_disability_certificate',
          label: 'Disability Certificate Available?',
          items: ['Yes', 'No'],
          helpText:
              'A disability certificate is an official document issued by an authorised medical/Government authority confirming disability.',
        ),
      ],
    );
  }

  // ==========================================================
  // BC / MBC / MINORITIES
  // ==========================================================

  Widget communityDetails() {
    return Column(
      children: [
        dropdown(
          field: 'community',
          label: 'Community',
          items: [
            'BC',
            'MBC',
            'Minority',
            'Other',
          ],
          helpText:
              'Select the community category that applies to you according to your official community records or certificate.',
        ),
        dropdown(
          field: 'community_certificate',
          label: 'Community Certificate Available?',
          items: ['Yes', 'No'],
          helpText:
              'A community certificate is an official Government document showing your community category.',
        ),
        dropdown(
          field: 'minority_status',
          label: 'Minority Status?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you belong to a community recognised by the Government as a minority community.',
        ),
        dropdown(
          field: 'minority_certificate',
          label: 'Minority Certificate Available?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if you have an official document/certificate supporting your minority status.',
        ),
      ],
    );
  }

  // ==========================================================
  // CHILDREN
  // ==========================================================

  Widget childrenDetails() {
    return Column(
      children: [
        textField(
          field: 'child_age',
          label: 'Child Age',
          hint: 'Enter child age',
          keyboardType: TextInputType.number,
          icon: Icons.child_care_outlined,
          helpText:
              'Enter the current age of the child for whom you are looking for schemes.',
        ),
        dropdown(
          field: 'child_gender',
          label: 'Child Gender',
          items: [
            'Male',
            'Female',
            'Other',
          ],
          helpText:
              'Select the gender of the child.',
        ),
        dropdown(
          field: 'child_school_status',
          label: 'Child School Status',
          items: [
            'Studying',
            'Not Studying',
            'Dropped Out',
          ],
          helpText:
              'Select whether the child is currently studying, not attending school, or has stopped school before completing education.',
        ),
        dropdown(
          field: 'is_child_in_need_of_care',
          label: 'Child in Need of Care?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if the child needs special care, protection or support because of difficult family or living circumstances.',
        ),
        dropdown(
          field: 'is_abandoned_or_surrendered_child',
          label: 'Abandoned or Surrendered Child?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if the child has been abandoned by parents/guardians or has been formally surrendered for care and protection.',
        ),
        dropdown(
          field: 'parental_support_available',
          label: 'Parental Support Available?',
          items: ['Yes', 'No'],
          helpText:
              'Select Yes if the child currently receives care and support from their parents or legal guardians.',
        ),
      ],
    );
  }

  // ==========================================================
  // SELECT CATEGORY DETAILS
  // ==========================================================

  Widget getCategoryDetails() {
    switch (widget.categoryId) {
      case 1:
        return educationDetails();
      case 2:
        return womenDetails();
      case 3:
        return employmentDetails();
      case 4:
        return agricultureDetails();
      case 5:
        return healthDetails();
      case 6:
        return housingDetails();
      case 7:
        return socialSecurityDetails();
      case 8:
        return differentlyAbledDetails();
      case 9:
        return communityDetails();
      case 10:
        return childrenDetails();
      default:
        return const Text(
          'No details available.',
        );
    }
  }

  // ==========================================================
  // CONVERT VALUES
  // ==========================================================

  dynamic convertValue(
    String key,
    String value,
  ) {
    const numberFields = {
      'academic_marks',
      'shg_size',
      'years_deserted',
      'girl_child_count',
      'delivery_count',
      'employment_registration_years',
      'land_area',
      'disability_percentage',
      'child_age',
    };

    if (numberFields.contains(key)) {
      return double.tryParse(value) ?? value;
    }

    return value;
  }

  // ==========================================================
  // SUBMIT DETAILS
  // ==========================================================

  Future<void> submitDetails() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> additionalData = {};

      // Dropdown values
      values.forEach((key, value) {
        if (value != null &&
            value!.trim().isNotEmpty) {
          additionalData[key] = value;
        }
      });

      // Text field values
      controllers.forEach(
        (key, textController) {
          final value =
              textController.text.trim();

          if (value.isNotEmpty) {
            additionalData[key] =
                convertValue(key, value);
          }
        },
      );

      // ======================================================
      // SAVE CATEGORY-SPECIFIC DETAILS
      // ======================================================

      final additionalResult =
          await ApiService.saveAdditionalProfile(
        email: widget.email,
        selectedCategoryId:
            widget.categoryId,
        additionalData: additionalData,
      );

      if (!mounted) return;

      if (additionalResult['message'] !=
          'Additional profile saved successfully') {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              additionalResult['message'] ??
                  'Failed to save additional profile',
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      // ======================================================
      // SUCCESS
      // ======================================================

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Category details saved successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            email: widget.email,
            name: widget.name,
            dob: widget.dob,
            age: widget.age,
            gender: widget.gender,
            maritalStatus:
                widget.maritalStatus,
            educationLevel:
                widget.educationLevel,
            currentlyStudying:
                widget.currentlyStudying,
            course: widget.course,
            occupation:
                widget.occupation,
            annualFamilyIncome:
                widget.annualFamilyIncome,
            state: widget.state,
            district:
                widget.district,
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Error while saving category details: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ==========================================================
  // UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8FCFF),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFFF8FCFF),
        elevation: 0,
        title: Text(
          '$categoryName Details',
          style: const TextStyle(
            color: Color(0xFF102A5C),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF102A5C),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Text(
              'Tell us about your $categoryName needs',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF102A5C),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Please provide the details below to find suitable government schemes.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF78909C),
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // INFO MESSAGE
            // ==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color(0xFF356AE6),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Not sure about a question? Tap the ⓘ icon next to it to see a simple explanation.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF31527D),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            getCategoryDetails(),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : submitDetails,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF356AE6),
                  foregroundColor:
                      Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFF9DB5F0),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),

                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Submit & Continue',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w600,
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