***
### METRAL EMILE - HARBUTOGLU MUSTAFA - CROZIER CYRIAN - CARTELIER ALEXIS
***

# VirtuProject  - Groupe 9

## Configuration réseau

|Nom|Réseau||
|----|----|---------|
Stockage | 172.16.0.0/24 | 
Management| 192.168.17.144 - 192.168.17.159|
Prod|10.20.30.0| 
vMotion|10.50.100.0| 


Stockage | 172.16.9.0/24 |   

Freenas | 172.16.9.10 /24  
Esxi01 | 172.16.9.11 /24  
Esxi02 | 172.16.9.12 /24   
Esxi03 | 172.16.9.13 /24  

  
Management | 192.168.17.144 - 192.168.17.159/28|  
  
DC | 192.168.17.145 /28  
VCSA | 192.168.17.146 /28  
Esxi01 | 192.168.17.147 /28  
Esxi02 | 192.168.17.148 /28   
Esxi03 | 192.168.17.149 /28  

  
Prod|10.20.30.0 /24|   
  
user01 | 10.20.30.1/24  
user02 | 10.20.30.2/24  
user03 | 10.20.30.3/24  

  
vMotion|10.50.100.0/24|  
  
Esxi01 | 10.50.100.1/24  
Esxi02 | 10.50.100.2/24  
Esxi03 | 10.50.100.3/24


<br/>


# CREATION ESXI : 

> Lors de la création de la VM, il faut sélectionner l'espace de stockage *luntp*.

![](/images/ESXI/image1.png)

> On sélectionne ensuite le système d'exploitation de note machine. Ici, *VMware Esxi 7.0*

![](/images/ESXI/image2.png)

> La configuration finale de notre machine est la suivante : 

![](/images/ESXI/image3.png)

> On peut ensuite démarrer la machine virtuelle et configurer l'IP de la machine avec sa passerelle.

![](/images/ESXI/image4.png)

> On peut ensuite se connecter à notre machine virtuelle via le client vSphere.

![](/images/ESXI/image5.png)

> Dans l'onglet *Mise en réseau > Commutateurs virtuels*, on peut voir les différents commutateurs virtuels créés puis créer un nouveau commutateur virtuel pour chaque réseau.

![](/images/ESXI/image6.png)

> On peut ensuite créer un nouveau *groupe de ports* pour chaque réseau.

![](/images/ESXI/image7.png)

> Ensuite, on ajoute une adresse IP statique à chaque groupe de ports  dans lesquels notre esxi doit être connecté dans l'onglet *NIC VMKernel*. On rajoute donc une IPv4 dans les réseaux suivant : Stockage et VMotion.  

![](/images/ESXI/image8.png)

> Pour le groupe de port Vmotion, il faut bien penser à cocher le service *vMotion*.

![](/images/ESXI/image9.png)         

> Nous avons donc pour notre premier ESXI :
![](/images/ESXI/image10.png)         


Ces opérations sont à refaire sur notre deuxième ESXI. 

<br/>


# Création contrôleur de domaine

> Nous avons créer notre contrôleur de domaine en suivant le tuto suivant : https://www.informatiweb-pro.net/admin-systeme/win-server/ws-2012-nat-et-routage-reseau.html

> Pour cela nous avons défini le nom de la machine à l'aide d'un script Powershell.

* Script1_Rename-Computer

    > Script permettant de forcer le changement de nom du DC.

```powershell
$NameComputer = "virtu-DC09"

Rename-Computer -NewName $NameComputer -Force
Restart-Computer
```

<br/>

> Nous avons exécuté le script permettant de réaliser la configuration réseau du contrôleur de domaine.

* Script2_Change_Ip_Config
Script permettant de changer la configuration de la carte réseau : 
    - Gateway
    - Adresse IP
    - DNS

```powershell
$IPAddress = "192.168.17.145"
$Prefix = "29"
$Gateway = "192.168.17.1"
$IPAddressDNS = "127.0.0.1"

New-NetIPAddress -IPAddress $IPAddress -PrefixLength $Prefix -InterfaceIndex (Get-NetAdapter).ifIndex -DefaultGateway $Gateway
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ($IPAddressDNS)
```

