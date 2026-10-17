# flutter_ui_fundamentals

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Struktur Arsitektur

- **models:** Mengatur struktur data course.
- **services:** Mengambil dan membaca data dari sumber data, seperti file JSON.
- **repositories:** Menjadi perantara antara Provider dan Service.
- **providers:** Mengelola state aplikasi dan memberi tahu UI ketika state berubah.
- **screens:** Menampilkan halaman aplikasi.
- **widgets:** Menyediakan komponen UI yang dapat digunakan kembali.

**Arah dependency:** Screen/Widget → Provider → Repository → Service/Data Source.

UI untuk fitur Course Explorer tidak membaca file JSON secara langsung, melainkan menggunakan lapisan Repository dan Service.