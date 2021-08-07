//
//  ContentView.swift
//  forum
//
//  Created by Atsushi on 2021/08/02.
//

import SwiftUI
import NCMB

struct ContentView: View {
    var body: some View {
        ZStack {
            ThreadListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
