#!/bin/bash
set -euo pipefail
cd $(dirname $0)

bundle exec ruby ./cli.rb
