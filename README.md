# Video Converter - GUI for FFmpeg

This project is a graphical user interface (GUI) for FFmpeg, designed to simplify video conversion tasks. The application is built using Flutter and is currently available for **Windows** only.

## Disclaimer

- This project does **not** include any FFmpeg libraries or licenses for `acodec` or `vcodec` codecs.
- It is **not** intended for commercial use. This software is provided **solely for educational and research purposes**.
- FFmpeg binaries are not included in this repository due to licensing restrictions.
- Users are required to download or compile FFmpeg independently.
- Use at your own risk: The author is not liable for any damage to personal devices or assets. Any issues or damages that arise are the user's responsibility.
  
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
## Option 2: Download Precompiled FFmpeg Binaries
- You can download precompiled binaries from https://ffmpeg.org/download.html or other trusted sources.
- Make sure the FFmpeg executable is available in your system's PATH.

## Option 3: Modified FFmpeg to Support FLV over HEVC
1. Download FFmpeg from [https://github.com/FFmpeg/FFmpeg/tree/release/5.0](https://github.com/FFmpeg/FFmpeg/tree/release/5.0).
2. Download the modified files from [https://github.com/runner365/ffmpeg_rtmp_h265/tree/5.0](https://github.com/runner365/ffmpeg_rtmp_h265/tree/5.0).
3. Copy the files downloaded in Step 2 to `FFmpeg/libavformat`.
4. Run the configuration with MSYS2 MINGW64 on Windows.
5. For a Linux environment, please refer to the [FFmpeg Compilation Guide](https://trac.ffmpeg.org/wiki/CompilationGuide).

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
   
### 4. Copy the DLL and EXE Files
- Manually create the following folder: `C:\Users\yourusername\AppData\Roaming\com.jynn7.videoconverter\videoconverter\ffmpeg`
- Copy the generated `ffmpeg.exe` and all the generated `.dll` files to the folder: `C:\Users\yourusername\AppData\Roaming\com.jynn7.videoconverter\videoconverter\ffmpeg`

### 5. Compile and produced videoconverter.exe
```bash
flutter build windows --target lib/feature/main/main.dart
```
