import SwiftUI
import Photos
import AVFoundation

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var imageEditingModel = ImageEditingModel()
    
    @EnvironmentObject private var historyViewModel: HistoryListViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @State private var isShowingImagePicker = false
    @State private var selectedSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingCameraAlert = false
    @State private var isShowingPhotoLibraryAlert = false
    @State private var isShowingScanEditor = false
    @State private var isShowingAIWorkView = false
    @State private var isShowingResultView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                createHeader()
                Spacer()
                createPhotoGuide()
                Spacer()
                createScanButton()
            }
            .background(Color.appBackground)
            .sheet(isPresented: $viewModel.showSourceSelectionSheet) {
                SourceSelectionSheet(viewModel: viewModel) { source in
                    handleImageSource(source)
                }
            }
            .fullScreenCover(isPresented: $isShowingScanEditor) {
                if let selectedImage = imageEditingModel.originalImage {
                    ImageEditingView(image: selectedImage) { croppedImage in
                        if let croppedImage = croppedImage {
                            self.imageEditingModel.originalImage = croppedImage
                            self.isShowingAIWorkView = true
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowingAIWorkView, content: {
                if let croppedImage = imageEditingModel.originalImage {
                    AnalyzingView(image: croppedImage) { _ in
                        self.isShowingResultView = true
                    }
                }
            })
            .fullScreenCover(isPresented: $isShowingResultView, content: {
                if let croppedImage = imageEditingModel.originalImage {
                    ResultView(image: croppedImage, diagnosis: DiagnosisResult(label: "Акне", riskLevel: .looking))
                }
            })
            .fullScreenCover(isPresented: $isShowingImagePicker) {
                ImagePicker(sourceType: selectedSourceType) { image in
                    imageEditingModel.originalImage = image
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        isShowingScanEditor = true
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Skinly")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color.appPrimaryText)
                }
            }
            .alert("Нет доступа к камере", isPresented: $isShowingCameraAlert) {
                Button("Открыть настройки") {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                }
                Button("Отмена", role: .cancel) { }
            } message: {
                Text("Пожалуйста, разрешите доступ к камере в настройках устройства.")
            }
            .alert("Нет доступа к библиотеке фотографий", isPresented: $isShowingPhotoLibraryAlert) {
                Button("Открыть настройки") {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                }
                Button("Отмена", role: .cancel) { }
            } message: {
                Text("Пожалуйста, разрешите доступ к библиотеке фотографий в настройках устройства.")
            }
        }
    }
    
    @ViewBuilder
    private func createHeader() -> some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
                    .foregroundStyle(Color.appPrimaryText)
                VStack(alignment: .leading) {
                    Text("Cканирований")
                        .font(.headline)
                        .foregroundColor(.appPrimaryText)
                    Text("\(profileViewModel.statistics.totalScans)")
                        .foregroundColor(.appSecondaryText)
                }
            }
            Spacer()
            HStack {
                Image(systemName: "pencil.and.list.clipboard")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
                    .foregroundStyle(Color.appPrimaryText)
                VStack(alignment: .leading) {
                    Text("Последний")
                        .font(.headline)
                        .foregroundColor(.appPrimaryText)
                    Text("14.07.2025")
                        .foregroundColor(.appSecondaryText)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    @ViewBuilder
    private func createScanButton() -> some View {
        Button(action: {
            viewModel.showSourceSelectionSheet.toggle()
        }) {
            Text("Сканировать")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.appAccent)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
        }
        .padding(.bottom)
    }
    
    @ViewBuilder
    private func createPhotoGuide() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "camera.viewfinder")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.appSecondaryText)
            
            Text("Начните первое сканирование!")
                .font(.headline)
                .foregroundColor(.appSecondaryText)
            
            Text("📷 Фотографируйте при хорошем освещении.\nИзбегайте теней.\nФокусируйтесь на нужной области кожи.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
    }
    
    private func handleImageSource(_ source: ImageSource) {
        switch source {
        case .camera:
            checkCameraPermissionAndOpen()
        case .gallery:
            checkPhotoLibraryPermissionAndOpen()
        case .files:
            break
        }
    }

    private func checkCameraPermissionAndOpen() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch cameraAuthorizationStatus {
        case .authorized:
            selectedSourceType = .camera
            isShowingImagePicker = true

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.selectedSourceType = .camera
                        self.isShowingImagePicker = true
                    } else {
                        self.isShowingCameraAlert = true
                    }
                }
            }

        case .denied, .restricted:
            DispatchQueue.main.async {
                self.isShowingCameraAlert = true
            }

        @unknown default:
            break
        }
    }

    private func checkPhotoLibraryPermissionAndOpen() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch photoAuthorizationStatus {
        case .authorized, .limited:
            selectedSourceType = .photoLibrary
            isShowingImagePicker = true

        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        self.selectedSourceType = .photoLibrary
                        self.isShowingImagePicker = true
                    } else {
                        self.isShowingPhotoLibraryAlert = true
                    }
                }
            }

        case .denied, .restricted:
            DispatchQueue.main.async {
                self.isShowingPhotoLibraryAlert = true
            }

        @unknown default:
            break
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ProfileViewModel())
        .environmentObject(HistoryListViewModel())
}
