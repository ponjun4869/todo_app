import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/top_page.dart';

void main() async{
  //main関数にasync awaitをそのまま使うことはできないので、以下の処理を記述
  WidgetsFlutterBinding.ensureInitialized();
  //Firebaseの初期化
  //初期化してからrunAPPしたいのでasync awaitする
  await Firebase.initializeApp();
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //デバッグバナーを非表示に
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const TopPage(title: 'Flutter Demo Home Page'),
    );
  }
}

//todo FlutterとFirebaseを連携（iOS後で）

