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

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Compile or Download FFmpeg
Since FFmpeg binaries are not included, follow one of the options below:

## Option 1: Compile FFmpeg
1. Download the FFmpeg source code from [https://ffmpeg.org/download.html](https://ffmpeg.org/download.html).
2. Configure FFmpeg using the following command:

```bash
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
make clean
make -j8
make install
```
## Option 2: Download Precompiled FFmpeg Binaries
- You can download precompiled binaries from https://ffmpeg.org/download.html or other trusted sources.
- Make sure the FFmpeg executable is available in your system's PATH.
- 
## Option 3: Modified FFmpeg to support FLV over HEVC
- Download the FFmpeg from https://github.com/FFmpeg/FFmpeg/tree/release/5.0.
- Download modified files from https://github.com/runner365/ffmpeg_rtmp_h265/tree/5.0
- Run configuration with MSYS2 MINGW64 in windows.
- For Linux environment, please refer here https://trac.ffmpeg.org/wiki/CompilationGuide.

```bash
./configure \
    --enable-cross-compile \
    --pkg-config-flags="--static" \
    --extra-ldflags="-lm -lz -llzma -lpthread" \
    --extra-libs="-lpthread -lm" \
    --enable-gpl \
    --enable-libfdk_aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libvorbis \
    --enable-libopus \
    --enable-libvpx \
    --enable-libass \
    --enable-libsoxr \
    --enable-nonfree \
    --disable-shared \
    --enable-static
make clean
make -j8
make install
```

