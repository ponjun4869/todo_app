class Memo {
  String title;
  //初期値を定義しない場合は「？」でnull safetyをオフにする
  String detail;
  DateTime? createdTime;
  DateTime? updatedDate;

  //メモを作るためのコンストラクタ
  //必ず値を入れる必要がある引数であるときは、requiredを記述
  Memo({ required this.title, required this.detail, this.createdTime, this.updatedDate});
}