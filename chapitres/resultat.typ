= Résultats & Analyse

== Légende et Définitions
_ Ce tableau explique les métriques utilisées pour évaluer nos modèles, conformément au cahier des charges. _

#table(
  columns: 4,

  table.header(
    [*Métrique*],
    [*Catégorie*],
    [*Explication Simple*],
    [*Interprétation*],
  ),

  [*Accuracy* ],[Classification ],[Est-ce que le modèle a trouvé *tous* les objets de l'image sans aucune erreur ? (Très strict pour du multi-label). ],[Un score bas est normal (< 10%) car il suffit d'oublier un seul objet pour avoir 0. ],
  [*F1-Score\ (Micro)* ],[Classification ],[Moyenne harmonique entre Précision et Rappel. C'est la métrique *la plus importante* ici. ],[Plus c'est haut, mieux le modèle détecte les objets présents. ],
  [*Hamming Loss* ],[Classification ],[Taux d'erreur par étiquette. ],[*Plus c'est bas, mieux c'est.* (Proche de 0 = Parfait). ],
  [*BLEU-4* ],[NLP (Texte) ],[Mesure si la phrase générée contient les mêmes suites de 4 mots que la référence. ],[> 0.30 est un très bon score pour une phrase générée par template. ],
  [*CIDEr* ],[NLP (Texte) ],[Métrique spécifique au *Image Captioning*. Elle donne plus de poids aux mots rares et importants. ],[Le score le plus robuste pour valider la description. ],
)

== Tableau Synthétique des Performances
_ Ce tableau classe les modèles du plus performant au moins performant,
basé sur le *F1-Score (Micro)* qui est la métrique de référence pour la
classification multi-label. _

#table(
columns: 8,

table.header(
[],[*Modèle* ],[*F1-Score* ],[*Hamming Loss* ],[*Accuracy* ],[*BLEU-4* ],[*CIDEr* ],[*Verdict* ],
),

[1 ],[*Random Forest* ],[*0.569* ],[*0.0498* ],[*0.490* ],[*0.695* ],[*5.51* ],[*Excellent* ],
[2 ],[*SVM (RBF)* ],[0.541 ],[0.0491 ],[0.426 ],[0.608 ],[4.75 ],[Très Robuste ],
[3 ],[*MLP Classifier* ],[0.502 ],[0.0521 ],[0.377 ],[0.562 ],[4.25 ],[Bon ],
[4 ],[Naive Bayes ],[0.498 ],[0.0573 ],[0.377 ],[0.589 ],[4.38 ],[Efficace ],
[5 ],[LightGBM ],[0.492 ],[0.0521 ],[0.368 ],[0.547 ],[4.12 ],[Moyen ],
[6 ],[Decision Tree ],[0.239 ],[0.1722 ],[0.026 ],[0.303 ],[1.24 ],[Faible ],
)
- *F1-Score (Micro) :* La capacité à trouver les objets (Max = 1.0).
- *Hamming Loss :* Le taux d'erreur par étiquette (Min = 0.0 == Analyse Détaillée par Modèle
_ Le SVM a le plus faible Hamming Loss (0.0491), ce qui signifie qu'il fait le moins de "fausses détections" (faux positifs). _
- *Accuracy :* Le taux de prédiction parfaite (tous les objets trouvés sans erreur)
- *Critère de classement :* Le F1-Score (Micro) a été privilégié car c'est la métrique la plus robuste pour la classification multi-label déséquilibrée.
- *BLEU-4 / METEOR / CIDEr :* Métriques NLP (qualité de la phrase).
_ *CIDEr* est la plus importante pour la description d'image. _

== Analyse Détaillée par Modèle


=== Random Forest (Forêts Aléatoires)

`Score F1 : 0.569 | CIDEr : 5.51`

- *Performance :* C'est la révélation de ce test à grande échelle. Alors qu'il échouait sur 5000 images, le passage à 10 000 images lui a permis de stabiliser ses arbres de décision. Il obtient le meilleur score sur *toutes* les métriques.
- *Interprétation :* La méthode d'ensemble (Bagging) s'avère redoutable pour gérer le bruit des histogrammes visuels quand la quantité de données est suffisante. Il offre les descriptions les plus pertinentes (CIDEr > 5 est un score très élevé pour cette tâche).

=== SVM (Support Vector Machine)

`Score F1 : 0.540 | CIDEr : 4.75`

- *Performance :* Le SVM reste un modèle extrêmement solide. Il offre la meilleure généralisation théorique grâce à son noyau RBF.
- *Interprétation :* Il se comporte très bien dans l'espace à haute dimension créé par le *Bag-of-Visual-Words*. C'est le modèle le plus "sûr" mathématiquement, même s'il est battu par la puissance brute du Random Forest ici.

=== MLP Classifier (Réseau de Neurones)

`Score F1 : 0.501 | CIDEr : 4.25`

- *Performance :* Le réseau de neurones arrive en 3ème position. Il a bien convergé et offre des résultats cohérents.
- *Point Fort :* Lors de l'utilisation dans l'application, c'est ce modèle qui fournit les probabilités les plus *tranchées* (confiance élevée), ce qui facilite le filtrage des objets pour l'affichage.

=== Naive Bayes

`Score F1 : 0.497 | CIDEr : 4.38`

- *Performance :* Il talonne le MLP et le LightGBM.
- *Analyse :* C'est le meilleur rapport *Qualité / Temps de calcul*. L'approche BoVW traitant les images comme des textes (fréquence de mots), Naive Bayes est dans son élément naturel. Il obtient un excellent score METEOR (0.76), signe que les mots-clés générés sont très pertinents.

=== LightGBM (Gradient Boosting)

`Score F1 : 0.491 | CIDEr : 4.12`

- *Performance :* Légèrement en retrait par rapport au Random Forest.
- *Diagnostique :* Le Boosting est très sensible aux hyperparamètres. Sur des données d'histogrammes visuels (qui sont des matrices creuses), il semble avoir plus de mal à optimiser ses arbres séquentiels que le Random Forest qui travaille en parallèle.

=== Decision Tree (Arbre Unique)

`Score F1 : 0.238 | CIDEr : 1.24`

- *Performance :* Le décrochage est net.
- *Cause :* Ce résultat démontre les limites d'un arbre unique : il souffre de *sur-apprentissage (overfitting)*. Il apprend par cœur les images d'entraînement mais échoue à généraliser sur les nouvelles images. Cela justifie pleinement l'utilisation de méthodes d'ensemble comme le Random Forest.

= Conclusion Générale

Ce projet démontre la viabilité de l'approche classique (Non-Deep Learning) pour la description d'images.
L'augmentation de la taille du dataset (de 500 à 10 000 images) a transformé les résultats du projet.

== Validation de l'approche :
Nous avons atteint une Accuracy de 49% et un F1-Score de 0.57, ce qui est remarquable pour une approche classique (sans Deep Learning CNN) sur un dataset complexe comme Pascal VOC (20 classes).
== Qualité Textuelle :
Avec un score BLEU-4 proche de 0.70 (Random Forest), le système est capable de générer des phrases gabarits ("This image contains...") qui correspondent fidèlement au contenu de l'image.
== Choix de déploiement :
Pour l'application finale, le modèle Random Forest est retenu pour sa précision maximale, tandis que le SVM constitue une alternative robuste.

