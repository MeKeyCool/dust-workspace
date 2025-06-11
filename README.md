# Dust-Workspace

## Présentation et motivations

Je suis développeur informatique professionnel avec 15 ans d'expérience, ayant travaillé dans de nombreuses entreprises et sur une large palette de langages (C++, PHP, TypeScript, Scala, ...).

Je travaille sous Linux, actuellement sous Linux Mint, et j'apprécie les environnements qui respectent les logiques **Infrastructure As Code (IaC)**, y compris en local (docker, docker-compose, k3d, taskfile, shell).

J'ai une forte affinité avec la philosophie et les valeurs du **logiciel libre**. Je me définis comme un "bidouilleur astucieux" : j’aime apprendre, résoudre des problèmes complexes, me casser la tête et comprendre en profondeur les systèmes sur lesquels je travaille.

Je suis curieux des **avancées technologiques en IA** et souhaite m'investir sur un produit qui me motive dans cet écosystème.


## Organisation du projet

Je travaille avec [Taskfile](https://taskfile.dev/) pour mémoriser, documenter et versionner toutes les commandes utiles à l'installation et l'utilisation du projet.

J'utilise massivement **Docker** pour ne rien avoir à installer sur ma machine et pour facilement relancer le projet depuis n'importe quelle machine depuis les sources.


### Pré-requies

Ainsi les seuls pré-requis pour utiliser ce projet sont :
- ***Docker*** : https://docs.docker.com/engine/install/
- ***Taskfile*** : https://taskfile.dev/installation/
- ***k3d*** : https://k3d.io/stable/#releases
- Et bien entendu ***un shell*** pour exécuter tout ça.


### Architecture

- `env` : Stocke des données de configuration spécifiques et les volumes/données de state.
  > À la racine du répertoire `env`, vous trouver la configuration du host (votre machine) avec le fichier `project.env`.
  >
  > Les autres fichiers/répertoires spécifiques à l'instance d'environnement seront dans `env/${DEPLOY_ENV}` (logs, cache, fichiers d'env, ...)

- `infra` : Répertorie tous les fichiers de descriptions de l'infrastructure (Dockerfiles, docker-compoe, template de fichiers de configuration, ...)
- `src` : stock les sources (avec des git submodules pour les projets externes comme Dust)

Les `Taskfile` sont à la racine.


### Installation initiale en local

```bash
cp env/project.env.template env/project.env
```
Mettre à jour les valeurs dans `env/project.env`

Puis exécutez les commandes suivantes :
```bash
task host-init
task infra-init
```

---

⚠️ Note : le script `init_dev_container.sh` présent dans le dépôt Dust n’est pas utilisé ici.

Ce projet utilise un environnement Docker customisé avec `docker-compose` et `Taskfile`,
qui initialise directement les bases PostgreSQL nécessaires (`dust_api`, `dust_front_test`, etc.).

Le script `init_dev_container.sh` peut servir de référence mais ne doit pas être exécuté tel quel,
car il ne correspond pas à notre architecture conteneurisée actuelle.



## Contexte spécifique à Dust

Je m'intéresse particulièrement à l'entreprise [Dust](https://dust.tt/) qui développe un produit open source autour de l'IA. Je suis débutant sur leur stack mais souhaite :
- Tester **Dust** en local.
- Explorer le code de leur produit phare : https://github.com/dust-tt/dust.
- Potentiellement contribuer (bug fix, documentation, propositions de features, ...).
- Candidater chez **Dust** si l’expérience est concluante et que je m’entends bien avec l’équipe.


## Avancement et Décisions Techniques

Mon approche est progressive et pragmatique :

1. Installation et Stabilisation de Dust en local avec docker-compose :
   - Objectif immédiat : **faire tourner Dust (backend + frontend)** avec **docker-compose** sur mon environnement local.
   - Déploiement des services nécessaires : **Postgres**, **Redis**, **Qdrant**, **Elasticsearch**.
   - Configuration des variables d’environnement et des volumes.

2. Migration progressive vers k3d pour une infrastructure plus proche de la production :
  - Mise en place d'un cluster k3d local.
  - Déploiement des services de l’écosystème (Redis, Qdrant, Elasticsearch, ...) dans k3d.
  - Conservation des outils et du code applicatif dans docker-compose pour le confort dev.
  - Interopérabilité entre docker-compose et k3d via NodePorts ou partage de network Docker.
  - Migration progressive des services vers **k3d** au fil des besoins.

## Objectif Final
- Disposer d'un **environnement hybride docker-compose + k3d** :
  - **docker-compose** pour le confort dev sur le **backend** et le **frontend**.
  - **k3d** pour les services d’infrastructure afin de se rapprocher de la production.
- Connaître la stack de **Dust** en profondeur.
- Être capable de **développer, tester et contribuer efficacement** sur Dust.
