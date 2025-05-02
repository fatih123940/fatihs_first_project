import 'package:fatihs_first_project/services/auth.dart';
import 'package:fatihs_first_project/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/home_page.dart';

class OnBoardWidget extends StatelessWidget {
   OnBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context,listen: false);
    return StreamBuilder<User?>(stream: _auth.authStatus(), builder: (context,snapshot){
      if(snapshot.connectionState==ConnectionState.active){
       return snapshot.data != null ? HomePage():SignInPage();
      }else{
        return SizedBox(width: 300,height: 300,child: CircularProgressIndicator(),);
      }
    });
  }
}
