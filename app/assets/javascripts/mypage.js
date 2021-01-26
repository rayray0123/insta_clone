function previewFileWithId(selector) {
    // event.target = クリックした箇所のオブジェクト要素を取得出来る(inputタグ)
    const target = this.event.target;

    // 選択した画像ファイルを代入
    const file = target.files[0];

    // FileReaderクラスのインスタンスを作成
    const reader  = new FileReader();

    // reader.readAsDataURL(file);が完了したら処理が実行
    reader.onloadend = function () {
        //読み取った画像のローカルURLをimgタグのsrc属性に代入する
        selector.src = reader.result;
    }

    if (file) {
        // 画像のローカルURLを読み取り、それをreaderインスタンスのresultプロパティにセット
        reader.readAsDataURL(file);
    } else {
        selector.src = "";
    }
}
