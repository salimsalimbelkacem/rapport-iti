#import "template.typ": project

#show: project.with(
  specialty: [Intelligent information systems engineering (ISII)],
  module: [Introduction to image processing],
  professor: [Mme. MEZZOUDJ Saliha],
  title: [Analysis and optimization of machine learning techniques for regression and classification],
  year: "2024/2025",
  author: ("Ibrahim Zoj", "Ayoub Casquita", "Abderahmane casquita", "Abdelkabder secteur", "BELKACEM salim")
)

= Méthodologie
== Configuration & Dépendances

_ Fichier : requirements.txt _

Ce fichier définit l'environnement d'exécution du projet. Il liste les bibliothèques nécessaires pour:
- le traitement d'image (`opencv-python, pillow`)
- l'apprentissage automatique (`scikit-learn, lightgbm, xgboost`)
- le traitement du langage naturel (`nltk, rouge-score`)
- l'interface graphique (`customtkinter`).

Leur installation garantit la reproductibilité des résultats.

== Ingestion des Données

_ Fichier : src/data_loader.py _

Ce module assure l'interface avec le jeu de données *Pascal VOC*. Il parcourt l'arborescence des fichiers XML (Annotations) pour extraire la vérité terrain (labels) et charge les images associées (JPEGImages). Il implémente une gestion d'erreurs robuste pour ignorer les fichiers corrompus sans interrompre le pipeline.

== Prétraitement des données
_ Fichier : src/preprocessing.py _

Implémente l'étape de *prétraitement* des données brutes.

- *Redimensionnement spatial:* Les images sont ramenées à une taille fixe (256x256) pour standardiser le nombre de descripteurs extraits.
- *Nettoyage textuel:* Les annotations subissent une normalisation (suppression de la ponctuation et des caractères spéciaux) via des expressions régulières (regex).

== Extraction de Features

_ Fichier : src/features.py _

Extraction des caractéristiques locales (Local Features) utilisant l'algorithme *ORB* (Oriented FAST and Rotated BRIEF). ORB est choisi pour son efficacité computationnelle et son invariance à la rotation. Nous extrayons jusqu'à 500 points d'intérêt par image pour constituer la base du dictionnaire visuel.

== Bag of Visual Words

_ Fichier : src/bovw.py _

Implémentation de l'approche *BoVW*.

- *Construction du vocabulaire:* Un clustering *K-Means* (K==500) est appliqué sur l'ensemble des descripteurs pour identifier les motifs visuels récurrents.
- *Quantification vectorielle:* Chaque image est convertie en un histogramme de fréquences de ces mots visuels.
- *Normalisation L2:* Essentielle pour comparer les images indépendamment du nombre total de points détectés.

== Réduction de Dimension

_ Fichier : src/pca_reduction.py _

Application de l'*Analyse en Composantes Principales (ACP/PCA)*. Cette étape réduit la dimensionnalité des histogrammes tout en conservant 95% de la variance explicative. Elle permet de supprimer le bruit, de décorréler les variables et d'accélérer la convergence des modèles de classification.

== Classification

_ Fichier : src/classification.py _

Entraînement de classifieurs multi-labels selon la stratégie *One-Vs-Rest*.

Nous comparons SVM, RandomForest, MLP (Réseau de neurones) et LightGBM. L'optimisation des hyperparamètres est réalisée par *GridSearchCV*.

*Note importante :* L'option `class_weight=='balanced'` est utilisée pour compenser le déséquilibre des classes du dataset Pascal VOC.

== Génération de Légende

_ Fichier : src/captioning.py _

Module de génération de langage naturel (NLG) basé sur des templates.

Une heuristique déduit le *contexte environnemental* (ex: "sky", "room") à partir des objets détectés pour construire une phrase syntaxiquement correcte : *"This image contains [objets] in a [contexte]"*.


== Segmentation

_ Fichier : src/segmentation.py _

Segmentation non supervisée utilisant le clustering *K-Means sur les pixels*.

L'algorithme regroupe les pixels selon leur similarité colorimétrique (espace RGB), permettant d'isoler visuellement les régions homogènes (objets vs fond).

== Évaluation

_ Fichier : src/evaluation.py _

Module d'évaluation complet.

- *Classification:* Accuracy, Hamming Loss, F1-Score.
- *NLP:* BLEU-4, ROUGE-L, METEOR.
- *CIDEr:* Implémentation manuelle (basée sur TF-IDF) pour calculer la pertinence des descriptions sans dépendances Java complexes.

== Main Script

_ Fichier : main.py _

Orchestrateur principal du projet. Il charge les données, exécute le pipeline de vision (ORB -> BoVW -> PCA), entraîne les modèles, évalue les performances et sauvegarde les artefacts (.pkl). Configuré pour traiter 5000 images afin de garantir la convergence des modèles.

== Interface Utilisateur

Interface utilisateur (GUI) développée avec *CustomTkinter*.

Elle permet le chargement interactif d'images (gestion des encodages Windows), l'inférence en temps réel avec un seuil de probabilité ajustable (15%) pour détecter les classes rares, et la visualisation de la segmentation par K-Means.

= Résultats & Analyse

== Légende et Définitions
_ Ce tableau explique les métriques utilisées pour évaluer nos modèles, conformément au cahier des charges. _

#table(
  columns: 4,

  table.header(
    [*Métrique*],
    [*MCatégorie*],
    [*MExplication Simple*],
    [*MInterprétation*],
  ),

