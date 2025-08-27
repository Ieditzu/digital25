import SwiftUI

struct HeaderView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Text("Safer")
                .font(.title2)
                .bold()
                .foregroundColor(colorScheme == .dark ? Color.blue : .white)
                .padding(.leading, 20)
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6).opacity(0.9) : Color.blue.opacity(0.9))
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
        )
        .padding(.horizontal, 16)
        .padding(.top, 5)    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HeaderView()
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
            
            HeaderView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
        .previewLayout(.sizeThatFits)
    }
}
