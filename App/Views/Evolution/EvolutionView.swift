import SwiftUI

struct EvolutionView: View {
    @State private var viewModel: EvolutionViewModel
    @State private var showAddPhoto = false
    @State private var bodyWeight: Double = 0
    @State private var bodyFat: String = ""
    @State private var notes: String = ""

    init(dataService: DataService) {
        _viewModel = State(initialValue: EvolutionViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.showComparison {
                        comparisonSection
                    } else {
                        addPhotoButton
                        photoGrid
                    }
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Evolução")
            .toolbar {
                if viewModel.showComparison {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Limpar") { viewModel.clearComparison() }
                    }
                }
            }
            .sheet(isPresented: $showAddPhoto) {
                addPhotoSheet
            }
        }
    }

    private var addPhotoButton: some View {
        Button(action: { showAddPhoto = true }) {
            HStack {
                Image(systemName: "camera.fill")
                Text("Adicionar Fotos")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentBlue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var photoGrid: some View {
        VStack(spacing: 12) {
            if viewModel.photos.isEmpty {
                EmptyStateView(
                    icon: "camera.viewfinder",
                    title: "Nenhuma foto ainda",
                    message: "Registre sua evolução tirando fotos periódicas.",
                    actionTitle: "Adicionar Fotos",
                    action: { showAddPhoto = true }
                )
            } else {
                ForEach(viewModel.photos, id: \.id) { photo in
                    PhotoCard(
                        photo: photo,
                        onCompare: { viewModel.selectForComparison(photo) },
                        onDelete: { viewModel.deletePhoto(photo) }
                    )
                }
            }
        }
    }

    private var comparisonSection: some View {
        VStack(spacing: 16) {
            Text("Comparação")
                .font(.title2)
                .fontWeight(.bold)

            if let older = viewModel.comparePhoto, let newer = viewModel.selectedPhoto {
                HStack(spacing: 12) {
                    VStack {
                        Text(older.date.formattedShortDate())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray5))
                            .aspectRatio(0.75, contentMode: .fit)
                            .overlay { Image(systemName: "person.fill").font(.largeTitle).foregroundStyle(.secondary) }
                    }

                    Image(systemName: "arrow.right")
                        .foregroundStyle(Color.accentBlue)

                    VStack {
                        Text(newer.date.formattedShortDate())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray5))
                            .aspectRatio(0.75, contentMode: .fit)
                            .overlay { Image(systemName: "person.fill").font(.largeTitle).foregroundStyle(.secondary) }
                    }
                }

                HStack(spacing: 20) {
                    VStack {
                        Text("Peso")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(String(format: "%.1f", older.bodyWeight)) kg")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Image(systemName: "arrow.right")
                            .font(.caption)
                            .foregroundStyle(Color.accentGreen)
                        Text("\(String(format: "%.1f", newer.bodyWeight)) kg")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }

                    if let oldFat = older.bodyFat, let newFat = newer.bodyFat {
                        VStack {
                            Text("Gordura")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(String(format: "%.1f", oldFat))%")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Image(systemName: "arrow.right")
                                .font(.caption)
                            Text("\(String(format: "%.1f", newFat))%")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                    }
                }

                Button("Nova Comparação") {
                    viewModel.clearComparison()
                }
                .buttonStyle(.bordered)
            } else {
                Text("Selecione duas fotos para comparar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ForEach(viewModel.photos, id: \.id) { photo in
                    Button(action: { viewModel.selectForComparison(photo) }) {
                        PhotoCard(photo: photo)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var addPhotoSheet: some View {
        NavigationStack {
            Form {
                Section("Fotos") {
                    HStack(spacing: 12) {
                        photoPlaceholder("Frente")
                        photoPlaceholder("Costas")
                        photoPlaceholder("Lateral")
                    }
                }

                Section("Medidas") {
                    HStack {
                        Text("Peso (kg)")
                        Spacer()
                        TextField("Peso", value: $bodyWeight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Text("% Gordura")
                        Spacer()
                        TextField("Opcional", text: $bodyFat)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section("Observações") {
                    TextField("Observações...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section {
                    Button("Salvar") {
                        let fat = Double(bodyFat.replacingOccurrences(of: ",", with: "."))
                        viewModel.addPhoto(front: nil, back: nil, side: nil,
                                          weight: bodyWeight, bodyFat: fat, notes: notes)
                        showAddPhoto = false
                        bodyWeight = 0
                        bodyFat = ""
                        notes = ""
                    }
                    .disabled(bodyWeight == 0)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Nova Foto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { showAddPhoto = false }
                }
            }
        }
    }

    private func photoPlaceholder(_ label: String) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
                .aspectRatio(0.75, contentMode: .fit)
                .overlay {
                    VStack(spacing: 4) {
                        Image(systemName: "camera")
                            .foregroundStyle(.secondary)
                        Text(label)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
        }
    }
}
