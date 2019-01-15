## PaaS

## Azure App Service Linux
1. Ajouter le plugin dans le pom.xml

```xml
<plugin>
    <groupId>com.microsoft.azure</groupId>
    <artifactId>azure-webapp-maven-plugin</artifactId>
    <!-- check Maven Central for the latest version -->
    <version>1.5.2</version>
    <configuration>
        <authentication>
           <serverId>azure-auth</serverId>
        </authentication>
        <schemaVersion>v2</schemaVersion>
        <resourceGroup>supgalilee-paas</resourceGroup>
        <appName>supgalilee-app-service-{nb}</appName>
        <region>northeurope</region>
        <pricingTier>P1V2</pricingTier>
        <runtime>
            <os>linux</os>
            <javaVersion>jre8</javaVersion>
        </runtime>
        <deployment>
            <resources>
                <resource>
                    <directory>${project.basedir}/target</directory>
                    <includes>
                        <include>*.jar</include>
                    </includes>
                </resource>
            </resources>
        </deployment>
        <stopAppDuringDeployment>true</stopAppDuringDeployment>
    </configuration>
</plugin>
```

2. Ajouter l'authentification dans le settings.xml
```xml
<server>
   <id>azure-auth</id>
   <configuration>
       <client>44d89e69-a26a-4e6c-847d-1805b883c9dd</client>
       <tenant>c8709a2a-70b6-49b5-bdd5-6868b476da85</tenant>
       <key>e308559a-b603-4559-b725-0e01c6aa52a0</key>
       <environment>AZURE</environment>
   </configuration>
</server>
```

3. Déployer le package sur Azure

## Azure Database for MySQL
1. Activer le profil MySQL par défaut
```xml
<!-- Activate MySQL profile -->
<activation>
    <activeByDefault>true</activeByDefault>
</activation>
```

2. Modifier le profil MySQL
```xml
<profile>
    <id>MySQL</id>
    <activation>
        <activeByDefault>true</activeByDefault>
    </activation>
    <properties>
        <db.script>mysql</db.script>
        <jpa.database>MYSQL</jpa.database>
        <jdbc.driverClassName>com.mysql.jdbc.Driver</jdbc.driverClassName>
        <jdbc.url>jdbc:mysql://${DOLLAR}{MYSQL_SERVER_FULL_NAME}:3306/${DOLLAR}{MYSQL_DATABASE_NAME}?useUnicode=true</jdbc.url>
        <jdbc.username>${DOLLAR}{MYSQL_SERVER_ADMIN_LOGIN_NAME}</jdbc.username>
        <jdbc.password>${DOLLAR}{MYSQL_SERVER_ADMIN_PASSWORD}</jdbc.password>
    </properties>
</profile>
```