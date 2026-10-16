import SwiftUI


@StateObject private var cameraManager = CameraManager()

var body: some View {
    
    ZStack {
        
        CameraPreview(session: cameraManager.session)
            .mask(
                Image("mirrorMask")
                    .resizable()
                    .scaledToFit()
            )
        
        Image("mirrorFrame")
            .resizable()
            .scaledToFit()
            .allowsHitTesting(false)
    }
    .onAppear {
        cameraManager.setupCamera()
    }
}


#Preview {
    RealView()
}
