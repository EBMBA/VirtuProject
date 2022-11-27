# vsphere update manager

## Description

vsphere update manager est un composant (plug-in) de vcenter qui permet de gérer les mises à jour des composants de vcenter.

Update manager permet d'autoriser les administrateurs sécurité à appliquer les normes de sécurité sur les hôtes ESX/ESXi et les machines virtuelles hébergées. Ce plug-in vous permet de créer des lignes de base de sécurité personnalisées qui représent un ensemble de normes de sécurité. Les administrateurs de sécurité peuvent vérifier que les hôtes et les machines virtuelles respectent ces lignes de base pour identifiez et corrigez les machines virtuelles non conformes.

Update Manager vous permet d'effectuer les tâches suivantes :

* Mettez à niveau et corrigez les hôtes ESXi.
* Installez et mettez à niveau le logiciel tiers sur les hôtes.
* Mettre à niveau le matériel de machine virtuelle et VMware Tools.

Update Manager fonctionne avec les versions suivantes d'ESXi :

* Pour les opérations de mise à niveau de VMware Tools et du matériel des machines virtuelles, Update Manager fonctionne avec 6.0, ESXi 6.5 et ESXi 6.7.
* Pour les opérations d'application de correctifs aux hôtes ESXi, Update Manager fonctionne avec ESXi 6.0, ESXi 6.5 et ESXi 6.7.
* Pour les opérations de mise à niveau des hôtes d'ESXi, Update Manager fonctionne avec ESXi 6.0, ESXi 6.5 et leurs versions de mises à jour respectives.

Update Manager commence par télécharger des informations (métadonnées) sur les correctifs et les extensions. Un ou plusieurs de ces correctifs ou extensions sont agrégés pour former une ligne de base. Vous pouvez ajouter plusieurs lignes de base à un groupe de lignes de base. Vous pouvez ensuite appliquer les lignes de base à un ou plusieurs hôtes ESXi. Vous pouvez également appliquer les lignes de base à des machines virtuelles.