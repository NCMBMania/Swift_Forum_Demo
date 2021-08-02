//
//  forumApp.swift
//  forum
//
//  Created by Atsushi on 2021/08/02.
//

import SwiftUI
import NCMB
import Hydra

@main
struct forumApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.onChange(of: scenePhase) { scene in
            switch scene {
            case .active:
                let applicationKey = KeyManager().getValue(key: "applicationKey") as! String
                let clientKey = KeyManager().getValue(key: "clientKey") as! String
                NCMB.initialize(applicationKey: applicationKey, clientKey: clientKey)
                NCMBUser.enableAutomaticUser()
                checkAuth()
                if checkSession() == false {
                    checkAuth()
                }
            case .background: break
            case .inactive: break
            default: break
            }
        }
    }
    
    func checkAuth() -> Void {
        var result = NCMBUser.currentUser
        if result != nil {
            return;
        }
        let semaphore = DispatchSemaphore(value: 0)
        NCMBUser.automaticCurrentUserInBackground(callback: { _ in
            result = NCMBUser.currentUser
            semaphore.signal()
        })
        semaphore.wait()
        return
    }
    
    func checkSession() -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var result = false
        var query : NCMBQuery<NCMBObject> = NCMBQuery.getQuery(className: "Todo")
        query.limit = 1 // レスポンス件数を最小限にする
        // アクセス
        query.findInBackground(callback: { results in
            // 結果の判定
            switch results {
            case .success(_):
                result = true
                semaphore.signal()
            case .failure(_):
                // 強制ログアウト処理
                NCMBUser.logOutInBackground(callback: { _ in
                    result = false
                    semaphore.signal()
                })
            }
        })
        semaphore.wait()
        return result
    }
}
