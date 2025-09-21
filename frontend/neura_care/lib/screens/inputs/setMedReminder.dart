import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/models/med.dart';
import 'package:neura_care/providers/med_list.dart';
import 'package:neura_care/providers/theme.dart';
import 'package:neura_care/services/notifications.dart';
import 'package:neura_care/themes.dart';

class SetMedReminderScreen extends ConsumerStatefulWidget {
  final Med? existingMed;
  final int? editIndex;
  
  const SetMedReminderScreen({
    super.key, 
    this.existingMed,
    this.editIndex,
  });

  @override
  ConsumerState<SetMedReminderScreen> createState() => _SetMedReminderScreenState();
}

class _SetMedReminderScreenState extends ConsumerState<SetMedReminderScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _medNameController = TextEditingController();
  final _dosageController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation
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
    
    // Pre-fill form if editing existing medication
    if (widget.existingMed != null) {
      _medNameController.text = widget.existingMed!.medName;
      _dosageController.text = widget.existingMed!.number.toString();
      _selectedTime = TimeOfDay(
        hour: widget.existingMed!.timingHrs,
        minute: widget.existingMed!.timingMins,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _medNameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final medListObj = ref.watch(medListProviderNotifier);
    final medList = medListObj.meds;

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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Medication Form
                          _buildMedicationForm(theme, isDark),
                          
                          const SizedBox(height: 24),
                          
                          // Current Medications List
                          if (medList.isNotEmpty) _buildCurrentMedicationsList(theme, isDark, medList),
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
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.medication,
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
                  widget.existingMed != null ? "Edit Medication" : "Add Medication",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.existingMed != null ? "Update reminder details" : "Set up medication reminders",
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

  Widget _buildMedicationForm(ThemeData theme, bool isDark) {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Icon(
                  Icons.edit,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Medication Details",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Medication Name Field
            _buildTextField(
              controller: _medNameController,
              label: "Medication Name",
              hint: "Enter medication name",
              icon: Icons.medication_liquid,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter medication name';
                }
                return null;
              },
              theme: theme,
              isDark: isDark,
            ),
            
            const SizedBox(height: 20),
            
            // Dosage Field
            _buildTextField(
              controller: _dosageController,
              label: "Dosage (number of tablets/pills)",
              hint: "Enter number of tablets",
              icon: Icons.format_list_numbered,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter dosage';
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              theme: theme,
              isDark: isDark,
            ),
            
            const SizedBox(height: 20),
            
            // Time Picker
            _buildTimePicker(theme, isDark),
            
            const SizedBox(height: 32),
            
            // Action Buttons
            _buildActionButtons(theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    required ThemeData theme,
    required bool isDark,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                  .withOpacity(0.5),
            ),
            prefixIcon: Icon(
              icon,
              color: AppTheme.primaryColor,
            ),
            filled: true,
            fillColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppTheme.darkOutline : AppTheme.lightOutline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppTheme.darkOutline : AppTheme.lightOutline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.errorRed, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reminder Time",
          style: theme.textTheme.titleMedium?.copyWith(
            color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppTheme.darkOutline : AppTheme.lightOutline,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  "${_selectedTime.format(context)}",
                  style: TextStyle(
                    color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
              side: BorderSide(
                color: isDark ? AppTheme.darkOutline : AppTheme.lightOutline,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveMedication,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
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
                : Text(widget.existingMed != null ? "Update" : "Save"),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentMedicationsList(ThemeData theme, bool isDark, List<Med> medications) {
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
              Icon(
                Icons.list_alt,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Current Medications",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...medications.asMap().entries.map((entry) {
            int index = entry.key;
            Med med = entry.value;
            return _buildMedicationCard(med, index, theme, isDark);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(Med med, int index, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
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
                  "${med.number} tablets at ${TimeOfDay(hour: med.timingHrs, minute: med.timingMins).format(context)}",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: (isDark ? AppTheme.darkOnSurface : AppTheme.lightOnSurface)
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _editMedication(med, index),
            icon: Icon(
              Icons.edit,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () => _deleteMedication(index),
            icon: Icon(
              Icons.delete,
              color: AppTheme.errorRed,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newMed = Med(
        _medNameController.text.trim(),
        _selectedTime.hour,
        _selectedTime.minute,
        int.parse(_dosageController.text),
      );

      final currentMedsObj = ref.read(medListProviderNotifier);
      final currentMeds = currentMedsObj.meds;
      List<Med> updatedMeds = List.from(currentMeds);

      if (widget.editIndex != null) {
        // Update existing medication
        updatedMeds[widget.editIndex!] = newMed;
      } else {
        // Add new medication
        updatedMeds.add(newMed);
      }

      await ref.read(medListProviderNotifier.notifier).updateMedList(updatedMeds);

      // Set notification
      try {
        await setTimedNotification(newMed);
        if (context.mounted) {
          final messenger = ScaffoldMessenger.maybeOf(context);
          if (messenger != null) {
            messenger.showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Text("${widget.existingMed != null ? 'Updated' : 'Added'} medication and set reminder!"),
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
        }
      } catch (e) {
        if (context.mounted) {
          final messenger = ScaffoldMessenger.maybeOf(context);
          if (messenger != null) {
            messenger.showSnackBar(
              SnackBar(
                content: Text("Medication saved, but reminder failed: $e"),
                backgroundColor: AppTheme.warningAmber,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        }
      }

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print("Error saving medication: $e");
      if (context.mounted) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text("Error saving medication: $e"),
              backgroundColor: AppTheme.errorRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _editMedication(Med med, int index) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SetMedReminderScreen(
          existingMed: med,
          editIndex: index,
        ),
      ),
    );
  }

  Future<void> _deleteMedication(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Medication"),
        content: const Text("Are you sure you want to delete this medication?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final currentMedsObj = ref.read(medListProviderNotifier);
      final currentMeds = currentMedsObj.meds;
      List<Med> updatedMeds = List.from(currentMeds);
      updatedMeds.removeAt(index);
      
      await ref.read(medListProviderNotifier.notifier).updateMedList(updatedMeds);
      
      if (context.mounted) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.delete, color: Colors.white),
                  SizedBox(width: 8),
                  Text("Medication deleted"),
                ],
              ),
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
}
