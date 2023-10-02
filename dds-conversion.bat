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
                rem if its a directory, recurse through it
                mkdir ..\dds\%%d\%%~ng
                
                if exist %%g\* (
                    for /d %%h in (%%g\*) do (
                        mkdir ..\dds\%%d\%%~ng\%%~nh
                        %script% -f DXT5 -m 1 -nologo -o ..\dds\%%d\%%~ng\%%~nh -srgb -y %%h

                        rename ..\dds\%%d\%%~ng\%%~nh.DDS %%~nh.dds
                    )
                )
                %script% -f DXT5 -m 1 -nologo -o ..\dds\%%d\%%~ng -srgb -y %%g

                rename ..\dds\%%d\%%~ng.DDS %%~ng.dds
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