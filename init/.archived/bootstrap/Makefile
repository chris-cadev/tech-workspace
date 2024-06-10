IS_UBUNTU := false
IS_MACOS := false
IS_M2 := false

# Check if the operating system is Ubuntu
ifeq ($(shell uname), Linux)
    IS_UBUNTU := true
endif

# Check if the operating system is macOS
ifeq ($(shell uname), Darwin)
    IS_MACOS := true
endif

# Check if the processor is an M2
ifeq ($(shell sysctl -n machdep.cpu.brand_string | grep -c "Apple M2"), 1)
    IS_M2 := true
endif

install:
ifeq ($(IS_UBUNTU),true)
	make -f Makefile.ubuntu
endif

ifeq ($(IS_MACOS),false)
	@echo "system not supported"
	exit 0
endif
ifeq ($(IS_M2),true)
	make -f Makefile.mac-m2
else
	make -f Makefile.mac
endif
