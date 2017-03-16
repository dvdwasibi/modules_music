# Copyright 2017 The Fuchsia Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Assumes that the project is located three levels deep in the Fuchsia tree, for
# example: $FUCHSIA_DIR/apps/modules/<project>. Change to suit the project
# location.
root := $(shell git rev-parse --show-toplevel)
fuchsia_root := $(realpath $(root)/../../..)
common_root := $(realpath $(fuchsia_root)/apps/modules/common/tools/common)
common_makefile := $(realpath $(common_root)/Makefile)

PROJECT := music
FLUTTER_TARGET := modules/music
FUCHSIA_TARGET := music

include $(common_makefile)
