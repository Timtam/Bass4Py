import os.path
import platform

from setuptools.extension import Extension

from .extension_handler import ExtensionHandler
from .utils import GetCurrentDirectory, IsX64


class TAGSExtensionHandler(ExtensionHandler):
    def GetExtensions(self):
        return [
            Extension(
                "Bass4Py.tags.tags",
                ["Bass4Py/tags/tags.pyx"],
                libraries=["tags", "bass"],
                language="c",
            ),
        ]

    def GetIncludeVariable(self):
        return "TAGSINC"

    def GetLibraryVariable(self):
        return "TAGSLIB"

    def GetLibraryDirectories(self):

        folders = [
            os.path.join(GetCurrentDirectory(), "tags18", "c"),  # Windows
            os.path.join(GetCurrentDirectory(), "tags18-linux"),  # Linux
        ]

        if IsX64():
            folders = [os.path.join(f, "x64") for f in folders]

        return folders

    def GetIncludeDirectories(self):

        folders = [
            os.path.join(GetCurrentDirectory(), "tags18", "c"),  # Windows
            os.path.join(GetCurrentDirectory(), "tags18-linux"),  # Linux
        ]

        return folders

    def GetContainedPackages(self):
        return ("Bass4Py.tags",)

    def GetDataFiles(self):

        if platform.system() == "Windows":
            if IsX64():
                return {"Bass4Py.tags": [os.path.join("tags18", "x64", "tags.dll")]}
            else:
                return {"Bass4Py.tags": [os.path.join("tags18", "tags.dll")]}

        return {}
