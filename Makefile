.DEFAULT_GOAL := help
SHELL := /bin/bash
COMPOSE := docker compose
DVAP_COMPOSE := docker compose -f upstream/dvap/docker-compose.yml -p dvap
LABS := catalog/labs.json

.PHONY: help setup fetch overlays model up down labs status lab dvap-up dvap-down clean

help: ## Show this help
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN{FS=":.*?## "}{printf "  %-12s %s\n", $$1, $$2}'
	@echo ""
	@echo "  Typical first run:  make setup && make up && make lab LAB=1.2.1"

setup: fetch overlays ## Fetch pinned upstreams and apply our overlays
	@echo ""
	@echo "Setup done. 'make up' starts the catalog."

fetch: ## Clone/checkout pinned upstream sources into upstream/
	@./scripts/fetch-upstream.sh

overlays: ## Apply our patches on top of the upstream checkouts
	@./scripts/apply-overlays.sh

model: ## Pull the shared model (one download for every lab)
	@$(COMPOSE) --profile model up -d ollama
	@echo "Pulling $${OLLAMA_MODEL:-llama3.1:8b} — this is a few GB, once."
	@$(COMPOSE) exec ollama ollama pull $${OLLAMA_MODEL:-llama3.1:8b}

up: ## Start the catalog only (nothing else runs)
	@$(COMPOSE) --profile core up -d
	@echo "Catalog: http://127.0.0.1:$${CATALOG_PORT:-8088}"

down: ## Stop everything, including the DVAP stack
	@$(COMPOSE) --profile core --profile model --profile llmvault --profile dvmcp down
	@-$(DVAP_COMPOSE) down 2>/dev/null || true

labs: ## List the Track 1 labs and their status
	@python3 -c "import json;d=json.load(open('$(LABS)'));\
print(d['track'], '| OWASP', d['owasp_edition']);\
[print(' ', l['id'].ljust(9), l['status'].ljust(12), l['stack'].ljust(9), l['title']) for l in d['labs']]"

status: ## Show which containers are up
	@$(COMPOSE) ps
	@-$(DVAP_COMPOSE) ps 2>/dev/null || true

# make lab LAB=1.2.2
lab: ## Start one lab and only what it needs (LAB=<id>)
	@test -n "$(LAB)" || { echo "usage: make lab LAB=1.2.1   (see 'make labs')"; exit 1; }
	@python3 scripts/lab.py "$(LAB)" > .lab.plan || exit 1
	@set -a; . ./.lab.plan; set +a; \
		if [ "$$STACK" = "none" ]; then \
			echo "$$MESSAGE"; \
		elif [ "$$STACK" = "dvap" ]; then \
			echo "Starting the DVAP stack (its own compose; needs ~16GB RAM)"; \
			$(DVAP_COMPOSE) up -d; \
			echo "$$MESSAGE"; \
		else \
			$(COMPOSE) $$PROFILE_ARGS up -d; \
			echo "$$MESSAGE"; \
		fi
	@rm -f .lab.plan

dvap-up: ## Start the DVAP platform on its own
	@$(DVAP_COMPOSE) up -d

dvap-down: ## Stop the DVAP platform
	@$(DVAP_COMPOSE) down

clean: down ## Stop everything and remove fetched upstreams
	@rm -rf upstream
	@echo "Removed upstream/. Run 'make setup' to fetch again."
