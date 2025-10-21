CXX = g++
CXXFLAGS = -Wall

# Path to Eigen headers (adjust if different)
EIGEN_PATH = ./eigen-3.4.0
CXXFLAGS += -I$(EIGEN_PATH)

PATHOBJ = ./build
PATHSRC = ./src

# Source files
SRCS = $(PATHSRC)/matrixMultiplication.cpp \
       $(PATHSRC)/eigenMultiplication.cpp

# Object files (not needed for multiple opt builds, but keep for normal)
OBJS = $(patsubst $(PATHSRC)/%.cpp,$(PATHOBJ)/%.o,$(SRCS))

# Optimization levels
# OPTS = O1 O2 O3
OPTS = O2

# Targets (executables by opt level)
TARGETS = $(foreach opt,$(OPTS), \
              $(PATHOBJ)/matrixMultiplication_$(opt) \
              $(PATHOBJ)/eigenMultiplication_$(opt))

all: $(TARGETS)

# Rules for each optimization level
define COMPILE_RULES
$(PATHOBJ)/matrixMultiplication_$(1): $(PATHSRC)/matrixMultiplication.cpp | $(PATHOBJ)
	$$(CXX) $$(CXXFLAGS) -$(1) $$^ -o $$@

$(PATHOBJ)/eigenMultiplication_$(1): $(PATHSRC)/eigenMultiplication.cpp | $(PATHOBJ)
	$$(CXX) $$(CXXFLAGS) -$(1) $$^ -o $$@
endef

$(foreach opt,$(OPTS),$(eval $(call COMPILE_RULES,$(opt))))

# Ensure build dir exists
$(PATHOBJ):
	mkdir -p $(PATHOBJ)

clean:
	rm -f $(PATHOBJ)/*
