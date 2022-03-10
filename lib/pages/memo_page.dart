import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MemoPage extends StatelessWidget {
  //メモページに来る際にメモ型の値を送ってくるようにする
  final QueryDocumentSnapshot? memo;
  //そのメモのデータを使うよー
  // ignore: use_key_in_widget_constructors
  const MemoPage(this.memo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(memo?.get('title')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Text('メモ内容', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(memo?.get('detail'), style: const TextStyle(fontSize: 18))
          ],
        ),
      ),
    );
  }
}