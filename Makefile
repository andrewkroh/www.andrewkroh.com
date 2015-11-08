site:
	bundler exec jekyll build
	#bundle exec htmlproof ./_site  --disable-external

clean:
	rm -rf _site

serve:
	bundler exec jekyll serve

deps:
	bundler install

prod:
	aws s3 sync _site/ s3://andrewkroh.com --acl public-read --delete
