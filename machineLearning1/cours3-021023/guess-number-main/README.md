# Mise en place

Une fois le projet récupéré, il faut installer [Poetry](https://python-poetry.org) si ce n'est pas fait.
Dans le projet, on installe les dépendences avec la commande :

```bash
poetry install
```

Un fichier `poetry.lock` devrait apparaitre.

On peut alors exécuter l'application avec la commande :

```bash
poetry run python manage.py runserver
```

L'application se recharge à chaque fois qu'on enregistre une modification. Il faut néanmoins recharger le navigateur pour voir ces modifications.

Enjoy!
