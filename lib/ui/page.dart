import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class PageWidget extends StatelessWidget {
  final Widget child;

  const PageWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.menu),
              color: Colors.black,
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('Reset token'),
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 0) {
                  await GetIt.instance.get<YubikitOpenPGP>().reset();
                }
              }),
        ],
      ),
      body: SafeArea(
          child:
              child), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}