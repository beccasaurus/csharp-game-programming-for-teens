run:	build_debug test_debug
	@bin/Debug/SimpleRpg.exe

test_debug:	build_debug
	@nunit-color-console -labels bin/Debug/SimpleRpg.Specs.dll

test_release:	build_release
	@nunit-color-console -labels bin/Release/SimpleRpg.Specs.dll

build_debug:	clean
	@xbuild

test_release:	clean
	@xbuild /p:Configuration=Release

clean:
	@rm -rfv bin
	@rm -rfv */obj
	@rm -rfv TestResult.xml
