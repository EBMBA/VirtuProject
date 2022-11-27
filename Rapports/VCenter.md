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

> Pour cela, sur notre console web : 
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
