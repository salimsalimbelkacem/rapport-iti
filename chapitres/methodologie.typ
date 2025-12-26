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

#figure(
    image("/img/resultat.jpg"),
    caption: [Légende générée]
)

== Segmentation

_ Fichier : src/segmentation.py _

Segmentation non supervisée utilisant le clustering *K-Means sur les pixels*.

L'algorithme regroupe les pixels selon leur similarité colorimétrique (espace RGB), permettant d'isoler visuellement les régions homogènes (objets vs fond).

#figure(
  [
    #set image(width: 200pt)
    #grid(
      columns: 2,
      gutter: 10pt,

      image("/img/image description.jpg"),
      image("/img/segmentation.jpg")
    )
  ],
  caption: [image orignal et sa version segmentée]
)
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

Elle permet:
- Le chargement interactif d'images,
- La selection de model (Random Forest, SVM, MLP Classifier, Naive Bayes, LightGBM, Decision Tree),
- L'analyse d'image et generation de Légende,
- L'inspection de la segmentation efféctué sur l'image chargé

#figure(
  image("/img/gui.png"),
  caption: [interface graphique]
)
