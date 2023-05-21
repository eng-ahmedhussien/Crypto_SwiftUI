//
//  CoinRowView.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 14/05/2023.
//

import SwiftUI

struct CoinRowView: View {
    let showHoldingsColumn :Bool
    let coin:CoinModel
    
    var body: some View{
        HStack{
            leftView
            
            Spacer()
            if showHoldingsColumn{
                centerView
            }
            Spacer()
            
            rigthview
        }
        .padding(.horizontal)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            CoinRowView(showHoldingsColumn: true, coin: dev.coin)
        }
      
    }
}

extension CoinRowView{
    var leftView : some  View{
        HStack{
            Text("\(coin.rank)")
                .foregroundColor (Color .theme.secondaryText)
            CoinImageview(coin: coin)
            .frame(width: 30,height:30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
        }
    }
    var centerView: some View{
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .font(.headline)
        .foregroundColor (Color.theme.accent)
    }
    var rigthview : some View {
        VStack(alignment: .trailing){
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .foregroundColor(Color.theme.accent)
            
            Text(coin.priceChangePercentage24H?.asNumberString() ?? "0")
                .foregroundColor(
                    coin.priceChangePercentage24H ?? 0  >= 0 ? Color.theme.green : Color.theme.red
                )
        }
        .frame (width: UIScreen.main.bounds.width / 4, alignment: .trailing)
        .font(.headline)
    }
}

