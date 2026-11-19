import 'dart:io';
import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:ala_feen/core/utils/app_strings.dart';
import 'package:ala_feen/core/utils/validator.dart';
import 'package:ala_feen/features/auth/data/models/user_model.dart';
import 'package:ala_feen/features/auth/presentation/cubits/register_cubit/cubit/register_cubit.dart';
import 'package:ala_feen/features/auth/presentation/screens/success_registration_view.dart';
import 'package:ala_feen/features/auth/presentation/widgets/shared_widgets/custom_text_form_field.dart';
import 'package:ala_feen/features/auth/presentation/widgets/register_widgets/passenger_image_picker.dart';
import 'package:ala_feen/features/get_started/widgets/custom_button_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ala_feen/core/functions/show_snack_bar.dart';

class RegisterPassengerFormWidget extends StatefulWidget {
  const RegisterPassengerFormWidget({
    super.key,
  });

  @override
  State<RegisterPassengerFormWidget> createState() =>
      _RegisterPassengerFormWidgetState();
}

class _RegisterPassengerFormWidgetState
    extends State<RegisterPassengerFormWidget> {
  final TextEditingController _passengerNameController =
      TextEditingController();
  final TextEditingController _passengerPhoneController =
      TextEditingController();
  final TextEditingController _passengerEmailController =
      TextEditingController();
  final TextEditingController _passengerPasswordController =
      TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> passengerFormKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;

  File? _profileImage;

  @override
  void dispose() {
    _passengerNameController.dispose();
    _passengerPhoneController.dispose();
    _passengerEmailController.dispose();
    _passengerPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: passengerFormKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Passenger Profile Image Picker
          FadeInDown(
            delay: const Duration(milliseconds: 100),
            child: PassengerImagePicker(
              onImageSelected: (image) {
                _profileImage = image;
              },
            ),
          ),
          // Name Field
          FadeInRight(
            delay: const Duration(milliseconds: 200),
            child: _buildFieldWithHeader(
              context: context,
              headerText: AppStrings.fullName,
              hintText: AppStrings.enterField(AppStrings.fullName),
              icon: Icons.person_outline,
              controller: _passengerNameController,
              validator: Validator.validateName,
            ),
          ),
          // Phone Field
          FadeInRight(
            delay: const Duration(milliseconds: 400),
            child: _buildFieldWithHeader(
              context: context,
              headerText: AppStrings.phoneNumber,
              hintText: AppStrings.enterField(AppStrings.phoneNumber),
              icon: Icons.phone_outlined,
              controller: _passengerPhoneController,
              keyboardType: TextInputType.number,
              validator: Validator.validatePhone,
            ),
          ),
          FadeInRight(
            delay: const Duration(milliseconds: 600),
            child: _buildFieldWithHeader(
              context: context,
              headerText: AppStrings.email,
              hintText: AppStrings.enterField(AppStrings.email),
              icon: Icons.email_outlined,
              controller: _passengerEmailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validator.validateEmail,
            ),
          ),
          // Password Field
          FadeInRight(
            delay: const Duration(milliseconds: 800),
            child: _buildFieldWithHeader(
              context: context,
              headerText: AppStrings.password,
              hintText: AppStrings.enterField(AppStrings.password),
              icon: Icons.lock_outline,
              controller: _passengerPasswordController,
              obscureText: _isPasswordVisible,
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              validator: Validator.validatePassword,
            ),
          ),
          SizedBox(height: 15.h),

          // Submit Button
          BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                GoRouter.of(context).go(SuccessRegistrationView.routeName);
              } else if (state is RegisterError) {
                showCustomSnackBar(context, state.errorMessage, isError: true);
              }
            },
            builder: (context, state) {
              return FadeInRight(
                delay: const Duration(milliseconds: 1000),
                child: CustomButtonWidget(
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    if (passengerFormKey.currentState!.validate()) {
                      passengerFormKey.currentState!.save();
                      if (_profileImage == null) {
                        showCustomSnackBar(
                          context,
                          AppStrings.pleaseSelectProfileImage,
                          isError: true,
                        );
                        return;
                      }

                      context.read<RegisterCubit>().registerUser(
                        user: UserModel(
                          name: _passengerNameController.text.trim(),
                          email: _passengerEmailController.text.trim(),
                          phone: _passengerPhoneController.text.trim(),
                          password: _passengerPasswordController.text.trim(),
                          role: 'passenger',
                        ),
                        profilePic: _profileImage,
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
    Widget? suffixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return FadeInUp(
      child: Column(
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
            suffixIcon: suffixIcon,
          ),
        ],
      ),
    );
  }
}
