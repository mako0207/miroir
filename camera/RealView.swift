import SwiftUI
import AVFoundation
import UIKit
import Combine

struct RealView: View {
    
    @StateObject private var cameraManager = CameraManager()
    
    // 画面の拡大率
    @State private var sceneScale: CGFloat = 1.0
    
    // さくらんぼ
    @State private var cherries: [FallingCherry] = []
    
    // 物理計算
    private let timer = Timer.publish(
        every: 1.0 / 30.0,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                // ==================================================
                // 背景
                // ==================================================
                LinearGradient(
                    colors: [
                        Color(red: 0.72, green: 0.74, blue: 0.76),
                        Color(red: 0.91, green: 0.92, blue: 0.93),
                        Color(red: 0.78, green: 0.80, blue: 0.82)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                
                // 背景の柔らかい光
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 220, height: 220)
                    .blur(radius: 45)
                    .offset(
                        x: -geometry.size.width * 0.32,
                        y: -geometry.size.height * 0.36
                    )
                
                Circle()
                    .fill(
                        Color(
                            red: 1.0,
                            green: 0.68,
                            blue: 0.80
                        )
                        .opacity(0.10)
                    )
                    .frame(width: 230, height: 230)
                    .blur(radius: 50)
                    .offset(
                        x: geometry.size.width * 0.32,
                        y: geometry.size.height * 0.30
                    )
                
                
                // ==================================================
                // 落下中のさくらんぼ
                // ★ 鏡より後ろ
                // ==================================================
                ForEach(
                    cherries.filter { !$0.isLanded }
                ) { cherry in
                    
                    FallingCherryView(size: cherry.size)
                        .frame(
                            width: cherry.size,
                            height: cherry.size
                        )
                        .position(
                            x: cherry.x,
                            y: cherry.y
                        )
                        .zIndex(1)
                }
                
                
                // ==================================================
                // 手鏡本体
                // ==================================================
                VStack(spacing: 0) {
                    
                    ZStack {
                        
                        let mirrorWidth =
                            geometry.size.width * 0.84
                        
                        let mirrorHeight =
                            geometry.size.height * 0.55
                        
                        
                        // ==================================================
                        // 外側の韓国コスメ風フレーム
                        // ==================================================
                        RoundedRectangle(
                            cornerRadius: mirrorWidth * 0.43
                        )
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    Color(
                                        red: 1.0,
                                        green: 0.94,
                                        blue: 0.97
                                    ),
                                    Color(
                                        red: 1.0,
                                        green: 0.78,
                                        blue: 0.88
                                    ),
                                    Color(
                                        red: 0.96,
                                        green: 0.64,
                                        blue: 0.80
                                    ),
                                    Color.white
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(
                            width: mirrorWidth + 30,
                            height: mirrorHeight + 30
                        )
                        .shadow(
                            color: Color.black.opacity(0.22),
                            radius: 18,
                            x: 0,
                            y: 12
                        )
                        
                        
                        // ==================================================
                        // ピンクパール風の縁
                        // ==================================================
                        RoundedRectangle(
                            cornerRadius: mirrorWidth * 0.405
                        )
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.98),
                                    Color(
                                        red: 1.0,
                                        green: 0.67,
                                        blue: 0.82
                                    ).opacity(0.95),
                                    Color.white.opacity(0.55),
                                    Color(
                                        red: 0.96,
                                        green: 0.55,
                                        blue: 0.73
                                    ).opacity(0.9)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 5
                        )
                        .frame(
                            width: mirrorWidth + 12,
                            height: mirrorHeight + 12
                        )
                        .allowsHitTesting(false)
                        
                        
                        // ==================================================
                        // 鏡面
                        // ==================================================
                        RoundedRectangle(
                            cornerRadius: mirrorWidth * 0.38
                        )
                        .fill(Color.black)
                        .frame(
                            width: mirrorWidth,
                            height: mirrorHeight
                        )
                        
                        
                        // ==================================================
                        // カメラ映像
                        // ★ 映像には線を付けない
                        // ==================================================
                        CameraPreview(
                            session: cameraManager.session
                        )
                        .frame(
                            width: mirrorWidth,
                            height: mirrorHeight
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: mirrorWidth * 0.38
                            )
                        )
                        
                        
                        // ==================================================
                        // 鏡面の透明な反射
                        // ==================================================
                        RoundedRectangle(
                            cornerRadius: mirrorWidth * 0.38
                        )
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.08),
                                    Color.clear,
                                    Color.clear,
                                    Color.white.opacity(0.03)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(
                            width: mirrorWidth,
                            height: mirrorHeight
                        )
                        .allowsHitTesting(false)
                        
                        
                        // ==================================================
                        // ハート
                        // ==================================================
                        Image(systemName: "heart.fill")
                            .font(
                                .system(
                                    size: 14,
                                    weight: .regular
                                )
                            )
                            .foregroundColor(
                                Color(
                                    red: 1.0,
                                    green: 0.55,
                                    blue: 0.70
                                )
                                .opacity(0.82)
                            )
                            .offset(
                                x: -mirrorWidth * 0.30,
                                y: mirrorHeight * 0.27
                            )
                            .allowsHitTesting(false)
                        
                        
                        // ==================================================
                        // キラキラ
                        // ==================================================
                        Image(systemName: "sparkles")
                            .font(
                                .system(
                                    size: 19,
                                    weight: .medium
                                )
                            )
                            .foregroundColor(
                                Color.white.opacity(0.92)
                            )
                            .offset(
                                x: mirrorWidth * 0.29,
                                y: -mirrorHeight * 0.30
                            )
                            .allowsHitTesting(false)
                        
                        
                        // ==================================================
                        // ほんのりした鏡面反射
                        // 「棒」に見えるものは使わない
                        // ==================================================
                        Ellipse()
                            .fill(Color.white.opacity(0.035))
                            .frame(
                                width: mirrorWidth * 0.28,
                                height: mirrorHeight * 0.60
                            )
                            .rotationEffect(.degrees(-25))
                            .offset(
                                x: -mirrorWidth * 0.18,
                                y: -mirrorHeight * 0.04
                            )
                            .blur(radius: 12)
                            .allowsHitTesting(false)
                    }
                    
                    
                    // ==================================================
                    // 手鏡の首
                    // ==================================================
                    RoundedRectangle(
                        cornerRadius: 14
                    )
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color(
                                    red: 1.0,
                                    green: 0.76,
                                    blue: 0.86
                                ),
                                Color(
                                    red: 0.96,
                                    green: 0.58,
                                    blue: 0.76
                                ),
                                Color.white
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: geometry.size.width * 0.18,
                        height: 34
                    )
                    .shadow(
                        color: .black.opacity(0.15),
                        radius: 5,
                        y: 4
                    )
                    
                    
                    // ==================================================
                    // 長い取手
                    // ==================================================
                    ZStack {
                        
                        RoundedRectangle(
                            cornerRadius: 30
                        )
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.98),
                                    Color(
                                        red: 1.0,
                                        green: 0.80,
                                        blue: 0.89
                                    ),
                                    Color(
                                        red: 1.0,
                                        green: 0.57,
                                        blue: 0.77
                                    ),
                                    Color(
                                        red: 1.0,
                                        green: 0.83,
                                        blue: 0.91
                                    )
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        
                        
                        // 取手の縁
                        RoundedRectangle(
                            cornerRadius: 30
                        )
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    Color(
                                        red: 0.74,
                                        green: 0.76,
                                        blue: 0.80
                                    ),
                                    Color.white
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2.5
                        )
                        
                        
                        // 取手中央の光
                        RoundedRectangle(
                            cornerRadius: 20
                        )
                        .fill(
                            Color.white.opacity(0.23)
                        )
                        .frame(
                            width: 8,
                            height: geometry.size.height * 0.14
                        )
                        .blur(radius: 0.5)
                        
                        
                        // ==================================================
                        // さくらんぼボタン
                        // ==================================================
                        Button {
                            
                            // 少しずつ拡大
                            withAnimation(
                                .easeInOut(
                                    duration: 0.45
                                )
                            ) {
                                sceneScale = min(
                                    sceneScale + 0.025,
                                    1.15
                                )
                            }
                            
                            // さくらんぼを落とす
                            dropCherries(
                                in: geometry.size
                            )
                            
                        } label: {
                            
                            CherryDecoration()
                                .frame(
                                    width: 110,
                                    height: 110
                                )
                        }
                        .buttonStyle(.plain)
                        .contentShape(Circle())
                        .offset(
                            y: geometry.size.height * 0.075
                        )
                        .accessibilityLabel(
                            "さくらんぼを落とす"
                        )
                    }
                    .frame(
                        width: geometry.size.width * 0.22,
                        height: geometry.size.height * 0.25
                    )
                    .shadow(
                        color: .black.opacity(0.18),
                        radius: 10,
                        x: 0,
                        y: 8
                    )
                }
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height * 0.47
                )
                .scaleEffect(sceneScale)
                
                
                // ==================================================
                // 着地したさくらんぼ
                // ==================================================
                ForEach(
                    cherries.filter { $0.isLanded }
                ) { cherry in
                    
                    FallingCherryView(
                        size: cherry.size
                    )
                    .frame(
                        width: cherry.size,
                        height: cherry.size
                    )
                    .position(
                        x: cherry.x,
                        y: cherry.y
                    )
                    .zIndex(20)
                }
                
                
                // ==================================================
                // ロゴ
                // ==================================================
                VStack {
                    
                    Spacer()
                    
                    Text("miroir")
                        .font(
                            .system(
                                size: 15,
                                weight: .medium,
                                design: .rounded
                            )
                        )
                        .tracking(3)
                        .foregroundColor(
                            Color.white.opacity(0.82)
                        )
                    
                    Text("REAL MIRROR")
                        .font(
                            .system(
                                size: 8,
                                weight: .regular
                            )
                        )
                        .tracking(2)
                        .foregroundColor(
                            Color.white.opacity(0.62)
                        )
                        .padding(.top, 2)
                    
                    Spacer()
                        .frame(height: 22)
                }
                .zIndex(30)
            }
            .scaleEffect(sceneScale)
            .onReceive(timer) { _ in
                updateCherryPhysics(
                    in: geometry.size
                )
            }
        }
        .onAppear {
            cameraManager.setupCamera()
        }
    }
    
    
    // ==================================================
    // MARK: - さくらんぼを落とす
    // ==================================================
    
    private func dropCherries(in size: CGSize) {
        
        // 1回で3個
        let numberOfCherries = 3
        
        for _ in 0..<numberOfCherries {
            
            let newCherry = FallingCherry(
                x: CGFloat.random(
                    in: size.width * 0.10 ...
                    size.width * 0.90
                ),
                y: -80,
                velocityY: CGFloat.random(
                    in: 0...2
                ),
                velocityX: CGFloat.random(
                    in: -0.8...0.8
                ),
                size: CGFloat.random(
                    in: 78...96
                ),
                isLanded: false
            )
            
            cherries.append(newCherry)
        }
        
        // 多くなりすぎないようにする
        if cherries.count > 35 {
            cherries.removeFirst(
                cherries.count - 35
            )
        }
        
        let generator =
            UIImpactFeedbackGenerator(
                style: .light
            )
        
        generator.impactOccurred()
    }
    
    
    // ==================================================
    // MARK: - さくらんぼの簡易物理
    // ==================================================
    
    private func updateCherryPhysics(
        in size: CGSize
    ) {
        
        guard !cherries.isEmpty else {
            return
        }
        
        let gravity: CGFloat = 0.85
        
        for index in cherries.indices {
            
            if cherries[index].isLanded {
                continue
            }
            
            // 重力
            cherries[index].velocityY += gravity
            
            // 移動
            cherries[index].y +=
                cherries[index].velocityY
            
            cherries[index].x +=
                cherries[index].velocityX
            
            
            // 空気抵抗
            cherries[index].velocityX *= 0.995
            
            
            let radius =
                cherries[index].size / 2
            
            
            // ==================================================
            // 左右の壁
            // ==================================================
            if cherries[index].x < radius {
                
                cherries[index].x = radius
                cherries[index].velocityX *= -0.45
            }
            
            if cherries[index].x >
                size.width - radius {
                
                cherries[index].x =
                    size.width - radius
                
                cherries[index].velocityX *= -0.45
            }
            
            
            // ==================================================
            // 床
            // ==================================================
            let floorY =
                size.height * 0.92
            
            if cherries[index].y + radius >= floorY {
                
                cherries[index].y =
                    floorY - radius
                
                cherries[index].velocityY *= -0.15
                
                if abs(
                    cherries[index].velocityY
                ) < 1.5 {
                    
                    cherries[index].velocityY = 0
                    cherries[index].isLanded = true
                }
            }
            
            
            // ==================================================
            // 他のさくらんぼとの衝突
            // ==================================================
            for otherIndex in cherries.indices {
                
                if index == otherIndex {
                    continue
                }
                
                let other =
                    cherries[otherIndex]
                
                let dx =
                    cherries[index].x - other.x
                
                let dy =
                    cherries[index].y - other.y
                
                let distance =
                    sqrt(
                        dx * dx +
                        dy * dy
                    )
                
                let minimumDistance =
                    (
                        cherries[index].size +
                        other.size
                    ) / 2
                
                if distance > 0 &&
                    distance < minimumDistance {
                    
                    let push =
                        minimumDistance -
                        distance
                    
                    let nx =
                        dx / distance
                    
                    let ny =
                        dy / distance
                    
                    // 横に押し出す
                    cherries[index].x +=
                        nx * push * 0.35
                    
                    // 上に押し上げる
                    if ny < 0.2 &&
                        cherries[index].velocityY > 0 {
                        
                        cherries[index].y -=
                            push * 0.55
                        
                        cherries[index].velocityY *=
                            -0.15
                        
                        cherries[index].velocityX *=
                            0.92
                        
                        if abs(
                            cherries[index].velocityY
                        ) < 1.2 {
                            
                            cherries[index].velocityY = 0
                            cherries[index].isLanded = true
                        }
                    }
                }
            }
        }
    }
}


