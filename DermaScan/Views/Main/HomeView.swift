import SwiftUI
import Photos
import AVFoundation
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject private var historyViewModel: HistoryListViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var imageEditingModel = ImageEditingModel()
    
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
                if historyViewModel.scanCases.count == 0 {
                    createEmptyListView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    createHeader()
                    Spacer()
                    createScanButton()
                        .padding(.bottom, 10)
                }
            }
            .onAppear {
                historyViewModel.loadCases(context: modelContext)
                profileViewModel.updateStatistics(from: historyViewModel)
            }
            .onReceive(NotificationCenter.default.publisher(for: .didAddNewScan)) { _ in
                historyViewModel.loadCases(context: modelContext)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
            .ignoresSafeArea(.all)
            .toolbarBackground(.white, for: .navigationBar)
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
    
    @ViewBuilder
    private func createHeader() -> some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    StatisticsView(statistics: profileViewModel.statistics)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    createHistoryButton()
                        .padding(.vertical, 10)
                    Text("Последние сканирования")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.appPrimaryText)
                    ForEach(historyViewModel.scanCases.prefix(5)) { scanCase in
                        if let scan = scanCase.scans.last {
                            ScanItemView(scan: scan)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .padding(.horizontal)
                .padding(.top, geometry.size.height * 0.13)
            }
        }
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
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
        }
        .padding(.bottom)
    }
    
    @ViewBuilder
    private func createHistoryButton() -> some View {
        NavigationLink(destination: HistoryListView()) {
            Text("История сканирований")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.appAccent)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    @ViewBuilder
    private func createEmptyListView() -> some View {
        VStack(spacing: 15) {
            ZStack {
                Image(systemName: "pencil.and.list.clipboard")
                    .resizable()
                    .foregroundStyle(Color.appSecondaryText)
                    .scaledToFit()
                    .frame(height: 100)
                    .offset(x: 8)
                Circle()
                    .stroke(Color.appSecondaryText, lineWidth: 2)
                    .frame(height: 150)
            }
            Text("История сканирований пуста")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.appSecondaryText)
            Text("Сделайте снимок кожи для проведения анализа на кожные заболевания, включая невус и меланому.")
                .font(.headline)
                .fontWeight(.regular)
                .foregroundStyle(Color.appSecondaryText)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            createScanButton()
        }
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
        .environmentObject(ProfileViewModel())
        .environmentObject(HistoryListViewModel())
}
