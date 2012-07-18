#! /bin/bash
rm -rfv bin
rm -rfv TestResult.xml
xbuild
nunit-color-console -labels "$@" bin/Debug/SimpleRpg.Specs.dll
