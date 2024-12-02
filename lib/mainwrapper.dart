import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nested_persistance_navigation/navigations/updates_navigation.dart';
import 'package:flutter_nested_persistance_navigation/navigations/wishlists_navigation.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  MainWrapperState createState() => MainWrapperState();
}

class MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    wishListNavigatorKey,
    updatesNavigatorKey,
  ];

  Future<bool> _systemBackButtonPressed() async {
  if (_navigatorKeys[_selectedIndex].currentState?.canPop() == true) {
    _navigatorKeys[_selectedIndex]
        .currentState
        ?.pop(_navigatorKeys[_selectedIndex].currentContext);
    return false;
  } else {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you really want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop'),
            child: Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _systemBackButtonPressed,
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedIndex: _selectedIndex,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.favorite),
              icon: Icon(Icons.favorite_border),
              label: 'Wishlist',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.notifications),
              icon: Icon(Icons.notifications_none),
              label: 'Updates',
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _selectedIndex,
            children: const <Widget>[
              /// First Route
              Wishlist(),

              /// Second Route
              UpdatesNavigator(),
            ],
          ),
        ),
      ),
    );
  }
}
