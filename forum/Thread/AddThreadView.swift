//
//  AddThreadView.swift
//  forum
//
//  Created by Atsushi on 2021/08/06.
//

import SwiftUI
import NCMB

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
            }
        }
        .sheet(isPresented: $showingPicker) {
            ImagePickerView(image: $image, sourceType: .library)
        }
    }
    
    func add() {
        let thread = NCMBObject(className: "Thread")
        thread["title"] = title
        thread["description"] = description
        let user = NCMBUser.currentUser
        var acl = NCMBACL.empty
        acl.put(key: "*", readable: true, writable: false)
        acl.put(key: user!.objectId!, readable: true, writable: true)
        thread.acl = acl
        if let image = image {
            let uuid = UUID()
            let fileName = "\(uuid).jpg"
            let photo = NCMBFile(fileName: fileName, acl: acl)
            _ = photo.save(data: image.jpegData(compressionQuality: 80.0)!)
            thread["fileName"] = fileName
        }
        let results = thread.save()
        if case .success(_) = results {
            presentationMode.wrappedValue.dismiss()
        } else {
            print("Error")
        }
    }
}

struct AddThreadView_Previews: PreviewProvider {
    static var previews: some View {
        AddThreadView()
    }
}
