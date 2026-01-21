// Configuration du système d'upload de documents
const UploadConfig = {
    // Paramètres généraux
    maxFileSize: 100 * 1024 * 1024, // 100 MB par fichier
    maxFiles: 50, // Nombre maximum de fichiers par upload
    
    // Formats acceptés (laisser vide pour accepter tous les formats)
    acceptedFormats: [], // Ex: ['.pdf', '.docx', '.pptx'] ou [] pour tout accepter
    
    // Seuils de confiance pour la classification
    confidenceThresholds: {
        high: 70,    // Confiance élevée (vert)
        medium: 40,  // Confiance moyenne (orange)
        low: 0       // Confiance faible (gris)
    },
    
    // Messages personnalisables
    messages: {
        uploadZoneText: 'Cliquez ou glissez vos fichiers ici',
        uploadZoneHint: 'PDF, Word, PowerPoint, Excel, Images, etc.',
        modalTitle: '📤 Ajouter des documents',
        confirmButton: 'Confirmer et Classer',
        cancelButton: 'Annuler',
        processingText: 'Traitement de',
        successText: '✓ Tous les documents ont été classés avec succès !',
        noSubjectSelected: '-- Choisir une matière --',
        classificationLabel: 'Matière suggérée',
        keywordsLabel: 'Mots-clés'
    },
    
    // Options d'affichage
    display: {
        showConfidenceIndicator: true,
        showMatchedKeywords: true,
        showFileSize: true,
        animationDuration: 300, // ms
        successMessageDuration: 3000 // ms
    },
    
    // Comportement
    behavior: {
        autoCloseOnSuccess: true,
        requireSubjectSelection: true, // Obliger à sélectionner une matière
        allowDuplicates: true,
        sortFilesByName: false
    },
    
    // Callbacks personnalisables (pour intégration backend)
    callbacks: {
        // Appelé avant l'upload
        beforeUpload: (files) => {
            console.log('Avant upload:', files);
            return true; // Retourner false pour annuler
        },
        
        // Appelé pour chaque fichier
        onFileProcess: async (fileData) => {
            console.log('Traitement:', fileData);
            // Ici, vous pouvez envoyer au serveur
            // return await fetch('/api/upload', { ... });
        },
        
        // Appelé après l'upload complet
        afterUpload: (results) => {
            console.log('Après upload:', results);
            // Rafraîchir la page, mettre à jour l'index, etc.
        },
        
        // Appelé en cas d'erreur
        onError: (error) => {
            console.error('Erreur:', error);
            alert('Une erreur est survenue: ' + error.message);
        }
    },
    
    // Validation personnalisée
    validation: {
        // Fonction de validation du nom de fichier
        validateFileName: (fileName) => {
            // Interdire certains caractères
            const invalidChars = /[<>:"|?*]/;
            if (invalidChars.test(fileName)) {
                return { valid: false, message: 'Le nom contient des caractères invalides' };
            }
            return { valid: true };
        },
        
        // Fonction de validation de la taille
        validateFileSize: (fileSize) => {
            if (fileSize > UploadConfig.maxFileSize) {
                return { 
                    valid: false, 
                    message: `Fichier trop volumineux (max ${UploadConfig.maxFileSize / 1024 / 1024} MB)` 
                };
            }
            return { valid: true };
        }
    },
    
    // Styles personnalisables
    styles: {
        primaryColor: '#667eea',
        accentColor: '#764ba2',
        successColor: '#4CAF50',
        warningColor: '#FF9800',
        errorColor: '#ff4757'
    }
};

// Export pour utilisation
if (typeof module !== 'undefined' && module.exports) {
    module.exports = UploadConfig;
}