<br/>

> Nous avons ensuite exécuté le script permettant de réaliser la configuration de l'ADDS et du DNS.

* Script3_Install_ADDS-DNS
Script permmetant la configuration de l'ADDS et du DNS
    - Le script configure le nom du DNS  
    - Puis installe les features nécessaire pour la configuration de l'ADDS.
    - Et pour finir configuration de la forêt AD

```powershell
$DomainNameDNS = "virtu-09.tpv.cpe.localdomain"
$DomainNameNetbios = "VIRTU-09"

$FeatureList = @("RSAT-AD-Tools", "AD-Domain-Services", "DNS")

Foreach($Feature in $FeatureList){

    if(((Get-WindowsFeature -Name $Feature).InstallState)-eq "Available"){

            Write-Output " Feature $Feature will be installed now ! "

                Try{

                        Add-WindowsFeature -Name $Feature -IncludeManagementTools -IncludeAllSubFeature

                        Write-Output  "$Feature : Installation is a success !"

                }Catch{

                        Write-Output "$Feature : Error during installation !"
                }
        } 
} # Foreach($Feature in $FeatureList)


$ForestConfiguration = @{
'-DatabasePath'= 'C:\Windows\NTDS';
'-DomainMode' = 'Default';
'-DomainName' = $DomainNameDNS;
'-DomainNetbiosName' = $DomainNameNetbios;
'-ForestMode' = 'Default';
'-InstallDns' = $true;
'-LogPath' = 'C:\Windows\NTDS';
'-NoRebootOnCompletion' = $false;
'-SysvolPath' = 'C:\Windows\SYSVOL';
'-Force' = $true;
'-CreateDnsDelegation' = $false }

Import-Module ADDSDeployment
Install-ADDSForest @ForestConfiguration
```

<br/>

> Nous avons ensuite exécuté le script permettant de réaliser l'installation et la configuration du DHCP.

* Script4_Configure_DHCP
Script permettant l'installation et la configuration du service DHCP
    - Premièrement création d'un security group
    - Configuration des paramètres du DHCP

```powershell
# Installer le service DHCP :
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Créer un security group :
netsh dhcp add securitygroups 
Restart-Service dhcpserver 

# Vérification de l'existence du serveur DHCP dans le DC : 
Get-DhcpServerInDC

$Scopes = @{
       'Prod' = @{
           Mask = "255.255.255.0"
           Network = "10.20.30.0"
           StartRange = "10.20.30.94"
           EndRange = "10.20.30.254"
           Gateway = "10.20.30.255"
    }
    AdresseDNS = "192.168.17.145"
    NameDomain = "virtu-09.tpv.cpe.localdomain"
}


foreach ($item in $Scopes.sites.Keys) {
    Add-DHCPServerv4Scope -Name $Scopes.sites.$item -StartRange $Scopes.sites.$item.StartRange -EndRange $Scopes.sites.$item.EndRange -SubnetMask $Scopes.sites.$item.Mask -State Active
    Set-DHCPServerv4OptionValue -ScopeID $Scopes.sites.$item.Network  -DnsDomain $Scopes.NameDomain -DnsServer $Scopes.AdresseDNS -Router $Scopes.sites.$item.Gateway
    Add-DhcpServerInDC -DnsName $Scopes.NameDomain -IpAddress $Scopes.AdresseDNS
}

Get-DhcpServerv4Scope
Restart-service dhcpserver
```


# Installation and configuration of VCenter

## Stage 1 : Installation of VCenter
---

> Nous déployons Vcenter sur une machine client Windows 10.

![](/images/Vcenter/vcenter1.png)

> On configure l'adresse IP du Vcenter avec son port ainsi que son user et son mot de passe.

![](/images/Vcenter/vcenter2.png)

![](/images/Vcenter/vcenter3.png)

> On définit ensuite le nom de la VM avec le mot de passe root.

![](/images/Vcenter/vcenter4.png)

> On choisit ensuite l'espace de stockage de la VM.

![](/images/Vcenter/vcenter5.png)

> On choisit l'endroit où sera stocké le serveur Vcenter.

![](/images/Vcenter/vcenter6.png)

