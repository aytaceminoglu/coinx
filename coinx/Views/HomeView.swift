import SwiftUI
import Supabase
import PhotosUI

struct HomeView: View {
    @State private var selectedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var uploadedImageUrl: String?
    @State private var analyzedCoin: Coin?
    @State private var showingAnswer = false
    @State private var isAnalyzing = false
    @State private var errorMessage: String?
    
    private let supabase = SupabaseClient(
        supabaseURL: URL(string: Configuration.supabaseUrl)!, 
        supabaseKey: Configuration.supabaseKey
    )
    
    private let openAIService = OpenAIService(apiKey: Configuration.openAIApiKey)
    
    func uploadImage() async {
        isAnalyzing = true
        errorMessage = nil
        
        guard let selectedImage = selectedImage,
              let imageData = selectedImage.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            let filePath = "\(UUID().uuidString).jpg"
            try await supabase.storage
                .from("coinx")
                .upload(
                    path: filePath,
                    file: imageData,
                    options: FileOptions(contentType: "image/jpeg")
                )
            
            // Get public URL
            let publicURL = try supabase.storage
                .from("coinx")
                .getPublicURL(path: filePath)
            
            print("Uploaded image URL: \(publicURL)")
            uploadedImageUrl = publicURL.absoluteString
            
            // Analyze image with GPT Vision API
            if let imageUrl = uploadedImageUrl {
                do {
                    analyzedCoin = try await openAIService.analyzeImage(imageUrl: imageUrl)
                    showingAnswer = true
                } catch {
                    errorMessage = "Failed to analyze image: \(error.localizedDescription)"
                    print("GPT Vision API error: \(error)")
                }
            }
        } catch {
            errorMessage = "Failed to upload image: \(error.localizedDescription)"
            print("Upload error: \(error)")
        }
        
        isAnalyzing = false
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Image preview box
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    }
                    
                    if isAnalyzing {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .background(Color.black.opacity(0.4))
                            .frame(width: 80, height: 80)
                            .cornerRadius(12)
                    }
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Photo selection buttons
                HStack(spacing: 20) {
                    PhotosPicker(selection: $selectedItem,
                               matching: .images) {
                        Label("From Gallery", systemImage: "photo.on.rectangle")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                    analyzedCoin = nil
                                    errorMessage = nil
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Identify button
                Button(action: {
                    Task {
                        await uploadImage()
                    }
                }) {
                    Text("Identify")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedImage != nil && !isAnalyzing ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(selectedImage == nil || isAnalyzing)
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                NavigationLink(
                    destination: analyzedCoin.map { AnswerView(coin: $0) },
                    isActive: $showingAnswer
                ) {
                    EmptyView()
                }
            }
        }
    }
} 
