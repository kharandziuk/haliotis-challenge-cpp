
CXXFLAGS = -g -Wall -Wextra -std=c++11 -Os -pthread -fsanitize=address

ifeq ($(CXX),g++)
CXXFLAGS += -fsanitize=undefined
LDLIBS = -lasan -lubsan
LDFLAGS = -pthread
endif

TARGETS = mcp example-player my-player

.PHONY: all help demo run clean dist

all: $(TARGETS)

help:
	@echo "The following make commands are available:"
	@echo "  $(MAKE) all   - builds everything"
	@echo "  $(MAKE) demo  - runs two of the example players against each other"
	@echo "  $(MAKE) run   - runs your own player against the example player"
	@echo "  $(MAKE) fight - runs two of your own player with resource limits"
	@echo "  $(MAKE) clean - removes all created files"

demo: mcp example-player
	./mcp -d example-player example-player

run: mcp example-player my-player
	./mcp -d example-player my-player

# add '-m 1024 -M 1024' to enforce memory limit
fight: mcp my-player
	./mcp -t 60 -T 61 my-player my-player

clean:
	rm -f $(TARGETS) *.o

mcp : mcp.o
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

mcp.o : mcp.S
