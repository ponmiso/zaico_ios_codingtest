import SwiftUI

struct CreateView: View {
    @State private var title: String = ""
    
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
                print("tapped button: \(title)")
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

#Preview {
    CreateView()
}
