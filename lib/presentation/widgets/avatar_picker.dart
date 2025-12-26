import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';

typedef AvatarChanged = void Function(File image);

class AvatarPicker extends StatefulWidget {
  final String? currentPath;
  final AvatarChanged onChanged;

  const AvatarPicker({super.key, required this.onChanged, this.currentPath});

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _selectedFile = File(file.path);
      });
      widget.onChanged(_selectedFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayPath = _selectedFile?.path ?? widget.currentPath;
    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundColor: ColorsManager.primary.withOpacity(0.1),
          backgroundImage: displayPath != null
              ? FileImage(File(displayPath))
              : null,
          child: displayPath == null
              ? Icon(Icons.person, size: 50.sp, color: ColorsManager.primary)
              : null,
        ),
        SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(
            Icons.camera_alt_outlined,
            color: ColorsManager.primary,
          ),
          label: Text(
            'Change photo',
            style: TextStyles.body.copyWith(
              color: ColorsManager.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: ColorsManager.primary.withOpacity(0.4)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ],
    );
  }
}
