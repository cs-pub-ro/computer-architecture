#!/usr/bin/env bash
set -euo pipefail

if (($# != 1)); then
	echo "Usage: $0 <top-module.v>" >&2
	exit 2
fi

design_file=$(cd "$(dirname "$1")" && pwd -P)/$(basename "$1")
if [[ ! -f "$design_file" ]]; then
	echo "Verilog file not found: $design_file" >&2
	exit 1
fi

repo_root=$(git -C "$(dirname "$design_file")" rev-parse --show-toplevel)
case "$design_file" in
	"$repo_root"/*) ;;
	*) echo "Design must be inside the course repository." >&2; exit 1 ;;
esac

top=${design_file##*/}
top=${top%.*}
relative_dir=${design_file%/*}
relative_dir=${relative_dir#"$repo_root"}
relative_dir=${relative_dir#/}

image=${SDC_IMAGE:-computer-architecture/dev:latest}
board=${FPGA_BOARD:-nexys_a7_100}
docker_args=(run --rm --privileged -v "$repo_root:/workspace" -w "/workspace/$relative_dir"
	-e SDC_ROOT=/workspace -e FPGA_TOP="$top" -e FPGA_BOARD="$board" "$image")
if [[ -n "${FPGA_XDC:-}" ]]; then
	docker_args+=(-e "FPGA_XDC=$FPGA_XDC")
fi

if [[ "$(uname -s)" == Darwin ]]; then
	docker "${docker_args[@]}" zsh -c 'source "$SDC_ROOT/docker/00-base/zsh/00-sdc-logging.zsh"; source "$SDC_ROOT/docker/30-fpga/zsh/30-fpga.zsh"; fpga_build "$FPGA_TOP"'
	if ! command -v openFPGALoader >/dev/null 2>&1; then
		echo "Install openFPGALoader on macOS (for example, with Homebrew) to flash the board." >&2
		exit 1
	fi
	openFPGALoader --board "$board" "$repo_root/$relative_dir/$top.bit"
else
	docker "${docker_args[@]}" zsh -c 'source "$SDC_ROOT/docker/00-base/zsh/00-sdc-logging.zsh"; source "$SDC_ROOT/docker/30-fpga/zsh/30-fpga.zsh"; fpga_build "$FPGA_TOP" && fpga_flash "$FPGA_TOP.bit"'
fi