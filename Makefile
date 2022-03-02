WORKING_BRANCH?=docker
VERSION?=master

help:
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make fullclean                 remove docker images/containers/volumes'
	@echo '   make develop                   update develop environment         '
	@echo '   make git-dev-start             open feature named "${WORKING_BRANCH}" for each module and main repo'
	@echo '   make git-dev-finish            finish feature named "${WORKING_BRANCH}" for each module and main repo'
	@echo '   make git-dev-rebase            rebase  named "${WORKING_BRANCH}" for each module and main repo'

version:
	@cd drips && git checkout -q ${VERSION}
	@cd drips-fe && git checkout -q ${VERSION}
	$(MAKE) status

info:
	@echo 'docker images'
	@docker images | grep drips
	@echo '------------------'
	@echo 'docker containers'
	@docker ps -a | grep drips

clean:
	@docker rmi unicef/drips-fe:dev --force
	@docker rmi unicef/drips:dev --force
	@docker images | grep drips


update:
	cd drips-fe && git reset --hard && git checkout
	git pull
	git submodule update

resync:
	cd drips && git reset --hard && git checkout develop && git pull && cd ..
	cd drips-fe && git reset --hard && git checkout develop && git pull && cd ..
	git add drips drips-fe && git commit -m "update submodules"
	$(MAKE) status


develop:
	git pull --recurse-submodules

fullclean:
	-docker stop `docker ps -f "name=docker-reporting-portal-infra*" -q`
	-docker rm `docker ps -a -f "name==docker-reporting-portal-infra*" -q`
	-docker rmi --force `docker images -f "ancestor=unicef/drips:dev" -q`
	-docker rmi --force `docker images -f "ancestor=unicef/drips-fe:dev" -q`
	-docker rmi --force `docker images -f "ancestor=unicef/drips-db:dev" -q`
	-docker rmi --force `docker images -f "ancestor=unicef/drips-proxy:dev" -q`
	-docker rmi --force `docker images -f "reference=unicef/drips-*" -q`
	rm -rf volumes


git-dev-start:
	cd drips && git flow feature start ${WORKING_BRANCH}
	cd drips-fe && git flow feature start ${WORKING_BRANCH}
	git flow feature start ${WORKING_BRANCH}

git-dev-finish:
	cd drips && git flow feature finish ${WORKING_BRANCH}
	cd drips-fe && git flow feature finish ${WORKING_BRANCH}
	git flow feature finish ${WORKING_BRANCH}

git-dev-rebase:
	cd drips && git rebase ${WORKING_BRANCH}
	cd drips-fe && git rebase ${WORKING_BRANCH}
	git rebase ${WORKING_BRANCH}

status:
	@echo "Infra: (`git symbolic-ref HEAD`)"
	@git log -1
	@echo "Backend: (`cd drips && git st -b && cd ..`)"
	@cd drips && git log -1
	@echo "Frontend: (`cd drips-fe && git st -b && cd ..`)"
	@cd drips-fe && git log -1


update-backend:
	@docker rmi $(docker images |grep 'drips')
	@docker ps -a | awk ‘{ print $1,$2 }’ | grep <drips> | awk ‘{print $1 }’ | xargs -I {} docker rm -f {}


ssh-backend:
	@docker exec -it drips_backend /bin/bash

ssh-frontend:
	@docker exec -it drips_frontend /bin/bash
