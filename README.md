# Video Converter - GUI for FFmpeg

This project is a graphical user interface (GUI) for FFmpeg, designed to simplify video conversion tasks. The application is built using Flutter and is currently available for **Windows** only.

## Disclaimer

- This project does **not** include any FFmpeg libraries or licenses for `acodec` or `vcodec` codecs.
- It is **not** intended for commercial use. This software is provided **solely for educational and research purposes**.
- FFmpeg binaries are not included in this repository due to licensing restrictions.
- Users are required to download or compile FFmpeg independently.
  
## Features

- User-friendly interface for converting video files.
- Supports various input and output formats using FFmpeg.
- Displays a list of selected video files for conversion.

## Prerequisites

- [Flutter](https://flutter.dev/) (version 3.0 or higher is recommended)
- Windows operating system
- FFmpeg: Users must compile or download FFmpeg binaries (see instructions below).

## Getting Started
### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/videoconverter.git
cd videoconverter
```

### 2. Clone the Repository
### 3. Clone the Repository
### 4. Clone the Repository
### 5. Clone the Repository
### 6. Clone the Repository
### 7. Clone the Repository
### 8. Clone the Repository
### 9. Clone the Repository



Getting Started
1. Clone the Repository
bash
Copy code
git clone https://github.com/yourusername/videoconverter.git
cd videoconverter
2. Install Dependencies
Ensure Flutter is installed and fetch the required dependencies:

bash
Copy code
flutter pub get
3. Compile or Download FFmpeg
Since FFmpeg binaries are not included, follow one of the options below:

Option 1: Compile FFmpeg
Download the FFmpeg source code from https://ffmpeg.org/download.html.

Configure FFmpeg using the following command:

bash
Copy code
./configure \
    --enable-cross-compile \
    --pkg-config-flags="--static" \
    --extra-ldflags="-lm -lz -llzma -lpthread" \
    --extra-libs="-lpthread -lm" \
    --enable-gpl \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libvorbis \
    --enable-libopus \
    --enable-libvpx \
    --enable-libass \
    --enable-libsoxr \
    --disable-shared \
    --enable-static
Follow the build process as described in the official FFmpeg documentation.

Option 2: Download Precompiled FFmpeg Binaries
You can download precompiled binaries from https://ffmpeg.org/download.html or other trusted sources.
Make sure the FFmpeg executable is available in your system's PATH.
4. Run the Application
To start the application, use:

bash
Copy code
flutter run -d windows
Usage
Select video files to convert.
Choose conversion settings such as output format and quality.
Click the "Convert" button to start the conversion process.
Monitor the progress and view converted files.
License
This project is distributed under the MIT License. See the LICENSE file for more information.

