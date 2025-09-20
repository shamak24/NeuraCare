import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/providers/user.dart';
import 'package:neura_care/services/api.dart';
import '../../providers/prev_history.dart';
import '../../providers/theme.dart';
import '../../themes.dart';

const allowedPreviousDiseases = [
  "Diabetes",
  "Hypertension (BP)",
  "Cardiovascular Disease",
  "Chronic Respiratory Disease",
  "Cancer",
  "Obesity (BMI)",
  "Thyroid Disorders",
  "PCOS",
  "Kidney Disease (CKD)",
  "Stroke",
  "Arthritis",
];

const allowedSurgicalHistory = [
  "Appendectomy",
  "Cholecystectomy (Gallbladder Removal)",
  "Hernia Repair",
  "Cataract Surgery",
  "Hip Replacement",
  "Knee Replacement",
  "Tonsillectomy",
  "Cesarean Section (C-Section)",
  "Hysterectomy",
  "Coronary Artery Bypass Grafting (CABG)",
];

const allowedFamilyHistory = [
  "Diabetes",
  "Hypertension (BP)",
  "Cardiovascular Disease",
  "Cancer",
  "Obesity (BMI)",
  "Thyroid Disorders",
  "Kidney Disease (CKD)",
  "Stroke",
  "Arthritis",
];

class PreviousHistoryScreen extends ConsumerStatefulWidget {
  const PreviousHistoryScreen({super.key});

  @override
  ConsumerState<PreviousHistoryScreen> createState() => _PreviousHistoryScreenState();
}

class _PreviousHistoryScreenState extends ConsumerState<PreviousHistoryScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
    
    // Load previous history data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(prevHistoryProviderNotifier.notifier).loadPrevHistory();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final previousHistory = ref.watch(prevHistoryProviderNotifier);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppTheme.darkBackground,
                    AppTheme.darkSurface.withOpacity(0.8),
                  ]
                : [
                    AppTheme.lightBackground,
                    AppTheme.primaryColor.withOpacity(0.05),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildCustomAppBar(theme, isDark),
              
              // Form Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDropdownCard(
                              theme: theme,
                              isDark: isDark,
                              title: "Previous Diseases",
                              subtitle: "Select any diseases you've been diagnosed with",
                              icon: Icons.medical_information_outlined,
                              items: allowedPreviousDiseases,
                              selectedItems: previousHistory.diseases,
                              onItemAdd: (disease) {
                                ref.read(prevHistoryProviderNotifier.notifier)
                                    .savePrevHistory(previousHistory.copyWith(
                                  diseases: [...previousHistory.diseases, disease],
                                ));
                              },
                              onItemRemove: (disease) {
                                ref.read(prevHistoryProviderNotifier.notifier)
                                    .savePrevHistory(previousHistory.copyWith(
                                  diseases: previousHistory.diseases
                                      .where((d) => d != disease)
                                      .toList(),
                                ));
                              },
                            ),
                            
                            const SizedBox(height: 20),
                            
                            _buildDropdownCard(
                              theme: theme,
                              isDark: isDark,
                              title: "Surgical History",
                              subtitle: "Select any surgeries you've undergone",
                              icon: Icons.healing_outlined,
                              items: allowedSurgicalHistory,
                              selectedItems: previousHistory.surgeries,
                              onItemAdd: (surgery) {
                                ref.read(prevHistoryProviderNotifier.notifier)
                                    .savePrevHistory(previousHistory.copyWith(
                                  surgeries: [...previousHistory.surgeries, surgery],
                                ));
                              },
                              onItemRemove: (surgery) {
                                ref.read(prevHistoryProviderNotifier.notifier)
                                    .savePrevHistory(previousHistory.copyWith(
                                  surgeries: previousHistory.surgeries
                                      .where((s) => s != surgery)
                                      .toList(),
                                ));
                              },
                            ),
                            
                            const SizedBox(height: 20),
                            
                            _buildDropdownCard(
                              theme: theme,
                              isDark: isDark,
                              title: "Family History",
                              subtitle: "Select any conditions that run in your family",
                              icon: Icons.family_restroom_outlined,
                              items: allowedFamilyHistory,
                              selectedItems: previousHistory.familyHistory,
                              onItemAdd: (history) {
                                ref.read(prevHistoryProviderNotifier.notifier)
                                    .savePrevHistory(previousHistory.copyWith(
                                  familyHistory: [...previousHistory.familyHistory, history],
                                ));
                              },
                              onItemRemove: (history) {
                                ref.read(prevHistoryProviderNotifier.notifier)
                                    .savePrevHistory(previousHistory.copyWith(
                                  familyHistory: previousHistory.familyHistory
                                      .where((h) => h != history)
                                      .toList(),
                                ));
                              },
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Action Buttons
                            _buildActionButtons(theme, isDark, previousHistory),
                            
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Previous History",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Your medical background",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                      .withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownCard({
    required ThemeData theme,
    required bool isDark,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> items,
    required List<String> selectedItems,
    required Function(String) onItemAdd,
    required Function(String) onItemRemove,
  }) {
    return Card(
      elevation: isDark ? 8 : 4,
      color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppTheme.darkOutline : AppTheme.lightOutline,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Dropdown for adding new items
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppTheme.darkOutline : AppTheme.lightOutline,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Add ${title.toLowerCase()}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  isExpanded: true,
                  value: null,
                  dropdownColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                  ),
                  onChanged: (String? value) {
                    if (value != null && !selectedItems.contains(value)) {
                      onItemAdd(value);
                    }
                  },
                  items: items
                      .where((item) => !selectedItems.contains(item))
                      .map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // Selected items display
            if (selectedItems.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.healthGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.healthGreen.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppTheme.healthGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Selected (${selectedItems.length})",
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.healthGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedItems.map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => onItemRemove(item),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.errorRed.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: AppTheme.errorRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, bool isDark, dynamic previousHistory) {
    return Column(
      children: [
        // Save Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : () => _savePreviousHistory(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save_outlined),
                      const SizedBox(width: 8),
                      Text(
                        "Save Previous History",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Clear All Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => _showClearConfirmation(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
              side: const BorderSide(color: AppTheme.errorRed),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.clear_all_outlined),
                const SizedBox(width: 8),
                Text(
                  "Clear All",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.errorRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _savePreviousHistory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await updateHistory(ref.read(userProviderNotifier).token!, ref.read(prevHistoryProviderNotifier));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text("Previous history saved successfully!"),
              ],
            ),
            backgroundColor: AppTheme.healthGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving data: $e"),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final isDark = ref.read(themeProvider) == ThemeMode.dark;
        
        return AlertDialog(
          backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: AppTheme.warningAmber,
              ),
              const SizedBox(width: 8),
              Text(
                "Clear All Data",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to clear all your previous history data? This action cannot be undone.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearAllData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
                foregroundColor: Colors.white,
              ),
              child: const Text("Clear All"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearAllData() async {
    try {
      await ref.read(prevHistoryProviderNotifier.notifier).clearPrevHistory();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 8),
                Text("All previous history data cleared"),
              ],
            ),
            backgroundColor: AppTheme.infoBlue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error clearing data: $e"),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}
