# Guide d'Intégration Rapide - Système d'Upload

## 🚀 Installation en 3 étapes

### Étape 1 : Inclure les fichiers CSS et JS

Ajoutez ces lignes dans le `<head>` de votre page HTML :

```html
<!-- CSS du système d'upload -->
<link rel="stylesheet" href="document-upload/upload-modal.css">

<!-- JavaScript (avant la fermeture du </body>) -->
<script src="document-upload/classifier.js"></script>
<script src="document-upload/upload-manager.js"></script>
<script src="document-upload/config.js"></script> <!-- Optionnel -->
```

### Étape 2 : Ajouter le bouton d'upload

Dans votre barre de navigation ou n'importe où sur la page :

```html
<button class="nav-link upload-btn" onclick="uploadManager.openModal()">
    📤 Ajouter Documents
</button>
```

### Étape 3 : C'est tout ! 🎉

Le système est maintenant fonctionnel. La modale sera automatiquement créée au chargement de la page.

---

## 🎨 Personnalisation

### Modifier les matières supportées

Éditez `classifier.js` et ajoutez/modifiez dans l'objet `subjects` :

```javascript
'ma-matiere': {
    keywords: ['mot1', 'mot2', 'mot3'],
    icon: '🎯',
    path: 'pages/s1/ma-matiere'
}
```

### Changer les couleurs

Éditez `config.js` :

```javascript
styles: {
    primaryColor: '#667eea',  // Couleur principale
    accentColor: '#764ba2',   // Couleur d'accent
    successColor: '#4CAF50',  // Couleur de succès
}
```

### Personnaliser les messages

Éditez `config.js` :

```javascript
messages: {
    modalTitle: 'Mon titre personnalisé',
    uploadZoneText: 'Mon texte personnalisé',
    // ...
}
```

---

## 🔌 Intégration Backend

### Envoyer les fichiers à un serveur

Modifiez la fonction `processFile` dans `upload-manager.js` :

```javascript
async processFile(fileData) {
    const formData = new FormData();
    formData.append('file', fileData.file);
    formData.append('subject', fileData.selectedSubject);
    formData.append('confidence', fileData.classification.confidence);
    
    const response = await fetch('/api/upload', {
        method: 'POST',
        body: formData
    });
    
    return await response.json();
}
```

### Utiliser les callbacks

Dans `config.js`, personnalisez les callbacks :

```javascript
callbacks: {
    beforeUpload: (files) => {
        // Validation avant upload
        return confirm(`Uploader ${files.length} fichier(s) ?`);
    },
    
    onFileProcess: async (fileData) => {
        // Traitement de chaque fichier
        return await myUploadFunction(fileData);
    },
    
    afterUpload: (results) => {
        // Actions après upload
        window.location.reload(); // Rafraîchir la page
    }
}
```

---

## 📊 Exemples d'utilisation

### Ouvrir la modale programmatiquement

```javascript
uploadManager.openModal();
```

### Fermer la modale

```javascript
uploadManager.closeModal();
```

### Tester la classification

```javascript
const classifier = new DocumentClassifier();
const result = classifier.classify('cours_sql_bdd.pdf');
console.log(result);
// {
//   subject: 'bdd',
//   confidence: 95,
//   matchedKeywords: ['sql', 'bdd'],
//   icon: '🗄️',
//   path: 'pages/s1/bdd'
// }
```

### Obtenir toutes les matières

```javascript
const classifier = new DocumentClassifier();
const subjects = classifier.getAllSubjects();
console.log(subjects);
```

---

## 🐛 Dépannage

### La modale ne s'ouvre pas

1. Vérifiez que les scripts sont bien chargés :
   ```javascript
   console.log(typeof uploadManager); // Devrait afficher "object"
   ```

2. Vérifiez la console pour les erreurs JavaScript

3. Assurez-vous que les fichiers sont au bon emplacement

### La classification ne fonctionne pas

1. Vérifiez que `classifier.js` est chargé avant `upload-manager.js`

2. Testez manuellement :
   ```javascript
   const classifier = new DocumentClassifier();
   classifier.classify('test.pdf');
   ```

### Problèmes de style

1. Vérifiez que `upload-modal.css` est bien chargé

2. Assurez-vous que les variables CSS du thème sont définies dans `style.css`

---

## 📱 Responsive

Le système est entièrement responsive et fonctionne sur :
- 📱 Mobile (< 768px)
- 📱 Tablette (768px - 1024px)
- 💻 Desktop (> 1024px)

---

## ⚡ Performance

- **Léger** : ~15KB de JavaScript (non minifié)
- **Rapide** : Classification instantanée côté client
- **Optimisé** : Pas de dépendances externes

---

## 🔒 Sécurité

### Validation côté client

Le système valide :
- Taille des fichiers
- Nombre de fichiers
- Noms de fichiers

### Important

⚠️ **La validation côté client n'est pas suffisante !**

Vous DEVEZ également valider côté serveur :
- Type MIME réel du fichier
- Contenu du fichier (scan antivirus)
- Taille et permissions
- Authentification de l'utilisateur

---

## 📚 Ressources

- **Documentation complète** : `README.md`
- **Fichier de test** : `test.html`
- **Configuration** : `config.js`
- **Code source** : `classifier.js`, `upload-manager.js`

---

## 💡 Conseils

1. **Nommage des fichiers** : Encouragez les utilisateurs à utiliser des noms descriptifs
2. **Mots-clés** : Ajoutez des mots-clés spécifiques à vos matières
3. **Feedback** : Testez avec de vrais utilisateurs et ajustez
4. **Backend** : Implémentez un vrai système de stockage pour la production

---

## 🎯 Prochaines étapes

1. ✅ Système installé et fonctionnel
2. 🔄 Tester avec différents types de fichiers
3. 🎨 Personnaliser selon vos besoins
4. 🔌 Intégrer avec votre backend
5. 🚀 Déployer en production

---

**Besoin d'aide ?** Consultez le `README.md` complet ou le fichier `test.html` pour des exemples.
