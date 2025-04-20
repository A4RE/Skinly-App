import SwiftUI

struct SaveSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    let size = UIScreen.main.bounds.size
    var completion: () -> (Void)
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Выберите вариант сохранения")
                .foregroundStyle(Color.appPrimaryText)
                .font(.title2.bold())
                .padding(.top, 24)

            Button(action: {
                completion()
                dismiss()
            }) {
                Text("Новое сканирование")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appAccent)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Button(action: {
                completion()
                dismiss()
            }) {
                Text("Добавить в существующее")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appSecondaryBackground)
                    .foregroundColor(.appPrimaryText)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Button(action: {
                dismiss()
            }) {
                Text("Закрыть")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appSecondaryBackground)
                    .foregroundColor(.appPrimaryText)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .presentationDetents([.fraction(size.height < 737 ? 0.48 : 0.38)])
        .presentationCornerRadius(20)
        .background(Color.appBackground)
    }
}
