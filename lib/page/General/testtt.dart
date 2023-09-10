import 'package:flutter/material.dart';
import 'package:miniworldapp/page/General/RaceAll.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../Host/race_create.dart';



class NavigationBarApp2 extends StatefulWidget {
  const NavigationBarApp2({super.key});

  @override
  State<NavigationBarApp2> createState() => _NavigationBarApp2State();
}

class _NavigationBarApp2State extends State<NavigationBarApp2> {
  @override
  Widget build(BuildContext context) {
    int currentPageIndex = 0;
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentPageIndex,
        onTap: (i) => setState(() => currentPageIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.purple,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Likes"),
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Colors.red,
          alignment: Alignment.center,
          child: RaceAll(),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: RaceCreatePage(),
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text('Page 3'),
        ),
         Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text('Page 3'),
        ),
      ][currentPageIndex],
    );
  }
}

// class NavigationBarApp extends StatelessWidget {
//   const NavigationBarApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: NavigationExample());
//   }
// }

// class NavigationExample extends StatefulWidget {
//   const NavigationExample({super.key});

//   @override
//   State<NavigationExample> createState() => _NavigationExampleState();
// }

// class _NavigationExampleState extends State<NavigationExample> {
//   int currentPageIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: SalomonBottomBar(
//         currentIndex: currentPageIndex,
//         onTap: (i) => setState(() => currentPageIndex = i),
//         items: [
//           /// Home
//           SalomonBottomBarItem(
//             icon: Icon(Icons.home),
//             title: Text("Home"),
//             selectedColor: Colors.purple,
//           ),

//           /// Likes
//           SalomonBottomBarItem(
//             icon: Icon(Icons.favorite_border),
//             title: Text("Likes"),
//             selectedColor: Colors.pink,
//           ),

//           /// Search
//           SalomonBottomBarItem(
//             icon: Icon(Icons.search),
//             title: Text("Search"),
//             selectedColor: Colors.orange,
//           ),

//           /// Profile
//           SalomonBottomBarItem(
//             icon: Icon(Icons.person),
//             title: Text("Profile"),
//             selectedColor: Colors.teal,
//           ),
//         ],
//       ),
//       body: <Widget>[
//         Container(
//           color: Colors.red,
//           alignment: Alignment.center,
//           child: RaceAll(),
//         ),
//         Container(
//           color: Colors.green,
//           alignment: Alignment.center,
//           child: RaceCreatePage(),
//         ),
//         Container(
//           color: Colors.blue,
//           alignment: Alignment.center,
//           child: const Text('Page 3'),
//         ),
//          Container(
//           color: Colors.blue,
//           alignment: Alignment.center,
//           child: const Text('Page 3'),
//         ),
//       ][currentPageIndex],
//     );
//   }
// }
