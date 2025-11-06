# 8Club Assignment  

## 🧾 Overview  
This Flutter project implements the **Hotspot Host Onboarding Flow**, designed to evaluate and onboard potential event hosts for the Hotspot platform.  
The flow collects host preferences, motivations, and responses through **text, audio, and video** — ensuring that each host aligns with the community’s standards and can facilitate safe, engaging, and inclusive social experiences.  


## ✨ Features  

### 1. Experience Type Selection Screen  
- Fetches a list of experiences dynamically from an API using **Dio**.  
- Displays each experience as an **interactive image card**:  
  - Grayscale when unselected  
  - Colored when selected  
- Supports **multi-selection** of experiences.  
- Includes a **multi-line text field** with a **250-character limit** for additional input.  
- Stores selected experience IDs and text using **Riverpod state management**.  
- Logs the stored state on **Next** click and navigates to the next onboarding screen.  

### 2. Onboarding Question Screen  
- Displays a question: **“Why do you want to host with us?”**  
- Includes a **multi-line text field** with a **600-character limit**.  
- Provides **audio and video recording** options for richer, more expressive answers.  
- Shows **waveform visualization** during audio recording.  
- Allows **canceling and deleting** audio or video recordings.  
- Adds **playback preview** for both audio and video — users can review their recordings before proceeding.  
- When both audio and video are recorded, the **Next button expands and changes color** with a smooth animation.  
- Fully **responsive layout** with safe keyboard handling for all device sizes.  

---

## ⚙️ Technical Implementation  

### 🧩 Architecture  
Implemented using the **Model-View-Controller (MVC)** architecture for scalability and clarity:  
- **Model:** Data structures and API layer.  
- **View:** UI elements, layouts, and visual logic.  
- **Controller:** Handles state changes, user actions, and navigation flow.  

### 🪄 State Management  
Built with **Riverpod**, ensuring a reactive and maintainable state flow between screens.  

### 🌐 Networking  
API integration handled with **Dio**, providing structured API calls, error handling, and logging.  

### 🎨 UI/UX Highlights  
- **Pixel-perfect implementation** based on Figma design references.  
- Smooth **UI animations** (grayscale-to-color transitions, button expansion).  
- **Responsive and adaptive** across all device resolutions.  
- **Keyboard-aware layouts** for input-heavy sections.  

## 🏅 Brownie Points Implemented

The following optional enhancements were successfully implemented beyond the core requirements:

- 🎧 **Audio Recording with Playback Preview** – Users can record their responses and replay them before submission.  
- 🎥 **Video Recording with Playback Preview** – Users can record video answers and watch them before proceeding.  
- 🌊 **Real-Time Audio Waveform Visualization** – Dynamic waveform animation during audio recording for a professional experience.  
- 🌀 **Animated Next Button** – Smooth expansion and color transition when both audio and video are recorded.  
- 🧩 **MVC Architecture with Riverpod State Management** – Ensures clean separation of logic, scalability, and testability.  
- 🧠 **Responsive & Keyboard-Aware UI** – Fully optimized layouts for all screen sizes and safe keyboard interactions.  
- ⚡ **Seamless UX Flow** – Fluid navigation and instant feedback make the onboarding experience intuitive and engaging.

