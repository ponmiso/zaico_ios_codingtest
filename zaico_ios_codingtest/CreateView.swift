import SwiftUI

struct CreateView: View {
    @State private var title: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("タイトル")
                TextField("", text: $title)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button {
                createInventories()
            } label: {
                Text("作成する")
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.orange)
            }
        }
    }
}

extension CreateView {
    private func createInventories() {
        if title.isEmpty {
            print("title is empty")
            return
        }
        Task {
            do {
                try await APIClient.shared.createInventories(title: title)
                dismiss()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    CreateView()
}
