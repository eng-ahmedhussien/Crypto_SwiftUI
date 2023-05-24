//
//  PortfolioView.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 22/05/2023.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var VM : HomeViewModel
    @State private var selectedCoin : CoinModel? = nil
    @State private var quantityText : String = ""
    @State private var showCheckMark = false
    
    var body: some View {
        NavigationView {
            ScrollView{
                SearchBar(searchText: $VM.searchText)
                coinLogoList
                
                if selectedCoin != nil {
                    portfolioInputSection
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolBarItems
                }
            }
            .onChange(of: VM.searchText) { newValue in
                selectedCoin = nil
            }
        }
        
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.VM)
    }
}

extension PortfolioView{
    
    
    private var coinLogoList: some View {
        ScrollView(.horizontal){
            LazyHStack{
                ForEach( VM.allCoin) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 70)
                        .onTapGesture {
                            updateSelectedCoin(coin: coin)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear
                                        , lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
       // .animation(.none)
        .padding()
        .font(.headline)
        
    }
    
    private var toolBarItems:some View{
        HStack{
            Button {
                print("")
            } label: {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
            }
            .opacity(showCheckMark ? 1.0 : 0.0)
            
            Button {
                saveButtonPressed()
            } label: {
                Text("save")
            }
            .opacity(selectedCoin != nil &&  selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0)
            //  .padding()
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed() {
        
        
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
            else { return }
        
        // save to portfolio
        VM.updatePortfolio(coin: coin, amount: amount)
       
        withAnimation(.easeIn){
            showCheckMark.toggle()
        }
        selectedCoin = nil
        VM.searchText = ""

        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute:{
            withAnimation(.easeOut){
                showCheckMark.toggle()
            }
        })
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = VM.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
}


