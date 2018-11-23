help: # shows help
	@cat Makefile | grep ':' | grep '#' | grep -v 'Makefile' | tr -d ':' | column -t -s'#'

post: # creates a new post
	P="_posts/`date '+%F'`-`echo ${POSTNAME} | tr ' ' '-'`.markdown"; \
	touch $$P ; \
	echo "---" >> $$P ; \
	echo "layout: post" >> $$P ; \
	echo "title: ${POSTNAME}" >> $$P ; \
	echo "date: `date '+%F'`" >> $$P ; \
	echo "---" >> $$P ; \
	vim $$P

.PHONY: site
