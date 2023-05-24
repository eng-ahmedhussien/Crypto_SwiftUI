//
//  HomeView.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 14/05/2023.
//

import SwiftUI

struct HomeView: View {
   @State var showPortfolioAnimation = false
   @State var showPortfolioView = false
   @EnvironmentObject var VM  : HomeViewModel
    
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
            VStack{
                headerView
                Spacer(minLength: 30)
                
                HomeStatsView(showPortfolio:$showPortfolioAnimation)
              
                SearchBar(searchText:$VM.searchText)

                headerslist
                   .padding(.horizontal)
            
                if (showPortfolioAnimation){
                    portfolioCoinList
                        .transition(.move(edge: .leading))
                }
                else{
                    allCoinList
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .sheet(isPresented: $showPortfolioView, content:{
            PortfolioView()
                .environmentObject(VM)
        })
        
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
            CircleButton(title: showPortfolioAnimation ?"plus":"info")
                .animation(.none, value: showPortfolioAnimation)
                .onTapGesture {
                    if showPortfolioAnimation {
                        showPortfolioView.toggle()
                    }
                }
            Spacer()
            Text(showPortfolioAnimation ? "portfolio" : "Coin List")
                .font(.title)
                .animation(.none, value: showPortfolioAnimation)
            Spacer()
            
            CircleButton(title: "chevron.right" )
                .rotationEffect(Angle(degrees: showPortfolioAnimation ? 180:0))
                .onTapGesture {
                    withAnimation(){ showPortfolioAnimation.toggle()}
                }
        }
        .padding(.horizontal, 30)
    }

   
    var headerslist : some View{
        HStack{
            Text("Coin")
            Spacer()
            if showPortfolioAnimation{
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
                CoinRowView(showHoldingsColumn: false, coin: i)
            }
        }
        .listStyle(.plain)
    }
    
    
    var portfolioCoinList : some View{
        List {
            ForEach(VM.portfolioCoins) { i in
                CoinRowView(showHoldingsColumn: true, coin: i)
            }
        }
        .listStyle(.plain)
    }
    
}
