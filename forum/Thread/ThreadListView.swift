//
//  ThreadListView.swift
//  forum
//
//  Created by Atsushi on 2021/08/06.
//

import SwiftUI
import NCMB

struct ThreadListView: View {
    @State var threads: [NCMBObject] = []
    @State private var showModal = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(self.threads, id: \.objectId) { thread in
                        NavigationLink(
                            destination: ThreadView(thread: thread)
                        ) {
                            ThreadListRow(thread: thread)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .navigationBarTitle("掲示板", displayMode: .inline)
                .navigationBarItems(trailing:
                                        Button(action: {
                                            showModal.toggle()
                                        }, label: {
                                            Image(systemName: "plus")
                                                .resizable()
                                                .padding(6)
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.blue)
                                        })
                )
            }
        }
        .onAppear {
            getThread()
        }
        .sheet(isPresented: $showModal, content: {
            AddThreadView()
        })
        .onChange(of: showModal, perform: { value in
            if (!showModal) {
                getThread()
            }
        })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("削除に失敗しました。権限がないようです。"))
        })
    }
    
    func getThread() {
        let query = NCMBQuery.getQuery(className: "Thread")
        let results = query.find()
        switch results {
        case let .success(ary):
            threads = ary
        case .failure(_): break
        }
    }
    
    func delete(at offsets: IndexSet) {
        let thread = self.threads[Array(offsets)[0]] as NCMBObject
        let results = thread.delete()
        switch results {
        case .success(_):
            getThread()
        case .failure(_):
            showAlert = true
        }
    }
}
