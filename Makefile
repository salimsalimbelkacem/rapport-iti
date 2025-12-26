.PHONY: watch all clean

TYPST = typst
CHAPITRES = ./chapitres
BROWSER = zen-browser

MAIN = main.typ

all: rapport.pdf

%.pdf: $(MAIN) $(CHAPITRES)/* clean
	$(TYPST) c $< $@

watch:
	$(BROWSER) main.pdf && $(TYPST) w $(MAIN)

clean:
	rm *.pdf
