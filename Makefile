DRAFTS = openid-wise-profile-1_0
BUILD = build

# DOCX output is only produced when pandoc is available (i.e. local builds).
# CI runners without pandoc build HTML and TXT only.
PANDOC := $(shell command -v pandoc 2>/dev/null)

OUTPUTS = $(addprefix $(BUILD)/,$(addsuffix .html,$(DRAFTS))) \
          $(addprefix $(BUILD)/,$(addsuffix .txt,$(DRAFTS)))

ifdef PANDOC
OUTPUTS += $(addprefix $(BUILD)/,$(addsuffix .docx,$(DRAFTS)))
endif

all: $(OUTPUTS)

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/%.xml: %.md | $(BUILD)
	kramdown-rfc2629 $< > $@

$(BUILD)/%.html: $(BUILD)/%.xml
	xml2rfc $< --html -o $@

$(BUILD)/%.txt: $(BUILD)/%.xml
	xml2rfc $< --text -o $@

$(BUILD)/%.docx: $(BUILD)/%.html
	pandoc $< -f html -t docx -o $@

clean:
	rm -rf $(BUILD)

.PHONY: all clean
