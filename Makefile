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

# Python lib
PYTHON_DIR = /usr/lib/python$(shell \
    python -c \
	'from sys import version_info as v; print "%s.%s" % (v.major, v.minor)')
PYTHON_FILES = goldibox.py

# QML files
SHARE_DIR = /usr/share/goldibox
SHARE_FILES = \
	images/icon.png \
	launcher.ini \
	qml/goldibox-remote/Goldistat/ExitButton.qml \
	qml/goldibox-remote/Goldistat/Goldistat.qml \
	qml/goldibox-remote/Goldistat/PowerButton.qml \
	qml/goldibox-remote/Goldistat/Private/GoldistatIn.qml \
	qml/goldibox-remote/Goldistat/Private/GoldistatOut.qml \
	qml/goldibox-remote/Goldistat/Private/GoldistatSet.qml \
	qml/goldibox-remote/assets/background.png \
	qml/goldibox-remote/assets/graph.png \
	qml/goldibox-remote/assets/locks.png \
	qml/goldibox-remote/description.ini \
	qml/goldibox-remote/goldibox-remote.qml \
	qml/goldibox-remote.pro \
	qml/main.cpp \
	qml/main.qml \
	qml/qml.qrc

# Overlay
HAVE_DTC = $(shell test -f /usr/bin/dtc && echo 1)

.PHONY: default
default:
	@echo "Please specify a target; choices:" 1>&2
	@echo "    install"
	@echo "    build"

.PHONY: add_user
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

/etc/apache2/conf-available/goldibox.conf: templates/apache.conf
	@mkdir -p $(dir $@)
	sed < $< > $@ \
	    -e 's,@VAR_DIR@,$(VAR_DIR),'
	ln -sf ../conf-available/goldibox.conf \
	    /etc/apache2/conf-enabled/goldibox.conf

$(VAR_DIR)/graphs/index.html: templates/index.html $(VAR_DIR)/saved_state.yaml
	@install -d -o $(USER) $(dir $@)
	cp $< $@

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

ifneq ($(HAVE_DTC),)
/lib/firmware/pb_goldibox-00A0.dtbo: etc/pb_goldibox.dts
	dtc -O dtb -o $@ -b 0 -@ $<
	if ! grep -q $@ /boot/uEnv.txt; then \
	    echo dtb_overlay=$@ > /boot/uEnv.txt; \
	fi
ALL_FILES += /lib/firmware/pb_goldibox-00A0.dtbo
endif

/etc/systemd/system/goldibox.service: templates/goldibox.service
	sed < $< > $@ \
	    -e 's,@USER@,$(USER),'
	ln -sf $@ /lib/systemd/goldibox.service

ALL_FILES += \
	$(patsubst %,$(HAL_DIR)/%,$(HAL_FILES)) \
	$(patsubst %,$(PYTHON_DIR)/%,$(PYTHON_FILES)) \
	$(patsubst %,$(BIN_DIR)/%,$(BIN_FILES)) \
	$(patsubst %,$(SHARE_DIR)/%,$(SHARE_FILES)) \
	$(ETC_DIR)/config.yaml \
	$(ETC_DIR)/overlay-pb.bbio \
	$(VAR_DIR)/saved_state.yaml \
	/etc/systemd/system/goldibox.service \
	/etc/apache2/conf-available/goldibox.conf \
	$(VAR_DIR)/graphs/index.html

.PHONY: install
install: add_user $(ALL_FILES)

.PHONY: uninstall
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
