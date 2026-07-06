DRAFTS = openid-wise-profile-1_0

all: $(addsuffix .html,$(DRAFTS)) $(addsuffix .txt,$(DRAFTS))

%.xml: %.md
	kramdown-rfc2629 $< > $@

%.html: %.xml
	xml2rfc $< --html -o $@

%.txt: %.xml
	xml2rfc $< --text -o $@

clean:
	rm -f $(addsuffix .xml,$(DRAFTS)) $(addsuffix .html,$(DRAFTS)) $(addsuffix .txt,$(DRAFTS))

.PHONY: all clean
