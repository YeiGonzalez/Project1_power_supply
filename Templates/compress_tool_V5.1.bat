@echo off
setlocal EnableDelayedExpansion
title "Release Organizer"


set /p temp="Introduce the release output directory: "
cd /D "%temp%"

echo.
echo 7z Compressor Tool
echo.
::Use .7z or .zip
set "extension=.zip"


if exist "%temp%" (
    goto :organizer
) else (
    echo Path does not exist.
    pause
    goto:eof
)

:organizer
for /f "delims=" %%i in ('dir /a:d /b "Altium"') do (set compressname_altium=%%i)
for /f %%a in ('dir /b /ad Altium^|find /c /v "" ') do (set foldercount_altium=%%a)
if %foldercount_altium%==1 (echo Compressing Altium Files ...
echo.
"C:\Program Files\7-zip\7z" a Altium\"%compressname_altium%"!extension! .\Altium\"%compressname_altium%"\*
echo Altium Files have been compressed.
echo.
echo Cleaning Altium Subdirectory...
 RD /s /q Altium\"%compressname_altium%"
echo.
) else (
echo Altium Subdirectory is already compressed.
echo.
)

for /f "delims=" %%i in ('dir /a:d /b "2D-3D"') do (set compressname_2d-3d=%%i)
for /f %%a in ('dir /b /ad 2D-3D^|find /c /v "" ') do (set foldercount_2d-3d=%%a)
if %foldercount_2d-3d%==1 (echo Compressing 2D-3D ...
echo.
"C:\Program Files\7-zip\7z" a 2D-3D\"%compressname_2d-3d%"!extension! .\2D-3D\"%compressname_2d-3d%"\*
echo 2D-3D Files have been compressed.
echo.
echo Cleaning 2D-3D Subdirectory ...
RD /s /q 2D-3D\"%compressname_2D-3D%"
echo.
) else (
echo 2D-3D Subdirectory is already compressed.
echo.
)

for /f "delims=" %%i in ('dir /a:d /b "Gerbers"') do (set compressname_gerbers=%%i)
for /f %%a in ('dir /b /ad Gerbers^|find /c /v "" ') do (set foldercount_gerbers=%%a)
if %foldercount_gerbers%==1 (echo Compressing Gerbers Directory ...
echo.
"C:\Program Files\7-zip\7z" a Gerbers\"%compressname_gerbers%"!extension! .\Gerbers\"%compressname_gerbers%"\*
echo Gerber Files have been compressed.
echo.
echo Cleaning Gerbers Subdirectory ...
RD /s /q Gerbers\"%compressname_gerbers%"
echo.
) else (
echo Gerbers Subdirectory is already compressed.
echo.
)
@echo off
for /f %%b in ('dir /b /aa "%CD%"^| find /c /v ""') do (set file_counter=%%b)
if %file_counter%==0 (echo There is no useless file on Release Directory.
echo.
) else (echo Cleaning Release Directory...
echo.
if not exist Bat.Recycle (mkdir "Bat.Recycle"
)
@echo off
move *.* "Bat.Recycle"
echo.
)
if exist Bat.Recycle (
    cd Bat.Recycle
    echo From Bat.Recycle the files deleted are:
    for /f "delims=" %%i in ('dir /a /b') do (
        echo %%i
    )
    cd /D "!temp!"
    rmdir /s /q "Bat.Recycle"
    echo.
)
if exist Dependencies (
    cd Dependencies
    echo From Dependencies the files deleted are:
    for /f "delims=" %%i in ('dir /a /b') do (
        echo %%i
    )
    cd /D "!temp!"
    rmdir /s /q "Dependencies"
    echo.
)



:choice
set /P c=Do you want to rename the files[Y/N]?
if /I "%c%" EQU "Y" goto :rename
if /I "%c%" EQU "N" goto :out
goto :choice

:out
    echo Files will not renamed
    goto:eof

