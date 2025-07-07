//
//  Series.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import Foundation
import RealmSwift

/// カプセルトイのシリーズ登録
final class Series: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    /// シリーズ名
    @Persisted var name: String
    /// アイテム数(手入力)
    @Persisted var count: Int
    /// 紐づいているカプセルトイ情報
    @Persisted var capsuleToys: RealmSwift.List<CapsuleToy>
    /// メモ
    @Persisted var memo: String?
    /// 生成日
    @Persisted var createdAt: Date = Date()
    /// 更新日
    @Persisted var updatedAt: Date = Date()
}

extension Series {
    static func mock(
        name: String = "猫フィギュア Vol.1",
        count: Int = 5,
        capsuleToyNames: [String] = ["黒猫", "白猫", "トラ猫", "三毛猫", "キジトラ"],
        memo: String? = "お気に入りシリーズ"
    ) -> Series {
        let series = Series()
        series.id = ObjectId.generate()
        series.name = name
        series.count = count
        series.memo = memo
        series.createdAt = Date()
        series.updatedAt = Date()

        for name in capsuleToyNames {
            let toy = CapsuleToy()
            toy.id = ObjectId.generate()
            toy.name = name
            toy.isOwned = Bool.random()
            toy.createdAt = Date()
            toy.updatedAt = Date()
            series.capsuleToys.append(toy)
        }

        return series
    }

    static func mockList() -> [Series] {
        return [
            Series.mock(
                name: "猫フィギュアシリーズ",
                count: 5,
                capsuleToyNames: ["黒猫", "白猫", "三毛猫", "キジトラ", "シャム"],
                memo: "猫好き向け"
            ),
            Series.mock(
                name: "恐竜フィギュアシリーズ",
                count: 4,
                capsuleToyNames: ["ティラノ", "トリケラ", "ステゴ", "プテラ"],
                memo: nil
            ),
            Series.mock(
                name: "鳥シリーズ",
                count: 3,
                capsuleToyNames: ["文鳥", "オカメ", "インコ"],
                memo: "小鳥好きにおすすめ"
            )
        ]
    }
}
