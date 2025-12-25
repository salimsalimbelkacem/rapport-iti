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

== Présentation du Jeu de Données

Nous avons opté pour le dataset Pascal VOC 2007 (Visual Object Classes).

=== Caractéristiques

Taille : Environ 5 000 images pour l'entraînement et 5 000 pour le test.
Classes : 20 catégories d'objets réparties en 4 groupes :
Personne : person
Animaux : bird, cat, cow, dog, horse, sheep
Véhicules : aeroplane, bicycle, boat, bus, car, motorbike, train
Intérieur : bottle, chair, dining table, potted plant, sofa, tv/monitor
Annotations : Format XML fournissant les boîtes englobantes (bounding boxes) et les
labels.

=== Pourquoi ce choix ?
Contrairement à Flickr8k qui contient des phrases complexes et du bruit, Pascal VOC est un
dataset de classification pure. Cela permet d'entraîner nos modèles classiques plus
efficacement sur des concepts visuels distincts, évitant la confusion que provoquerait un
dataset trop généraliste.
