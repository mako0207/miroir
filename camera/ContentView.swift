import SwiftUI
import AVFoundation

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // MARK: - 背景
                LinearGradient(
                    colors: [
                        Color.white,
                        Color(red: 1.0, green: 0.94, blue: 0.97),
                        Color(red: 0.96, green: 0.92, blue: 0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // MARK: - 背景のやわらかい光
                Circle()
                    .fill(
                        Color(
                            red: 1.0,
                            green: 0.65,
                            blue: 0.80
                        )
                        .opacity(0.10)
                    )
                    .frame(width: 260, height: 260)
                    .blur(radius: 50)
                    .offset(
                        x: -120,
                        y: -280
                    )
                
                Circle()
                    .fill(
                        Color.white.opacity(0.45)
                    )
                    .frame(width: 220, height: 220)
                    .blur(radius: 45)
                    .offset(
                        x: 130,
                        y: 300
                    )
                
                
                // MARK: - メインコンテンツ
                VStack(spacing: 0) {
                    
                    // 上に適度な余白
                    Spacer()
                        .frame(height: 90)
                    
                    
                    // MARK: - ロゴ
                    VStack(spacing: 8) {
                        
                        Text("miroir")
                            .font(
                                .system(
                                    size: 42,
                                    weight: .medium,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(
                                            red: 1.0,
                                            green: 0.48,
                                            blue: 0.68
                                        ),
                                        Color(
                                            red: 0.92,
                                            green: 0.32,
                                            blue: 0.55
                                        )
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("YOUR REAL BEAUTY")
                            .font(
                                .system(
                                    size: 10,
                                    weight: .medium
                                )
                            )
                            .tracking(3)
                            .foregroundColor(
                                Color.gray.opacity(0.65)
                            )
                    }
                    
                    Spacer()
                        .frame(height: 70)
                    
                    
                    // MARK: - メニュー
                    VStack(spacing: 18) {
                        
                        NavigationLink {
                            AiView()
                        } label: {
                            HomeMenuButton(
                                title: "AI肌・顔診断",
                                subtitle: "AIによる客観的な肌・顔分析",
                                systemImage: "sparkles",
                                style: .pink
                            )
                        }
                        
                        NavigationLink {
                            RealView()
                        } label: {
                            HomeMenuButton(
                                title: "リアルミラー",
                                subtitle: "鏡のように自然な自分をチェック",
                                systemImage: "mirror",
                                style: .silver
                            )
                        }
                        
                        NavigationLink {
                            DiagnosisResultView()
                        } label: {
                            HomeMenuButton(
                                title: "肌悩み別美容診断",
                                subtitle: "メイク加工から自分に合うスタイルを探す",
                                systemImage: "face.smiling",
                                style: .cherry
                            )
                        }
                    }
                    .padding(.horizontal, 28)
                    
                    
                    Spacer()
                    
                    
                    // MARK: - 下部
                    VStack(spacing: 8) {
                        
                        // さくらんぼの小さな飾り
                        HStack(spacing: 5) {
                            Text("🍒")
                                .font(.system(size: 18))
                            
                            Text("mirror your beauty")
                                .font(
                                    .system(
                                        size: 11,
                                        weight: .medium,
                                        design: .rounded
                                    )
                                )
                                .foregroundColor(
                                    Color.gray.opacity(0.60)
                                )
                            
                            Text("🍒")
                                .font(.system(size: 18))
                        }
                        
                        Text("miroir")
                            .font(
                                .system(
                                    size: 10,
                                    weight: .medium
                                )
                            )
                            .tracking(2)
                            .foregroundColor(
                                Color.gray.opacity(0.45)
                            )
                    }
                    .padding(.bottom, 30)
                }
            }
            .tint(.pink)
        }
    }
}


// MARK: - ホームメニューボタン

private struct HomeMenuButton: View {
    
    enum ButtonStyle {
        case pink
        case silver
        case cherry
    }
    
    let title: String
    let subtitle: String
    let systemImage: String
    let style: ButtonStyle
    
    var backgroundColors: [Color] {
        switch style {
        case .pink:
            return [
                Color(
                    red: 1.0,
                    green: 0.63,
                    blue: 0.78
                ),
                Color(
                    red: 0.95,
                    green: 0.42,
                    blue: 0.64
                )
            ]
            
        case .silver:
            return [
                Color(
                    red: 0.92,
                    green: 0.93,
                    blue: 0.95
                ),
                Color(
                    red: 0.70,
                    green: 0.72,
                    blue: 0.75
                )
            ]
            
        case .cherry:
            return [
                Color(
                    red: 1.0,
                    green: 0.75,
                    blue: 0.85
                ),
                Color(
                    red: 0.96,
                    green: 0.55,
                    blue: 0.73
                )
            ]
        }
    }
    
    var iconColor: Color {
        switch style {
        case .pink:
            return .white
            
        case .silver:
            return Color(
                red: 0.35,
                green: 0.36,
                blue: 0.39
            )
            
        case .cherry:
            return .white
        }
    }
    
    var titleColor: Color {
        switch style {
        case .pink:
            return .white
            
        case .silver:
            return Color(
                red: 0.25,
                green: 0.26,
                blue: 0.29
            )
            
        case .cherry:
            return .white
        }
    }
    
    var subtitleColor: Color {
        switch style {
        case .pink:
            return .white.opacity(0.80)
            
        case .silver:
            return Color(
                red: 0.30,
                green: 0.31,
                blue: 0.34
            )
            .opacity(0.70)
            
        case .cherry:
            return .white.opacity(0.80)
        }
    }
    
    var body: some View {
        
        HStack(spacing: 16) {
            
            // アイコン
            ZStack {
                Circle()
                    .fill(
                        Color.white.opacity(
                            style == .silver ? 0.65 : 0.18
                        )
                    )
                    .frame(
                        width: 54,
                        height: 54
                    )
                
                Image(systemName: systemImage)
                    .font(
                        .system(
                            size: 23,
                            weight: .semibold
                        )
                    )
                    .foregroundColor(iconColor)
            }
            
            
            // タイトル
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                
                Text(title)
                    .font(
                        .system(
                            size: 17,
                            weight: .semibold,
                            design: .rounded
                        )
                    )
                    .foregroundColor(titleColor)
                
                Text(subtitle)
                    .font(
                        .system(
                            size: 10,
                            weight: .regular
                        )
                    )
                    .foregroundColor(subtitleColor)
                    .lineLimit(2)
            }
            
            
            Spacer()
            
            
            Image(systemName: "chevron.right")
                .font(
                    .system(
                        size: 13,
                        weight: .semibold
                    )
                )
                .foregroundColor(
                    style == .silver
                    ? Color.gray.opacity(0.55)
                    : Color.white.opacity(0.75)
                )
        }
        .padding(.horizontal, 18)
        .frame(
            maxWidth: .infinity,
            minHeight: 82
        )
        .background(
            LinearGradient(
                colors: backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 24
            )
            .stroke(
                Color.white.opacity(
                    style == .silver ? 0.70 : 0.35
                ),
                lineWidth: 1.5
            )
        )
        .shadow(
            color: Color.black.opacity(0.10),
            radius: 12,
            x: 0,
            y: 7
        )
    }
}


#Preview {
    ContentView()
}
