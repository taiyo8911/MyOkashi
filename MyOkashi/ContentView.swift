//
//  ContentView.swift
//  MyOkashi
//
//  Created by Taiyo Koshiba on 2022/12/30.
//

import SwiftUI

struct ContentView: View {
    // OkashiDataを参照する状態変数
    @StateObject var okashiDataList = OkashiData()
    // 入力された文字列を保持する状態変数
    @State var inputText = ""
    // SafariViewの表示有無を管理する変数
    @State var showSafari = false
    
    var body: some View {
        VStack {
            TextField("キーワード", text: $inputText, prompt: Text("キーワードを入力してください"))
                .onSubmit {
                    // Taskは非同期で処理を実行できる
                    Task {
                        // 入力完了直後に検索をする
                        await okashiDataList.searchOkashi(keyword: inputText)
                    }
                }
            // キーボードの改行を検索にする
                .submitLabel(.search)
            // 余白
                .padding()
            
            // リストを表示する
            List(okashiDataList.okashiList) { okashi in
                // 1つ1つの要素を取り出す
                
                // ボタン
                Button(action: {
                    // SafariViewを表示する
                    // toggleメソッドを実行する度に、真偽値が切り替わる
                    showSafari.toggle()
                }) {
                    // 水平にレイアウト
                    HStack {
                        // 画像を読み込んで表示
                        AsyncImage(url: okashi.image) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 40)
                        } placeholder: {
                            // 読み込み中はインジケータを表示する
                            ProgressView()
                        }
                        Text(okashi.name)
                    }
                }
                // showSafariがtrueの場合にモーダルを表示する
                .sheet(isPresented: self.$showSafari, content: {
                    // SafariViewを表示する
                    SafariView(url: okashi.link)
                        // 画面下部がセーフエリア外までいっぱいになるように指定
                        .edgesIgnoringSafeArea(.bottom)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
