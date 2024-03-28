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
            UserAccountsDrawerHeader(
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
                leading: Icon(Icons.monetization_on),
                title: Text('Transactions'),
                onTap: (){},
              ),
              ListTile(
                leading: Icon(Icons.autorenew_rounded),
                title: Text('Recurrings'),
                onTap: (){},
              ),
              ListTile(
                leading: Icon(Icons.category),
                title: Text('Categories'),
                onTap: (){},
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: (){},
              )]
      ),
    ));
  }
}