> On vient ensuire configurer notre nom de domaine, l'adresse IP pour le Vcenter, son masque, sa passerelle et son serveur DNS.

![](/images/Vcenter/vcenter7.png)

> On peut ennuite valider et lancer l'installation.

![](/images/Vcenter/vcenter8.png)


## Stage 2 : Configuration of VCenter
---

> On passe ensuite à la configuration de notre Vcenter.

![](/images/Vcenter/vcenter2.1.png)

> On définit le nom de domaine, le username et le mot de passe pour notre SSO.

![](/images/Vcenter/vcenter2.2.png)

> On vérifie notre configuration afin de lancer son installation.

![](/images/Vcenter/vcenter2.3.png)

> On va ensuite créer une entrée DNS pour le VCSA.

![](/images/Vcenter/vcenter2.4.png)



## Upgrade Vcenter
---

> On indique l'adresse IP du Vcenter, son username et son mot de passe SSO.

> On indique également l'adresse IP du Vcenter, son username et son mot de passe SSO. 

![](/images/upgradeVcenter.png)


## Création datacenter
---

> On va ensuite créer notre datacenter.

> Pour cela on se rend dans notre Vcenter sur notre FQDN et on clique sur *Actions* puis sur *Nouveau centre de donées*.

![](/images/datacenter/datacenter1.png)

> On définit le nom de notre datacenter puis on valide.

![](/images/datacenter/datacenter2.png)


## Création cluster
---

> On va ensuite créer notre cluster.

> Pour cela on se rend dans notre datacenter et on clique sur *Actions* puis sur *Nouveau cluster*.

![](/images/cluster/cluster1.png)

> On définit le nom de notre cluster puis on valide.


## Connection des hosts ESXi à Vcenter
---

On va ici connecter nos 2 hôtes ESXi à notre Vcenter.
* Actions à répéter pour chaque nouvel host.

> On peut ensuite ajouter nos hôtes ESXi dans notre Vcenter.

> Pour cela, il faut se connecter sur notre Client Web Vcenter : *https://vcsa.virtu-09.tpv.cpe.localdomain/*

> On se connecte avec le compte administrator.

> Sur la page d'accueil, on clique sur *Hosts and Clusters*.

> On clique ensuite sur *Add Host*.

![](/images/addHosts/addHost1.png)

> On indique le DNS ou l'adresse IP de notre hôte ESXi.

![](/images/addHosts/addHost2.png)

![](/images/addHosts/addHost3.png)

> On indique notre username et notre mot de passe. Ici *root* et *VMware1!*.

![](/images/addHosts/addHost4.png)

> On vérifie nos informations puis on clique sur *Next*.

![](/images/addHosts/addHost5.png)

> On choisit notre licence.

![](/images/addHosts/addHost6.png)

> On laisse le mode de vérouillage en *Désactivé* pour que l'on puisse se connecter dessus.

![](/images/addHosts/addHost7.png)

> On séléctionne notre datacenter préalaablement créé.

![](/images/addHosts/addHost8.png)

> On vérifie à nouveau nos informations puis on clique sur *Finish* pour valider l'ajout de notre hôte ESXi.

![](/images/addHosts/addHost9.png)


## Join AD
---

> On va maintenant joindre notre Vcenter à notre Active Directory.

> Sur notre Vcenter, on clique sur : **Administration* > *Single Sign-On* > *Configuration* > *Domaine Active Directory* > *Join Domain**.

> On renseigne notre nom de domaine, notre username et notre mot de passe puis on clique sur *Join*.

![](/images/joinAD.png)


## Création Distributed Switch
---

> Sur le Vcenter, sur notre Datacenter, dans *Actions* on clique sur *Distributed Switch* puis *Nouveau Distributed Switch*.

![](/images/distributedSwitch/distributedSwitch1.png)

> On lui choisit un nom puis on valide. Ici *DSwitch*.

![](/images/distributedSwitch/distributedSwitch2.png)

> On sélectionne ensuite la version de notre switch.

![](/images/distributedSwitch/distributedSwitch3.png)

> On configure notre switch comme suit :

![](/images/distributedSwitch/distributedSwitch4.png)

