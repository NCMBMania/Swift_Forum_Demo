//
//  AddCommentView.swift
//  forum
//
//  Created by Atsushi on 2021/08/06.
//

import SwiftUI
import NCMB

struct AddCommentView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var thread: NCMBObject
    @State private var text = ""
    
    var body: some View {
        VStack {
            NavigationView {
                        Form {
                            TextField("コメントを入力してください", text: $text)
                            Button(action: {
                                add()
                            }) {
                                Text("コメントする")
                            }
                        }
                    }
        }
    }
    
    func add() {
        let comment = NCMBObject(className: "Comment")
        comment["text"] = text
        comment["thread"] = [
            "objectId": (thread["objectId"] ?? "") as String,
            "__type": "Pointer",
            "className": "Thread"
        ]
        let user = NCMBUser.currentUser
        var acl = NCMBACL.empty
        acl.put(key: "*", readable: true, writable: false)
        acl.put(key: user!.objectId!, readable: true, writable: true)
        comment.acl = acl
        let results = comment.save()
        if case .success(_) = results {
            presentationMode.wrappedValue.dismiss()
        } else {
            print("Error")
        }
    }
}
