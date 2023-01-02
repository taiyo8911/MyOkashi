//
//  OkashiData.swift
//  MyOkashi
//
//  Created by Taiyo Koshiba on 2022/12/30.
//

import Foundation
import UIKit

// お菓子の情報をユニークに識別できる構造体（Identifiabel）を定義
struct OkashiItem: Identifiable {
    let id = UUID() // ランダムな一意の値を生成できる
    let name: String
    let link: URL
    let image: URL
}

// webAPIからデータを取得するクラス
class OkashiData: ObservableObject {
    // 取得したJSONを格納するための変数（JSONデータの項目名と変数名を同じにするとJSONを変換した時に一括でデータを格納できる）
    struct ResultJson: Codable {
        // JSONのitem内のデータ構造
        struct Item: Codable {
            // お菓子の名称
            let name: String?
            // 掲載URL
            let url: URL?
            // 画像URL
            let image: URL?
        }
        //複数の構造体を保持できる配列を宣言
        let item: [Item]?
    }
    
    // お菓子のリスト（Identifiableプロトコル）OkashiItem構造体を複数保持できる配列を作成。
    // Publishedでプロパティを監視して自動通知できる
    @Published var okashiList: [OkashiItem] = []
    
    // WebAPI検索用のメソッド　第一引数に検索したいワード
    func searchOkashi(keyword: String) async {
        print(keyword)
        
        // お菓子の検索キーワードをURLエンコードする
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            return
        }
        
        // リクエストURLの組み立て
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
            return
        }
        
        // URLSessionの実行時エラーになる可能性があるため例外処理を行う
        do {
            // リクエストURLからダウンロード(awaitでデータ取得完了まで待機する)
            let (data , _) = try await URLSession.shared.data(from: req_url)
            
            // JSONをデコードするためのオブジェクトを作成
            let decoder = JSONDecoder()
            
            // 受け取ったJSONデータを解析して格納
            let json = try decoder.decode(ResultJson.self, from: data)
            
            //            print(json)
            
            // お菓子の情報が取得できているか確認
            guard let items = json.item else { return }
            
            // @Publishedの変数を更新するときはメインスレッドで更新する必要がある
            DispatchQueue.main.async {
                // お菓子のリストを初期化
                self.okashiList.removeAll()
                
                // 取得しているお菓子の数だけ処理
                for item in items {
                    // お菓子の名称、掲載URL、画像URLをアンラップ
                    if let name = item.name,
                       let link = item.url,
                       let image = item.image {
                        // 1つのお菓子を構造体でまとめて管理
                        let okashi = OkashiItem(name: name, link: link, image: image)
                        
                        // お菓子の配列へ追加
                        self.okashiList.append(okashi)
                    }
                }
            }
                        
            // パース時にエラーになる可能性があるので例外処理
        } catch {
            // エラー処理
            print("エラー")
        }
    }
}
