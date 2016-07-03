help: # shows help
	@cat Makefile | grep ':' | grep '#' | grep -v 'Makefile' | tr -d ':' | column -t -s'#'

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
