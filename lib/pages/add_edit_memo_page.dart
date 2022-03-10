

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEditMemoPage extends StatefulWidget {
  final QueryDocumentSnapshot? memo;
  const AddEditMemoPage({Key? key, this.memo}) : super(key: key);


  @override
  State<AddEditMemoPage> createState() => _AddEditMemoPageState();
}

class _AddEditMemoPageState extends State<AddEditMemoPage> {
  //入力内容を司るコントローラー
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  //cloudfirestoreに追加する処理(時間のかかる処理)
  Future<void> addMemo() async {
    var collection = FirebaseFirestore.instance.collection('memo');
    await collection.add({
      'title': titleController.text,
      'detail': detailController.text,
      'created_date': Timestamp.now()
    });
  }

  //編集したメモを更新する
  Future<void> updateMemo() async {
    var document = FirebaseFirestore.instance.collection('memo').doc(widget.memo?.id);
    document.update({
      'title': titleController.text,
      'detail': detailController.text,
      'created_date': Timestamp.now()
    });
  }

  @override
  void initState() {
    super.initState();
    //編集画面だった場合、メモの内容の初期値を入れる
    if (widget.memo != null) {
      titleController.text = widget.memo?.get('title');
      detailController.text = widget.memo?.get('detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //三項演算子でメモを新規か編集で変更
        title: Text(widget.memo == null ? 'メモを追加' : 'メモを編集'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text('タイトル'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: InputBorder.none
                    ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text('メモ内容'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: detailController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: InputBorder.none
                    ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    if (widget.memo == null) {
                      //メモ追加の処理
                      //addMemoの処理が終わってから画面遷移する必要があるため非同期処理にする。
                      //同期処理にしてしまうと、addMemoの処理が終わっていないのに画面遷移する可能性があるためラグが生じる。
                      await addMemo();
                    } else {
                      await updateMemo();
                    }
                    Navigator.pop(context);
                  },
                  //三項演算子で新規追加か編集で条件分岐
                  child: Text(widget.memo == null ? '追加' : '編集'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}