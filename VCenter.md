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

> On renseigne notre nom de domaine, notre username et notre mot de passe.

![](/images/joinAD.png)



![](/images/distributedSwitch/distributedSwitch1.png)

![](/images/distributedSwitch/distributedSwitch2.png)

![](/images/distributedSwitch/distributedSwitch3.png)

![](/images/distributedSwitch/distributedSwitch4.png)

![](/images/distributedSwitch/distributedSwitch5.png)










Ajout source d'authentification (AD)

Menu > Administration > SingleSignOn > Configuration > Domain Active Directory > Join AD



J'ai créé un OU dans AD et j'ai ajouté les utilisateurs qui ont accès à VCenter

Connecter TruNAS à VCenter

J'ai créé un compte dans AD pour TruNAS

J'ai ajouté le compte dans VCenter

J'ai ajouté le compte dans TruNAS

Ensuite j'ai ajouté le compte dans le groupe des administrateurs de VCenter

J'ai ajouté le compte dans le groupe des administrateurs de TruNAS



AD ajouter 2 reverse lookup zone (pour chaque réseau).