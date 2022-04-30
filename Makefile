SHELL:=/bin/sh
.PHONY: all build test clean

export GO111MODULE=on

# Path Related
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))
RELEASE_DIR := $(MKFILE_DIR)/build/bin

# Version
RELEASE?=v0.1.0

# go source files, ignore vendor directory
SOURCE = $(shell find ${MKFILE_DIR} -type f -name "*.go")
TARGET = ${RELEASE_DIR}/ipquery

all: ${TARGET}

${TARGET}: ${SOURCE}
	mkdir -p ${RELEASE_DIR}
	go mod tidy
	go build -a -ldflags '-s -w -extldflags "-static"' -gcflags=-G=3 -o ${TARGET} ${MKFILE_DIR}cmd/ipquery

build: all

test:
	go test -race -count=1 ./...

clean:
	@rm -rf ${MKFILE_DIR}/build
