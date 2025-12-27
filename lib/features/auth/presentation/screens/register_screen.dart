import 'dart:io';
import 'package:ala_feen/features/auth/presentation/screens/registration_success_screen.dart';
import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/auth/presentation/widgets/driver_and_passenger_toggle_widget.dart';
import 'package:ala_feen/features/auth/presentation/widgets/image_upload_field.dart';
import 'package:ala_feen/features/auth/presentation/widgets/logo_with_back_button.dart';
import 'package:ala_feen/features/auth/presentation/widgets/profile_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPassenger = false;
  File? profileImage;
  File? idImage;
  File? licenseImage;
  File? carImage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                const LogoWithBackButton(),
                SizedBox(height: 20.h),
                DriverAndPassengerToggleWidget(
                  onRoleChanged: (val) {
                    setState(() {
                      isPassenger = val;
                    });
                  },
                ),
                SizedBox(height: 30.h),
                ProfileImagePicker(
                  onImageSelected: (image) {
                    profileImage = image;
                  },
                ),
                SizedBox(height: 30.h),
                CustomTextFormField(
                  controller: nameController,
                  hintText: AppStrings.fullName,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                SizedBox(height: 16.h),
                CustomTextFormField(
                  controller: phoneController,
                  hintText: AppStrings.phoneNumber,
                  prefixIcon: const Icon(Icons.phone_android_outlined),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16.h),
                if (!isPassenger) ...[
                  ImageUploadField(
                    label: AppStrings.personalIdCard,
                    onImageSelected: (image) => idImage = image,
                  ),
                  ImageUploadField(
                    label: AppStrings.licenseImage,
                    onImageSelected: (image) => licenseImage = image,
                  ),
                  ImageUploadField(
                    label: AppStrings.carImage,
                    onImageSelected: (image) => carImage = image,
                  ),
                ],
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(RegistrationSuccessScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: Text(
                      AppStrings.send,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
