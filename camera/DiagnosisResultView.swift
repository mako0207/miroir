import SwiftUI

// MARK: - メイクテンプレート
struct MakeupTemplate {
    let name: String
    let lipColor: Color
    let cheekColor: Color
    let lipIntensity: Double
    let cheekIntensity: Double
    let balance: Double
}

// MARK: - テンプレート一覧
extension MakeupTemplate {

    static let wanHong = MakeupTemplate(
        name: "ワンホン",
        lipColor: Color(red: 0.72, green: 0.08, blue: 0.18),
        cheekColor: Color(red: 0.82, green: 0.20, blue: 0.30),
        lipIntensity: 0.85,
        cheekIntensity: 0.45,
        balance: 0.65
    )

    static let chunYu = MakeupTemplate(
        name: "純欲",
        lipColor: Color(red: 0.90, green: 0.30, blue: 0.45),
        cheekColor: Color(red: 0.95, green: 0.45, blue: 0.55),
        lipIntensity: 0.70,
        cheekIntensity: 0.55,
        balance: 0.55
    )

    static let baiTang = MakeupTemplate(
        name: "白湯",
        lipColor: Color(red: 0.78, green: 0.48, blue: 0.40),
        cheekColor: Color(red: 0.88, green: 0.60, blue: 0.52),
        lipIntensity: 0.38,
        cheekIntensity: 0.30,
        balance: 0.50
    )

    static let koreanIdol = MakeupTemplate(
        name: "韓国アイドル",
        lipColor: Color(red: 0.95, green: 0.25, blue: 0.40),
        cheekColor: Color(red: 0.95, green: 0.42, blue: 0.50),
        lipIntensity: 0.70,
        cheekIntensity: 0.65,
        balance: 0.50
    )

    static let jirai = MakeupTemplate(
        name: "地雷",
        lipColor: Color(red: 0.60, green: 0.08, blue: 0.28),
        cheekColor: Color(red: 0.70, green: 0.25, blue: 0.50),
        lipIntensity: 0.82,
        cheekIntensity: 0.40,
        balance: 0.68
    )

    static let ryosan = MakeupTemplate(
        name: "量産型",
        lipColor: Color(red: 0.90, green: 0.35, blue: 0.55),
        cheekColor: Color(red: 0.95, green: 0.45, blue: 0.65),
        lipIntensity: 0.62,
        cheekIntensity: 0.68,
        balance: 0.45
    )

    static let tenmei = MakeupTemplate(
        name: "テンメイ",
        lipColor: Color(red: 1.00, green: 0.42, blue: 0.45),
        cheekColor: Color(red: 1.00, green: 0.55, blue: 0.45),
        lipIntensity: 0.60,
        cheekIntensity: 0.58,
        balance: 0.50
    )

    static let kitsune = MakeupTemplate(
        name: "キツネ",
        lipColor: Color(red: 0.68, green: 0.22, blue: 0.12),
        cheekColor: Color(red: 0.65, green: 0.30, blue: 0.20),
        lipIntensity: 0.72,
        cheekIntensity: 0.30,
        balance: 0.72
    )

    static let hakanai = MakeupTemplate(
        name: "儚い",
        lipColor: Color(red: 0.88, green: 0.65, blue: 0.75),
        cheekColor: Color(red: 0.78, green: 0.70, blue: 0.85),
        lipIntensity: 0.28,
        cheekIntensity: 0.22,
        balance: 0.50
    )

    static let all: [MakeupTemplate] = [
        .wanHong,
        .chunYu,
        .baiTang,
        .koreanIdol,
        .jirai,
        .ryosan,
        .tenmei,
        .kitsune,
        .hakanai
    ]
}


// MARK: - 診断結果
struct DiagnosisResultView: View {

    @Environment(\.dismiss) var dismiss

    @State private var selectedTemplate = "純欲"

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    // 1. パーソナルカラー
                    VStack(alignment: .leading, spacing: 10) {

                        HStack {
                            Image(systemName: "paintpalette.fill")
                                .foregroundColor(.pink)

                            Text("あなたのパーソナルカラー")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        Text("ブルベ夏（Summer）")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.pink)

                        Text("透明感のある青み寄りカラーや、明るくソフトなトーンがよく映えるタイプです。")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)


                    // 2. 肌状態
                    VStack(alignment: .leading, spacing: 16) {

                        Text("肌状態の分析結果")
                            .font(.headline)

                        scoreRow(title: "キメ・ツヤ感", score: 85)
                        scoreRow(title: "水分・油分バランス", score: 72)
                        scoreRow(title: "肌の透明感", score: 90)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)


                    // 3. メイクテンプレート
                    VStack(alignment: .leading, spacing: 14) {

                        HStack {
                            Image(systemName: "wand.and.stars")
                                .foregroundColor(.pink)

                            Text("メイクテンプレート")
                                .font(.headline)
                        }

                        Text("テンプレートを選ぶと、リップ・チークの設定をまとめて変更できます。")
                            .font(.footnote)
                            .foregroundColor(.secondary)


                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 12
                        ) {

                            ForEach(MakeupTemplate.all, id: \.name) { template in

                                Button {

                                    selectedTemplate = template.name

                                } label: {

                                    VStack(spacing: 7) {

                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        template.lipColor,
                                                        template.cheekColor
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 42, height: 42)

                                        Text(template.name)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        selectedTemplate == template.name
                                        ? Color.pink.opacity(0.16)
                                        : Color(.systemGray6)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(
                                                selectedTemplate == template.name
                                                ? Color.pink
                                                : Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                                    .cornerRadius(14)
                                }
                            }
                        }


                        // 選択中テンプレート
                        if let template = MakeupTemplate.all.first(
                            where: { $0.name == selectedTemplate }
                        ) {

                            VStack(alignment: .leading, spacing: 12) {

                                Text("「\(template.name)」を選択中")
                                    .font(.subheadline)
                                    .fontWeight(.bold)

                                HStack {
                                    Text("リップ")
                                    Spacer()

                                    Circle()
                                        .fill(template.lipColor)
                                        .frame(width: 24, height: 24)

                                    Text("\(Int(template.lipIntensity * 100))%")
                                        .font(.caption)
                                }

                                HStack {
                                    Text("チーク")
                                    Spacer()

                                    Circle()
                                        .fill(template.cheekColor)
                                        .frame(width: 24, height: 24)

                                    Text("\(Int(template.cheekIntensity * 100))%")
                                        .font(.caption)
                                }

                                HStack {
                                    Text("バランス")
                                    Spacer()

                                    Text("\(Int(template.balance * 100))%")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                            }
                            .padding()
                            .background(Color.pink.opacity(0.08))
                            .cornerRadius(14)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)


                    // 4. アドバイス
                    VStack(alignment: .leading, spacing: 10) {

                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.orange)

                            Text("今日のアドバイス")
                                .font(.headline)
                        }

                        Text("青みピンクのリップやラベンダー系のチークを合わせると、肌の透明感がより引き立ちます。")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.pink.opacity(0.1))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("診断結果")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {
                        dismiss()
                    }
                }
            }
        }
    }


    // MARK: - スコアバー
    private func scoreRow(title: String, score: Int) -> some View {

        VStack(spacing: 4) {

            HStack {
                Text(title)

                Spacer()

                Text("\(score)点")
                    .bold()
                    .foregroundColor(.pink)
            }

            GeometryReader { geometry in

                ZStack(alignment: .leading) {

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.pink)
                        .frame(
                            width: geometry.size.width * CGFloat(score) / 100,
                            height: 8
                        )
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    DiagnosisResultView()
}
