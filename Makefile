# Project settings
NAME         = exefile
SRC_DIR      = src
OBJ_BASE_DIR = obj
BIN_BASE_DIR = bin

# Compiler flags
CXX      = g++
CXXFLAGS = -std=c++11 -MMD
LDFLAGS  = 

ifeq ($(VERSION),DEBUG)
  CONF      = dbg
  CXXFLAGS += -O0 -DDEBUG -g
else
  CONF      = rel
  CXXFLAGS += -O3 -DNDEBUG
endif

################################################################################

OBJ_DIR = $(OBJ_BASE_DIR)/$(CONF)
BIN_DIR = $(BIN_BASE_DIR)/$(CONF)

EXE = $(BIN_DIR)/$(NAME)

CPP_FILES = $(shell find $(SRC_DIR) -name "*.cpp")
OBJ_FILES = $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(CPP_FILES))
OBJ_DIRS  = $(patsubst $(SRC_DIR)/%/.,$(OBJ_DIR)/%,$(wildcard $(addsuffix /.,$(wildcard $(SRC_DIR)/*))))

.PHONY: all clean

all: $(EXE)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(OBJ_DIR) $(OBJ_DIRS)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(EXE): $(OBJ_FILES)
	@mkdir -p $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

-include $(OBJ_FILES:.o=.d)

clean:
	rm -rf $(OBJ_BASE_DIR) $(BIN_BASE_DIR)
