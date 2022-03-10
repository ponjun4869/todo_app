
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/add_edit_memo_page.dart';
import 'package:todo_app/pages/memo_page.dart';
import 'package:url_launcher/url_launcher.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  //チェックかどうかの変数
  var _value = false;

  //削除機能の処理
  Future<void> deleteMemo(String docID) async {
    var document = FirebaseFirestore.instance.collection('memo').doc(docID);
    document.delete();
  }

  //ウィジェットが作成されたタイミングで処理を行う
  @override
  void initState(){
    super.initState();
  }

  //firestoreからインスタンスからコレクションのmemoを取得し定義する
  final Stream<QuerySnapshot> memos = FirebaseFirestore.instance.collection('memo').snapshots();

  //アプリ内でウェブブラウザを表示する処理
  Future<void> launchURL(String s) async {
    if (await canLaunch('https://pub.dev/')) {
      launchURL('https://pub.dev/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoアプリ Firebase×Flutter'),
      ),
      drawer: Drawer(
        child: ListView(
          children: const <Widget>[
            DrawerHeader(
              child: Text(
                'カスタマーサポート',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.orange
              ),
            ),
            ListTile(
              trailing: Icon(Icons.ac_unit_sharp),
            ),
            ListTile(
              title: Text('web view'),
              trailing: Icon(Icons.emoji_nature_sharp),
            ),
            ListTile(
              title: Text('ログイン'),
              trailing: Icon(Icons.login),
            ),
            ListTile(
              title: Text('SNS'),
              trailing: Icon(Icons.cabin),
            ),
          ],
        ),
      ),
      //StreamBuilderはstreamの値を見て、自動で再描画する
      body: StreamBuilder<QuerySnapshot>(
        //streamは値が変更したときにbuilderが動くようにするため
        stream: memos,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            //メモ数を取得し、表示
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(snapshot.data!.docs[index]['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  leading: Checkbox(
                    value: _value,
                    onChanged: (isChecked) {
                      setState(() {
                        _value = isChecked!;
                      });
                    },
                  ),
                  dense: true,
                  subtitle: Text(snapshot.data!.docs[index]['detail']),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.list),
                    onPressed: () {
                      showModalBottomSheet(context: context, builder: (context){
                        return SafeArea(
                          child: Column( 
                            //ボトムシートを最小限のサイズにする
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.edit, color: Colors.blueAccent),
                                title: const Text('編集'),
                                onTap: () {
                                  //ボトムシートを消してから
                                  Navigator.pop(context);
                                  //編集ページへ画面遷移
                                  //編集ページに特定のmemoのデータを引数で渡してる
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditMemoPage(memo: snapshot.data!.docs[index])));
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
                                title: const Text('削除'),
                                onTap: () async {
                                  //削除機能の呼び出し
                                  //削除が完了したら、画面遷移するようにするため非同期処理を走らせる
                                  await deleteMemo(snapshot.data!.docs[index].id);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      }); 
                    },
                  ),
                  onTap: () {
                    // 確認画面に遷移
                    //docs[index]で対応する画面遷移先にデータを渡す
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MemoPage(snapshot.data!.docs[index])));
                  },
                ),
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.museum_rounded),
        onPressed: () {
          //メモ追加画面に遷移
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditMemoPage()));
        },
      ),
    );
  }
}