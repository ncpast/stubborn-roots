import os
import sys

env = SConscript("godot-cpp/SConscript")

sources = Glob("src/*.cpp")

if env["platform"] == "windows":
    library = env.SharedLibrary(
        "bin/libgdapi.windows.debug.x86_64.dll",
        source=sources,
    )
else:
    library = env.SharedLibrary(
        "bin/libgdapi",
        source=sources,
    )

Default(library)