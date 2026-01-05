import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orderplus/domain/utils/crop_image.dart';
import 'package:orderplus/ui/widget/cards/flexible_image.dart';

class ImageUploadArea extends StatelessWidget {
  final String? imagePath;
  final Function(String) onImageSelected;

  const ImageUploadArea({
    super.key,
    this.imagePath,
    required this.onImageSelected,
  });

  Future<void> _showImagePickerOptions(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    final croppedFile = await cropImage(image.path);
                    if (croppedFile != null) {
                      onImageSelected(croppedFile.path);
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    final croppedFile = await cropImage(image.path);
                    if (croppedFile != null) {
                      onImageSelected(croppedFile.path);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePickerOptions(context),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: imagePath == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap to add an image",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  FlexibleImage(imagePath: imagePath!, fit: BoxFit.contain),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: ElevatedButton(
                      onPressed: () => _showImagePickerOptions(context),
                      child: const Text("Change"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
