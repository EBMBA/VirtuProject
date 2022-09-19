# CREATION ESXI : 

> Lors de la création de la VM, il faut sélectionner l'espace de stockage *luntp*.

![](/images/image1.png)

> On sélectionne ensuite le système d'exploitation de note machine. Ici, *VMware Esxi 7.0*

![](/images/image2.png)

> La configuration finale de notre machine est la suivante : 

![](/images/image3.png)

> On peut ensuite démarrer la machine virtuelle et configurer l'IP de la machine avec sa passerelle.

![](/images/image4.png)

> On peut ensuite se connecter à notre machine virtuelle via le client vSphere.

![](/images/image5.png)

> Dans l'onglet *Mise en réseau > Commutateurs virtuels*, on peut voir les différents commutateurs virtuels créés puis créer un nouveau commutateur virtuel pour chaque réseau.

![](/images/image6.png)

> On peut ensuite créer un nouveau *groupe de ports* pour chaque réseau.

![](/images/image7.png)

> Ensuite, on ajoute une adresse IP statique à chaque groupe de ports dans l'onglet *NIC VMKernel*.

![](/images/image8.png)

> Pour le groupe de port Vmotion, il faut bien penser à cocher le service *vMotion*.

![](/images/image9.png)