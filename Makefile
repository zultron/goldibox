USER = goldibox

# For saved state
VAR_DIR = /var/lib/goldibox

# For configuration
ETC_DIR = /etc/goldibox

# HAL configs
HAL_DIR = $(ETC_DIR)/hal
HAL_FILES = common.hal pb.hal sim.hal

# Executables
BIN_DIR = /usr/bin
BIN_FILES = goldibox goldibox-control goldibox-logger goldibox-remote \
	goldibox-sim-temp

PYTHON_DIR = /usr/lib/python$(shell \
    python -c \
	'from sys import version_info as v; print "%s.%s" % (v.major, v.minor)')
PYTHON_FILES = goldibox.py

SHARE_DIR = /usr/share/goldibox
SHARE_FILES = \
	images/icon-fridge.svg \
	launcher.ini \
	qml/goldibox-remote/description.ini \
	qml/goldibox-remote/goldibox-remote.qml \
	qml/goldibox-remote/assets/background.png \
	qml/goldibox-remote.pro \
	qml/main.cpp \
	qml/main.qml \
	qml/qml.qrc

default:
	@echo "Please specify a target; choices:" 1>&2
	@echo "    install"
	@echo "    build"

add_user:
	@ if ! id $(USER) 2>/dev/null >/dev/null; then \
	    echo "Creating user $(USER)"; \
	    adduser \
		--home $(VAR_DIR) \
		--no-create-home \
		--shell /usr/sbin/nologin \
		--gecos goldibox \
		--disabled-password \
		$(USER) >/dev/null; \
	fi

$(patsubst %,$(HAL_DIR)/%,$(HAL_FILES)): $(HAL_DIR)/%: hal/%
	@mkdir -p $(HAL_DIR)
	install -m 644 $< $@

$(patsubst %,$(PYTHON_DIR)/%,$(PYTHON_FILES)): $(PYTHON_DIR)/%: lib/python/%
	@mkdir -p $(dir $@)
	install -m 644 $< $@

$(patsubst %,$(BIN_DIR)/%,$(BIN_FILES)): $(BIN_DIR)/%: bin/%
	install -m 755 $< $@

$(patsubst %,$(SHARE_DIR)/%,$(SHARE_FILES)): $(SHARE_DIR)/%: %
	@mkdir -p $(dir $@)
	install -m 644 $< $@

$(VAR_DIR)/saved_state.yaml:
	install -d -o $(USER) $(VAR_DIR)
	touch $(VAR_DIR)/saved_state.yaml
	chown $(USER) $(VAR_DIR)/saved_state.yaml

$(ETC_DIR)/overlay-pb.bbio: etc/overlay-pb.bbio
	install -d $(ETC_DIR)
	@mkdir -p $(dir $@)
	install -m 644 $< $@

$(ETC_DIR)/config.yaml: templates/config.yaml
	@mkdir -p $(ETC_DIR)
	sed < $< > $@ \
	    -e 's,@HAL_DIR@,$(HAL_DIR),' \
	    -e 's,@VAR_DIR@,$(VAR_DIR),' \
	    -e 's,@ETC_DIR@,$(ETC_DIR),' \
	    -e 's,@SHARE_DIR@,$(SHARE_DIR),'

ALL_FILES = \
	$(patsubst %,$(HAL_DIR)/%,$(HAL_FILES)) \
	$(patsubst %,$(PYTHON_DIR)/%,$(PYTHON_FILES)) \
	$(patsubst %,$(BIN_DIR)/%,$(BIN_FILES)) \
	$(patsubst %,$(SHARE_DIR)/%,$(SHARE_FILES)) \
	$(ETC_DIR)/config.yaml \
	$(ETC_DIR)/overlay-pb.bbio \
	$(VAR_DIR)/saved_state.yaml


install: add_user $(ALL_FILES)

uninstall:
	@ for i in $(ALL_FILES); do \
	    echo "Removing $$i"; \
	    rm -f $$i; \
	done



.PHONY: build
build:
	mkdir -p build
	( cd build; qmake ../qml )
	make -C build
