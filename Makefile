#XMLS=haskell.xml cmake.xml diff.xml hamlet.xml alert.xml modelines.xml c.xml doxygen.xml
XMLS=$(wildcard xml/*.xml)

quick:
	stack install --test --fast --flag "skylighting:executable"

test:
	stack test

format:
	stylish-haskell -i -c .stylish-haskell \
	      bin/*.hs test/test-skylighting.hs \
	      src/Skylighting/*.hs src/Skylighting/Format/*.hs src/Skylighting.hs

bootstrap: $(XMLS)
	-rm -rf src/Skylighting/Syntax
	stack install --fast --flag 'skylighting:bootstrap'
	skylighting-extract $(XMLS)
	stack install --test --fast

syntax-highlighting:
	git clone https://github.com/KDE/syntax-highlighting

update-xml: syntax-highlighting
	cd syntax-highlighting; \
	git pull; \
	cd ../xml; \
	for x in *.xml; do cp ../syntax-highlighting/data/syntax/$x ./; done

clean:
	stack clean

.PHONY: all update-xml quick clean test format

