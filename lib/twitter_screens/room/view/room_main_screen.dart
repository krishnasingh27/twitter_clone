import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/twitter_screens/home/view/home_main_screen_duplicate.dart';
import 'package:twitter_clone/twitter_screens/login_screen/view/login_screen.dart';
import 'package:twitter_clone/twitter_screens/messages/view/message_main_screen.dart';
import 'package:twitter_clone/twitter_screens/notification/view/notification_main_screen.dart';
import 'package:twitter_clone/twitter_screens/profile/view/profile_screen.dart';
import 'package:twitter_clone/twitter_screens/search/view/search_main_screen.dart';

class RoomMainScreen extends StatefulWidget {
  const RoomMainScreen({super.key});

  @override
  State<RoomMainScreen> createState() => _RoomMainScreenState();
}

enum BottomNavigationIcons { home, search, bell, mail }

class _RoomMainScreenState extends State<RoomMainScreen> {
  BottomNavigationIcons selectedBottomNavigationIcons =
      BottomNavigationIcons.home;

  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreenWIdget()));
                  },
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/my_image.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Lists'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false);
                });
              },
            ),
            Divider(),
            Expanded(
                child: ListView(
              children: [
                for (int i = 0; i < 20; i++)
                  ListTile(
                    title: const Text('Profile'),
                    onTap: () {},
                  ),
                ListTile(
                  title: const Text('Lists'),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false);
                    });
                  },
                ),
              ],
            ))
          ],
        ),
      ),
      backgroundColor: Colors.blue,
      appBar: appBarView(),
      body: bodyItems[selectedBottomNavigationIcons],
      bottomNavigationBar: bottomNavBar(),
    );
  }

  PreferredSizeWidget appBarView() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: InkWell(
          onTap: () {
            _scaffoldkey.currentState?.openDrawer();
          },
          child: Container(
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("assets/my_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      title: Image.asset(
        "assets/twitter_logo.png",
        height: 27,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Image.asset(
            "assets/feature_icon.png",
            height: 25,
          ),
        )
      ],
      centerTitle: true,
    );
  }

  Map get bodyItems => {
        BottomNavigationIcons.home: const DuplicateHomeScreen(),
        BottomNavigationIcons.search: const SearchMainScreen(),
        BottomNavigationIcons.bell: const NoificationMainScreen(),
        BottomNavigationIcons.mail: const MessageMainScreen()
      };

  Widget bottomNavBar() {
    return Container(
      color: Colors.white,
      height: 50,
      width: double.infinity,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  selectedBottomNavigationIcons = BottomNavigationIcons.home;
                });
              },
              icon: Image.asset(
                selectedBottomNavigationIcons == BottomNavigationIcons.home
                    ? "assets/room_icons/solid_home_icon.png"
                    : "assets/room_icons/home_icon.png",
                height: 22,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  selectedBottomNavigationIcons = BottomNavigationIcons.search;
                });
              },
              icon: Image.asset(
                selectedBottomNavigationIcons == BottomNavigationIcons.search
                    ? "assets/room_icons/solid_search_icon.png"
                    : "assets/room_icons/search_icon.png",
                height: 22,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  selectedBottomNavigationIcons = BottomNavigationIcons.bell;
                });
              },
              icon: Image.asset(
                selectedBottomNavigationIcons == BottomNavigationIcons.bell
                    ? "assets/room_icons/solid_bell_icon.png"
                    : "assets/room_icons/bell_icon.png",
                height: 22,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  selectedBottomNavigationIcons = BottomNavigationIcons.mail;
                });
              },
              icon: Image.asset(
                selectedBottomNavigationIcons == BottomNavigationIcons.mail
                    ? "assets/room_icons/solid_mail_icon.png"
                    : "assets/room_icons/mail_icon.png",
                height: 22,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
