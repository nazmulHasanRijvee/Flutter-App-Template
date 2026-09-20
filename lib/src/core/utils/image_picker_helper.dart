// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ImagePickerHelper {
//   static final ImagePicker _picker = ImagePicker();

//   static Future<XFile?> pickImage(ImageSource source) async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: source,
//         imageQuality: 80,
//       );
//       return image;
//     } catch (e) {
//       debugPrint("Error picking image: $e");
//       return null;
//     }
//   }

//   static Future<XFile?> showImageSourceSheet(BuildContext context) async {
//     XFile? pickedFile;
//     await showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Camera'),
//                 onTap: () async {
//                   pickedFile = await pickImage(ImageSource.camera);
//                   if (context.mounted) Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Gallery'),
//                 onTap: () async {
//                   pickedFile = await pickImage(ImageSource.gallery);
//                   if (context.mounted) Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//     return pickedFile;
//   }
// }
