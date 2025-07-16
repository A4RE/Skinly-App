# Skinly: AI-Powered Skin Disease Detection  

**Skinly** is an innovative iOS app developed as a master's thesis project. It uses artificial intelligence to analyze skin photos and provide preliminary assessments of potential dermatological conditions.  

## 🔍 Key Features  
- 📸 **Instant Analysis** – Upload a photo or take a new one with your camera to evaluate your skin.  
- 🤖 **Core ML-Powered AI Model** – A neural network trained on clinical datasets.  
- 📊 **Condition Overview & Recommendations** – Brief insights on possible diagnoses and next steps.  
- 🔒 **Privacy-First Approach** – All processing happens on-device; no data is sent to servers.  

## 🎓 Academic Background  
This app was created as part of a master's thesis, exploring the application of machine learning in healthcare.  

## 📲 Technologies  
- SwiftUI  
- Core ML + Vision (for image processing)  
- Native iOS Camera integration  

---

## 📦 Download the AI Model

To keep the repository lightweight and within GitHub's size limits, the Core ML model is not included in the repo.

🔗 **Download the model here**:  
[📁 Google Drive – Skinly Core ML Model](https://drive.google.com/drive/folders/1GlCDEzG2HmsROw5InYOu5GwnqiURkue4?usp=sharing)

### ➕ How to add the model to the project:

1. Download the `.mlpackage.zip` file from the link above.
2. Unzip the archive to extract the .mlpackage model file.
3. Open the Xcode project.
4. Drag and drop the model file into the `Resources` folder in the Xcode file navigator.
5. Make sure to check ✅ **"Copy items if needed"** and add it to the correct target.
6. Clean and build the project (`⇧⌘K`, then `⌘B`).

---

### ⚠️ Important Note  
Skinly is not a substitute for professional medical advice and is intended for research purposes only.  

---  
🚀 **Try Skinly and discover more about your skin health!**  

*(Contributions and feedback are welcome!)*
