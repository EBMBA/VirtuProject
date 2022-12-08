# Introduction   

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
