#!/bin/bash

# 更新があればinstall
bundle check || bundle install -j4
npm install
bundle exec puma -C config/puma.rb
