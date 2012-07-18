#! /bin/bash
rm -rfv bin
rm -rfv TestResult.xml
xbuild /p:Configuration=Release
nunit-color-console -labels "$@" bin/Release/SimpleRpg.Specs.dll
