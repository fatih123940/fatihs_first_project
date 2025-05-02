
import 'package:fatihs_first_project/widgets/on_board_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/auth.dart';

void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FirebaseAuthApp());
}

class FirebaseAuthApp extends StatelessWidget {
  const FirebaseAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<Auth>(

      create: (BuildContext context) => Auth() ,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OnBoardWidget(),
      ),
    );
  }
}
