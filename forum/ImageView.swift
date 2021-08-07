//
//  ImageView.swift
//  forum
//
//  Created by Atsushi on 2021/08/06.
//

import SwiftUI
import NCMB

struct ImageView: View {
    var fileName: String?
    var size: CGFloat
    var body: some View {
        if let image = image() {
            Image(uiImage: image)
                .resizable()
                .frame(width: size, height: size)
        } else {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .resizable()
                .frame(width: size, height: size)
                .foregroundColor(.blue)
        }
    }

    func image() -> UIImage? {
        if fileName == nil || fileName == "" {
            return nil
        }
        let file = NCMBFile(fileName: fileName!)
        let results = file.fetch()
        switch results {
        case let .success(data):
            return UIImage(data: data!)
        case .failure(_):
            return nil
        }
    }

}
