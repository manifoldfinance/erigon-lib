/*
   Copyright 2021 Erigon contributors

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

package direct

import (
	"context"
	txpool_proto "github.com/ledgerwatch/erigon-lib/gointerfaces/txpool"
	"google.golang.org/grpc"
)

var _ txpool_proto.SealingClient = (*SealingClient)(nil)

type SealingClient struct {
	server txpool_proto.SealingServer
}

func NewSealingClient(server txpool_proto.SealingServer) *SealingClient {
	return &SealingClient{server: server}
}

func (s *SealingClient) SealBlock(ctx context.Context, request *txpool_proto.SealRequest, _ ...grpc.CallOption) (*txpool_proto.SealResponse, error) {
	return s.server.SealBlock(ctx, request)
}
