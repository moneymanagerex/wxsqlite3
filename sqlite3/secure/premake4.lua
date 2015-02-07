-- Build SQLite3
--   static or shared library
--   AES 128 bit or AES 256 bit encryption support
--   Debug or Release

solution "SQLite3"
  configurations { "DebugAES128", "ReleaseAES128", "DebugAES256", "ReleaseAES256" }

-- SQLite3 as static library
project "sqlite3lib"
  uuid "5104BC68-6E98-864B-9DBC-8D87F537B771"
  kind "StaticLib"
  language "C++"
  vpaths {
    ["Header Files"] = { "**.h" },
    ["Source Files"] = { "**.c" }
  }
  files { "src/sqlite3secure.c", "src/*.h" }
  flags { "Unicode", "StaticRuntime" }

  location "build/sqlite3lib"
  targetname "sqlite3"

  defines {
    "_LIB",
    "THREADSAFE=1",
    "SQLITE_SOUNDEX",
    "SQLITE_ENABLE_COLUMN_METADATA",
    "SQLITE_HAS_CODEC",
    "SQLITE_SECURE_DELETE",
    "SQLITE_ENABLE_FTS3",
    "SQLITE_ENABLE_FTS3_PARENTHESIS",
    "SQLITE_ENABLE_RTREE",
    "SQLITE_CORE",
    "SQLITE_ENABLE_EXTFUNC",
    "SQLITE_USE_URI",
    "SQLITE_USER_AUTHENTICATION",
    "_CRT_SECURE_NO_WARNINGS",
    "_CRT_SECURE_NO_DEPRECATE",
    "_CRT_NONSTDC_NO_DEPRECATE"
  }

  configuration "windows"
    defines { "WIN32", "_WINDOWS" }

  configuration "linux"
    defines {
      "HAVE_ACOSH=1",
      "HAVE_ASINH=1",
      "HAVE_ATANH=1",
      "HAVE_ISBLANK=1"
    }

  configuration "DebugAES128"
    targetdir "aes128/lib/debug"
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES128",
      "DEBUG",
      "_DEBUG"
    }
    flags { "Symbols" }

  configuration "ReleaseAES128"
    targetdir "aes128/lib/release"
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES128",
      "NDEBUG"
    }
    flags { "Optimize" }

    configuration "DebugAES256"
    targetdir "aes256/lib/debug"
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES256",
      "DEBUG",
      "_DEBUG"
    }
    flags { "Symbols" }

  configuration "ReleaseAES256"
    targetdir "aes256/lib/release"
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES256",
      "NDEBUG"
    }
    flags { "Optimize" }

-- SQLite3 as shared library
project "sqlite3dll"
  uuid "DA8570DF-BED3-8844-BF37-CBBACB650F31"
  kind "SharedLib"
  language "C++"
  vpaths {
    ["Header Files"] = { "**.h" },
    ["Source Files"] = { "**/sqlite3secure.c", "**.def", "**.rc" }
  }
  files { "src/sqlite3secure.c", "src/*.h", "src/sqlite3.def" }
  flags { "Unicode", "StaticRuntime" }

  location "build/sqlite3dll"
  targetname "sqlite3"

  defines {
    "_USRDLL",
    "THREADSAFE=1",
    "SQLITE_SOUNDEX",
    "SQLITE_ENABLE_COLUMN_METADATA",
    "SQLITE_HAS_CODEC",
    "SQLITE_SECURE_DELETE",
    "SQLITE_ENABLE_FTS3",
    "SQLITE_ENABLE_FTS3_PARENTHESIS",
    "SQLITE_ENABLE_RTREE",
    "SQLITE_CORE",
    "SQLITE_ENABLE_EXTFUNC",
    "SQLITE_USE_URI",
    "SQLITE_USER_AUTHENTICATION",
    "_CRT_SECURE_NO_WARNINGS",
    "_CRT_SECURE_NO_DEPRECATE",
    "_CRT_NONSTDC_NO_DEPRECATE"
  }

  configuration "windows"
    files { "src/sqlite3.rc" }
    defines { "WIN32", "_WINDOWS" }

  configuration "linux"
    defines {
      "HAVE_ACOSH=1",
      "HAVE_ASINH=1",
      "HAVE_ATANH=1",
      "HAVE_ISBLANK=1"
    }

  configuration "DebugAES128"
    targetdir "aes128/dll/debug"
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES128",
      "DEBUG",
      "_DEBUG"
    }
    flags { "Symbols" }

  configuration "ReleaseAES128"
    targetdir "aes128/dll/release"
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES128",
      "NDEBUG"
    }
    flags { "Optimize" }

  configuration "DebugAES256"
    targetdir "aes256/dll/debug"
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES256",
      "DEBUG",
      "_DEBUG"
    }
    flags { "Symbols" }

  configuration "ReleaseAES256"
    targetdir "aes256/dll/release"
    defines {
      "CODEC_TYPE=CODEC_TYPE_AES256",
      "NDEBUG"
    }
    flags { "Optimize" }

-- SQLite3 Shell
project "sqlite3shell"
  uuid "BA98AAC1-AACD-2F4F-8EDB-CF7C62668BC4"
  kind "ConsoleApp"
  language "C++"
  vpaths {
    ["Header Files"] = { "**.h" },
    ["Source Files"] = { "**.c", "**.rc" }
  }
  files { "src/sqlite3.h", "src/shell.c" }
  flags { "Unicode", "StaticRuntime" }
  links { "sqlite3lib" }

  location "build/sqlite3shell"

  defines {
    "SQLITE_HAS_CODEC",
    "SQLITE_USER_AUTHENTICATION",
    "_CRT_SECURE_NO_DEPRECATE",
    "_CRT_NONSTDC_NO_DEPRECATE"
  }

  configuration "windows"
    files { "src/sqlite3shell.rc" }
    defines { "WIN32", "_WINDOWS" }

  configuration "linux"
    links { "pthread", "dl" }

  configuration "DebugAES128"
    targetdir "aes128/debug"
    defines { "DEBUG" }
    flags { "Symbols" }

  configuration "ReleaseAES128"
    targetdir "aes128/release"
    defines { "NDEBUG" }
    flags { "Optimize" }

  configuration "DebugAES256"
    targetdir "aes256/debug"
    defines { "DEBUG" }
    flags { "Symbols" }

  configuration "ReleaseAES256"
    targetdir "aes256/release"
    defines { "NDEBUG" }
    flags { "Optimize" }
