//
//  ContentView.swift
//  forum
//
//  Created by Atsushi on 2021/08/02.
//

import SwiftUI
import NCMB

class Thread: ObservableObject {
    @Published var items: [NCMBObject] = []
}

struct ContentView: View {
    var body: some View {
        ZStack {
            ThreadListView()
        }
    }
}

struct ThreadListView: View {
    @ObservedObject var threads = Thread()
    @State private var showModal = false
    var body: some View {
        NavigationView {
                    ZStack(alignment: .bottomTrailing) {
                        List {
                            ForEach(self.threads.items, id: \.objectId) { thread in
                                Text((thread["title"] ?? "") as String)
                            }
                            .onDelete(perform: delete)
                        }
                        .navigationBarTitle("掲示板", displayMode: .inline)
                        .navigationBarItems(trailing:
                                                Button(action: {
                                                    self.showModal.toggle()
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
            self.getThread()
        }
        .sheet(isPresented: $showModal, content: {
            AddThreadView()
        })
    }
    
    func getThread() {
        let query : NCMBQuery<NCMBObject> = NCMBQuery.getQuery(className: "Thread")
        let results = query.find()
        switch results {
        case let .success(ary):
            self.threads.items = ary
        case .failure(_): break
        }
    }
    
    func delete(at offsets: IndexSet) {
        
    }
}

struct AddThreadView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var title = ""
    @State private var description = ""
    @State var showingPicker = false
    @State var image: UIImage?
    var body: some View {
        VStack {
            NavigationView {
                        Form {
                            TextField("スレッドのタイトルを入力してください", text: $title)
                            TextField("スレッドの紹介文を入力してください", text: $description)
                            Button(action: {
                                showingPicker.toggle()
                            }) {
                                Text("画像追加")
                            }
                            if let image = image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            Button(action: {
                                add()
                            }) {
                                Text("スレッド追加")
                            }
                            
                            
                        }
                        .navigationBarTitle("スレッドの新規追加")
                    }
        }
        .sheet(isPresented: $showingPicker) {
            ImagePickerView(image: $image, sourceType: .library)
        }
    }
    
    func add() {
        let thread = NCMBObject(className: "Thread")
        thread["title"] = $title
        thread["description"] = $description
        if let image = image {
            let uuid = UUID()
            let fileName = "\(uuid).jpg"
            let user = NCMBUser.currentUser
            var acl = NCMBACL.empty
            acl.put(key: "*", readable: true, writable: false)
            acl.put(key: user!.objectId!, readable: true, writable: true)
            let photo = NCMBFile(fileName: fileName, acl: acl)
            _ = photo.save(data: image.jpegData(compressionQuality: 80.0)!)
            thread["fileName"] = fileName
        }
        _ = thread.save()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
