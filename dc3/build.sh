#!/bin/bash

#
# Copyright 2016-present the IoT DC3 original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

cd ../console-ui
yarn
yarn build

cd ..
mvn -Prelease-nacos -Dmaven.test.skip=true clean install -U

docker buildx build --platform linux/arm64,linux/amd64  -t registry.cn-beijing.aliyuncs.com/dc3/nacos-server:2.3.0 . --push