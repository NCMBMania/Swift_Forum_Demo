//
//  ThreadView.swift
//  forum
//
//  Created by Atsushi on 2021/08/06.
//

import SwiftUI
import NCMB

struct ThreadView: View {
    var thread: NCMBObject
    @State private var showModal = false
    @State private var comments: [NCMBObject] = []
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            ImageView(fileName: (thread["fileName"] ?? "") as String, size: 200)
            Text("コメント").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            List {
                ForEach(self.comments, id: \.objectId) { comment in
                    CommentListRow(comment: comment)
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle((thread["title"] ?? ""), displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        showModal.toggle()
                                    }, label: {
                                        Image(systemName: "bubble.middle.bottom.fill")
                                            .resizable()
                                            .padding(6)
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.blue)
                                    })
            )
        }
        .onAppear {
            getComments()
        }
        .sheet(isPresented: $showModal, content: {
            AddCommentView(thread: thread)
        })
        .onChange(of: showModal, perform: { value in
            if (!showModal) {
                getComments()
            }
        })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("削除に失敗しました。権限がないようです。"))
        })
    }

    func getComments() {
        var query = NCMBQuery.getQuery(className: "Comment")
        query
            .where(field: "thread", equalTo: [
                "objectId": (thread["objectId"] ?? "") as String,
                "__type": "Pointer",
                "className": "Thread"
            ])
        let results = query.find()
        switch results {
        case let .success(ary):
            comments = ary
        case .failure(_): break
        }
    }
    
    func delete(at offsets: IndexSet) {
        let comment = comments[Array(offsets)[0]] as NCMBObject
        let results = comment.delete()
        switch results {
        case .success(_):
            getComments()
        case .failure(_):
            showAlert = true
        }
    }
}
