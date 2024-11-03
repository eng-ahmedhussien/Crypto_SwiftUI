//
//  SearchBar.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 17/05/2023.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText : String
    
    var body: some View {
        HStack{
            
            Image(systemName: "magnifyingglass.circle")
                .foregroundColor(.theme.accent)
            
            TextField("search text", text: $searchText)
                .foregroundColor(.theme.accent)
                .overlay(alignment: .trailing) {
                    Image(systemName: "x.circle")
                        .padding(.horizontal)
                        .foregroundColor(.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1)
                        .onTapGesture {
                            searchText = ""
                        }
                }
                .padding()
                .background(Color.theme.background)
                .cornerRadius(25)
        }
        .padding(.horizontal)
        
       
        
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        
        SearchBar(searchText: .constant(""))
    }
}
