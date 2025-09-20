import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/models/prev_history.dart';
import 'package:neura_care/providers/prev_history.dart';
import 'package:neura_care/providers/theme.dart';
import 'package:neura_care/screens/inputs/prev_history.dart';
import 'package:neura_care/themes.dart';

class DiseasesScreen extends ConsumerStatefulWidget {
  const DiseasesScreen({super.key});

  @override
  ConsumerState<DiseasesScreen> createState() => _DiseasesScreenState();
}

class _DiseasesScreenState extends ConsumerState<DiseasesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    final prevHistory = ref.watch(prevHistoryProviderNotifier);

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
              
              // Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Disease History Section
                          _buildDiseaseHistorySection(theme, isDark, prevHistory),
                          
                          const SizedBox(height: 24),
                          
                          // Surgery History Section
                          _buildSurgeryHistorySection(theme, isDark, prevHistory),
                          
                          const SizedBox(height: 24),
                          
                          // Family History Section
                          _buildFamilyHistorySection(theme, isDark, prevHistory),
                          
                          const SizedBox(height: 32),
                          
                          // Update Button
                          _buildUpdateButton(theme, isDark),
                        ],
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.errorRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.medical_information,
              color: AppTheme.errorRed,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Medical History",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Review your health records",
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
    );
  }

  Widget _buildDiseaseHistorySection(ThemeData theme, bool isDark, PreviousHistory prevHistory) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_hospital,
                  color: AppTheme.errorRed,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Disease History",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (prevHistory.diseases.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.errorRed.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.health_and_safety_outlined,
                    size: 48,
                    color: AppTheme.errorRed.withOpacity(0.7),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No Disease History",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You haven't recorded any diseases yet",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                          .withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ] else ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: prevHistory.diseases.map((disease) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.errorRed.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.medical_services,
                      size: 16,
                      color: AppTheme.errorRed,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      disease,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.errorRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSurgeryHistorySection(ThemeData theme, bool isDark, PreviousHistory prevHistory) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.warningAmber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.healing,
                  color: AppTheme.warningAmber,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Surgery History",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (prevHistory.surgeries.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.warningAmber.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.warningAmber.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.healing_outlined,
                    size: 48,
                    color: AppTheme.warningAmber.withOpacity(0.7),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No Surgery History",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You haven't recorded any surgeries yet",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                          .withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ] else ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: prevHistory.surgeries.map((surgery) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.warningAmber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.warningAmber.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.healing,
                      size: 16,
                      color: AppTheme.warningAmber,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      surgery,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.warningAmber,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFamilyHistorySection(ThemeData theme, bool isDark, PreviousHistory prevHistory) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.healthGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.family_restroom,
                  color: AppTheme.healthGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Family History",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (prevHistory.familyHistory.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.healthGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.healthGreen.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.family_restroom_outlined,
                    size: 48,
                    color: AppTheme.healthGreen.withOpacity(0.7),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No Family History",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You haven't recorded any family history yet",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                          .withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ] else ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: prevHistory.familyHistory.map((history) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.healthGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.healthGreen.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.family_restroom,
                      size: 16,
                      color: AppTheme.healthGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      history,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.healthGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpdateButton(ThemeData theme, bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PreviousHistoryScreen(),
            ),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text("Update Medical History"),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}