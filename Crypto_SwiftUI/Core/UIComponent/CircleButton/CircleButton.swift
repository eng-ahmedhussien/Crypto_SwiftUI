//
//  CircleButton.swift
//  Crypto_SwiftUI
//
//  Created by DBS on 14/05/2023.
//

import SwiftUI



struct CircleButton:View{
    var title:String
    
    var body: some View{
        Image(systemName: title)
        .font(.headline)
        .foregroundColor(Color.theme.accent)
        .frame(width: 50,height: 50)
        .background(
            Circle()
                .foregroundColor(Color.theme.background)
        )
        .shadow(color: .theme.accent.opacity(0.5), radius:10, x: 0, y: 0)
         
    }
}

struct HeaderView: View {
    @State var showAnimation = false
    var body: some View {
        ZStack{
            Color.red
                .ignoresSafeArea()
            HStack{
                CircleButton(title: showAnimation ?"plus":"info")
                    .animation(.none, value: showAnimation)
                
                Spacer()
                Text(showAnimation ? "ahmed title" : "next view")
                    .font(.title)
                    .animation(.none, value: showAnimation)
                Spacer()
                
                CircleButton(title: "chevron.right")
                    .rotationEffect(Angle(degrees: showAnimation ? 180:0))
                    .onTapGesture {
                        withAnimation(){ showAnimation.toggle()}
                    }
            }.padding(.horizontal)
        }
    }
 
}


struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            HeaderView()
                .previewLayout(PreviewLayout.sizeThatFits)
            CircleButton(title: "info")
                .previewLayout(PreviewLayout.sizeThatFits)
        }
        
        
       
        
    }
}

