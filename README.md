# 📈 Real-Time OHLC Candlestick Chart App

This Flutter project simulates a real-time OHLC (Open, High, Low, Close) candlestick chart using mock tick data. It supports timeframes (1-minute and 5-minute), interactive dragging for price inspection, and smooth updates every second.

---

## 🎩 Demo Video

Watch the demo video here:
[📺 Watch Demo on Google Drive](https://drive.google.com/file/d/1iGlIWlI4e_l0uuqZTtA54A-ITDAtUnE2/view?usp=sharing)

---

## 🗂️ APK Download

Click below to download the APK:

[Download APK](https://drive.google.com/file/d/1-pAd5VbuWloV9LxK9_KBvvb2BCp_WYL3/view?usp=sharing)

---

## 🗀️ Screenshots

| 1 Min Timeframe Chart                                                                          | 5 Min Timeframe Chart                                                                          |
| ---------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| ![Screenshot 1](https://drive.google.com/uc?export=view\&id=1u8_SEih11OeB1Zv3e-hIhYHCv8HYVD18) | ![Screenshot 2](https://drive.google.com/uc?export=view\&id=1uXchnCSwM395QywhIudDanzQvoHzcJUz) |

---

## 🚀 Features

* 📊 Real-time tick simulation every second
* 📈 Aggregation into OHLC candles (1-min & 5-min timeframes)
* 🔹 Dragging line shows price tooltip with reset after 3 seconds
* 🔀 Maintains only the last 30 candles
* 💡 Optimized redraw using CustomPainter
* 🪪 Unit tests for:

  * Candle creation
  * Drag-reset logic
  * New candle per minute
  * Tick updates
  * 30-candle list limit

---

## 🩵 Tech Stack

* Flutter
* BLoC for state management
* CustomPainter for chart rendering

---

## 🪪 Testing

```bash
flutter test test/ohlc_bloc_test.dart
```

Tests include:

* ✅ Correct candle generation
* ✅ Candle updates on tick
* ✅ New candle per minute
* ✅ 30-candle limit
* ✅ Drag line reset
* ✅ Timeframe switching

---

## 📂 Folder Structure

```
lib/
├── core/
│   └── utils/
│       └── timeframe.dart
├── feature/
│   └── chart/
│       ├── domain/
│       │   └── entities/
│       │       └── candle.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── ohlc_bloc.dart
│           │   ├── ohlc_event.dart
│           │   └── ohlc_state.dart
│           ├── pages/
│           │   └── home_page.dart
│           └── widgets/
│               └── candle_painter.dart
```

---

## 📌 Getting Started

```bash
git clone https://github.com/chandan123-pradhan/Real-time-trading-app.git
cd Real-time-trading-app
flutter pub get
flutter run
```

---

## 🧠 Author

**Chandan Pradhan**
Mobile App Developer (Flutter) with >5 years of experience

---

## 📄 License

This project is licensed under the MIT License.
