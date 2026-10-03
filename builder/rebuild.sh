#!/bin/bash

#
# Create combined Lua file from sources. Regenerate test output
#
# Author: Martin Eden
# Last mod.: 2026-10-03
#

#
# Results are placed in "deploy/"
#
# Toolchain uses my "lua code melder" tool to combine files into one:
#
#   https://github.com/martin-eden/lua_code_melder
#
# Toolchain uses my "lua code formatter" tool to strip comments:
#
#   https://github.com/martin-eden/lua_code_formatter
#

set -e -u

#
# src/
#

cd ../src

rm -r -f workshop/

lua ../builder/deploy.lua

mv deploy/workshop/ .
rm -r deploy/

#
# builder/
#

cd ../builder

# ( Combine all Lua code, reformat and strip comments

./meld ../src/ files_tree > ../deploy/files_tree.melded.lua

./reformat_lua \
  ../deploy/files_tree.melded.lua \
  ../deploy/files_tree.melded.stripped.lua \
  --~keep-comments \
  --right-margin=72
rm ../deploy/files_tree.melded.lua

mv \
  ../deploy/files_tree.melded.stripped.lua \
  ../deploy/files_tree.lua

# )

#
# deploy/
#

cd ../deploy

# ( Add shebang to compiled code

echo '#!/usr/local/bin/lua' > files_tree.shebanged.lua
echo >> files_tree.shebanged.lua
cat files_tree.lua >> files_tree.shebanged.lua
rm files_tree.lua
mv files_tree.shebanged.lua files_tree
chmod +x files_tree

# )

#
# Create test data using freshly build tool
#
rm -r ../test/output
mkdir ../test/output
./files_tree export ../test/input ../test/output/files.is
./files_tree import ../test/output/files.is ../test/output/restored_input/

# 2026 #
# 2026-10-03