// ==================================================
// MARK: - さくらんぼデータ
// ==================================================

private struct FallingCherry: Identifiable {
    
    let id = UUID()
    
    var x: CGFloat
    var y: CGFloat
    
    var velocityY: CGFloat
    var velocityX: CGFloat
    
    let size: CGFloat
    
    var isLanded: Bool
}


// ==================================================
// MARK: - 取手のさくらんぼ
// ==================================================

private struct CherryDecoration: View {
    
    var body: some View {
        
        ZStack {
            
            // 茎
            Capsule()
                .stroke(
                    Color(
                        red: 0.30,
                        green: 0.58,
                        blue: 0.28
                    ),
                    lineWidth: 2.4
                )
                .frame(
                    width: 42,
                    height: 32
                )
                .rotationEffect(
                    .degrees(22)
                )
                .offset(
                    x: 4,
                    y: -19
                )
            
            
            // 葉
            Ellipse()
                .fill(
                    Color(
                        red: 0.55,
                        green: 0.78,
                        blue: 0.43
                    )
                )
                .frame(
                    width: 25,
                    height: 12
                )
                .rotationEffect(
                    .degrees(-25)
                )
                .offset(
                    x: 15,
                    y: -23
                )
            
            
            // 左の実
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(
                                red: 1.0,
                                green: 0.44,
                                blue: 0.57
                            ),
                            Color(
                                red: 0.88,
                                green: 0.15,
                                blue: 0.30
                            )
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(
                    width: 36,
                    height: 36
                )
                .overlay(
                    Circle()
                        .fill(
                            Color.white.opacity(0.45)
                        )
                        .frame(
                            width: 9,
                            height: 9
                        )
                        .offset(
                            x: -8,
                            y: -8
                        )
                )
                .offset(
                    x: -15,
                    y: 4
                )
            
            
            // 右の実
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(
                                red: 1.0,
                                green: 0.51,
                                blue: 0.63
                            ),
                            Color(
                                red: 0.90,
                                green: 0.18,
                                blue: 0.33
                            )
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(
                    width: 36,
                    height: 36
                )
                .overlay(
                    Circle()
                        .fill(
                            Color.white.opacity(0.45)
                        )
                        .frame(
                            width: 9,
                            height: 9
                        )
                        .offset(
                            x: -8,
                            y: -8
                        )
                )
                .offset(
                    x: 15,
                    y: 7
                )
        }
    }
}


