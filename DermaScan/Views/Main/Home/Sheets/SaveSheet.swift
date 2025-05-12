import SwiftUI

struct SaveSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    let size = UIScreen.main.bounds.size
    var completion: (_ isNewCase: Bool) -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Выберите вариант сохранения")
                .foregroundStyle(Color.appPrimaryText)
                .font(.title2.bold())
                .padding(.top, 24)

            Button(action: {
                completion(true)
                dismiss()
            }) {
                Text("Новое сканирование")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appAccent)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)

            Button(action: {
                completion(false)
                dismiss()
            }) {
                Text("Добавить в существующее")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appSecondaryBackground)
                    .foregroundColor(.appPrimaryText)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
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
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .presentationDetents([.fraction(size.height < 737 ? 0.48 : 0.38)])
        .presentationCornerRadius(20)
        .background(Color.appBackground)
    }
}
