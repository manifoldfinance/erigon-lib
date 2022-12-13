default: grpc mocks

grpc:
    go mod vendor
    protoc --proto_path=vendor/github.com/ledgerwatch/interfaces --go_out=gointerfaces types/types.proto
    protoc --proto_path=vendor/github.com/ledgerwatch/interfaces \
      --go_out=gointerfaces types/types.proto \
      --go-grpc_out=gointerfaces \
      --go_opt=Mtypes/types.proto=github.com/ledgerwatch/erigon-lib/gointerfaces/types \
      --go-grpc_opt=Mtypes/types.proto=github.com/ledgerwatch/erigon-lib/gointerfaces/types \
      p2psentry/sentry.proto p2psentinel/sentinel.proto \
      remote/kv.proto remote/ethbackend.proto \
      downloader/downloader.proto execution/execution.proto \
      txpool/txpool.proto txpool/mining.proto
    rm -rf vendor

mocks:
    rm -f gointerfaces/remote/mocks.go
    go generate ./...

test:
    go test -trimpath -tags nosqlite,noboltdb,disable_libutp --count 1 -p 2 ./...

test-no-fuzz:
    go test -trimpath -tags nosqlite,noboltdb,disable_libutp,nofuzz --count 1 -p 2 ./...