:rename
    for /f "delims=" %%a in ('dir /a:d /b PDF*') do (set schematics_folder=%%a)
    for /f "delims=" %%a in ('dir /a:d /b PB*') do (set pbm_folder=%%a)
    cd %pbm_folder%
    for /f %%a in ('dir /b ^|find /c "PBM"') do (set number_pbms=%%a)
    for /f %%a in ('dir /b ^|find /c "No Variations"') do (set number_no_variations_pbm=%%a)
    set /a number_variants=!number_pbms!-!number_no_variations_pbm!

    if !number_no_variations_pbm!==1 (
        for /f "delims=" %%a in ('dir /b^|find "No Variations"') do (set no_variations_pbm=%%a)
        call set "pbm_name=!no_variations_pbm:-[No Variations]=!"
        call set "pbm_name=!pbm_name:-No Variations=!"
        rename "!no_variations_pbm!" "!pbm_name!"
        echo.
        echo PBM No Variations was removed from the name
        echo.
    )

    cd /D "%temp%"

    cd %schematics_folder%
    for /f %%a in ('dir /b ^|find /c "SCH"') do (set number_schs=%%a)
    for /f %%a in ('dir /b ^|find /c "No Variations"') do (set number_no_variations_sch=%%a)

    if !number_no_variations_sch!==1 (
        for /f "delims=" %%a in ('dir /b^|find "No Variations"') do (set no_variations_schematics=%%a)
        call set schematics_name=!no_variations_schematics:-[No Variations]=!
        call set schematics_name=!schematics_name:-No Variations=!
        rename "!no_variations_schematics!" "!schematics_name!"
        echo.
        echo Schematic No Variations was removed from the name
        echo.
    )
    
    cd /D "%temp%"


    if !number_no_variations_pbm! gtr 1 (
        echo There are more than 1 file of No Variations, please check the files
        echo There are more than 1 file of No Variations, please check the files >> !filename!
        goto:eof
    )

    if !number_no_variations_pbm!==1 (
        if !number_variants!==0 (
            echo There is just the main variant.
        )


        cd %pbm_folder%
        if !number_variants! gtr 1 (
            set /a "item=1"
            for /f "delims=" %%a in ('dir /b ^|find "PBM"') do (
                if not %%~a equ !pbm_name! (
                    set variant_names[!item!]=%%~a
                    call set variant_names[!item!]=%%variant_names[!item!]:*_=%%
                    call set variant_names[!item!]=%%variant_names[!item!]:*_=%%
                    call set to_del=%%variant_names[!item!]:~-18%%
                    call set variant_names[!item!]=%%variant_names[!item!]:!to_del!=%%
                    set /a item+=1
                )
            )
        )
        cd /D "%temp%"

        if !number_variants! gtr 1 (
            echo The variants found were:
            for /l %%n in (1,1,!number_variants!) do (
                echo -!variant_names[%%n]!
            )
        )


        if !number_variants! gtr 1 (
            for /l %%n in (1,1,!number_variants!) do (
                echo.
                echo For the variant: !variant_names[%%n]!
                call :input_len variant_pns[%%n] 
            )
            for /l %%n in (1,1,!number_variants!) do ( 
            cd %pbm_folder%
            for /f "delims=" %%a in ('dir /b ^|find "!variant_names[%%n]!_"') do (
                if not %%a==!pbm_name! (
                    echo.
                    echo The file: %%a
                    set variant=%%a
                    call set variant_name=!variant:*_=!
                    call set variant_name=!variant_name:~0,9!
                    call set "pbm_full=PBM!variant_pns[%%n]!"
                    call set variant=%%variant:!variant_name!=!pbm_full!%%
                    rename "%%a" "!variant!"
                    echo Was renamed as: !variant! 
                )
            )
            cd /D "%temp%"
            cd %schematics_folder%
            for /f "delims=" %%a in ('dir /b ^|find "!variant_names[%%n]!_"') do (
                if not %%a==!sch_name! (
                    echo.
                    echo The file: %%a
                    set variant=%%a
                    call set variant_name=!variant:*_=!
                    call set variant_name=!variant_name:~0,9!
                    call set "sch_full=SCH!variant_pns[%%n]!"
                    call set variant=%%variant:!variant_name!=!sch_full!%%
                    rename "%%a" "!variant!"
                    echo Was renamed as: !variant! 
                )
            )
            cd /D "%temp%"
            )
        )

    )

    if !number_no_variations_pbm!==0 (
        if !number_variants!==1 (
            echo There are not variant files or there is just the main variant.
        )
        
        cd %pbm_folder%

        if !number_variants! gtr 1 (
            set /a "item=1"
            for /f "delims=" %%a in ('dir /b ^|find "PBM"') do (
                set variant_names[!item!]=%%~a
                call set variant_names[!item!]=%%variant_names[!item!]:*_=%%
                call set variant_names[!item!]=%%variant_names[!item!]:*_=%%
                call set to_del=%%variant_names[!item!]:~-18%%
                call set variant_names[!item!]=%%variant_names[!item!]:!to_del!=%%
                set /a item+=1
            )
        )

        set /a upper_limit=!number_variants!-1

        if !number_variants! gtr 1 (
            echo The variants found were:
            for /l %%n in (1,1,!number_variants!) do (
                echo -!variant_names[%%n]!
            )
        )
        cd /D "%temp%"


        if !number_variants! gtr 1 (
            for /l %%n in (1,1,!number_variants!) do (
                echo.
                echo For the variant: !variant_names[%%n]!
                call :input_len variant_pns[%%n] 
            )
            for /l %%n in (1,1,!number_variants!) do (
            cd %pbm_folder%
            for /f %%a in ('dir /b ^|find /c "!variant_names[%%n]!_"') do (set pbm_to_change=%%a)
            if !pbm_to_change!==1 (
                for /f "delims=" %%a in ('dir /b ^|find "!variant_names[%%n]!_"') do (
                    echo.
                    echo The file: %%a
                    set variant=%%a
                    call set variant_name=!variant:*_=!
                    call set variant_name=!variant_name:~0,9!
                    call set "pbm_full=PBM!variant_pns[%%n]!"
                    call set variant=%%variant:!variant_name!=!pbm_full!%%
                    rename "%%a" "!variant!"
                    echo Was renamed as: !variant! 
                )
            )
            cd /D "%temp%"
            cd %schematics_folder%
            for /f %%a in ('dir /b ^|find /c "!variant_names[%%n]!_"') do (set sch_to_change=%%a)
            if !sch_to_change!==1 (
                for /f "delims=" %%a in ('dir /b ^|find "!variant_names[%%n]!_"') do (
                    echo.
                    echo The file: %%a
                    set variant=%%a
                    call set variant_name=!variant:*_=!
                    call set variant_name=!variant_name:~0,9!
                    call set "sch_full=SCH!variant_pns[%%n]!"
                    call set variant=%%variant:!variant_name!=!sch_full!%%
                    rename "%%a" "!variant!"
                    echo Was renamed as: !variant! 
                )
            )
            cd /D "%temp%"

            )
        )
        
    )
pause


goto:eof
:input_len StrVar 
    call set /p "name_temp=Please write the TPN: "
    call :strlen name_temp _length
    for %%N in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
        if !_length! neq 6 (
            call set /p "name_temp=Write a valid TPN: "
            call :strlen name_temp _length
        )
    )
    endlocal&if "%~1" neq "" (set %~1=%name_temp%) else echo %name_temp%

goto:eof
:strlen  StrVar  [RtnVar]
  setlocal EnableDelayedExpansion
  set "s=#!%~1!"
  set "len=0"
  for %%N in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
    if "!s:~%%N,1!" neq "" (
      set /a "len+=%%N"
      set "s=!s:~%%N!"
    )
  )
  endlocal&if "%~2" neq "" (set %~2=%len%) else echo %len%
exit /b