import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          lockAspectRatio: true, // keeps square
          hideBottomControls: false, // shows zoom and rotate
          initAspectRatio: CropAspectRatioPreset.square,
          cropFrameStrokeWidth: 2,
          cropGridStrokeWidth: 1,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true, // keeps square
          rotateButtonsHidden: false, // allow rotation
          resetButtonHidden: false, // allow reset
        ),
      ],
    );

    if (croppedFile != null) {
      return XFile(croppedFile.path);
    }
    return null;
  }