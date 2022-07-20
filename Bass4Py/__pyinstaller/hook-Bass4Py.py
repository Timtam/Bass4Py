from PyInstaller.utils.hooks import collect_all

datas, binaries, hiddenimports = collect_all('Bass4Py', exclude_datas=['__pyinstaller'])
