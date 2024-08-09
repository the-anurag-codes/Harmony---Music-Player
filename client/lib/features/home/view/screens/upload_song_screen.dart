import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_loader.dart';
import 'package:client/core/widgets/custom_textfield.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongScreen extends ConsumerStatefulWidget {
  const UploadSongScreen({super.key});

  @override
  ConsumerState<UploadSongScreen> createState() => _UploadSongScreenState();
}

class _UploadSongScreenState extends ConsumerState<UploadSongScreen> {
  final songNameController = TextEditingController();
  final artistNameController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedThumbnail;
  File? selectedSong;
  final _formKey = GlobalKey<FormState>();

  void selectSong() async {
    final pickedAudio = await pickAudio();

    if (pickedAudio != null) {
      setState(() {
        selectedSong = pickedAudio;
      });
    }
  }

  void selectThumbnail() async {
    final pickedImage = await pickThumbnail();

    if (pickedImage != null) {
      setState(() {
        selectedThumbnail = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    songNameController.dispose();
    artistNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        homeViewModelProvider.select((value) => value?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() &&
                    selectedSong != null &&
                    selectedThumbnail != null) {
                  ref.read(homeViewModelProvider.notifier).uploadSong(
                        selectedSong: selectedSong!,
                        selectedThumbnail: selectedThumbnail!,
                        songName: songNameController.text,
                        artist: artistNameController.text,
                        selectedColor: selectedColor,
                      );
                } else {
                  showSnackBar(context, 'Missing Fields!');
                }
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: isLoading
          ? const CustomLoader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectThumbnail,
                        child: selectedThumbnail != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    selectedThumbnail!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : DottedBorder(
                                color: Pallete.borderColor,
                                radius: const Radius.circular(10),
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                dashPattern: const [10, 4],
                                child: const SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Select the thumbnail for your song',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      selectedSong != null
                          ? AudioWaves(path: selectedSong!.path)
                          : CustomTextField(
                              hintText: 'Pick Song',
                              readOnly: true,
                              onTap: selectSong,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        hintText: 'Artist Name',
                        controller: artistNameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        hintText: 'Song Name',
                        controller: songNameController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ColorPicker(
                        color: selectedColor,
                        pickersEnabled: const {ColorPickerType.wheel: true},
                        onColorChanged: (Color color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        heading: const Text('Select Color'),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
