# Système d'Upload et Classification Automatique de Documents

## 📋 Description

Ce système permet d'ajouter facilement des documents au site web de cours ING1 avec une classification automatique intelligente par matière.

## ✨ Fonctionnalités

### 1. Interface d'Upload Intuitive
- **Bouton dans la navigation** : Accessible depuis n'importe quelle page
- **Drag & Drop** : Glissez-déposez vos fichiers directement
- **Multi-fichiers** : Uploadez plusieurs documents en une seule fois
- **Tous formats supportés** : PDF, Word, PowerPoint, Excel, images, etc.

### 2. Classification Automatique par IA
L'algorithme analyse le nom du fichier et suggère automatiquement la matière appropriée :

#### Matières Semestre 1
- 🇬🇧 Anglais
- 🗄️ Base de Données
- 🎤 CEF
- 📊 Data Exploration
- ⚖️ Éthique
- 💼 Gestion
- 📜 Histoire & Design
- 🎲 Probabilités
- 💻 Système
- 🔤 Langages
- 🐍 Python

#### Matières Semestre 2
- 🖥️ Architecture des Ordinateurs (ADO)
- 🧮 Algorithmique
- 💡 Créativité
- 🌐 Développement Web
- 🇬🇧 English
- 🖱️ Interaction
- ☕ Java
- 📈 Optimisation

### 3. Indicateur de Confiance
- **Vert (70-100%)** : Haute confiance - la suggestion est très probablement correcte
- **Orange (40-69%)** : Confiance moyenne - vérification recommandée
- **Gris (0-39%)** : Faible confiance - sélection manuelle nécessaire

### 4. Validation et Modification
- Confirmez la suggestion de l'IA en un clic
- Modifiez manuellement si la suggestion n'est pas correcte
- Visualisez les mots-clés détectés pour comprendre la classification

## 🎯 Comment utiliser

1. **Cliquez sur "📤 Ajouter Documents"** dans la barre de navigation
2. **Sélectionnez vos fichiers** :
   - Cliquez sur la zone d'upload, ou
   - Glissez-déposez vos fichiers
3. **Vérifiez les suggestions** :
   - L'IA propose automatiquement une matière pour chaque fichier
   - Le pourcentage indique le niveau de confiance
4. **Ajustez si nécessaire** :
   - Changez la matière via le menu déroulant si besoin
5. **Confirmez** :
   - Cliquez sur "Confirmer et Classer"
   - Les documents sont automatiquement organisés

## 🧠 Algorithme de Classification

### Fonctionnement
L'algorithme utilise une approche basée sur les mots-clés :

1. **Normalisation** : Le nom du fichier est normalisé (minuscules, sans accents)
2. **Analyse** : Recherche de mots-clés spécifiques à chaque matière
3. **Scoring** : Attribution de points selon :
   - Présence de mots-clés
   - Longueur des mots-clés (plus spécifiques = plus de points)
   - Nombre de correspondances
4. **Confiance** : Calcul du pourcentage de confiance basé sur le score

### Exemples de Classification

| Nom du fichier | Matière suggérée | Confiance |
|----------------|------------------|-----------|
| `cours_sql_bdd.pdf` | Base de Données | 95% |
| `tp_python_pandas.py` | Python | 90% |
| `examen_probabilites.pdf` | Probabilités | 85% |
| `projet_java_poo.zip` | Java | 88% |
| `cours.pdf` | - | 0% |

## 📁 Structure des Fichiers

```
document-upload/
├── classifier.js          # Algorithme de classification
├── upload-manager.js      # Gestionnaire d'interface
├── upload-modal.css       # Styles de la modale
└── README.md             # Documentation
```

## 🔧 Intégration

### Dans index.html
```html
<!-- CSS -->
<link rel="stylesheet" href="document-upload/upload-modal.css">

<!-- JavaScript -->
<script src="document-upload/classifier.js"></script>
<script src="document-upload/upload-manager.js"></script>
```

### Dans la navigation
```html
<button class="nav-link" onclick="uploadManager.openModal()">
    📤 Ajouter Documents
</button>
```

## 🎨 Design

- **Interface moderne** : Design cohérent avec le reste du site
- **Responsive** : Fonctionne sur mobile, tablette et desktop
- **Animations fluides** : Transitions et feedbacks visuels
- **Mode sombre** : Compatible avec le thème sombre du site

## 🚀 Améliorations Futures

- [ ] Intégration avec un backend pour stockage réel
- [ ] OCR pour analyser le contenu des PDF
- [ ] Machine Learning pour améliorer la précision
- [ ] Historique des uploads
- [ ] Gestion des doublons
- [ ] Prévisualisation des fichiers
- [ ] Compression automatique des images
- [ ] Support des dossiers complets

## 📝 Notes Techniques

### Formats Supportés
Le système accepte tous les formats de fichiers. Les icônes sont automatiquement attribuées selon l'extension :
- 📕 PDF
- 📘 Word (doc, docx)
- 📙 PowerPoint (ppt, pptx)
- 📗 Excel (xls, xlsx)
- 🖼️ Images (jpg, png, gif)
- 🎥 Vidéos (mp4, avi)
- 📦 Archives (zip, rar)
- Et plus...

### Performance
- Traitement instantané côté client
- Pas de limite de taille (recommandé < 100MB par fichier)
- Support de centaines de fichiers simultanément

## 🤝 Contribution

Pour ajouter de nouvelles matières ou améliorer l'algorithme, modifiez le fichier `classifier.js` :

```javascript
this.subjects = {
    'nouvelle-matiere': {
        keywords: ['mot1', 'mot2', 'mot3'],
        icon: '🎯',
        path: 'pages/s1/nouvelle-matiere'
    }
}
```

## 📞 Support

Pour toute question ou suggestion d'amélioration, n'hésitez pas à contribuer au projet !

---

**Version** : 1.0.0  
**Dernière mise à jour** : 2024  
**Auteur** : Système ING1
