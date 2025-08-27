import SwiftUI

struct HeaderView: View {
    var body: some View {
        Text("Saviour")
            .font(.footnote)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.05))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.bottom, 20)
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
