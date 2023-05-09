XZ_VERSION = 5.2.5
XZ_TARBALL = $(DOWNLOAD)/xz-$(XZ_VERSION).tar.gz
XZ_URL = https://tukaani.org/xz/xz-$(XZ_VERSION).tar.gz/download

XZ_WASM_LIB = $(WASM)/lib/liblzma.a
DEFAULT_WASM_LIBS += $(XZ_WASM_LIB)

.PHONY: xz
xz: $(XZ_WASM_LIB)

$(XZ_TARBALL):
	mkdir -p $(DOWNLOAD)
	wget $(XZ_URL) -O $@

$(XZ_WASM_LIB): $(XZ_TARBALL)
	mkdir -p $(BUILD)/xz-$(XZ_VERSION)/build
	tar -C $(BUILD) -xf $(XZ_TARBALL)
	cd $(BUILD)/xz-$(XZ_VERSION)/build && \
	  CFLAGS="$(WASM_CFLAGS)" \
	  emconfigure ../configure \
	    --enable-shared=no \
	    --enable-static=yes \
	    --enable-threads=no \
	    --prefix=$(WASM) && \
	  emmake make install
