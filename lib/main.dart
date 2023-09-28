// ignore_for_file: sized_box_for_whitespace, unused_local_variable, unused_import, unused_element

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

List<CameraDescription>? cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple.withOpacity(0.4)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController? controller;

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    controller = CameraController(cameras![0], ResolutionPreset.medium);
    controller!.initialize();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<String> saveImage() async {
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    String filePath = '/storage/emulated/0/Pictures/$timeStamp.jpg';

    if (controller!.value.isTakingPicture) return 'null';
    try {
      await controller!.takePicture();
    } on CameraException catch (e) {
      showInSnackBar(e.toString());
    }

    return filePath;
  }

  void takePicture() async {
    saveImage().then((String filePath) {
      if (mounted) {
        showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
  // void _showUrl() {
  //   _launchUrl('https://github.com/Bijosabu');
  // }

  // void _showEmail() {
  //   _launchUrl('mailto:bijosabu123@gmail.com');
  // }

  // void _showSms() {
  //   _launchUrl('sms:9495436983');
  // }

  // void _showTel() {
  //   _launchUrl('tel:9495436983');
  // }

  // void _launchUrl(String urlString) async {
  //   if (await canLaunchUrl(Uri.parse(urlString))) {
  //     await launchUrl(Uri.parse(urlString));
  //   } else {
  //     throw 'Could not launch Url';
  //   }
  // }

  // SizedBox sizedBox = const SizedBox(
  //   height: 20,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission module'),
      ),
      body: SafeArea(
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 20,
            ),
            CommonListTile(
              onTap: () async {
                PermissionStatus cameraStatus =
                    await Permission.camera.request();
                if (cameraStatus.isGranted) {
                  if (mounted) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return OpenCamera(
                          controller: controller!,
                          onPressed: () {
                            takePicture();
                          },
                        );
                      },
                    ));
                  }
                }
                if (cameraStatus.isDenied) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Permission is required')));
                  }
                }
                if (cameraStatus.isPermanentlyDenied) {
                  openAppSettings();
                }
              },
              whichPermission: 'Take Picture',
              whichIcon: Icons.camera,
            ),
            const SizedBox(
              height: 20,
            ),
            CommonListTile(
              onTap: () {},
              whichPermission: 'Audio Permission',
              whichIcon: Icons.audio_file,
            ),
            const SizedBox(
              height: 20,
            ),
            CommonListTile(
              onTap: () async {
                PermissionStatus contactsStatus =
                    await Permission.contacts.request();
                if (contactsStatus.isGranted) {}
                if (contactsStatus.isDenied) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Permission is required')));
                  }
                }
                if (contactsStatus.isPermanentlyDenied) {
                  openAppSettings();
                }
              },
              whichPermission: 'Contacts Permission',
              whichIcon: Icons.storage,
            ),
            const SizedBox(
              height: 20,
            ),
            CommonListTile(
              onTap: () async {
                Map<Permission, PermissionStatus> status = await [
                  Permission.camera,
                  Permission.microphone,
                ].request();
                if (kDebugMode) {
                  print(status);
                }
              },
              whichPermission: 'All permission',
              whichIcon: Icons.request_page,
            ),
          ]),
        ),
      ),
    );
  }
}

class CommonListTile extends StatelessWidget {
  final Function()? onTap;
  final IconData whichIcon;
  final String whichPermission;
  const CommonListTile({
    super.key,
    required this.whichPermission,
    required this.whichIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        child: Icon(whichIcon),
      ),
      title: Text(whichPermission),
      subtitle: const Text('Grant permission'),
    );
  }
}

class OpenCamera extends StatelessWidget {
  final Function()? onPressed;
  final CameraController controller;
  const OpenCamera({super.key, required this.controller, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: onPressed, child: const Text('Take picture')),
              ],
            ),
            AspectRatio(
              aspectRatio: 1.0,
              child: CameraPreview(controller),
            )
          ],
        ),
      ),
    );
  }
}
