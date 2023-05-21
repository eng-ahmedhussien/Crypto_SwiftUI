//
//  HomeView.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 14/05/2023.
//

import SwiftUI

struct HomeView: View {
   @State var showPortfolio = true
   @EnvironmentObject var VM  : HomeViewModel
    
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
            VStack{
                headerView
                Spacer(minLength: 30)
                
                //homeStatView
                HomeStatsView(showPortfolio:$showPortfolio)
              
                SearchBar(searchText:$VM.searchText)

                listHeaders
                    .padding(.horizontal)

                if (showPortfolio){
                    allCoinList
                        .transition(.move(edge: .trailing))
                }
                else{
                    portfolioCoinList
                        .transition(.move(edge: .leading))
                }
            }
        }
    }

}

struct HomeView_Previews: PreviewProvider { 
    static var previews: some View {
        NavigationView {
            HomeView()
               .toolbar(.hidden)
        }
        .environmentObject(dev.VM)
        
    }
}

extension HomeView{
    var headerView : some View{
        HStack{
            CircleButton(title: showPortfolio ?"info":"plus")
                .animation(.none, value: showPortfolio)
            Spacer()
            Text(showPortfolio ? "ahmed title" : "portfolio")
                .font(.title)
                .animation(.none, value: showPortfolio)
            Spacer()
            
            CircleButton(title: "chevron.left" )
                .rotationEffect(Angle(degrees: showPortfolio ? 180:0))
                .onTapGesture {
                    withAnimation(){ showPortfolio.toggle()}
                }
        }
         .padding(.horizontal)
    }
    
//    var homeStatView : some View{
//        HStack {
//            ForEach(VM.statistics) { stat in
//                StatisticView(stat: stat)
//                    .frame(width: UIScreen.main.bounds.width / 3)
//            }
//        }
////        .frame(width: UIScreen.main.bounds.width,
////               alignment: showPortfolio ? .trailing : .leading
////        )
//    }
    
    var listHeaders : some View{
        HStack{
            Text("Coin")
            Spacer()
            if showPortfolio{
                Text("Holding")
            }
            Text("Price")
                .frame (width: UIScreen.main.bounds.width / 3.3, alignment: .trailing)
        }
        .padding(.horizontal)
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText )
    }
    
    var allCoinList : some View{
        List {
            ForEach(VM.allCoin) { i in
                CoinRowView(showHoldingsColumn: true, coin: i)
            }
        }
        .listStyle(.plain)
    }
    
    var portfolioCoinList : some View{
        List {
            ForEach(VM.allCoin) { i in
                CoinRowView(showHoldingsColumn: false, coin: i)
            }
        }
        .listStyle(.plain)
    }
    
}
