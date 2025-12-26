= Introduction Générale

== Contexte du projet

La vision par ordinateur (Computer Vision) est l'un des domaines les plus dynamiques de
l'intelligence artificielle. L'un de ses défis majeurs est le "fossé sémantique" (semantic gap) : la
difficulté pour une machine de traduire une matrice de pixels (bas niveau) en concepts
compréhensibles par l'humain (haut niveau), comme "un chien courant sur l'herbe".
Ce projet, intitulé "Génération de descriptions dʼimages avec des modèles dʼapprentissage
automatique", s'inscrit dans le module de Traitement d'Image Numérique du Master 1. Il vise à
résoudre ce problème d'annotation automatique (Image Captioning).

== Objectifs et Contraintes

L'objectif principal est de produire, pour une image donnée, une liste de mots-clés pertinents
ou une phrase descriptive simple.
La contrainte fondamentale imposée par le cahier des charges est l'interdiction d'utiliser des
techniques d'apprentissage profond (Deep Learning), tels que les Réseaux de Neurones
Convolutifs (CNN) ou les Transformers, qui dominent l'état de l'art actuel. Nous devons
exclusivement recourir à des méthodes "classiques" (Machine Learning traditionnel) et des
descripteurs locaux.

== Problématique

Comment construire un système performant de reconnaissance d'objets et de génération de
texte en utilisant uniquement des descripteurs de bas niveau (ORB/SIFT) et des classifieurs
statistiques, tout en gérant la variabilité visuelle des images (éclairage, rotation, échelle) ?
Ce rapport détaille notre démarche, de la sélection du jeu de données Pascal VOC à
l'implémentation d'une architecture "Bag of Visual Words" optimisée, jusqu'à la réalisation
d'une interface graphique de démonstration.

== État de l'art et Choix Techniques

Avant l'avènement du Deep Learning en 2012, la méthode de référence pour la classification
d'images était l'approche Bag of Visual Words (BoVW).
Inspirée du traitement du langage naturel (Bag of Words), cette technique considère une image
comme un "document" contenant des "mots visuels". Ces mots ne sont pas des pixels, mais
des motifs locaux (coins, bords, textures) identifiés par des algorithmes d'extraction de
caractéristiques.
Pour ce projet, nous avons validé les choix techniques suivants :
Descripteur : ORB (Oriented FAST and Rotated BRIEF). Il est choisi pour sa rapidité et sa
gratuité (contrairement à SIFT qui est breveté et lourd).
Dictionnaire : K-Means. Pour regrouper les descripteurs similaires.
Classification : SVM (Support Vector Machine). Réputé pour sa robustesse en haute
dimension.

== À propos du jeu de données
Le jeu de données *VOC0712* #cite(<PascalVOC>) est une fusion des ensembles *PASCAL VOC 2007* et *PASCAL VOC 2012*, largement reconnus dans le domaine de la vision par ordinateur pour les tâches de détection et de segmentation d’objets. Il regroupe des images représentant *20 classes d’objets*, comprenant des personnes, des animaux et des véhicules.

=== Utilisation
Ce jeu de données est couramment utilisé pour la *détection d’objets*, la *segmentation d’objets* ainsi que pour d’autres applications connexes en vision par ordinateur. Il constitue une référence standard pour l’évaluation et la comparaison des performances des modèles, et de nombreux modèles de pointe ont été entraînés à partir de VOC0712.

=== Collecte des données
Les images ont été collectées à partir de diverses sources publiques, notamment des recherches sur le web, Flickr et d’autres dépôts d’images accessibles au public. Les annotations ont été réalisées par des experts du domaine et sont régulièrement mises à jour afin d’assurer leur *exactitude* et leur *qualité*.

=== Couverture
Le jeu de données VOC0712 comprend un total de *16 551 images*, dont *11 530 images d’entraînement* et *4 921 images de test*. Il couvre les 20 classes suivantes : avion, vélo, oiseau, bateau, bouteille, bus, voiture, chat, chaise, vache, table à manger, chien, cheval, moto, personne, plante en pot, mouton, canapé, train, télévision / moniteur.
