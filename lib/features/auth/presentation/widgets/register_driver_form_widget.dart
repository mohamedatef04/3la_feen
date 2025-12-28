import 'dart:io';

import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/core/utils/validator.dart';
import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/auth/presentation/cubits/register_cubit/cubit/register_cubit.dart';
import 'package:ala_feen/features/auth/presentation/screens/success_registration_view.dart';
import 'package:ala_feen/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/auth/presentation/widgets/driver_image_picker.dart';
import 'package:ala_feen/features/auth/presentation/widgets/image_upload_field.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterDriverFormWidget extends StatefulWidget {
  const RegisterDriverFormWidget({
    super.key,
  });

  @override
  State<RegisterDriverFormWidget> createState() =>
      _RegisterDriverFormWidgetState();
}

class _RegisterDriverFormWidgetState extends State<RegisterDriverFormWidget> {
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _driverPhoneController = TextEditingController();
  final TextEditingController _driverEmailController = TextEditingController();
  final TextEditingController _driverPasswordController =
      TextEditingController();
  GlobalKey<FormState> driverFormKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  File? _profileImage;
  File? _personalIdCard;
  File? _licenseImage;
  File? _carImage;

  @override
  void dispose() {
    _driverNameController.dispose();
    _driverPhoneController.dispose();
    _driverEmailController.dispose();
    _driverPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: driverFormKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Driver Profile Image Picker
          FadeInDown(
            delay: const Duration(milliseconds: 100),
            child: DriverImagePicker(
              onImageSelected: (image) {
                _profileImage = image;
              },
            ),
          ),
          // Name and Phone Fields
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FadeInRight(
                  delay: const Duration(milliseconds: 200),
                  child: _buildFieldWithHeader(
                    context: context,
                    headerText: AppStrings.fullName,
                    hintText: 'أدخل ${AppStrings.fullName}',
                    icon: Icons.person_outline,
                    controller: _driverNameController,
                    validator: Validator.validateName,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: FadeInLeft(
                  delay: const Duration(milliseconds: 400),
                  child: _buildFieldWithHeader(
                    context: context,
                    headerText: AppStrings.phoneNumber,
                    hintText: 'أدخل ${AppStrings.phoneNumber}',
                    icon: Icons.phone_outlined,
                    controller: _driverPhoneController,
                    keyboardType: TextInputType.number,
                    validator: Validator.validatePhone,
                  ),
                ),
              ),
            ],
          ),
          // Email and Password Fields
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FadeInRight(
                  delay: const Duration(milliseconds: 600),
                  child: _buildFieldWithHeader(
                    context: context,
                    headerText: AppStrings.email,
                    hintText: 'أدخل ${AppStrings.email}',
                    icon: Icons.email_outlined,
                    controller: _driverEmailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validator.validateEmail,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: FadeInLeft(
                  delay: const Duration(milliseconds: 800),
                  child: _buildFieldWithHeader(
                    context: context,
                    headerText: AppStrings.password,
                    hintText: 'أدخل ${AppStrings.password}',
                    icon: Icons.lock_outline,
                    controller: _driverPasswordController,
                    obscureText: true,
                    validator: Validator.validatePassword,
                  ),
                ),
              ),
            ],
          ),
          FadeInLeft(
            delay: const Duration(milliseconds: 1000),
            child: ImageUploadField(
              label: AppStrings.personalIdCard,
              onImageSelected: (image) {
                _personalIdCard = image;
              },
            ),
          ),
          // License and Car Image Fields
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FadeInRight(
                  delay: const Duration(milliseconds: 1200),
                  child: ImageUploadField(
                    label: AppStrings.licenseImage,
                    onImageSelected: (image) {
                      _licenseImage = image;
                    },
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: FadeInLeft(
                  delay: const Duration(milliseconds: 1400),
                  child: ImageUploadField(
                    label: AppStrings.carImage,
                    onImageSelected: (image) {
                      _carImage = image;
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          // Submit Button
          BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                GoRouter.of(context).go(SuccessRegistrationView.routeName);
              } else if (state is RegisterError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    duration: const Duration(seconds: 10),
                  ),
                );
              }
            },
            builder: (context, state) {
              return FadeInUp(
                delay: const Duration(milliseconds: 1600),
                child: CustomButtonWidget(
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    if (driverFormKey.currentState!.validate()) {
                      if (_personalIdCard == null ||
                          _licenseImage == null ||
                          _carImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('يرجى تحميل جميع الصور المطلوبة'),
                          ),
                        );
                        return;
                      }

                      context.read<RegisterCubit>().registerUser(
                        user: UserModel(
                          name: _driverNameController.text.trim(),
                          email: _driverEmailController.text.trim(),
                          phone: _driverPhoneController.text.trim(),
                          password: _driverPasswordController.text.trim(),
                          role: 'driver',
                        ),
                        profilePic: _profileImage,
                        cardIdPic: _personalIdCard,
                        licensePic: _licenseImage,
                        carPic: _carImage,
                      );
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.onUserInteraction;
                      });
                    }
                  },
                  child: state is RegisterLoading
                      ? const CupertinoActivityIndicator(color: AppColors.white)
                      : Text(
                          AppStrings.send,
                          style: AppTextStyles.bold16(context),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFieldWithHeader({
    required BuildContext context,
    required String headerText,
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headerText,
          style: AppTextStyles.bold14(context).copyWith(
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextFormField(
          controller: controller,
          hintText: hintText,
          prefixIcon: Icon(icon),
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
        ),
      ],
    );
  }
}
