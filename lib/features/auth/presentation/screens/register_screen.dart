import 'dart:io';
import 'package:ala_feen/features/auth/presentation/widgets/register_driver_form_widget.dart';
import 'package:ala_feen/features/auth/presentation/widgets/register_passenger_form_widget.dart';
import 'package:ala_feen/features/auth/presentation/widgets/driver_and_passenger_toggle_widget.dart';
import 'package:ala_feen/features/auth/presentation/widgets/logo_with_back_button.dart';
import 'package:ala_feen/features/auth/presentation/widgets/profile_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Role selection state
  bool _isPassenger = false;

  // Common
  File? _profileImage;

  // Passenger controllers
  final TextEditingController _passengerNameController =
      TextEditingController();
  final TextEditingController _passengerPhoneController =
      TextEditingController();
  final TextEditingController _passengerPasswordController =
      TextEditingController();

  // Driver controllers
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _driverPhoneController = TextEditingController();
  final TextEditingController _driverPasswordController =
      TextEditingController();

  // Driver document images
  File? _idImage;
  File? _licenseImage;
  File? _carImage;

  @override
  void dispose() {
    // Dispose passenger controllers
    _passengerNameController.dispose();
    _passengerPhoneController.dispose();
    _passengerPasswordController.dispose();

    // Dispose driver controllers
    _driverNameController.dispose();
    _driverPhoneController.dispose();
    _driverPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              spacing: 20.h,
              children: [
                const LogoWithBackButton(),
                DriverAndPassengerToggleWidget(
                  initialIsPassenger: _isPassenger,
                  onRoleChanged: (isPassenger) {
                    setState(() {
                      _isPassenger = isPassenger;
                    });
                  },
                ),
                SizedBox(height: 10.h),
                ProfileImagePicker(
                  onImageSelected: (image) {
                    _profileImage = image;
                  },
                ),
                SizedBox(height: 10.h),
                // Conditionally show passenger or driver form
                if (_isPassenger)
                  RegisterPassengerFormWidget(
                    nameController: _passengerNameController,
                    phoneController: _passengerPhoneController,
                    passwordController: _passengerPasswordController,
                    onSubmit: () {
                      // Handle passenger registration
                    },
                  )
                else
                  RegisterDriverFormWidget(
                    nameController: _driverNameController,
                    phoneController: _driverPhoneController,
                    passwordController: _driverPasswordController,
                    onIdImageSelected: (image) => _idImage = image,
                    onLicenseImageSelected: (image) => _licenseImage = image,
                    onCarImageSelected: (image) => _carImage = image,
                    onSubmit: () {
                      // Handle driver registration
                    },
                  ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
