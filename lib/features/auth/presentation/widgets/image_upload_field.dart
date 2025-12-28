import 'dart:io';
import 'package:ala_feen/core/theme/app_colors.dart';
import 'package:ala_feen/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadField extends StatefulWidget {
  const ImageUploadField({
    super.key,
    required this.label,
    required this.onImageSelected,
  });

  final String label;
  final Function(File? image) onImageSelected;

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  File? _image;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      widget.onImageSelected(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.bold14(context).copyWith(
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 100.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 213, 213, 232),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1,
              ),
              image: _image != null
                  ? DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _image == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        color: AppColors.primary.withOpacity(0.6),
                        size: 30.sp,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'حمل الصورة',
                        style: TextStyle(
                          color: AppColors.primary.withOpacity(0.6),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _image = null;
                          });
                          widget.onImageSelected(null);
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
