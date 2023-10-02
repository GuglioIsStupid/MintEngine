set script=%CD%\tools\texconv\texconv.exe

pushd src\assets\images\png

if exist ..\dds rmdir ..\dds /q /s

echo Converting PNG images to DXT5 DDS...

for /d %%d in (*) do (
    mkdir ..\dds\%%d

    rem recurse through all folders
    for %%f in (%%d\*) do (
        if exist %%f\* (
            for /d %%g in (%%f\*) do (
                %script% -f DXT5 -m 1 -nologo -o ..\dds\%%d\%%~ng -srgb -y %%g
            )
        )
        %script% -f DXT5 -m 1 -nologo -o ..\dds\%%d -srgb -y %%f

        rename ..\dds\%%d\%%~nf.DDS %%~nf.dds
    )
)

for %%f in (*) do (
    %script% -f DXT5 -m 1 -nologo -o ..\dds -srgb -y %%f

    rename ..\dds\%%~nf.DDS %%~nf.dds
)

popd