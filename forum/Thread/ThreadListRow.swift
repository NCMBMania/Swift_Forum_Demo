//
//  ThreadListRow.swift
//  forum
//
//  Created by Atsushi on 2021/08/06.
//

import SwiftUI
import NCMB

struct ThreadListRow: View {
    var thread: NCMBObject
    var body: some View {
        HStack {
            ImageView(fileName: (thread["fileName"] ?? "") as String, size: 50)
            VStack {
                Text((thread["title"] ?? "") as String)
                    .font(.title3)
                Text((thread["description"] ?? "") as String)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}

