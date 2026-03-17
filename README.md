# Stubborn Roots, a mobile farming game made with Godot

## 🛠️ Налаштування C++ (GDExtension) для команди

Оскільки ми використовуємо C++ для роботи з API, кожному з вас потрібно один раз "зібрати" бібліотеку локально, щоб Godot побачив вузол `APIClient`.

### 1. Підготовка (якщо ще немає)
Переконайтеся, що у вас встановлені:
* **Python 3**
* **SCons** (в терміналі: `pip install scons`)
* **Visual Studio 2022** (з встановленим робочим набором "Desktop development with C++")

### 2. Завантаження залежностей
Після клонування репозиторію виконайте цю команду в терміналі (всередині папки проєкту), щоб завантажити бібліотеку Godot-cpp:
```bash
git submodule update --init --recursive