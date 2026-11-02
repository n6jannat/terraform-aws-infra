.PHONY: fmt validate local-up local-apply local-destroy local-down

fmt:
	terraform fmt -recursive

validate:
	for d in bootstrap envs/dev envs/local; do \
		(cd $$d && terraform init -backend=false -input=false >/dev/null && terraform validate) || exit 1; \
	done

local-up:
	docker compose up -d

local-apply: local-up
	cd envs/local && terraform init -input=false && terraform apply -auto-approve

local-destroy:
	cd envs/local && terraform destroy -auto-approve

local-down:
	docker compose down
