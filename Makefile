# Run everything from the repo root.
#
#   make                         build every program in every class
#   make run                     build + run src/main.cpp from the latest class (cwd = src/)
#   make run P=bfs ARGS='a b'    run src/bfs.cpp instead, with arguments
#   make run C=07 P=bfs          same, but from class 07
#   make run P=bfs DEBUG=1       build with sanitizers (binary gets a .dbg suffix)
#   make new SLUG=bfs [DATE=YYYY-MM-DD]
#   make format / make tidy      clang-format / clang-tidy (latest class, or C=07, or C=all)
#   make clean

SHELL := bash

CXX ?= g++
P ?= main
# compile_flags.txt is shared with clangd, so diagnostics in the editor match the build.
CXXFLAGS := $(shell cat compile_flags.txt) -O2 -g
SUFFIX :=
ifdef DEBUG
CXXFLAGS += -O0 -fsanitize=address,undefined -fno-omit-frame-pointer
SUFFIX := .dbg
endif

SRCS := $(wildcard classes/*/src/*.cpp)
# classes/X/src/foo.cpp -> classes/X/build/foo
bin = $(subst /src/,/build/,$(1:.cpp=))$(SUFFIX)
BINS := $(foreach s,$(SRCS),$(call bin,$(s)))

# Class selection: C=7 / C=07 -> classes/07-*, otherwise the highest-numbered class.
ifdef C
ifneq ($(C),all)
CLASS := $(firstword $(wildcard classes/$(shell printf '%02d' $$((10#$(C))))-*))
endif
else
CLASS := $(shell ls -d classes/[0-9]*/ 2>/dev/null | sed 's|/$$||' | sort -t/ -k2 -n | tail -n1)
endif

ifeq ($(C),all)
SCOPE_SRCS := $(SRCS)
else
SCOPE_SRCS := $(wildcard $(CLASS)/src/*.cpp)
endif

.PHONY: all run new format tidy check-scope clean

all: $(BINS)

define PROG_RULE
$(call bin,$(1)): $(1) compile_flags.txt
	@mkdir -p $$(@D)
	$$(CXX) $$(CXXFLAGS) $$< -o $$@
endef
$(foreach s,$(SRCS),$(eval $(call PROG_RULE,$(s))))

run: $(call bin,$(CLASS)/src/$(P).cpp)
	@test -n "$(CLASS)" || { echo "no class found (C=$(C))" >&2; exit 1; }
	cd $(CLASS)/src && ../build/$(P)$(SUFFIX) $(ARGS)

new:
	scripts/new-class.sh $(SLUG) $(if $(DATE),--date $(DATE))

format tidy: check-scope
format:
	clang-format -i $(SCOPE_SRCS)
tidy:
	clang-tidy --quiet $(SCOPE_SRCS)

check-scope:
	@test -n "$(SCOPE_SRCS)" || { echo "no sources in $(if $(CLASS),$(CLASS)/src,C=$(C))" >&2; exit 1; }

clean:
	rm -rf classes/*/build
