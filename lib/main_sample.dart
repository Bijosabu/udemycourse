// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme:
//             ColorScheme.fromSeed(seedColor: Colors.deepPurple.withOpacity(0.4)),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class AnimatedLogo extends AnimatedWidget {
//   const AnimatedLogo({super.key, required Animation<double> animation})
//       : super(listenable: animation);
//   static final opacityTween = Tween(begin: 0.1, end: 1.0);
//   static final sizeTween = Tween(begin: 0.0, end: 300);
//   static final rotateTween = Tween(begin: 0.0, end: 12.0);
//   @override
//   Widget build(BuildContext context) {
//     final Animation<double> animation = listenable as Animation<double>;
//     return Center(
//       child: Transform.rotate(
//         angle: rotateTween.evaluate(animation),
//         child: Opacity(
//             opacity: opacityTween.evaluate(animation),
//             child: Container(
//               height: sizeTween.evaluate(animation).toDouble(),
//               width: sizeTween.evaluate(animation).toDouble(),
//               child: const FlutterLogo(
//                 size: 300,
//               ),
//             )),
//       ),
//     );
//   }
// }

// class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//   Animation<double>? animation;
//   AnimationController? controller;
//   bool showWelcomeText = false;
//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//         duration: const Duration(milliseconds: 2000), vsync: this);
//     final CurvedAnimation curve =
//         CurvedAnimation(parent: controller!, curve: Curves.easeIn);
//     animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn);
//     // animation = Tween(begin: 0.0, end: 300.0).animate(curve);
//     // animation!.addStatusListener(listener);
//     // animation!.addListener(() {
//     //   setState(() {
//     //     if (animation!.value >= 150) {
//     //       showWelcomeText = true;
//     //     }
//     //   });
//     // });
//     controller!.forward();
//   }

//   void listener(AnimationStatus status) {
//     if (animation!.isCompleted) {
//       controller!.reverse();
//     } else if (animation!.isDismissed) {
//       controller!.forward();
//     }
//   }

//   @override
//   void dispose() {
//     controller!.dispose();
//     super.dispose();
//   }

//   // Widget builder() {
//   //   return Container(
//   //     height: animation!.value,
//   //     width: animation!.value,
//   //     child: const FlutterLogo(
//   //       size: 300,
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(
//                 height: 20,
//               ),
//               const Text(
//                 'Hello',
//                 style: TextStyle(fontSize: 24),
//               ),
//               Container(
//                   padding: const EdgeInsets.all(32.0),
//                   child: AnimatedLogo(animation: animation!)),

//               // if (showWelcomeText)
//               //   const Center(
//               //     child: Text(
//               //       'Welcome to Flutter',
//               //       style: TextStyle(
//               //         fontSize: 24,
//               //         color: Colors.blue,
//               //       ),
//               //     ),
//               //   )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
