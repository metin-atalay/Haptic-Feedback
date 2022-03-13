//
//  OnboardingView.swift
//  Restart
//
//  Created by Metin Atalay on 13.03.2022.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffeset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var imageOfset : CGSize = .zero
    @State private var indicatorOpacity: Double = 1.0
    @State private var titleText: String = "Shared."
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Color("ColorBlue").ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing: 20) {
                //MARK: -HEADER
                
                Spacer()
                
                VStack(spacing:20) {
                    Text(titleText)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(titleText)
                    
                    Text("""
                         It's not how much give but how much love we put into giving.
                         """)
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal,10)
                }
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimating)
                
                //MARK - Center
                ZStack{
                    
                    CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
                        .offset(x: imageOfset.width * -1)
                        .blur(radius: abs(imageOfset.width / 5))
                        .animation(.easeOut(duration: 1), value: imageOfset)
                    
                    Image("character-1").resizable().scaledToFit()
                        .opacity(isAnimating ? 1:0)
                        .animation(.easeOut(duration: 1), value: isAnimating)
                        .offset(x: imageOfset.width * 1.2 , y:0)
                        .rotationEffect(.degrees(Double(imageOfset.width / 20)))
                        .gesture(DragGesture()
                                .onChanged({ gesture in
                            
                            if abs(imageOfset.width) <= 150 {
                                imageOfset = gesture.translation
                                
                                withAnimation(.linear(duration: 0.25)){
                                    indicatorOpacity = 0
                                    titleText = "Give."
                                }
                            }
                            
                       
                        })
                                    .onEnded({ _ in
                            imageOfset = .zero
                            withAnimation(.linear(duration: 0.25)){
                                indicatorOpacity = 1
                                titleText = "Share."
                            }
                        })
                        )
                        .animation(.easeOut(duration: 1), value: imageOfset)
                    
                }
                .overlay(
                Image(systemName: "arrow.left.and.right.circle")
                    .font(.system(size: 44, weight: .ultraLight))
                    .foregroundColor(.white)
                    .offset(y:40)
                    .opacity(isAnimating ? 1: 0)
                    .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                    .opacity(indicatorOpacity)
                ,alignment: .bottom
                )
                
                Spacer()
                
                //MARK: -Footer
                
                ZStack {
                    
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    
                    Capsule().fill(Color.white.opacity(0.2)).padding(8)
                    
                    Text("Get Started")
                        .font(.system(.title3,design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x:20)
                    
                    HStack {
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: 80)
                        
                        Spacer()
                    }
                    
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }.frame(width: 80, height: 80, alignment: .center)
                            .offset(x: buttonOffeset)
                            .gesture(DragGesture()
                                        .onChanged({ gesture in
                                if gesture.translation.width > 0 && buttonOffeset <= buttonWidth - 80 {
                                    buttonOffeset = gesture.translation.width
                                }
                            })
                                        .onEnded({ _ in
                                withAnimation(Animation.easeOut(duration: 0.4)){
                                    if buttonOffeset > buttonWidth / 2 {
                                        hapticFeedback.notificationOccurred(.success)
                                        playSound(sound: "chimeup", type: "mp3")
                                        buttonOffeset = buttonWidth - 80
                                        isOnboardingViewActive = false
                                    }else {
                                        hapticFeedback.notificationOccurred(.warning)
                                        buttonOffeset = 0
                                    }
                                }
                            })
                            )
                        
                        
                        Spacer()
                    }
                    
                    
                }.frame( height: 80, alignment: .center)
                    .padding()
                    .opacity(isAnimating ? 1: 0)
                    .offset(y: isAnimating ? 0 :40)
                    .animation(.easeOut(duration: 1), value: isAnimating)
                
            }
        }.onAppear {
            isAnimating = true
        }
        .preferredColorScheme(.dark)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
