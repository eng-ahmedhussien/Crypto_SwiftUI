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
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
//        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
//        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
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
