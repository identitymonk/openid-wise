DRAFTS = openid-wise-profile-1_0
BUILD = build

all: $(addprefix $(BUILD)/,$(addsuffix .html,$(DRAFTS))) \
     $(addprefix $(BUILD)/,$(addsuffix .txt,$(DRAFTS))) \
     $(addprefix $(BUILD)/,$(addsuffix .docx,$(DRAFTS)))

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