> On vérifie notre configuration puis on valide.

![](/images/distributedSwitch/distributedSwitch5.png)


## Création Distributed Switch groupes de ports
---

> On va ensuite créer nos DSwitch groupes de ports Prod Vmotion Stockage.

![](/images/distributedSwitch/dswitch_port1.png)

> On ajoute ensuite les hôtes sur les DSwitch.

> Pour cela on se rend sur Dswitch > Ajouter et gérer les hôtes.

![](/images/distributedSwitch/dswitch_port2.png)

> On séléctionne ensuite les hôtes à ajouter.

![](/images/distributedSwitch/dswitch_port3.png)

> Ensuite, pour chaque interface on ajoute une liaison montante en faisant correspondre les numero d'uplink avec les liaison équivalentes entre les deux hotes.

![](/images/distributedSwitch/dswitch_port4.png)
![](/images/distributedSwitch/dswitch_port5.png)

> On attribue chaque VMKernel à un groupe de port sauf pour le vSwitch0.

![](/images/distributedSwitch/dswitch_port6.png)

> Ensuite on migre la mise en réseau des VMs.


## Connexion ESXi à iSCSI.

> On va maintenant connecter nos hôtes ESXi à notre iscsi.

> Pour cela, sur vsphere : 
> * Sur la page d'accueil, cliquez sur l'onglet Configuration.
> * Cliquez sur Adaptateurs de stockage > Ajouter.
> * Cliquez sur OK pour ajouter l'adaptateur iSCSI logiciel.
> * Confirmez en cliquant sur OK.
> * Après l'actualisation, le nouvel adaptateur iSCSI est répertorié.

### on va ensuite configurer notre iSCSI.

> * Cliquez sur Propriétés.
> * Dans la fenêtre Propriétés, cliquez sur Configurer et définissez le Nom sur l'IQN du serveur.
> * Cliquez sur l'onglet Dynamic discovery puis sur Ajouter.
> * Sélectionnez Ne pas utiliser CHAP dans la section CHAP mutuel, puis cliquez sur OK.
> * Vous voyez maintenant le périphérique dans la fenêtre de découverte dynamique et cliquez sur Fermer.
> * Confirmez la nouvelle analyse des périphériques de stockage.
> * Vous voyez maintenant le périphérique devenir gris et "démonté".

![](/images/iscsi/iscsi1.png)

### On va ensuite ajouter un disque pour notre iSCSI.

> Pour cela, cliquez sur le menu Data store situé dans la colonne de gauche, puis cliquez sur add storage et sélectionnez Disc/LUN.

![](/images/iscsi/iscsi2.png)

> Une fois réalisé, on peut voir notre iSCSI qui est donc notre TrueNas dans la liste des datastores.

![](/images/iscsi/iscsi3.png)


# HA & Fault Tolerance :

## Introduction   

**High Availability:**   
La haute disponibilité permet d'assurer et de garantir le bon fonctionnement des services ou applications et ce 7j/7 et 24h/24.
La disponibilité est aujourd'hui un enjeu important pour les infrastructures informatiques. 
Deux moyens complémentaires sont utilisés pour améliorer la disponibilité :   
- la mise en place d'une infrastructure matérielle spécialisée, généralement en se basant sur de la redondance matérielle. 
Est alors créé un cluster de haute-disponibilité; une grappe d'ordinateurs dont le but est d'assurer un service en évitant au maximum les indisponibilités;
- la mise en place de processus adaptés permettant de réduire les erreurs, et d'accélérer la reprise en cas d'erreur. 

**Fault tolerance:**   
Fault Tolerance est une fonctionnalité qui va permettre de donner de la haute disponibilité voir de la disponibilité quasi total d'une machine virtuelle critique. Conçu pour qu'une machine virtuelle secondaire puisse reprendre immédiatement sans aucune perte de service lorsque survient une panne.      
Quand Fault Tolerance est activée, vCenter Server réinitialise la limite de mémoire de la VM et définit la réservation de mémoire en fonction de la taille de la mémoire de la VM.   
Si Fault Tolerance reste activée, il n'est pas possible de modifier la réservation de mémoire, sa taille, la limite, le nombre de vCPU ou les partages.   
Il est également impossible d'ajouter ou de supprimer des disques pour la machine virtuelle. Quand Fault Tolerance est désactivée, les valeurs d'origine de tous les paramètres qui ont été modifiés ne sont pas restaurées.   

