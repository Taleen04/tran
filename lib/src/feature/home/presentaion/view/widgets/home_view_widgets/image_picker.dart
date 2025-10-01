// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ImagePickerExample extends StatefulWidget {
//   const ImagePickerExample({super.key});

//   @override
//   State<ImagePickerExample> createState() => _ImagePickerExampleState();
// }

// class _ImagePickerExampleState extends State<ImagePickerExample> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker(); 

//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Image Picker Example")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image == null
//                 ? const Text("ما في صورة مختارة")
//                 : Image.file(
//                     _image!,
//                     width: 200,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () => _pickImage(ImageSource.gallery),
//               icon: const Icon(Icons.photo),
//               label: const Text("اختر من المعرض"),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton.icon(
//               onPressed: () => _pickImage(ImageSource.camera),
//               icon: const Icon(Icons.camera_alt),
//               label: const Text("التقط صورة"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



