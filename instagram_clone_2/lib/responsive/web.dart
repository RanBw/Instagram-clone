import 'package:flutter/material.dart';
import 'package:instagram_clone_2/materials/colors.dart';
import 'package:instagram_clone_2/screens/addPost.dart';
import 'package:instagram_clone_2/screens/favorite.dart';
import 'package:instagram_clone_2/screens/home.dart';
import 'package:instagram_clone_2/screens/profile.dart';
import 'package:instagram_clone_2/screens/search.dart';
import 'package:flutter_svg/svg.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({super.key});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  final PageController _pageController = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/imgs/instagram.svg",
          width: 90,
          height: 40,
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: () {
                _pageController.jumpToPage(0);
              },
              icon: Icon(
                Icons.home,
                color: index == 0 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                _pageController.jumpToPage(1);
              },
              icon: Icon(
                Icons.search,
                color: index == 1 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                _pageController.jumpToPage(2);
              },
              icon: Icon(
                Icons.add_a_photo,
                color: index == 2 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                _pageController.jumpToPage(3);
              },
              icon: Icon(
                Icons.favorite,
                color: index == 3 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                _pageController.jumpToPage(4);
              },
              icon: Icon(
                Icons.person,
                color: index == 4 ? primaryColor : secondaryColor,
              )),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (indx) {
          setState(() {
            index = indx;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          SearchPage(),
          AddPost(),
          Favorite(),
          ProfilePage()
        ],
      ),
    );
  }
}
