run:	build
	./game.exe

test:	build
	echo No tests yet

build:
	rm -fv game.exe
	dmcs -r:System.Windows.Forms.dll -r:System.Drawing.dll game.cs

.PHONY:	test
