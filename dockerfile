FROM python:3-bookworm AS prepare
WORKDIR /app/
COPY ./src/ ./
RUN pip install pillow optimize-images css-html-js-minify exif_delete
RUN optimize-images ./
RUN css-html-js-minify ./
RUN exif_delete --replace ./**/*.jpg
RUN exif_delete --replace ./**/*.JPG
RUN exif_delete --replace ./**/*.JPEG
RUN exif_delete --replace ./**/*.png
RUN exif_delete --replace ./**/*.PNG
RUN exif_delete --replace ./**/*.gif
RUN exif_delete --replace ./**/*.GIF

FROM golang:1-bookworm AS server
COPY server.go server.go
RUN go build -ldflags "-linkmode external -extldflags -static" -a server.go

FROM scratch
COPY --from=prepare /app/ ./
COPY --from=server /go/server ./server
CMD ["./server"]
EXPOSE 80