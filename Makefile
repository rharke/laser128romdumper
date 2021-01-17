# https://github.com/AppleCommander/bastools/tree/master/tools/bt
BT=bt

# https://github.com/mach-kernel/cadius
CADIUS=cadius

# https://cc65.github.io/
CA65=ca65
LD65=ld65

BDIR=build
ODIR=$(BDIR)/obj
LDIR=$(BDIR)/lib
SDIR=src
RDIR=res

IMGNAME=laserdump.po
VOLNAME=LASERDUMP

# 04=TXT, 06=BIN, FC=BAS, FF=SYS
attrs.PRODOS		= FF0000
attrs.BASIC.SYSTEM	= FF2000
attrs.STARTUP		= FC0801
attrs.DUMPROM		= 064000

# Add a file to a disk image with Cadius, using the attrs.*
# map above for the file type/subtype.
define addfile
	cp $3 $3\#$(attrs.$(notdir $3)) ;
	$(CADIUS) addfile $1 $2 $3\#$(attrs.$(notdir $3)) ;
	rm $3\#$(attrs.$(notdir $3)) ;
endef

$(BDIR)/$(IMGNAME): \
$(RDIR)/PRODOS \
$(RDIR)/BASIC.SYSTEM \
$(LDIR)/STARTUP \
$(LDIR)/DUMPROM
	rm -f $@
	$(CADIUS) createvolume $@ $(VOLNAME) 140KB
	$(foreach f,$^,$(call addfile,$@,/$(VOLNAME),$f))

$(ODIR)/%.o: $(SDIR)/%.s
	mkdir -p $(ODIR)
	$(CA65) -o $@ $^

$(LDIR)/%: $(ODIR)/%.o
	mkdir -p $(LDIR)
	$(LD65) -t none -o $@ $^

$(LDIR)/%: $(SDIR)/%.bas
	mkdir -p $(LDIR)
	$(BT) -o $@ $^

clean:
	rm -rf build