[*Accuracy* ],[Classification ],[Est-ce que le modèle a trouvé *tous* les objets de l'image sans aucune erreur ? (Très strict pour du multi-label). ],[Un score bas est normal (< 10%) car il suffit d'oublier un seul objet pour avoir 0. ],
[*F1-Score\ (Micro)* ],[Classification ],[Moyenne harmonique entre Précision et Rappel. C'est la métrique *la plus importante* ici. ],[Plus c'est haut, mieux le modèle détecte les objets présents. ],
[*Hamming Loss* ],[Classification ],[Taux d'erreur par étiquette. ],[*Plus c'est bas, mieux c'est.* (Proche de 0 = Parfait). ],
[*BLEU-4* ],[NLP (Texte) ],[Mesure si la phrase générée contient les mêmes suites de 4 mots que la référence. ],[> 0.30 est un très bon score pour une phrase générée par template. ],
[*CIDEr* ],[NLP (Texte) ],[Métrique spécifique au *Image Captioning*. Elle donne plus de poids aux mots rares et importants. ],[Le score le plus robuste pour valider la description. ],
)
== Tableau Comparatif des Performances

_ Résultats obtenus après entraînement sur 5000 images du dataset Pascal VOC 2007 (BoVW K=500)._

#table(
columns: 6,

table.header(
[*Modèle* ],[*Accuracy* ],[*F1-Score (Micro)* ],[*BLEU-4* ],[*CIDEr* ],[*Observation* ],
),

[*SVM (RBF)* ],[*0.081* ],[*0.275* ],[*0.329* ],[*1.69* ],[*Meilleur Modèle global* ],
[*MLP Classifier* ],[0.061 ],[0.233 ],[0.303 ],[1.42 ],[Très confiant, excellent pour la démo ],
[*Naive Bayes* ],[0.059 ],[0.231 ],[0.320 ],[1.46 ],[Rapide et surprenant ],
[*LightGBM* ],[0.056 ],[0.226 ],[0.269 ],[1.20 ],[Correct mais moins performant ici ],
[*Decision Tree* ],[0.008 ],[0.191 ],[0.301 ],[1.11 ],[Moyen, manque de généralisation ],
[*Random Forest* ],[0.011 ],[0.048 ],[0.142 ],[0.23 ],[Échec (Biais sur la classe "Person") ],
)

== Analyse Détaillée par Modèle

Critère de classement : Le F1-Score (Micro) a été privilégié car c'est la métrique la plus robuste pour la classification multi-label déséquilibrée.

===  SVM (Support Vector Machine)
`Score F1 : 0.2748 | CIDEr : 1.6911`

- *Analyse:* Le grand gagnant. Avec son noyau RBF (non-linéaire) et la gestion des poids (class_weight='balanced'), il a su tracer les meilleures frontières entre les classes dans l'espace complexe des histogrammes visuels.
- *Verdict:* C'est le modèle à mettre en avant dans le rapport comme la référence technique.

=== MLP Classifier (Réseau de Neurones)

`Score F1 : 0.2335 | CIDEr : 1.4242`

- *Analyse :* Il arrive en deuxième position, très proche du sommet. Les réseaux de neurones (même simples comme ce Perceptron Multi-Couches) sont excellents pour capter les corrélations non-linéaires entre les mots visuels.
- *Point fort :* Lors des tests en temps réel, c'est lui qui affiche les *probabilités les plus tranchées* (confiance élevée), ce qui le rend idéal pour la démonstration.

=== Naive Bayes

`Score F1 : 0.2307 | CIDEr : 1.4648`
 
- *Analyse :* La "surprise" du projet. Il talonne le réseau de neurones de très près.
- *Explication :* Notre technique (Bag-of-Visual-Words) transforme les images en "documents de mots". Or, Naive Bayes est mathématiquement conçu pour l'analyse de texte (fréquence des mots). Il est donc naturellement très à l'aise sur ce type de données, malgré sa simplicité apparente.

=== LightGBM

`Score F1 : 0.2266 | CIDEr : 1.2058`
 
- *Analyse :* Performance honorable, mais légèrement en retrait par rapport au top 3.
- *Pourquoi ?* Bien que très puissant sur des données tabulaires (Excel), le Gradient Boosting a eu un peu plus de mal à généraliser sur les histogrammes BoVW réduits par PCA comparé à la géométrie du SVM. Il reste cependant un modèle valide pour ce projet.

===  Decision Tree

`Score F1 : 0.1912 | CIDEr : 1.1125`
 
- *Analyse :* Un décrochage net dans les performances.
- *Problème :* Un arbre de décision unique est trop "rigide". Il a tendance à apprendre par cœur le bruit des données d'entraînement (overfitting) et échoue à reconnaître des objets qu'il n'a pas vus exactement sous le même angle.

=== Random Forest

`Score F1 : 0.0485 | CIDEr : 0.2303`
 
- *Analyse :* L'échec du comparatif.
- *Cause :* Le modèle n'a pas réussi à gérer le fort déséquilibre des classes (beaucoup de "Person", peu d'"Avion"). Il est tombé dans un piège statistique : pour minimiser son erreur, il a décidé de prédire "Personne" ou "Rien" la plupart du temps. C'est un biais d'apprentissage majeur.


= Conclusion Générale

Ce projet démontre la viabilité de l'approche classique (Non-Deep Learning) pour la description d'images.

1. *L'impact des Données :* Passer de 500 à 5000 images a été décisif pour obtenir des résultats cohérents.
2. *Limites du BoVW :* L'approche par "sac de mots visuels" perd l'information spatiale (forme globale). Cela explique les confusions fréquentes entre objets ayant des textures similaires (ex: poils de chat vs texture de canapé).
3. *Choix Final :* Pour une application réelle basée sur cette architecture, nous retiendrions le couple *SVM* (pour la précision) ou *MLP* (pour la confiance).

