SERVE_HOST ?= 127.0.0.1

all:
	$(MAKE) docker CMD="make deps serve"

site:
	bundler exec jekyll build

proof:
	bundle exec htmlproofer ./_site  --disable-external

clean:
	rm -rf _site

serve:
	bundler exec jekyll serve --host=$(SERVE_HOST)

deps:
	bundler install --path vendor/cache

prod:
	aws s3 sync _site/ s3://andrewkroh.com --acl public-read --delete

image:
	docker build -t www_andrewkroh_com .

docker: image
	docker run -it --rm \
	  -v $(PWD):/site \
	  -p 127.0.0.1:4000:4000 \
	  -e "SERVE_HOST=0.0.0.0" \
	  www_andrewkroh_com \
		$(CMD)
