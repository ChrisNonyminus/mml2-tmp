VERSION ?= us
MAIN := main

CROSS 			:= mipsel-linux-gnu-
AS    			:= $(CROSS)as
CROSS_AS := $(AS)
ASPSX           := wine ./bin/ASPSX.exe -quiet
CC 	  			:= wine ./bin/CC1PSX.exe -quiet
LD    			:= $(CROSS)ld
CPP   			:= $(CROSS)cpp
OBJCOPY         := $(CROSS)objcopy
PSYQ2ELF      := tools/psyq-obj-parser

UNIX2DOS := unix2dos

AS_FLAGS        += -Iinclude -march=r3000 -mtune=r3000 -no-pad-sections -O1 -G0
CC_FLAGS        += -mcpu=3000 -G0 -w -O2 -funsigned-char -fpeephole -ffunction-cse -fpcc-struct-return -fcommon -fverbose-asm -fgnu-linker -mgas -msoft-float
CPP_FLAGS       += -Iinclude -Isrc/main -undef -Wall -lang-c -fno-builtin -gstabs
CPP_FLAGS       += -Dmips -D__GNUC__=2 -D__OPTIMIZE__ -D__mips__ -D__mips -Dpsx -D__psx__ -D__psx -D_PSYQ -D__EXTENSIONS__ -D_MIPSEL -D_LANGUAGE_C -DLANGUAGE_C -DHACKS
CROSS_AS_FLAGS := $(AS_FLAGS)
ASPSX_FLAGS := -G8 -Iinclude/

ASM_DIR := asm
SRC_DIR := src
INCLUDE_DIR := include
BUILD_DIR := build/$(VERSION)

GO				:= $(HOME)/go/bin/go
GOPATH			:= $(HOME)/go
ASPATCH			:= $(GOPATH)/bin/aspatch
SOTNDISK		:= $(GOPATH)/bin/sotn-disk

# Files
MAIN_ASM_DIRS   := $(ASM_DIR)/$(MAIN) $(ASM_DIR)/$(MAIN)/data
NONMATCHINGS_DIRS := $(ASM_DIR)/$(MAIN)/nonmatchings/16D4  $(ASM_DIR)/$(MAIN)/nonmatchings/60F4
MAIN_SRC_DIRS   := $(SRC_DIR)/$(MAIN)
MAIN_S_FILES    := $(foreach dir,$(MAIN_ASM_DIRS),$(wildcard $(dir)/*.s)) \
					$(foreach dir,$(MAIN_ASM_DIRS),$(wildcard $(dir)/**/*.s))
MAIN_C_FILES    := $(foreach dir,$(MAIN_SRC_DIRS),$(wildcard $(dir)/*.c)) \
					$(foreach dir,$(MAIN_SRC_DIRS),$(wildcard $(dir)/**/*.c))
MAIN_O_FILES    := $(foreach file,$(MAIN_S_FILES),$(BUILD_DIR)/$(file).o) \
					$(foreach file,$(MAIN_C_FILES),$(BUILD_DIR)/$(file).o)
MAIN_TARGET     := $(BUILD_DIR)/$(MAIN)

# overrides

$(BUILD_DIR)/asm/main/header.s.o: ASPSX := $(CROSS_AS)
$(BUILD_DIR)/asm/main/header.s.o: ASPSX_FLAGS := $(CROSS_AS_FLAGS)

$(BUILD_DIR)/asm/main/data/%.rodata.s.o: ASPSX := $(CROSS_AS)
$(BUILD_DIR)/asm/main/data/%.rodata.s.o: ASPSX_FLAGS := $(CROSS_AS_FLAGS)

$(BUILD_DIR)/asm/main/data/%.data.s.o: ASPSX := $(CROSS_AS)
$(BUILD_DIR)/asm/main/data/%.data.s.o: ASPSX_FLAGS := $(CROSS_AS_FLAGS)

all: build check
build: main
check:
	sha1sum --check mml2.sha

fixgp:
	@echo "Stripping %got & %gp_rel from assembly..."
	grep -rlE '%(got|gp_rel)' asm/esa/nonmatchings | xargs sed -i -E -s 's/%(got|gp_rel)\(([^)]+)\)\(\$$28\)/\2/' 2>/dev/null || true
	grep -rlE '%(got|gp_rel)' asm/esa/nonmatchings | xargs sed -i -E -s 's/\$$28, %(got|gp_rel)\(([^)]+)\)/\2/' 2>/dev/null || true

main: main_dirs $(MAIN_TARGET).exe
main_dirs: nonmatchings
	$(foreach dir, $(MAIN_ASM_DIRS) $(MAIN_SRC_DIRS), $(shell mkdir -p $(BUILD_DIR)/$(dir)))
$(MAIN_TARGET).exe: $(MAIN_TARGET).elf
	$(OBJCOPY) -O binary $< $@
$(MAIN_TARGET).elf: $(MAIN_O_FILES)
	$(LD) -o $@ \
	-Map mml2.$(MAIN_TARGET).map \
	-T mml2.ld \
	-T syms.$(VERSION).txt \
	--no-check-sections \
	-nostdlib \
	-s



$(BUILD_DIR)/%.s.o: %.s
	$(UNIX2DOS) -q $<
	$(ASPSX) $(ASPSX_FLAGS) $< -o $@.obj
	if [[ "$$(head -c3 $@.obj)" = "LNK" ]] ; then $(PSYQ2ELF) $@.obj -o $@ >/dev/null ; else cp $@.obj $@; fi

$(BUILD_DIR)/%.c.o: %.c $(ASPATCH)
	$(CPP) $(CPP_FLAGS) $< | $(UNIX2DOS) | $(CC) $(CC_FLAGS) -o $@.s
	$(ASPSX) -G8 -Iinclude/ $@.s -o $@.obj
	if [[ "$$(head -c3 $@.obj)" = "LNK" ]] ; then $(PSYQ2ELF) $@.obj -o $@ >/dev/null ; else cp $@.obj $@; fi

$(GO):
	curl -L -o go1.19.7.linux-amd64.tar.gz https://go.dev/dl/go1.19.7.linux-amd64.tar.gz
	tar -C $(HOME) -xzf go1.19.7.linux-amd64.tar.gz
	rm go1.19.7.linux-amd64.tar.gz
$(ASPATCH): $(GO)
	$(GO) install github.com/xeeynamo/sotn-decomp/tools/aspatch@latest
$(SOTNDISK): $(GO)
	$(GO) install github.com/xeeynamo/sotn-decomp/tools/sotn-disk@latest


# for each file in NONMATCHINGS_DIR recursively, run unix2dos on it

nonmatchings: $(NONMATCHINGS_DIRS) fixgp
	$(foreach dir,$(NONMATCHINGS_DIRS),$(shell find $(dir) -type f -exec unix2dos {} \;))


.PHONY: all, clean, format, check, expected, nonmatchings, fixgp
.PHONY: main
.PHONY: %_dirs
SHELL = /bin/bash -e -o pipefail
