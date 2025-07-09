//
//  RealmRepository.swift
//  CapsuleToyApp
//
//  Created by t&a on 2025/07/07.
//

import RealmSwift
import UIKit

class RealmRepository: RealmRepositoryProtocol {
    
    init() {
        let config = Realm.Configuration(schemaVersion: RealmConfig.MIGRATION_VERSION)
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm()
    }

    private let realm: Realm
    
    /// Create
    public func createObject<T: Object>(_ obj: T) {
        try? realm.write {
            realm.add(obj, update: .modified)
        }
    }
    
    /// Update
    public func updateObject<T: Object>(_ objectType: T.Type, id: ObjectId, updateBlock: @escaping (T) -> Void) {
        guard let obj = realm.object(ofType: objectType, forPrimaryKey: id) else { return }
        try? realm.write {
            updateBlock(obj)
        }
    }

    
    /// Read
    public func readAllObjs<T: Object>() -> Array<T> {
        let objs = realm.objects(T.self)
        // Deleteでクラッシュするため凍結させる
        let freezeObjs = objs.freeze().sorted(byKeyPath: "id", ascending: true)
        return Array(freezeObjs)
    }
    
    /// プライマリーキーで取得
    public func getByPrimaryKey<T: Object>(_ id: ObjectId) -> T? {
        let obj = realm.object(ofType: T.self, forPrimaryKey: id)
        return obj?.freeze()
    }
    
    /// Remove・削除対象指定
    public func removeObjs<T: Object & Identifiable>(list: [T]) {
        let ids = list.map(\.id)
        let predicate = NSPredicate(format: "id IN %@", ids)
        let objectsToDelete = realm.objects(T.self).filter(predicate)

        try? realm.write {
            realm.delete(objectsToDelete)
        }
    }
    
    /// Remove：All削除
    public func removeAllObjs<T: Object & Identifiable>(_ objectType: T.Type) {
        let allObjs = realm.objects(T.self)
        // データがない場合は終了
        guard !allObjs.isEmpty else { return }
        try? realm.write {
            realm.delete(allObjs)
        }
    }
}

// MARK: Background Realm
extension RealmRepository {
    
    /// Create background
    public func createObjectBG<T: Object>(_ obj: T) {
        guard let realmBG = try? Realm() else { return }
        try? realmBG.write {
            realm.add(obj, update: .modified)
        }
    }
    
    /// Read background
    public func readAllObjsBG<T: Object>() -> Array<T> {
        guard let realmBG = try? Realm() else { return [] }
        let objs = realmBG.objects(T.self)
        // Deleteでクラッシュするため凍結させる
        let freezeObjs = objs.freeze().sorted(byKeyPath: "id", ascending: true)
        return Array(freezeObjs)
    }
    
    /// プライマリーキーで取得 background
    public func getByPrimaryKeyBG<T: Object>(_ id: ObjectId) -> T? {
        guard let realmBG = try? Realm() else { return nil }
        let obj = realmBG.object(ofType: T.self, forPrimaryKey: id)
        return obj?.freeze()
    }
    
    
    /// Update background
    public func updateObjectBG<T: Object>(_ objectType: T.Type, id: ObjectId, updateBlock: @escaping (T) -> Void) {
        guard let realmBG = try? Realm() else { return }
        guard let obj = realmBG.object(ofType: objectType, forPrimaryKey: id) else { return }
        try? realmBG.write {
            updateBlock(obj)
        }
    }
    
    /// Remove：All削除 background
    public func removeAllObjsBG<T: Object & Identifiable>(_ objectType: T.Type) {
        guard let realmBG = try? Realm() else { return }
        let allObjs = realmBG.objects(T.self)
        // データがない場合は終了
        guard !allObjs.isEmpty else { return }
        try? realmBG.write {
            realmBG.delete(allObjs)
        }
    }
}


