import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:neura_care/models/med.dart';
import 'package:neura_care/models/prev_history.dart';
import 'package:neura_care/providers/prev_history.dart';
import 'package:neura_care/providers/med_list.dart';
import 'package:neura_care/providers/theme.dart';
import 'package:neura_care/screens/inputs/prev_history.dart';
import 'package:neura_care/screens/inputs/setMedReminder.dart';
import 'package:neura_care/services/notifications.dart';
import 'package:neura_care/themes.dart';

class _FloatMascot extends StatefulWidget {
  final String asset;
  final double? width;
  final double? height;
  final Duration duration;

  const _FloatMascot({Key? key, required this.asset, this.width, this.height, this.duration = const Duration(milliseconds: 1400)}) : super(key: key);

  @override
  State<_FloatMascot> createState() => _FloatMascotState();
}

class _FloatMascotState extends State<_FloatMascot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _yAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _yAnim = Tween<double>(begin: -6.0, end: 6.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          await _ctrl.animateTo(1.0, duration: const Duration(milliseconds: 200));
          await _ctrl.animateBack(0.0, duration: const Duration(milliseconds: 200));
          _ctrl.repeat(reverse: true);
        } catch (_) {}
      },
      child: AnimatedBuilder(
        animation: _yAnim,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _yAnim.value),
            child: child,
          );
        },
        child: Image.asset(
          widget.asset,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class MedsTab extends ConsumerStatefulWidget {
  const MedsTab({super.key});

  @override
  ConsumerState<MedsTab> createState() => _MedsTabState();
}

class _MedsTabState extends ConsumerState<MedsTab>
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
    
    // Load medication list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medListProviderNotifier.notifier).loadMedList();
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
    final prevHistory = ref.watch(prevHistoryProviderNotifier);
    final medListObj = ref.watch(medListProviderNotifier);
    final medList = medListObj.meds;

    return Container(
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              slivers: [
                // Header
               
                SliverToBoxAdapter(
                  child: _buildHeader(theme, isDark),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: _FloatMascot(asset: 'images/mascotMedic.png', height: 160),
                    ),
                  ),
                ),
                // Medication Reminders Section
                SliverToBoxAdapter(
                  child: _buildMedicationRemindersSection(theme, isDark, medList),
                ),
                
                // Previous History Section
                SliverToBoxAdapter(
                  child: _buildPreviousHistorySection(theme, isDark, prevHistory),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.health_and_safety,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Health Dashboard",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Manage your medications and health history",
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

  Widget _buildMedicationRemindersSection(ThemeData theme, bool isDark, List<Med> medications) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.medication,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Medication Reminders",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SetMedReminderScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (medications.isEmpty) ...[
            // Empty State
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.medication_liquid_outlined,
                    size: 48,
                    color: AppTheme.primaryColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No Medications Set",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add your medications to set up reminders",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                          .withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SetMedReminderScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Medication"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Medications List
            ...medications.asMap().entries.map((entry) {
              int index = entry.key;
              Med med = entry.value;
              return _buildMedicationAlarmCard(med, index, theme, isDark);
            }).toList(),
            
            const SizedBox(height: 16),
            
            // Add More Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SetMedReminderScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Another Medication"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: BorderSide(color: AppTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicationAlarmCard(Med med, int index, ThemeData theme, bool isDark) {
    final now = DateTime.now();
    final medicationTime = DateTime(now.year, now.month, now.day, med.timingHrs, med.timingMins);
    final isUpcoming = medicationTime.isAfter(now);
    final timeUntil = isUpcoming ? medicationTime.difference(now) : Duration.zero;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUpcoming 
            ? AppTheme.healthGreen.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUpcoming 
              ? AppTheme.healthGreen.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Status Indicator
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUpcoming 
                  ? AppTheme.healthGreen.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isUpcoming ? Icons.schedule : Icons.check_circle,
              color: isUpcoming ? AppTheme.healthGreen : Colors.grey,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Medication Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med.medName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${med.number} tablets",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                        .withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                          .withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      TimeOfDay(hour: med.timingHrs, minute: med.timingMins).format(context),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                            .withOpacity(0.7),
                      ),
                    ),
                    if (isUpcoming && timeUntil.inHours < 24) ...[
                      const SizedBox(width: 8),
                      Text(
                        "• ${_formatTimeUntil(timeUntil)}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.healthGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Action Buttons
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SetMedReminderScreen(
                      existingMed: med,
                      editIndex: index,
                    ),
                  ),
                );
              } else if (value == 'test') {
                _testNotification(med);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'test',
                child: Row(
                  children: [
                    Icon(Icons.notifications),
                    SizedBox(width: 8),
                    Text('Test Notification'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousHistorySection(ThemeData theme, bool isDark, PreviousHistory prevHistory) {
    final hasHistory = prevHistory != PreviousHistory.empty() && 
                      (prevHistory.diseases.isNotEmpty || 
                       prevHistory.surgeries.isNotEmpty || 
                       prevHistory.familyHistory.isNotEmpty);

    return Container(
      margin: const EdgeInsets.all(16),
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
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.infoBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.medical_information,
                  color: AppTheme.infoBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Medical History",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PreviousHistoryScreen(),
                    ),
                  );
                },
                icon: Icon(
                  hasHistory ? Icons.edit : Icons.add,
                  color: AppTheme.infoBlue,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (!hasHistory) ...[
            // Empty State
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.infoBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.infoBlue.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.medical_information_outlined,
                    size: 48,
                    color: AppTheme.infoBlue.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No Medical History",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Adding previous history helps us provide better health recommendations",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                          .withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PreviousHistoryScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Medical History"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.infoBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // History Summary
            if (prevHistory.diseases.isNotEmpty) _buildHistoryCard("Diseases", prevHistory.diseases, Icons.local_hospital, AppTheme.errorRed, theme, isDark),
            if (prevHistory.surgeries.isNotEmpty) _buildHistoryCard("Surgeries", prevHistory.surgeries, Icons.healing, AppTheme.warningAmber, theme, isDark),
            if (prevHistory.familyHistory.isNotEmpty) _buildHistoryCard("Family History", prevHistory.familyHistory, Icons.family_restroom, AppTheme.healthGreen, theme, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String title, List<String> items, IconData icon, Color color, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: items.map((item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  String _formatTimeUntil(Duration duration) {
    if (duration.inHours > 0) {
      return "in ${duration.inHours}h ${duration.inMinutes % 60}m";
    } else {
      return "in ${duration.inMinutes}m";
    }
  }

  Future<void> _testNotification(Med med) async {
    try {
      await showImmediateNotification(
        'Test Medication Reminder',
        'This is how your reminder for ${med.medName} will look (${med.number} tablets)',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.notifications, color: Colors.white),
                SizedBox(width: 8),
                Text("Test notification sent!"),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error sending test notification: $e"),
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