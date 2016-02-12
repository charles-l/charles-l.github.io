site:
	./site build
	cd _site; \
		git add --all; \
		git commit -m "update $(date)"; \
		git push

.PHONY: site
