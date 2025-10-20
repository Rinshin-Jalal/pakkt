import SwiftUI

// MARK: - Text Field
struct PakktTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String?
    let style: PakktInputStyle

    init(
        _ placeholder: String,
        text: Binding<String>,
        icon: String? = nil,
        style: PakktInputStyle = .glass
    ) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.style = style
    }

    var body: some View {
        HStack(spacing: PakktSpacing.s) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(PakktColors.secondaryText)
            }

            TextField(placeholder, text: $text)
                .font(PakktTypography.body)
                .foregroundColor(PakktColors.primaryText)
        }
        .paddingM()
        .background(backgroundColor)
        .cornerRadiusMedium()
        .overlay(
            RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                .stroke(borderColor, lineWidth: borderWidth)
        )
    }

    private var backgroundColor: Color {
        switch style {
        case .glass:
            return PakktColors.glassWhite
        case .brutal:
            return PakktColors.pureBlack
        }
    }

    private var borderColor: Color {
        switch style {
        case .glass:
            return PakktColors.glassBorder
        case .brutal:
            return PakktColors.white
        }
    }

    private var borderWidth: CGFloat {
        switch style {
        case .glass:
            return PakktSpacing.borderThin
        case .brutal:
            return PakktSpacing.borderMedium
        }
    }
}

// MARK: - Secure Field
struct PakktSecureField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String?
    let style: PakktInputStyle
    @State private var isSecure = true

    init(
        _ placeholder: String,
        text: Binding<String>,
        icon: String? = "lock.fill",
        style: PakktInputStyle = .glass
    ) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.style = style
    }

    var body: some View {
        HStack(spacing: PakktSpacing.s) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(PakktColors.secondaryText)
            }

            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(PakktTypography.body)
                    .foregroundColor(PakktColors.primaryText)
            } else {
                TextField(placeholder, text: $text)
                    .font(PakktTypography.body)
                    .foregroundColor(PakktColors.primaryText)
            }

            Button(action: { isSecure.toggle() }) {
                Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(PakktColors.secondaryText)
            }
        }
        .paddingM()
        .background(backgroundColor)
        .cornerRadiusMedium()
        .overlay(
            RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                .stroke(borderColor, lineWidth: borderWidth)
        )
    }

    private var backgroundColor: Color {
        switch style {
        case .glass:
            return PakktColors.glassWhite
        case .brutal:
            return PakktColors.pureBlack
        }
    }

    private var borderColor: Color {
        switch style {
        case .glass:
            return PakktColors.glassBorder
        case .brutal:
            return PakktColors.white
        }
    }

    private var borderWidth: CGFloat {
        switch style {
        case .glass:
            return PakktSpacing.borderThin
        case .brutal:
            return PakktSpacing.borderMedium
        }
    }
}

// MARK: - Text Editor
struct PakktTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let style: PakktInputStyle

    init(
        text: Binding<String>,
        placeholder: String = "Enter text...",
        style: PakktInputStyle = .glass
    ) {
        self._text = text
        self.placeholder = placeholder
        self.style = style
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(PakktTypography.body)
                    .foregroundColor(PakktColors.tertiaryText)
                    .paddingM()
            }

            TextEditor(text: $text)
                .font(PakktTypography.body)
                .foregroundColor(PakktColors.primaryText)
                .scrollContentBackground(.hidden)
                .paddingM()
        }
        .frame(minHeight: 120)
        .background(backgroundColor)
        .cornerRadiusMedium()
        .overlay(
            RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                .stroke(borderColor, lineWidth: borderWidth)
        )
    }

    private var backgroundColor: Color {
        switch style {
        case .glass:
            return PakktColors.glassWhite
        case .brutal:
            return PakktColors.pureBlack
        }
    }

    private var borderColor: Color {
        switch style {
        case .glass:
            return PakktColors.glassBorder
        case .brutal:
            return PakktColors.white
        }
    }

    private var borderWidth: CGFloat {
        switch style {
        case .glass:
            return PakktSpacing.borderThin
        case .brutal:
            return PakktSpacing.borderMedium
        }
    }
}

// MARK: - Search Bar
struct PakktSearchBar: View {
    @Binding var text: String
    let placeholder: String

    init(
        text: Binding<String>,
        placeholder: String = "Search..."
    ) {
        self._text = text
        self.placeholder = placeholder
    }

    var body: some View {
        HStack(spacing: PakktSpacing.s) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(PakktColors.secondaryText)

            TextField(placeholder, text: $text)
                .font(PakktTypography.body)
                .foregroundColor(PakktColors.primaryText)

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(PakktColors.secondaryText)
                }
            }
        }
        .paddingM()
        .background(PakktColors.glassWhite)
        .background(.ultraThinMaterial)
        .cornerRadiusMedium()
        .overlay(
            RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                .stroke(PakktColors.glassBorder, lineWidth: PakktSpacing.borderThin)
        )
    }
}

// MARK: - Toggle
struct PakktToggle: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .bodyStyle()

            Spacer()

            Toggle("", isOn: $isOn)
                .tint(PakktColors.yellow)
        }
        .paddingM()
        .background(PakktColors.glassWhite)
        .background(.ultraThinMaterial)
        .cornerRadiusMedium()
        .overlay(
            RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                .stroke(PakktColors.glassBorder, lineWidth: PakktSpacing.borderThin)
        )
    }
}

// MARK: - Slider
struct PakktSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        VStack(alignment: .leading, spacing: PakktSpacing.xs) {
            HStack {
                Text(title)
                    .bodyStyle()
                Spacer()
                Text(String(format: "%.0f", value))
                    .bodyBoldStyle(color: PakktColors.yellow)
            }

            Slider(value: $value, in: range)
                .tint(PakktColors.yellow)
        }
        .paddingM()
        .background(PakktColors.glassWhite)
        .background(.ultraThinMaterial)
        .cornerRadiusMedium()
        .overlay(
            RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                .stroke(PakktColors.glassBorder, lineWidth: PakktSpacing.borderThin)
        )
    }
}

// MARK: - Picker
struct PakktPicker<T: Hashable>: View {
    let title: String
    @Binding var selection: T
    let options: [T]
    let label: (T) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: PakktSpacing.xs) {
            Text(title)
                .bodyBoldStyle()

            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(label(option))
                        .tag(option)
                }
            }
            .pickerStyle(.segmented)
            .background(PakktColors.glassWhite)
        }
        .paddingM()
        .background(PakktColors.glassWhite)
        .background(.ultraThinMaterial)
        .cornerRadiusMedium()
        .overlay(
            RoundedRectangle(cornerRadius: PakktSpacing.radiusMedium)
                .stroke(PakktColors.glassBorder, lineWidth: PakktSpacing.borderThin)
        )
    }
}

// MARK: - Input Style Enum
enum PakktInputStyle {
    case glass
    case brutal
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: PakktSpacing.m) {
            PakktTextField("Email", text: .constant(""), icon: "envelope.fill", style: .glass)

            PakktTextField("Username", text: .constant(""), icon: "person.fill", style: .brutal)

            PakktSecureField("Password", text: .constant(""), style: .glass)

            PakktTextEditor(text: .constant(""), placeholder: "Write something...", style: .glass)

            PakktSearchBar(text: .constant(""))

            PakktToggle(title: "Enable Notifications", isOn: .constant(true))

            PakktSlider(title: "Volume", value: .constant(50), range: 0...100)

            PakktPicker(
                title: "Select Theme",
                selection: .constant("Dark"),
                options: ["Light", "Dark", "Auto"],
                label: { $0 }
            )
        }
        .paddingM()
    }
    .background(PakktColors.background)
}