// ==================================================
// MARK: - 落下するさくらんぼ
// ==================================================

private struct FallingCherryView: View {
    
    let size: CGFloat
    
    var body: some View {
        
        ZStack {
            
            // 茎
            Capsule()
                .stroke(
                    Color(
                        red: 0.30,
                        green: 0.58,
                        blue: 0.28
                    ),
                    lineWidth:
                        max(
                            1.5,
                            size * 0.035
                        )
                )
                .frame(
                    width: size * 0.42,
                    height: size * 0.25
                )
                .rotationEffect(
                    .degrees(20)
                )
                .offset(
                    x: size * 0.04,
                    y: -size * 0.22
                )
            
            
            // 左の実
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(
                                red: 1.0,
                                green: 0.45,
                                blue: 0.58
                            ),
                            Color(
                                red: 0.88,
                                green: 0.16,
                                blue: 0.31
                            )
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(
                    width: size * 0.48,
                    height: size * 0.48
                )
                .overlay(
                    Circle()
                        .fill(
                            Color.white.opacity(0.45)
                        )
                        .frame(
                            width: size * 0.13,
                            height: size * 0.13
                        )
                        .offset(
                            x: -size * 0.13,
                            y: -size * 0.13
                        )
                )
                .offset(
                    x: -size * 0.16,
                    y: size * 0.03
                )
            
            
            // 右の実
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(
                                red: 1.0,
                                green: 0.52,
                                blue: 0.64
                            ),
                            Color(
                                red: 0.90,
                                green: 0.19,
                                blue: 0.35
                            )
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(
                    width: size * 0.48,
                    height: size * 0.48
                )
                .overlay(
                    Circle()
                        .fill(
                            Color.white.opacity(0.45)
                        )
                        .frame(
                            width: size * 0.13,
                            height: size * 0.13
                        )
                        .offset(
                            x: -size * 0.13,
                            y: -size * 0.13
                        )
                )
                .offset(
                    x: size * 0.16,
                    y: size * 0.07
                )
        }
    }
}
