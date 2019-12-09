@echo off
IF %SDIST_ONLY% == 1 (
  %PYTHON%\\python.exe setup.py sdist
) ELSE (
  %PYTHON%\\python.exe setup.py build_ext --inplace
  %PYTHON%\\python.exe setup.py bdist_wheel
)
