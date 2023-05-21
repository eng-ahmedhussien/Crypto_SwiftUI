//
//  Crypto_SwiftUIApp.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 11/05/2023.
//

import SwiftUI

@main
struct Crypto_SwiftUIApp: App {
    @StateObject var VM =  HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
           .toolbar(.hidden)
           .environmentObject(VM)
        }
        
    }
}
