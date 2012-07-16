run:	build
	./game.exe

test:	build
	echo No tests yet

build:
	rm -fv game.exe
	dmcs -r:System.Windows.Forms.dll game.cs

.PHONY:	test