# Prérequis:
L'option permettant d'activer Fault Tolerance n'est pas disponible si l'une de ces conditions s'applique :   
- La machine virtuelle réside sur un hôte qui n'a pas de licence pour la fonction.   
- La machine virtuelle réside sur un hôte qui est dans le mode maintenance ou le mode standby.   
- La machine virtuelle est déconnectée ou orpheline (son fichier .vmx n'est pas accessible).   
- L'utilisateur n'a pas l'autorisation d'activer la fonction.


# Procédure   
1. Dans vSphere Client, accédez à la VM pour laquelle vous souhaitez activer Fault Tolerance   
2. Cliquez avec le bouton droit sur la machine virtuelle et sélectionnez Fault Tolerance > Activer Fault Tolerance.
3. Cliquez sur Yes.   
4. Choisissez une banque de données sur laquelle placer les fichiers de configuration de la machine virtuelle secondaire. Puis cliquez sur Suivant.   
5. Choisissez un hôte sur lequel placer la machine virtuelle secondaire. Puis cliquez sur Suivant.   
6. Passez vos sélections en revue et cliquez sur Terminer.


<br/>

# SDRS

## Introduction   

**SDRS:**   
 Le DRS de Stockage permet de gérer les ressources regroupées d'un cluster de banques de données. Lorsque le DRS de stockage est activé, il fournit des recommandations au sujet du placement et de la migration des disques de la machine virtuelle pour équilibrer l'espace et les ressources d'E/S entre les banques de données du cluster.

Lorsqu'on souhaite activer le DRS de stockage, on doit activer les fonctions suivantes:
- Équilibrage de charge de l'espace entre les banques de données dans un cluster de banque de données.   
- Équilibrage de charge E/S entre les banques de données dans un cluster de banque de données.   
- Placement initial des disques virtuels en fonction de l'espace et de la charge de travail E/S.   


# Procédure   

1. Accédez au cluster de banques de données dans vSphere Client.   
2. Cliquez sur l'onglet Configurer, puis sur Services.   
3. Sélectionnez Storage DRS et cliquez sur Modifier.   
4. Sélectionnez Activer vSphere DRS et cliquez sur OK.   
5. (Facultatif) Pour désactiver uniquement les fonctions du DRS de stockage liées aux E/S, en laissant les commandes liées à l'espace actives, suivez les étapes suivantes.   
- Sous DRS de stockage, sélectionnez Modifier.   
- Désélectionnez l'option Activer la mesure E/S du DRS de stockage, puis cliquez sur OK.   


<br/>



# VM Backup
vCenter Server prend en charge un mécanisme de sauvegarde et de restauration sur fichier qui permet de récupérer un environnement après des défaillances.

## Configuration
Depuis l'interface de vCenter Server il est possible de créer une sauvegarde sur fichier de l'instance de vCenter Server.   
Après avoir créé la sauvegarde, il est possible de la restaurer à l'aide du programme d'installation de l'interface utilisateur graphique du dispositif.

Depuis l'interface de vCenter Server il est possible d'effectuer une sauvegarde sur fichier des données de configuration mémoire, d'inventaire et d'historique de l’instance de vCenter Server. Les données sauvegardées sont transférées via FTP, FTPS, HTTP, HTTPS, SFTP, NFS ou SMB vers un système distant. La sauvegarde n'est pas stockée sur le dispositif vCenter Server.

Il est possible d'effectuer une restauration sur fichier uniquement pour un système vCenter Server qui a été sauvegardé précédemment à l'aide de l'interface de vCenter Server.   
Il est possible d'effectuer une opération de restauration de ce type à l'aide du programme d'installation de l'interface utilisateur graphique de vCenter Server Appliance. Le processus consiste à déployer une nouvelle instance de vCenter Server Appliance et à copier les données issues de la sauvegarde sur fichier vers le nouveau dispositif.


<br/>


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


<br/>


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
