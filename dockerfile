FROM golang:latest AS build-stage-server
COPY server.go server.go
RUN go build -ldflags "-linkmode external -extldflags -static" -a server.go

FROM alpine/git:latest
#COPY ./src/index.html ./index.html
RUN mkdir repo
RUN git clone "https://github.com/oscar230/oresundspacecollective.com" repo
RUN mv repo/src/* ./
RUN rm -rf repo
COPY --from=build-stage-server /go/server ./server
CMD ["./server"]
EXPOSE 80
