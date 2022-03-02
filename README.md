Donor Reporting Portal Deployment Stack
============================================


### Full Stack Links

  - Development - https://github.com/unicef/drips-infra
  - Backend - https://github.com/unicef/drips
  - Frontend - https://github.com/unicef/drips-fe
  


Development
============================================


Initialization
------------------------------

Be sure you have a `.env` file in the backend folder (check .env_template).

```bash
git pull --recurse-submodules
```
 

Update Environment
------------------------------

```bash
   docker-compose pull
```


if you updated the backend to update the database

```bash
   make ssh-backend
   django-admin init-setup --all
```


Start Environment
------------------------------

```bash
   docker-compose up
```
