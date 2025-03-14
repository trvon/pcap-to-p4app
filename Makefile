.PHONY: all build clean test lint run help

# Binary name
BINARY_NAME=pcap-to-p4app

# Build directory
BUILD_DIR=build

# Main build target
all: lint build

# Build the application
build:
	@echo "Building $(BINARY_NAME)..."
	@mkdir -p $(BUILD_DIR)
	go build -o $(BUILD_DIR)/$(BINARY_NAME) -v

# Run the application with default settings
run: build
	@echo "Running $(BINARY_NAME)..."
	$(BUILD_DIR)/$(BINARY_NAME) --verbose

# Run with custom PCAP file
run-pcap: build
	@echo "Running with custom PCAP file..."
	$(BUILD_DIR)/$(BINARY_NAME) --pcap $(PCAP) --verbose

# Run with directory of PCAP files
run-dir: build
	@echo "Running with directory of PCAP files..."
	$(BUILD_DIR)/$(BINARY_NAME) --dir $(DIR) --verbose

# Clean build artifacts
clean:
	@echo "Cleaning..."
	@rm -rf $(BUILD_DIR)
	@go clean

# Run tests
test:
	@echo "Running tests..."
	go test -v ./...

# Run linter
lint:
	@echo "Running linter..."
	go vet ./...
	@if command -v golangci-lint > /dev/null; then \
		echo "Running golangci-lint..."; \
		golangci-lint run; \
	else \
		echo "golangci-lint not found, skipping additional lint checks"; \
	fi

# Format code
fmt:
	@echo "Formatting code..."
	go fmt ./...

# Display help information
help:
	@echo "PCAP to P4 Application Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make                    Build the application after running linters"
	@echo "  make build              Build the application"
	@echo "  make run                Run the application with default settings"
	@echo "  make run-pcap PCAP=file.pcap  Run with a specific PCAP file"
	@echo "  make run-dir DIR=path/to/dir  Run with a directory of PCAP files"
	@echo "  make test               Run tests"
	@echo "  make lint               Run linters"
	@echo "  make fmt                Format code"
	@echo "  make clean              Clean build artifacts"
	@echo "  make help               Show this help message"