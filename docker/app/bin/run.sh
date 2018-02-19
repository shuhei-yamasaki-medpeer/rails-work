#!/bin/bash

# 更新があればinstall
bundle check || bundle install -j4
bundle exec puma -C config/puma.rb
