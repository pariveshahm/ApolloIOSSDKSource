//
//  GridView.swift
//  ATTORMRetailIntegration
//
//  Created by Selma Suvalija on 3/15/20.
//  Copyright © 2020 Selma Suvalija. All rights reserved.
//

import SwiftUI

struct AttGridView<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    var rowHeight: CGFloat = 50

    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) { row in
                VStack {
                    HStack {
                        ForEach(0 ..< self.columns, id: \.self) { column in
                            self.content(row, column)
                        }
                        Spacer()
                    }.frame(height: self.rowHeight)
                    Divider()
                }
                
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        AttGridView(rows: 4, columns: 4) { row, col in
            Image(systemName: "\(row * 4 + col).circle")
            Text("R\(row) C\(col)")
            
        }
    }
}
