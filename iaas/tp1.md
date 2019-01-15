## TP1

### IaaS

#### Petclinic
1. Se connecter au serveur en SSH
2. Installer ```openjdk-8-jdk```
3. Cloner https://github.com/spring-projects/spring-petclinic.git
4. Compiler le package
5. Lancer Petclinic
6. Se connecter au serveur et vérifier que celui-ci fonctionne

#### MySQL
1. Installer mariadb-server
2. Sécuriser l'installation avec ```mysql_secure_installation``` et changer le mot de passe root en petclinic
3. Importer les scripts SQL ```src/main/resources/db/mysql/{schema,data}.sql```
4. Lancer le package avec le profile mysql
5. Se connecter au serveur et vérifier que celui-ci fonctionne