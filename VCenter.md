# Installation and configuration of VCenter

## Stage 1 : Installation of VCenter


> Nous déployons Vcenter sur une machine client Windows 10.

![](/images/vcenter1.png)

> On configure l'adresse IP du Vcenter avec son port ainsi que son user et son mot de passe.

![](/images/vcenter2.png)

![](/images/vcenter3.png)

> On définit ensuite le nom de la VM avec le mot de passe root.

![](/images/vcenter4.png)

> On choisit ensuite l'espace de stockage de la VM.

![](/images/vcenter5.png)

> On choisit l'endroit où sera stocké le serveur Vcenter.

![](/images/vcenter6.png)

> On vient ensuire configurer notre nom de domaine, l'adresse IP pour le Vcenter, son masque, sa passerelle et son serveur DNS.

![](/images/vcenter7.png)

> 

![](/images/vcenter8.png)

![](/images/vcenter9.png)


## Stage 2 : Configuration of VCenter

![](/images/vcenter2.1.png)

![](/images/vcenter2.2.png)

![](/images/vcenter2.3.png)

![](/images/vcenter2.4.png)

![](/images/vcenter2.5.png)

![](/images/vcenter2.6.png)




Upgrade VCenter 
Connecter nouvelles hosts (2)
pas de mode de vérouillage pour pouvoir se connecter dessus

Screennnnn

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