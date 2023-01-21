import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:http/http.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  VideoPlayerController? videoPlayerController;
  CustomVideoPlayerController? _customVideoPlayerController;
  bool isImage = true;

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    log(ref.toString());

    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    log('Download Link:$urlDownload');
    videoPlayerController = VideoPlayerController.network(urlDownload)
      ..initialize().then((_) {
        log(videoPlayerController.toString());
        _customVideoPlayerController = CustomVideoPlayerController(
          context: context,
          videoPlayerController: videoPlayerController!,
        );
        Image.file(File(pickedFile!.path!));
        setState(() {});
      });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    var stname;
    if (result == null) return;
    pickedFile = result.files.single;
    //stname = pickedFile.toString()+;
    log(result.files.single.toString());
    log(pickedFile!.extension.toString());
    if (pickedFile!.extension == 'jpg' || pickedFile!.extension == 'png') {
      setState(() {
        isImage = true;
      });
    } else {
      isImage = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: ListView(
        children: [
          if (pickedFile != null)
            ////

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isImage == true
                    ? Image.file(
                        File(pickedFile!.path!),
                        width: size.width * 0.8,
                      )
                    : (_customVideoPlayerController != null)
                        ? CustomVideoPlayer(
                            customVideoPlayerController:
                                _customVideoPlayerController!)
                        : Container(),
                Text(pickedFile!.name),
              ],
            ),
          ElevatedButton(
            onPressed: selectFile,
            child: const Text('Select File'),
          ),
          const SizedBox(height: 2),
          buildProgress(),
          ElevatedButton(
            onPressed: uploadFile,
            child: const Text('Upload File'),
          ),
        ],
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox(height: 50);
        }
      });
}
