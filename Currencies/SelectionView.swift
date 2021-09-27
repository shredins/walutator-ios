import SwiftUI

struct SelectionView<Content: View, Selection: Equatable>: View {
    
    @Binding private var isSelected: Selection

    private let content: Content
    private let id: Selection
    private var selectedColor = Color.accentColor.opacity(0.8)
    private var unselectedColor = Color.clear
    
    init(isSelected: Binding<Selection>, id: Selection, @ViewBuilder content: () -> Content) {
        self._isSelected = isSelected
        self.id = id
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            (isSelected == id ? selectedColor : unselectedColor)
                .cornerRadius(7)
            content
                .padding(6)
        }
        .onTapGesture {
            isSelected = id
        }
    }
    
    func selectedColor(_ value: Color) -> Self {
        var view = self
        view.selectedColor = value
        return view
    }
    
    func unselectedColor(_ value: Color) -> Self {
        var view = self
        view.unselectedColor = value
        return view
    }
}

struct SelectionViewPreviews: PreviewProvider {
    static var previews: some View {
        let binding = Binding<Bool?>(get: { true }, set: { _ in })
        
        return SelectionView(isSelected: binding, id: true) {
            VStack(alignment: .leading) {
                Text("Hello!")
                    .font(.headline)
                Text("Welcome")
                    .font(.subheadline)
            }
        }
        .fixedSize()
    }
}
