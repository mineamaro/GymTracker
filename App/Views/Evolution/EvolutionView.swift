import SwiftUI

struct EvolutionView: View {
    @State private var viewModel: EvolutionViewModel
    @State private var showAddPhoto = false
    @State private var bodyWeight: String = ""
    @State private var bodyFat: String = ""
    @State private var notes: String = ""

    init(dataService: DataService) {
        _viewModel = State(initialValue: EvolutionViewModel(dataService: dataService))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gymBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        heroSection

                        if viewModel.showComparison {
                            comparisonSection
                        } else {
                            addPhotoButton
                            photoGrid
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("📸 EVOLUÇÃO")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.gymCard, for: .navigationBar)
            .toolbar {
                if viewModel.showComparison {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Limpar") { viewModel.clearComparison() }
                            .foregroundStyle(Color.neonOrange)
                    }
                }
            }
            .sheet(isPresented: $showAddPhoto) {
                addPhotoSheet
            }
        }
    }

    private var heroSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 50))
                .foregroundStyle(Color.neonGreen)

            Text("REGISTRE SUA EVOLUÇÃO")
                .font(.title3).fontWeight(.heavy)
                .foregroundStyle(.white)

            Text("Tire fotos regularmente para acompanhar suas mudanças")
                .font(.caption)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)

            if !viewModel.photos.isEmpty {
                HStack(spacing: 20) {
                    statCircle(value: "\(viewModel.photos.count)", label: "FOTOS", color: .neonBlue)
                    if let first = viewModel.photos.last, let last = viewModel.photos.first {
                        let diff = last.bodyWeight - first.bodyWeight
                        statCircle(value: "\(String(format: "%.1f", abs(diff)))kg", label: diff >= 0 ? "GANHOU" : "PERDEU", color: diff >= 0 ? .neonGreen : .neonOrange)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gymBorder, lineWidth: 1))
    }

    private func statCircle(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2).fontWeight(.heavy)
                .foregroundStyle(color)
            Text(label)
                .font(.caption2).fontWeight(.bold)
                .foregroundStyle(.gray)
        }
        .frame(width: 80, height: 70)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var addPhotoButton: some View {
        Button(action: { showAddPhoto = true }) {
            HStack {
                Image(systemName: "camera.fill")
                    .font(.title3)
                Text("📸 ADICIONAR NOVAS FOTOS")
                    .fontWeight(.heavy)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.neonBlue.opacity(0.15))
            .foregroundStyle(Color.neonBlue)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.neonBlue.opacity(0.3), lineWidth: 1))
        }
    }

    private var photoGrid: some View {
        VStack(spacing: 12) {
            if viewModel.photos.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 60))
                        .foregroundStyle(.gray.opacity(0.3))

                    Text("NENHUMA FOTO AINDA")
                        .font(.headline).fontWeight(.bold)
                        .foregroundStyle(.gray)

                    Text("Toque em \"Adicionar Fotos\"\ne comece a registrar sua evolução!")
                        .font(.subheadline)
                        .foregroundStyle(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color.gymCard)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gymBorder, lineWidth: 1))
            } else {
                ForEach(viewModel.photos) { photo in
                    PhotoCard(
                        photo: photo,
                        onCompare: { viewModel.selectForComparison(photo) },
                        onDelete: { viewModel.deletePhoto(photo) }
                    )
                    .background(Color.gymCard)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
                }
            }
        }
    }

    private var comparisonSection: some View {
        VStack(spacing: 20) {
            Text("⚖️ COMPARAÇÃO")
                .font(.title2).fontWeight(.heavy)
                .foregroundStyle(Color.neonGreen)

            if let older = viewModel.comparePhoto, let newer = viewModel.selectedPhoto {
                HStack(spacing: 16) {
                    VStack {
                        Text(older.date.formattedShortDate())
                            .font(.caption).fontWeight(.bold).foregroundStyle(.gray)
                        photoPlaceholder
                            .overlay(alignment: .bottom) {
                                Text("\(String(format: "%.1f", older.bodyWeight)) kg")
                                    .font(.caption2).fontWeight(.bold).padding(4)
                                    .background(.ultraThinMaterial)
                            }
                    }

                    Image(systemName: "arrow.right")
                        .font(.title2).foregroundStyle(Color.neonGreen)

                    VStack {
                        Text(newer.date.formattedShortDate())
                            .font(.caption).fontWeight(.bold).foregroundStyle(.gray)
                        photoPlaceholder
                            .overlay(alignment: .bottom) {
                                Text("\(String(format: "%.1f", newer.bodyWeight)) kg")
                                    .font(.caption2).fontWeight(.bold).padding(4)
                                    .background(.ultraThinMaterial)
                            }
                    }
                }

                HStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text("PESO").font(.caption2).foregroundStyle(.gray)
                        Text("\(String(format: "%.1f", older.bodyWeight)) kg")
                            .font(.subheadline).foregroundStyle(.gray)
                        Image(systemName: "arrow.right").font(.caption).foregroundStyle(Color.neonGreen)
                        Text("\(String(format: "%.1f", newer.bodyWeight)) kg")
                            .font(.title3).fontWeight(.bold).foregroundStyle(Color.neonGreen)
                    }

                    if let oldFat = older.bodyFat, let newFat = newer.bodyFat {
                        VStack(spacing: 4) {
                            Text("GORDURA").font(.caption2).foregroundStyle(.gray)
                            Text("\(String(format: "%.1f", oldFat))%")
                                .font(.subheadline).foregroundStyle(.gray)
                            Image(systemName: "arrow.right").font(.caption)
                            Text("\(String(format: "%.1f", newFat))%")
                                .font(.title3).fontWeight(.bold).foregroundStyle(newFat < oldFat ? Color.neonGreen : Color.neonRed)
                        }
                    }
                }

                Button("NOVA COMPARAÇÃO") {
                    viewModel.clearComparison()
                }
                .fontWeight(.heavy).font(.caption)
                .padding(.horizontal, 24).padding(.vertical, 12)
                .background(Color.neonOrange.opacity(0.15))
                .foregroundStyle(Color.neonOrange)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.neonOrange.opacity(0.3), lineWidth: 1))
            } else {
                Text("SELECIONE DUAS FOTOS PARA COMPARAR")
                    .font(.subheadline).fontWeight(.bold)
                    .foregroundStyle(.gray)

                ForEach(viewModel.photos) { photo in
                    Button(action: { viewModel.selectForComparison(photo) }) {
                        PhotoCard(photo: photo)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(Color.gymCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gymBorder, lineWidth: 1))
    }

    private var photoPlaceholder: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gymCardLight)
            .aspectRatio(0.75, contentMode: .fit)
            .overlay {
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.gray.opacity(0.4))
            }
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gymBorder, lineWidth: 1))
    }

    private var addPhotoSheet: some View {
        NavigationStack {
            ZStack {
                Color.gymBackground.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        Text("📸 NOVO REGISTRO")
                            .font(.title2).fontWeight(.heavy)
                            .foregroundStyle(.white)

                        HStack(spacing: 12) {
                            photoSlot("FRENTE")
                            photoSlot("COSTAS")
                            photoSlot("LATERAL")
                        }

                        VStack(spacing: 16) {
                            gymTextField("Peso (kg)", text: $bodyWeight, keyboard: .decimalPad)
                            gymTextField("% Gordura (opcional)", text: $bodyFat, keyboard: .decimalPad)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("OBSERVAÇÕES")
                                    .font(.caption).fontWeight(.bold).foregroundStyle(.gray)
                                TextEditor(text: $notes)
                                    .frame(height: 80)
                                    .padding(8)
                                    .background(Color.gymCard)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .foregroundStyle(.white)
                                    .scrollContentBackground(.hidden)
                            }
                        }

                        Button(action: savePhoto) {
                            Text("💾 SALVAR FOTOS")
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(bodyWeight.isEmpty ? Color.gray : Color.neonGreen)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .disabled(bodyWeight.isEmpty)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.gymCard, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { showAddPhoto = false }
                        .foregroundStyle(Color.neonRed)
                }
            }
        }
    }

    private func photoSlot(_ label: String) -> some View {
        VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gymCardLight)
                .aspectRatio(0.75, contentMode: .fit)
                .overlay {
                    VStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                            .font(.title2)
                            .foregroundStyle(Color.neonBlue)
                        Text(label)
                            .font(.caption2).fontWeight(.bold)
                            .foregroundStyle(.gray)
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gymBorder, style: StrokeStyle(lineWidth: 1, dash: [4])))
        }
    }

    private func gymTextField(_ placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(placeholder.uppercased())
                .font(.caption).fontWeight(.bold).foregroundStyle(.gray)
            TextField("", text: text)
                .keyboardType(keyboard)
                .padding(12)
                .background(Color.gymCard)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gymBorder, lineWidth: 1))
        }
    }

    private func savePhoto() {
        let peso = Double(bodyWeight.replacingOccurrences(of: ",", with: ".")) ?? 0
        let fat = Double(bodyFat.replacingOccurrences(of: ",", with: "."))
        viewModel.addPhoto(front: nil, back: nil, side: nil, weight: peso, bodyFat: fat, notes: notes)
        showAddPhoto = false
        bodyWeight = ""
        bodyFat = ""
        notes = ""
    }
}
