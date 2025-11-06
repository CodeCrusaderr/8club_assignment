<<<<<<< HEAD
# hotspot_hosts

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# 8Club Assignment  

## 🧾 Overview  
This Flutter project implements the **Hotspot Host Onboarding Flow**, designed to evaluate and onboard potential event hosts for the Hotspot platform.  
The flow collects host preferences, motivations, and responses through **text, audio, and video** — ensuring that each host aligns with the community’s standards and can facilitate safe, engaging, and inclusive social experiences.  

---

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


>>>>>>> 61a58b81b6e3db8cb8a393816ce2d289240f7f19
