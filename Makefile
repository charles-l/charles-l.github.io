help: # shows help
	@cat Makefile | grep ':' | grep '#' | grep -v 'Makefile' | tr -d ':' | column -t -s'#'

site: # builds the site and pushes to github
	./site build
	cd _site; \
		git add --all; \
		git commit -m "update $(date)"; \
		git push -u origin master

post: # creates a new post
	@while [ -z "$$POST" ]; do \
		read -r -p "post title: " POST; \
	done ; \
	P="posts/`date '+%F'`-`echo $$POST | tr ' ' '-'`.markdown"; \
	touch $$P ; \
	echo "---" >> $$P ; \
	echo "layout: post" >> $$P ; \
	echo "title: $$POST" >> $$P ; \
	echo "date:`date '+%F'`" >> $$P ; \
	echo "---" >> $$P ; \
	vim $$P

.PHONY: site
