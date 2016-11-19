EJABBERD_VERSION:=16.09
EJABBERD_MAJOR:=16
EJABBERD_MINOR:=09

OBJS:=mod_forward_msg.beam
#OBJS+=another_mod_x.beam
#OBJS+=another_mod_y.beam

ERLC=erlc
ERLC_FLAGS=-DNO_EXT_LIB \
		   -DLAGER

ifeq ($(EJABBERD_MAJOR), 15)
$(info Ejabberd major version 15)
	# master path
	INCLUDE_OPTIONS:=-I /opt/ejabberd-$(EJABBERD_VERSION)/lib/ejabberd-$(EJABBERD_VERSION)/include/
	# master append path
	APPEND_OPTIONS:=-pa /opt/ejabberd-$(EJABBERD_VERSION)/lib/ejabberd-$(EJABBERD_VERSION)/ebin/
endif

ifeq ($(EJABBERD_MAJOR), 16)
$(info Ejabberd major version 16)
	# master path
	INCLUDE_OPTIONS:=-I /opt/ejabberd-$(EJABBERD_VERSION)/lib/ejabberd-$(EJABBERD_VERSION)/include/
	# fxml path
	INCLUDE_OPTIONS+=-I /opt/ejabberd-$(EJABBERD_VERSION)/lib/fast_xml-1.1.15/include/
	# lager path
	INCLUDE_OPTIONS+=-I /opt/ejabberd-$(EJABBERD_VERSION)/lib/lager-3.2.1/include/

	# master append path
	APPEND_OPTIONS:=-pa /opt/ejabberd-$(EJABBERD_VERSION)/lib/ejabberd-$(EJABBERD_VERSION)/ebin/
	# lager append path
	APPEND_OPTIONS+=-pa /opt/ejabberd-$(EJABBERD_VERSION)/lib/lager-3.2.1/ebin/
endif

INSTALL_DIR="/opt/ejabberd-$(EJABBERD_VERSION)/lib/ejabberd-$(EJABBERD_VERSION)/ebin/"



ifndef APPEND_OPTIONS
$(error APPEND_OPTIONS not defined)
endif
ifndef INCLUDE_OPTIONS
$(error INCLUDE_OPTIONS not defined)
endif
ifndef INSTALL_DIR
$(error INSTALL_DIR not defined)
endif

all: dirs clean $(OBJS)

dirs:
	mkdir -p ebin

%.beam : %.erl
	$(ERLC) $(ERLC_FLAGS) -b beam $(INCLUDE_OPTIONS) $< $(APPEND_OPTIONS)
	@mv $@ ebin

install:
	cp ebin/mod_forward_msg.beam $(INSTALL_DIR)
#	cp ebin/another_mod_x.beam $(INSTALL_DIR)
#	cp ebin/another_mod_y.beam $(INSTALL_DIR)

uninstall:
	rm $(INSTALL_DIR)/mod_forward_msg.beam
#	rm $(INSTALL_DIR)/another_mod_x.beam
#	rm $(INSTALL_DIR)/another_mod_y.beam

clean:
	rm -f ebin/$(OBJS)

.PHONY: all dirs install uninstall clean
