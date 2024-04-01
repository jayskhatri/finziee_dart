import 'package:flutter/material.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=1380&t=st=1711450325~exp=1711450925~hmac=1bca85493249bbc30bfded5fec7da5151b7a3e0b78262b16648761781cf095a0'),
              ),
              accountName: Text('John Doe'),
              accountEmail: Text('johndoe@aayatmedia.tech'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: (){
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
              ListTile(
                leading: const Icon(Icons.monetization_on),
                title: const Text('Transactions'),
                onTap: (){
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/transactions');
                },
              ),
              ListTile(
                leading: const Icon(Icons.autorenew_rounded),
                title: const Text('Recurrings'),
                onTap: (){},
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Categories'),
                onTap: (){
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/categories');
                },
              ),
              const Divider(color: Colors.black87),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              )]
      ),
    ));
  }
}