//import SwiftUI
//import AVFoundation
//import CoreImage
//import Combine
//
//// MARK: - ✨ 肌悩み・美容診断画面
//struct DiagnosisView: View {
//    @State private var isAnalyzing = false
//    @State private var showResult = false
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 24) {
//                Spacer()
//                
//                ZStack {
//                    Circle()
//                        .fill(Color.pink.opacity(0.1))
//                        .frame(width: 140, height: 140)
//                    
//                    Image(systemName: "sparkles")
//                        .font(.system(size: 60))
//                        .foregroundColor(.pink)
//                }
//                
//                VStack(spacing: 8) {
//                    Text("AI 肌悩み・パーソナルカラー診断")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                    
//                    Text("カメラで肌状態を測定し、あなたに最適なメイクやスキンケアをアドバイスします。")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal, 32)
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    startDiagnosis()
//                }) {
//                    HStack {
//                        Image(systemName: "camera.fill")
//                        Text("診断をスタート")
//                            .fontWeight(.bold)
//                    }
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.pink)
//                    .cornerRadius(16)
//                    .shadow(color: .pink.opacity(0.3), radius: 8, x: 0, y: 4)
//                }
//                .padding(.horizontal, 30)
//                .padding(.bottom, 20)
//            }
//            .navigationTitle("美容診断")
//            .sheet(isPresented: $showResult) {
//                DiagnosisResultView()
//            }
//        }
//    }
//    
//    private func startDiagnosis() {
//        // 診断処理のダミーアニメーション
//        isAnalyzing = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            isAnalyzing = false
//            showResult = true
//        }
//    }
//}
//
//#Preview {
//    BeautyDiagnosisView()
//}
