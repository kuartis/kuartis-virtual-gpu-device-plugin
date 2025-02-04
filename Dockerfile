# Copyright 2020 Amazon.com, Inc. or its affiliates
# Copyright 2022 Kuartis.com
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.17 as build

ENV GOPROXY direct
WORKDIR /go/src/github.com/kuartis/kuartis-virtual-gpu-device-plugin
COPY . .

RUN export CGO_LDFLAGS_ALLOW='-Wl,--unresolved-symbols=ignore-in-object-files' && \
    go build -ldflags="-s -w" -o virtual-gpu-device-plugin main.go


FROM amazonlinux:latest

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=utility

COPY --from=build /go/src/github.com/kuartis/kuartis-virtual-gpu-device-plugin/virtual-gpu-device-plugin /usr/bin/virtual-gpu-device-plugin

CMD ["virtual-gpu-device-plugin"]
