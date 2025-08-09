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
    /// 金額
    @Persisted var amount: Int
    /// 紐づいているカプセルトイ情報
    @Persisted var capsuleToys: RealmSwift.List<CapsuleToy>
    /// カテゴリ(複数登録可能)
    @Persisted var categories: RealmSwift.List<Category>
    /// メモ
    @Persisted var memo: String
    /// 位置情報
    @Persisted var locations: RealmSwift.List<Location>
    /// 画像パス
    @Persisted var imagePath: String?
    /// 生成日
    @Persisted var createdAt: Date = Date()
    /// 更新日
    @Persisted var updatedAt: Date = Date()
}


extension Series {
    
    /// カテゴリリストの一番最初の名前を取得
    public var getFirstCategoryName: String? {
        categories.first?.name
    }
    
    /// 所有済みのアイテム数を取得
    public var isOwendToysCount: Int {
        capsuleToys.filter { $0.isOwned }.count
    }
    
    /// アイテムを全て獲得済みかどうか
    public var isComplete: Bool {
        isOwendToysCount >= count
    }
    
    /// アイテムのシークレットを獲得しているかどうか
    public var isGetSecret: Bool {
        capsuleToys.contains { $0.isSecret == true && $0.isOwned == true }
    }
    
    /// 手動で登録している種類数と実際に登録しているアイテム数で大きい方を取得
    public var highCount: Int {
        max(capsuleToys.count, count)
    }
}


extension Series {
    static func mock(
        name: String = "猫フィギュア Vol.1",
        count: Int = 5,
        amount: Int = 300,
        capsuleToyNames: [String] = ["黒猫", "白猫", "トラ猫", "三毛猫", "キジトラ"],
        categoryNames: [String] = ["鬼滅の刃"],
        memo: String = "お気に入りシリーズ"
    ) -> Series {
        let series = Series()
        series.id = ObjectId.generate()
        series.name = name
        series.count = count
        series.amount = amount
        series.memo = memo
        series.createdAt = Date()
        series.updatedAt = Date()

        for name in capsuleToyNames {
            let toy = CapsuleToy()
            toy.id = ObjectId.generate()
            toy.name = name
            toy.isOwned = Bool.random()
            toy.isSecret = Bool.random()
            toy.isGetAt = toy.isOwned ? Date() : nil
            series.capsuleToys.append(toy)
        }
        
        for name in categoryNames {
            let category = Category()
            category.id = ObjectId.generate()
            category.name = name
            series.categories.append(category)
        }

        return series
    }

    static func mockList() -> [Series] {
        return [
            Series.mock(
                name: "海の仲間シリーズ",
                count: 5,
                amount: 300,
                capsuleToyNames: ["イルカ", "クジラ", "カクレクマノミ", "タツノオトシゴ", "カメ"],
                categoryNames: ["海の生き物", "水族館"],
                memo: "海モチーフのカプセルトイ"
            ),
            Series.mock(
                name: "恐竜ザウルス Vol.1",
                count: 4,
                amount: 500,
                capsuleToyNames: ["ティラノサウルス", "トリケラトプス", "ステゴサウルス", "プテラノドン"],
                categoryNames: ["恐竜", "古代生物"],
                memo: "恐竜好き必見"
            ),
            Series.mock(
                name: "ミニチュア家具シリーズ",
                count: 3,
                amount: 300,
                capsuleToyNames: ["ソファ", "ダイニングテーブル", "ランプ"],
                categoryNames: ["家具", "インテリア"],
                memo: "小物ディスプレイ用にも最適"
            )

        ]
    }
}
