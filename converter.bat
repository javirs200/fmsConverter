@echo off
setlocal enabledelayedexpansion

set "directory=%cd%"

set "outputFile=%cd%\output.json"

if exist "%outputFile%" (
    del "%outputFile%"
)

set /a count=0
for /r "%directory%" %%f in (*) do (
    set /a count+=1
    set "file[!count!]=%%f"
    echo     !count!. %%~nxf
)

set /p "choice=Enter the file number to extract lines from: "

echo [ >> %outputFile%

set "countLine=0"



for /f "usebackq delims=" %%a in ("!file[%choice%]!") do (
    set /a countLine+=1
    set "line=%%a"
    if !countLine! geq 7 (
        for /f "tokens=2,3,5,6 delims= " %%b in ("!line!") do (

            if "%%c"=="ADEP" (
                echo {^ >> %outputFile%
                echo "ident": "%%b", >> %outputFile%
                echo "type": "DPT", >> %outputFile%
                echo "lat": %%d, >> %outputFile%
                echo "lon": %%e, >> %outputFile%
                echo "alt": 0, >> %outputFile%
                echo "spd": "", >> %outputFile%
                echo "heading": 0 >> %outputFile%
                echo }^,^ >> %outputFile%
            )
            
            if "%%c"=="ADES" (
                echo {^ >> %outputFile%
                echo "ident": "%%b", >> %outputFile%
                echo "type": "DST", >> %outputFile%
                echo "lat": %%d, >> %outputFile%
                echo "lon": %%e, >> %outputFile%
                echo "alt": 0, >> %outputFile%
                echo "spd": "" >> %outputFile%
                echo }^ >> %outputFile%
            )

            if not "%%c"=="ADEP" (
                if not "%%c"=="ADES" (
                    echo {^ >> %outputFile%
                    echo "ident": "%%b", >> %outputFile%
                    echo "type": "FIX", >> %outputFile%
                    echo "lat": %%d, >> %outputFile%
                    echo "lon": %%e, >> %outputFile%
                    echo "alt": 0, >> %outputFile%
                    echo "spd": "" >> %outputFile%
                    echo }^,^ >> %outputFile%
                )
            )

        )
    )
    
)



echo ] >> %outputFile%

echo JSON file created successfully!



endlocal