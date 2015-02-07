dofile "premake/wxwidgets.lua"

newoption {
  trigger = "wx_version",
  value   = "VERSION",
  description = "Choose wxWidgets version",
  allowed = {
    { "2.8", "wxWidgets 2.8 (default)" },
    { "2.9", "wxWidgets 2.9" },
    { "3.0", "wxWidgets 3.0" }
  }
}

newoption {
  trigger = "embed",
  description = "embed SQLite3 statically"
}

wx_version = _OPTIONS["wx_version"] or "2.8"

solution "wxsqlite3"
  configurations { "Debug", "Release" }

-- wxSQLite3 as static library
project "wxsqlite3lib"
  --uuid "8B4C3E27-674F-6740-B5F8-5E7BB48E1A9F"
  kind "StaticLib"
  language "C++"
  vpaths {
    ["Header Files"] = { "**.h" },
    ["Source Files"] = { "**.cpp" }
  }
  files { "src/*.cpp", "include/wx/*.h" }
  includedirs { "include", "sqlite3/include" }
  flags { "Unicode" }

  location "build/wxsqlite3lib"
  targetname "wxsqlite3"

  defines {
    "_LIB",
    "WXMAKINGLIB_WXSQLITE3",
    "wxUSE_DYNAMIC_SQLITE3_LOAD=0",
    "WXSQLITE3_HAVE_METADATA=1",
    "WXSQLITE3_HAVE_CODEC=1",
    "WXSQLITE3_HAVE_LOAD_EXTENSION=0",
    "_CRT_SECURE_NO_WARNINGS",
    "_CRT_SECURE_NO_DEPRECATE",
    "_CRT_NONSTDC_NO_DEPRECATE"
  }

  configuration "windows"
    defines { "WIN32", "_WINDOWS" }

  configuration "Debug"
    targetdir "bin/lib/debug"
    defines {
      "DEBUG",
      "_DEBUG"
    }
    flags { "Symbols" }
    wx_config {Unicode="yes", Version=wx_version, Static="no", Debug="yes"}

  configuration "Release"
    targetdir "bin/lib/release"
    defines {
      "NDEBUG"
    }
    flags { "Optimize" }
    wx_config {Unicode="yes", Version=wx_version, Static="no", Debug="no"}

-- wxSQLite3 as shared library
project "wxsqlite3dll"
  uuid "8B4C3E27-674F-6740-B5F8-5E7BB48E1A9F"
  kind "SharedLib"
  language "C++"
  vpaths {
    ["Header Files"] = { "**.h" },
    ["Source Files"] = { "**.cpp" }
  }
  files { "src/*.cpp", "include/wx/*.h" }
  includedirs { "include", "sqlite3/include" }
  flags { "Unicode" }


  location "build/wxsqlite3dll"
  targetname "wxsqlite3"

  defines {
    "_USRDLL",
    "WXMAKINGDLL_WXSQLITE3",
    "wxUSE_DYNAMIC_SQLITE3_LOAD=0",
    "WXSQLITE3_HAVE_METADATA=1",
    "WXSQLITE3_HAVE_CODEC=1",
    "WXSQLITE3_HAVE_LOAD_EXTENSION=0",
    "_CRT_SECURE_NO_WARNINGS",
    "_CRT_SECURE_NO_DEPRECATE",
    "_CRT_NONSTDC_NO_DEPRECATE"
  }

  -- seems not used
  configuration "embed"
    links { "sqlite3" }
    libdirs { "sqlite3/secure/aes128/lib/release" }

  configuration "not embed"
    links { "sqlite3" }
    libdirs { "sqlite3/secure/aes128/dll/release" }
  --

  configuration "windows"
    defines { "WIN32", "_WINDOWS" }

  configuration "Debug"
    targetdir "bin/dll/debug"
    defines {
      "DEBUG",
      "_DEBUG"
    }
    flags { "Symbols" }
    wx_config {Unicode="yes", Version=wx_version, Static="no", Debug="yes"}

  configuration "Release"
    targetdir "bin/dll/release"
    defines {
      "NDEBUG"
    }
    flags { "Optimize" }
    wx_config {Unicode="yes", Version=wx_version, Static="no", Debug="no"}

-- Minimal wxSQLite3 sample
project "minimal"
  uuid "2A32F255-01A7-914A-93EF-BEC9D76F3875"
  kind "ConsoleApp"
  language "C++"
  vpaths {
    ["Header Files"] = { "**.h" },
    ["Source Files"] = { "**.cpp", "**.rc" }
  }
  files { "samples/*.cpp" }
  includedirs { "include" }
  flags { "Unicode" }

  location "build/minimal"

  defines {
    "_CRT_SECURE_NO_WARNINGS",
    "_CRT_SECURE_NO_DEPRECATE",
    "_CRT_NONSTDC_NO_DEPRECATE"
  }

  configuration "windows"
    defines { "WIN32", "_WINDOWS" }
    files { "samples/*.rc" }

  configuration "linux"
	defines { "dl", "pthread" }

  configuration "embed"
    links { "wxsqlite3lib" }

    links { "sqlite3" }
    libdirs { "sqlite3/secure/aes128/lib/release" }

  configuration "not embed"
    -- FIXME: premake4-beta gmake fails to using correct links options for dll
    -- links { "wxsqlite3dll" }
    links { "wxsqlite3" }
	defines { "WXUSINGDLL_WXSQLITE3" }

    links { "sqlite3" }
    libdirs { "sqlite3/secure/aes128/dll/release" }
	
  configuration { "not embed", "Debug" }
	libdirs { "bin/dll/debug" }

  configuration { "not embed", "Release" }
	libdirs { "bin/dll/release" }

  configuration "Debug"
    targetdir "bin/debug"
    defines { "DEBUG" }
    flags { "Symbols" }
    wx_config {Unicode="yes", Version=wx_version, Static="no", Debug="yes"}

  configuration "Release"
    targetdir "bin/release"
    defines { "NDEBUG" }
    flags { "Optimize" }
    wx_config {Unicode="yes", Version=wx_version, Static="no", Debug="no"}
