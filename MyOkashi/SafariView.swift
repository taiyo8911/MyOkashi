//
//  SafariView.swift
//  MyOkashi
//
//  Created by Taiyo Koshiba on 2023/01/02.
//

import SwiftUI
// アプリの内部でSafariを起動できるフレームワーク（ウェブビュー）
import SafariServices

// SFSafariViewControllerを起動する構造体
struct SafariView: UIViewControllerRepresentable {
    // 表示するウェブページのURLを受ける変数
    var url: URL
    
    // 表示するViewを生成するときに実行
    func makeUIViewController(context: Context) -> SFSafariViewController {
        // Safariを起動
        return SFSafariViewController(url: url)
    }
    
    // Viewが更新されたときに実行
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // なし
    }
}
