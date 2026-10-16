import SwiftUI

struct CameraView: View {

    @StateObject var camera = CameraModel()

    var body: some View {

        ZStack {

            CameraPreview(session: camera.session)
                .ignoresSafeArea()

            VStack {

                Spacer()

                Button {

                    camera.takePhoto()

                } label: {

                    Circle()
                        .fill(.white)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 2)
                        )
                }
                .padding(.bottom, 50)
            }
        }
    }
}
