//
//  CoinImageview.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 16/05/2023.
//

import SwiftUI

struct CoinImageview: View {
    @StateObject var VM  : CoinImageVM
    
    init(coin:CoinModel) {
        _VM = StateObject(wrappedValue: CoinImageVM(coin: coin))
    }
    
    var body: some View {
        ZStack{
            if VM.coinImage != nil{
                Image(uiImage: VM.coinImage!)
                    .resizable()
                    .scaledToFit()
            }
            else if VM.isLoading{
                ProgressView()
            }
            else{
                Image(systemName: "heart")
            }
            
        }
    }
}

struct CoinImageview_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageview(coin: dev.coin )
    }
}
