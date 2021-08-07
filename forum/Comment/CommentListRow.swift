//
//  CommentListRow.swift
//  forum
//
//  Created by Atsushi on 2021/08/06.
//

import SwiftUI
import NCMB

struct CommentListRow: View {
    var comment: NCMBObject
    var body: some View {
        HStack {
            Text((comment["text"] ?? "") as String)
        }
    }
}
