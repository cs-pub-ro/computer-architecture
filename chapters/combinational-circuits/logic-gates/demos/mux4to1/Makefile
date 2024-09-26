# Variables
CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++20
TARGET = mux4to1
SRCS = mux4to1.cpp

# Default target
all: $(TARGET)

# Build target
$(TARGET): $(TARGET).cpp
	$(CXX) $(CXXFLAGS) -o $(TARGET) $<

# Clean target
clean:
	rm -f $(TARGET)

# Run target
run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run