import SwiftUI

struct InfoView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("sources_nav_title")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(.black)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.title2)
                            .foregroundStyle(.black)
                    }

                }
                Text("sources_title")
                    .font(.title2.bold())
                    .foregroundStyle(.black)
                
                Group {
                    Text("sources_description")
                        .font(.body)
                        .foregroundStyle(.black)
                    
                    Link("• Fitzpatrick17k", destination: URL(string: "https://github.com/mattgroh/fitzpatrick17k")!)
                    
                    Link("• DERMNET", destination: URL(string: "https://www.kaggle.com/datasets/shubhamgoel27/dermnet")!)
                    
                    Link("• PAD-UFES-20", destination: URL(string: "https://www.kaggle.com/datasets/mahdavi1202/skin-cancer")!)
                }
                .font(.callout)
                .foregroundColor(.blue)
                
                Divider()
                
                Text("sources_warning_title")
                    .font(.title3.bold())
                    .foregroundStyle(.black)
                
                Text("sources_warning_description")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color.white)
    }
}

#Preview {
    InfoView()
}
