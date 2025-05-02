import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
enum FormStatus {signIn, register, reset}
class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({super.key});

  @override
  State<EmailSignInPage> createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  final  _signInFormKey = GlobalKey<FormState>();
  final  _registerFormKey=GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();
  FormStatus _formStatus = FormStatus.signIn;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _formStatus==FormStatus.signIn?buildSignInForm():
        _formStatus==FormStatus.register?

        buildRegisterForm():buildResetPasswordForm(),
      ),
    );
  }

  Widget buildSignInForm() {
   TextEditingController emailCtr = TextEditingController();
   TextEditingController passwordCtr= TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
          key: _signInFormKey,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text('Lütfen Giriş Yapınız',style: TextStyle(fontSize: 25),),
          TextFormField(
            controller: emailCtr,
            validator: (value){
              if(!EmailValidator.validate(value!)){
                return 'Lütfen geçerli bir email adresi giriniz';
              }else{
                return null;
              }


            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'E-mail',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
          SizedBox(height: 10,),
          TextFormField(
            controller: passwordCtr,
            validator: (value){
              if(value!.length<6){
                return 'Şifre en az 6 karakter olmalıdır';
              }else {
                return null;
              }
            },
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Şifre',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
          SizedBox(height: 10,),
          ElevatedButton(onPressed: ()async{
            if(_signInFormKey.currentState!.validate()) {
              final user =await Provider.of<Auth>(context, listen: false)
                  .signInWithEmailAndPassword(emailCtr.text, passwordCtr.text);

              if(!user.emailVerified){
                await _showMyDialog();
                await Provider.of<Auth>(context,listen: false).signOut();
              }
              Navigator.pop(context);
            }
          }, child: Text('Giriş')),
          TextButton(onPressed: (){
            setState(() {
              _formStatus=FormStatus.register;
            });
          }, child: Text('Hesabınız yok mu ? Kayıt olun')),
            TextButton(onPressed: (){
              setState(() {
                _formStatus=FormStatus.reset;
              });
            }, child: Text('Şifremi Unuttum')),
        ],)),
    );
  }
  Widget buildResetPasswordForm() {
    TextEditingController _emailCtr = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
          key: _resetFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Şifre Yenileme',style: TextStyle(fontSize: 25),),
              TextFormField(
                controller: _emailCtr,
                validator: (value){
                  if(!EmailValidator.validate(value!)){
                    return 'Lütfen geçerli bir email adresi giriniz';
                  }else{
                    return null;
                  }


                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: ()async{
                if(_resetFormKey.currentState!.validate()) {
                  await Provider.of<Auth>(context, listen: false)
                      .sendPasswordResetEmail(_emailCtr.text);


                    await _showResetPasswordDialog();


                  Navigator.pop(context);
                }
              }, child: Text('Gönder')),

            ],)),
    );
  }
  Widget buildRegisterForm() {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _passwordConfirmController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
          key: _registerFormKey,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Kayıt Formu',style: TextStyle(fontSize: 25),),
          TextFormField(
            controller: _emailController,
            validator: (value){
              if(!EmailValidator.validate(value!)){
                return 'Lütfen geçerli bir email adresi giriniz';
              }else{
                return null;
              }


            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'E-mail',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 10,),
          TextFormField(
            controller: _passwordController,
            validator: (value){
              if(value!.length<6){
                return 'Şifreniz en az 6 haneli olmalıdır';
              }else {
                return null;
              }
            },
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Şifre',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
          SizedBox(height: 10,),
          TextFormField(
            controller: _passwordConfirmController,
            validator: (value){
              if(value!=_passwordController.text){
                return 'Şifreler uyuşmuyor';
              }else {
                return null;
              }
            },
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Şifre Onay',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
          SizedBox(height: 10,),
          ElevatedButton(onPressed: ()async{
            if(_registerFormKey.currentState!.validate()) {
              final user = await Provider.of<Auth>(context, listen: false)
                  .createUserEmailAndPassword(
                  _emailController.text, _passwordController.text);
              if(!user.emailVerified){
                await user.sendEmailVerification();
              }
              await _showMyDialog();
              await Provider.of<Auth>(context,listen: false).signOut();
              setState(() {
                _formStatus=FormStatus.signIn;
              });
            }
          }, child: Text('Kayıt')),
          TextButton(onPressed: (){
            setState(() {
              _formStatus=FormStatus.signIn;
            });
          }, child: Text('Zaten üye misiniz ? Giriş Yap')),
        ],)),
    );
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context)
    {
      return AlertDialog(
        title: const Text('ONAY GEREKİYOR'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Lütfen mailinizi kontrol ediniz'),
              Text('Emailinizi onaylayıp işleminize devam ediniz'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('ANLADIM'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );




    });}
  Future<void> _showResetPasswordDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: const Text('ŞİFRE YENİLEME'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Lütfen mailinizi kontrol ediniz'),
                  Text('Emailinize girin ve şifrenizi yenileyin'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('ANLADIM'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );




        });}

}
