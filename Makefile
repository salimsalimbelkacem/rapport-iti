.PHONY: watch

TYPST = typst
CHAPITRES = ./chapitres
BROWSER = zen-browser

raport.pdf: main.typ $(CHAPITRES)/*
	$(TYPST) c $<

watch:
	$(BROWSER) ./main.pdf && $(TYPST) watch main.typ
