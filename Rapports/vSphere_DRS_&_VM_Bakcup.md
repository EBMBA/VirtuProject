# vSphere DRS 
## Distributed Ressource Scheduler
Fonction qui affecte et équilibre la capacité informatique dynamiquement dans
les collections de ressources matérielles pour les machines virtuelles. Cette
fonction comporte des possibilités de gestion d'alimentation distribuée (DPM)
permettant au centre de données de réduire significativement sa
consommation d'énergie.
Equilibrage des ressources de manières planifié en :   
- Determiner les heures
- fonction des CPU et de la RAM  

DRS va décider en fonction du type de parametrage de migrer entre les différents ESXI. De façon à équilibrer les ressources.

### Configuration
Cluster, activer la fonctionnalité.   
vMotion doit être activé et fonctionelle et correctement configurer pour permettre l'équilibrage.

Lors de la création d'un cluster, l'option DRS doit être coché
Plusieurs option s'affiche : 
- Niveau d'automatisation (3 niveaux : manuel, partiellement automatisé, tout automatisé)
- Seuil de migration : considérentation en fonction des priorités (de modéré à élévé)

Posibilité de planifier une configuration: nom de tâche, description, horaire.

# VM Backup
vCenter Server prend en charge un mécanisme de sauvegarde et de restauration sur fichier qui permet de récupérer un environnement après des défaillances.

## Configuration
Depuis l'interface de vCenter Server il est possible de créer une sauvegarde sur fichier de l'instance de vCenter Server.   
Après avoir créé la sauvegarde, il est possible de la restaurer à l'aide du programme d'installation de l'interface utilisateur graphique du dispositif.

Depuis l'interface de vCenter Server il est possible d'effectuer une sauvegarde sur fichier des données de configuration mémoire, d'inventaire et d'historique de l’instance de vCenter Server. Les données sauvegardées sont transférées via FTP, FTPS, HTTP, HTTPS, SFTP, NFS ou SMB vers un système distant. La sauvegarde n'est pas stockée sur le dispositif vCenter Server.

Il est possible d'effectuer une restauration sur fichier uniquement pour un système vCenter Server qui a été sauvegardé précédemment à l'aide de l'interface de vCenter Server.   
Il est possible d'effectuer une opération de restauration de ce type à l'aide du programme d'installation de l'interface utilisateur graphique de vCenter Server Appliance. Le processus consiste à déployer une nouvelle instance de vCenter Server Appliance et à copier les données issues de la sauvegarde sur fichier vers le nouveau dispositif.


