import SwiftUI

enum ImageSource {
    case camera
    case gallery
    case files
}

struct SourceSelectionSheet: View {
    @ObservedObject var viewModel: HomeViewModel
    var onSelectSource: (ImageSource) -> Void
    
    let size = UIScreen.main.bounds.size

    var body: some View {
        ZStack {
            Color.appBackground
            VStack(spacing: 24) {
                Text("choose_source")
                    .foregroundStyle(Color.appPrimaryText)
                    .font(.title2.bold())
                    .padding(.top, 15)
                
                Button(action: {
                    onSelectSource(.camera)
                    viewModel.showSourceSelectionSheet = false
                }) {
                    Text("source_camera")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appAccent)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                Button(action: {
                    onSelectSource(.gallery)
                    viewModel.showSourceSelectionSheet = false
                }) {
                    Text("source_gallery")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appAccent)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                Button(action: {
                    onSelectSource(.files)
                    viewModel.showSourceSelectionSheet = false
                }) {
                    Text("source_files")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appAccent)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                Button(action: {
                    viewModel.showSourceSelectionSheet = false
                }) {
                    Text("close")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appDanger)
                        .foregroundColor(.appPrimaryText)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .presentationDetents([.fraction(size.height < 737 ? 0.6 : 0.48)])
        .presentationCornerRadius(20)
        .ignoresSafeArea(.all)
    }
}
