FROM golang:latest AS build-server
COPY server.go server.go
RUN go build -ldflags "-linkmode external -extldflags -static" -a server.go

FROM alpine/git:latest AS download
#COPY ./src/index.html ./index.html
RUN mkdir repo
RUN git clone "https://github.com/oscar230/oresundspacecollective.com" /repo

FROM scratch
COPY --from=download /repo/src/* ./
COPY --from=build-stage-server /go/server ./server
CMD ["./server"]
EXPOSE 80