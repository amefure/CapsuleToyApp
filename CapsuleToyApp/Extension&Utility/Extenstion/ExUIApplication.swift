//
//  ExUIApplication.swift
//  MinnanoOiwai
//
//  Created by t&a on 2025/01/26.
//

import UIKit

extension UIApplication {
    // フォーカスの制御をリセット
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
