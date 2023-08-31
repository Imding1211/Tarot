//
//  DrawCardView.swift
//  Tarot
//
//  Created by 丁啟恆 on 2023/8/6.
//

import SwiftUI

struct DailyCardView: View {
    
    @Environment(\.colorScheme) var colorScheme

    @State var cardState: Int = 0
    @State var cardIndex: Int = Int.random(in: 1...156)
    @State var turnCardDegrees: Double = 0.0
    @State var shuffleCardDegrees: Double = 0.0
    @State var cardDatas: [CardInfo] = CardData().getData()
    @State var showCardSheet: Bool = false
        
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image(colorScheme == .light ? "background-light" : "background-dark")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    
                    DailyCardTitle(message: cardState > 78 ? cardDatas[cardState-78].englishName : cardDatas[cardState].englishName)
                    
                    Button {
                        if cardState == 0 {
                            turnCard()
                            
                            DispatchQueue.main.asyncAfter(deadline:  .now() + 0.5) {
                                showCardSheet.toggle()
                            }
                        }
                        else {
                            showCardSheet.toggle()
                        }

                    } label: {
                        if cardState == 0 {
                            DailyCardImage(imageName: cardDatas[cardState].imageName)
                                .rotation3DEffect(.degrees(turnCardDegrees), axis: (x: 0, y: 1, z: 0))
                                .rotationEffect(.degrees(shuffleCardDegrees))
                        }
                        else if cardState <= 78 {
                            DailyCardImage(imageName: cardDatas[cardState].imageName)
                                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                .rotation3DEffect(.degrees(turnCardDegrees), axis: (x: 0, y: 1, z: 0))
                        }
                        else {
                            DailyCardImage(imageName: cardDatas[cardState-78].imageName)
                                .rotationEffect(.degrees(180))
                                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                .rotation3DEffect(.degrees(turnCardDegrees), axis: (x: 0, y: 1, z: 0))
                        }
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            turnCard()
                        } label: {
                            DailyCardButtonLabel(message: "翻牌", iconName: "arrow.triangle.2.circlepath")
                        }
                        
                        Spacer()
                        
                        Button {
                            shuffleCard()
                            
                            if cardState != 0 {
                                turnCard()
                            }
                            withAnimation(.default) {
                                shuffleCardDegrees += 360
                            }
                            
                        } label: {
                            DailyCardButtonLabel(message: "洗牌", iconName: "repeat")
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                }
            }
            .navigationTitle("Daily Tarot Draw")
            .sheet(isPresented: $showCardSheet) {
                ShowCardView(cardState: cardState > 78 ? cardState-78 : cardState, isReversed: cardState > 78 ? true : false)
            }
        }
        .accentColor(Color("MainColor"))
    }
    
    func turnCard() {
        
        if cardState == 0 {
            cardState = cardIndex
            withAnimation {
                turnCardDegrees += 180
            }
        }
        else {
            cardState = 0
            withAnimation {
                turnCardDegrees -= 180
            }
        }
        
    }
    
    func shuffleCard() {
        
        cardIndex = Int.random(in: 1...156)
        
    }
    
}

struct DailyCardView_Previews: PreviewProvider {
    static var previews: some View {
        
        DailyCardView()
            .preferredColorScheme(.light)
        
        DailyCardView()
            .preferredColorScheme(.dark)

    }
}