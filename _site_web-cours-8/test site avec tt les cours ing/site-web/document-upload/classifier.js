// Algorithme de classification automatique des documents
class DocumentClassifier {
    constructor() {
        this.contentExtractor = new ContentExtractor();
        
        // Types de documents
        this.documentTypes = {
            'examen': {
                keywords: ['examen', 'exam', 'partiel', 'controle', 'test', 'ds', 'devoir surveille', 'epreuve', 'cc', 'controle continu'],
                icon: '📝',
                priority: 10
            },
            'td': {
                keywords: ['td', 'travaux diriges', 'exercice', 'exercices', 'serie'],
                icon: '📋',
                priority: 8
            },
            'tp': {
                keywords: ['tp', 'travaux pratiques', 'pratique', 'labo', 'laboratoire'],
                icon: '🔬',
                priority: 8
            },
            'cours': {
                keywords: ['cours', 'cm', 'magistral', 'lecon', 'chapitre', 'support'],
                icon: '📚',
                priority: 7
            },
            'correction': {
                keywords: ['correction', 'corrige', 'solution', 'reponse'],
                icon: '✅',
                priority: 9
            },
            'projet': {
                keywords: ['projet', 'project', 'mini-projet'],
                icon: '🚀',
                priority: 8
            },
            'resume': {
                keywords: ['resume', 'synthese', 'fiche', 'recap', 'recapitulatif'],
                icon: '📄',
                priority: 6
            },
            'annale': {
                keywords: ['annale', 'ancien', 'anciens sujets', 'sujet'],
                icon: '📜',
                priority: 7
            }
        };

        // Années académiques
        this.yearPattern = /20\d{2}[-_]?20?\d{2}|20\d{2}/g;

        this.subjects = {
            'anglais': {
                keywords: ['english', 'anglais', 'vocabulary', 'grammar', 'speaking', 'listening', 'toeic', 'toefl'],
                icon: '🇬🇧',
                path: 'pages/s1/anglais'
            },
            'bdd': {
                keywords: ['base', 'données', 'database', 'sql', 'mysql', 'postgresql', 'mcd', 'mld', 'merise', 'requete', 'select', 'normalisation'],
                icon: '🗄️',
                path: 'pages/s1/bdd'
            },
            'cef': {
                keywords: ['cef', 'communication', 'expression', 'oral', 'presentation'],
                icon: '🎤',
                path: 'pages/s1/cef'
            },
            'data-exploration': {
                keywords: ['data', 'exploration', 'statistique', 'analyse', 'univariée', 'bivariée', 'acp', 'dataset', 'pandas', 'numpy'],
                icon: '📊',
                path: 'pages/s1/data-exploration'
            },
            'ethique': {
                keywords: ['ethique', 'ethics', 'morale', 'deontologie', 'philosophie'],
                icon: '⚖️',
                path: 'pages/s1/ethique'
            },
            'gestion': {
                keywords: ['gestion', 'management', 'entreprise', 'comptabilite', 'finance', 'marketing'],
                icon: '💼',
                path: 'pages/s1/gestion'
            },
            'histoire-et-design': {
                keywords: ['histoire', 'design', 'art', 'ux', 'ui', 'interface', 'ergonomie'],
                icon: '📜',
                path: 'pages/s1/histoire-et-design'
            },
            'probabilites': {
                keywords: ['probabilite', 'probability', 'proba', 'statistique', 'loi', 'variable', 'aleatoire', 'esperance', 'variance'],
                icon: '🎲',
                path: 'pages/s1/probabilites'
            },
            'systeme': {
                keywords: ['systeme', 'system', 'linux', 'unix', 'shell', 'bash', 'docker', 'virtualbox', 'vm', 'reseau', 'network'],
                icon: '💻',
                path: 'pages/s1/systeme'
            },
            'langages': {
                keywords: ['langage', 'language', 'programmation', 'compilation', 'interpreteur', 'syntaxe', 'grammaire', 'automate'],
                icon: '🔤',
                path: 'pages/s1/langages'
            },
            'python': {
                keywords: ['python', 'py', 'jupyter', 'notebook', 'pandas', 'matplotlib', 'numpy'],
                icon: '🐍',
                path: 'pages/s1/python'
            },
            // Semestre 2
            'ado': {
                keywords: ['ado', 'architecture', 'ordinateur', 'assembleur', 'processeur', 'memoire', 'cache'],
                icon: '🖥️',
                path: 'pages/s2/ado'
            },
            'algo': {
                keywords: ['algo', 'algorithme', 'algorithm', 'graphe', 'arbre', 'complexite', 'tri', 'parcours', 'dijkstra'],
                icon: '🧮',
                path: 'pages/s2/algo'
            },
            'creativite': {
                keywords: ['creativite', 'creativity', 'innovation', 'design thinking'],
                icon: '💡',
                path: 'pages/s2/creativite'
            },
            'devweb': {
                keywords: ['web', 'html', 'css', 'javascript', 'js', 'react', 'node', 'frontend', 'backend'],
                icon: '🌐',
                path: 'pages/s2/devweb'
            },
            'english': {
                keywords: ['english', 'anglais', 'storytelling', 'picture', 'ads'],
                icon: '🇬🇧',
                path: 'pages/s2/english'
            },
            'interaction': {
                keywords: ['interaction', 'ihm', 'interface', 'utilisateur', 'ux', 'ui'],
                icon: '🖱️',
                path: 'pages/s2/interaction'
            },
            'java': {
                keywords: ['java', 'poo', 'objet', 'class', 'heritage', 'polymorphisme', 'swing', 'javafx'],
                icon: '☕',
                path: 'pages/s2/java'
            },
            'optimisation': {
                keywords: ['optimisation', 'optimization', 'lineaire', 'simplexe', 'contrainte', 'programmation'],
                icon: '📈',
                path: 'pages/s2/optimisation'
            }
        };
    }

    // Normalise le texte pour la comparaison
    normalizeText(text) {
        return text.toLowerCase()
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, '') // Supprime les accents
            .replace(/[^a-z0-9\s]/g, ' ')
            .trim();
    }

    // Calcule le score de correspondance pour une matière
    calculateScore(fileName, subject) {
        const normalizedFileName = this.normalizeText(fileName);
        const keywords = subject.keywords;
        let score = 0;
        let matchedKeywords = [];

        keywords.forEach(keyword => {
            const normalizedKeyword = this.normalizeText(keyword);
            if (normalizedFileName.includes(normalizedKeyword)) {
                // Score plus élevé pour les mots plus longs (plus spécifiques)
                const keywordScore = keyword.length * 2;
                score += keywordScore;
                matchedKeywords.push(keyword);
            }
        });

        return { score, matchedKeywords };
    }

    // Détecte le type de document
    detectDocumentType(fileName) {
        const normalizedFileName = this.normalizeText(fileName);
        let bestType = null;
        let bestScore = 0;
        let matchedKeywords = [];

        for (const [typeKey, typeData] of Object.entries(this.documentTypes)) {
            let score = 0;
            let matched = [];

            typeData.keywords.forEach(keyword => {
                const normalizedKeyword = this.normalizeText(keyword);
                if (normalizedFileName.includes(normalizedKeyword)) {
                    score += keyword.length * typeData.priority;
                    matched.push(keyword);
                }
            });

            if (score > bestScore) {
                bestScore = score;
                bestType = typeKey;
                matchedKeywords = matched;
            }
        }

        return {
            type: bestType,
            icon: bestType ? this.documentTypes[bestType].icon : '📄',
            matchedKeywords: matchedKeywords,
            confidence: bestScore > 0 ? Math.min(100, (bestScore / 5) * 100) : 0
        };
    }

    // Détecte l'année académique
    detectYear(fileName) {
        const matches = fileName.match(this.yearPattern);
        if (matches && matches.length > 0) {
            return matches[0];
        }
        return null;
    }

    // Détecte le numéro (TD1, TP2, etc.)
    detectNumber(fileName) {
        const patterns = [
            /(?:td|tp|cm|ds|cc|exam|chapitre|ch)\s*[\-_]?\s*(\d+)/i,
            /(?:numero|n°|no)\s*[\-_]?\s*(\d+)/i,
            /\b(\d+)\b/
        ];

        for (const pattern of patterns) {
            const match = fileName.match(pattern);
            if (match) {
                return match[1];
            }
        }
        return null;
    }

    // Classifie un document avec analyse du contenu
    async classifyWithContent(file) {
        // Classification basée sur le nom
        const nameClassification = this.classify(file.name);
        
        // Extraction et analyse du contenu
        const content = await this.contentExtractor.extractText(file);
        
        if (!content || content.length < 50) {
            // Pas assez de contenu, on retourne la classification par nom
            return nameClassification;
        }
        
        // Analyse du contenu
        const contentAnalysis = this.analyzeContent(content);
        
        // Fusion des résultats
        return this.mergeClassifications(nameClassification, contentAnalysis, file.name);
    }

    // Analyse le contenu du document
    analyzeContent(content) {
        const normalizedContent = this.normalizeText(content);
        
        // Détection de la matière dans le contenu
        let subjectScores = {};
        for (const [subjectKey, subject] of Object.entries(this.subjects)) {
            let score = 0;
            let matched = [];
            
            subject.keywords.forEach(keyword => {
                const normalizedKeyword = this.normalizeText(keyword);
                const regex = new RegExp('\\b' + normalizedKeyword + '\\b', 'gi');
                const matches = normalizedContent.match(regex);
                
                if (matches) {
                    score += matches.length * keyword.length;
                    matched.push(keyword);
                }
            });
            
            if (score > 0) {
                subjectScores[subjectKey] = { score, matched };
            }
        }
        
        // Détection du type dans le contenu
        let typeScores = {};
        for (const [typeKey, typeData] of Object.entries(this.documentTypes)) {
            let score = 0;
            let matched = [];
            
            typeData.keywords.forEach(keyword => {
                const normalizedKeyword = this.normalizeText(keyword);
                const regex = new RegExp('\\b' + normalizedKeyword + '\\b', 'gi');
                const matches = normalizedContent.match(regex);
                
                if (matches) {
                    score += matches.length * typeData.priority;
                    matched.push(keyword);
                }
            });
            
            if (score > 0) {
                typeScores[typeKey] = { score, matched };
            }
        }
        
        // Meilleure matière
        let bestSubject = null;
        let bestSubjectScore = 0;
        let bestSubjectKeywords = [];
        
        for (const [key, data] of Object.entries(subjectScores)) {
            if (data.score > bestSubjectScore) {
                bestSubjectScore = data.score;
                bestSubject = key;
                bestSubjectKeywords = data.matched;
            }
        }
        
        // Meilleur type
        let bestType = null;
        let bestTypeScore = 0;
        let bestTypeKeywords = [];
        
        for (const [key, data] of Object.entries(typeScores)) {
            if (data.score > bestTypeScore) {
                bestTypeScore = data.score;
                bestType = key;
                bestTypeKeywords = data.matched;
            }
        }
        
        return {
            subject: bestSubject,
            subjectScore: bestSubjectScore,
            subjectKeywords: bestSubjectKeywords,
            documentType: bestType,
            typeScore: bestTypeScore,
            typeKeywords: bestTypeKeywords
        };
    }

    // Fusionne les classifications du nom et du contenu
    mergeClassifications(nameClass, contentClass, fileName) {
        // Matière finale
        let finalSubject = nameClass.subject;
        let finalSubjectConfidence = nameClass.subjectConfidence;
        let finalSubjectKeywords = [...nameClass.subjectKeywords];
        
        if (contentClass.subject) {
            const contentConfidence = Math.min(100, (contentClass.subjectScore / 20) * 100);
            
            if (contentClass.subject === nameClass.subject) {
                // Même matière : boost de confiance
                finalSubjectConfidence = Math.min(100, finalSubjectConfidence + 20);
                finalSubjectKeywords = [...new Set([...finalSubjectKeywords, ...contentClass.subjectKeywords])];
            } else if (contentConfidence > finalSubjectConfidence) {
                // Contenu plus confiant : on prend le contenu
                finalSubject = contentClass.subject;
                finalSubjectConfidence = contentConfidence;
                finalSubjectKeywords = contentClass.subjectKeywords;
            }
        }
        
        // Type final
        let finalType = nameClass.documentType;
        let finalTypeConfidence = nameClass.documentTypeConfidence;
        let finalTypeKeywords = [...nameClass.documentTypeKeywords];
        
        if (contentClass.documentType) {
            const contentTypeConfidence = Math.min(100, (contentClass.typeScore / 10) * 100);
            
            if (contentClass.documentType === nameClass.documentType) {
                // Même type : boost de confiance
                finalTypeConfidence = Math.min(100, finalTypeConfidence + 25);
                finalTypeKeywords = [...new Set([...finalTypeKeywords, ...contentClass.typeKeywords])];
            } else if (contentTypeConfidence > finalTypeConfidence) {
                // Contenu plus confiant : on prend le contenu
                finalType = contentClass.documentType;
                finalTypeConfidence = contentTypeConfidence;
                finalTypeKeywords = contentClass.typeKeywords;
            }
        }
        
        // Reconstruction du titre suggéré
        let suggestedTitle = '';
        if (finalType) {
            suggestedTitle += this.formatDocumentType(finalType);
            if (nameClass.number) suggestedTitle += ' ' + nameClass.number;
        }
        if (finalSubject) {
            if (suggestedTitle) suggestedTitle += ' - ';
            suggestedTitle += this.formatSubjectName(finalSubject);
        }
        if (nameClass.year) {
            suggestedTitle += ' (' + nameClass.year + ')';
        }
        
        return {
            subject: finalSubject,
            subjectConfidence: Math.round(finalSubjectConfidence),
            subjectKeywords: finalSubjectKeywords,
            subjectIcon: finalSubject ? this.subjects[finalSubject].icon : '📄',
            path: finalSubject ? this.subjects[finalSubject].path : null,
            
            documentType: finalType,
            documentTypeIcon: finalType ? this.documentTypes[finalType].icon : '📄',
            documentTypeConfidence: Math.round(finalTypeConfidence),
            documentTypeKeywords: finalTypeKeywords,
            
            year: nameClass.year,
            number: nameClass.number,
            suggestedTitle: suggestedTitle || fileName,
            
            confidence: Math.round((finalSubjectConfidence + finalTypeConfidence) / 2),
            
            icon: finalSubject ? this.subjects[finalSubject].icon : '📄',
            matchedKeywords: [...new Set([...finalSubjectKeywords, ...finalTypeKeywords])],
            
            analyzedContent: true
        };
    }

    // Classifie un document et retourne toutes les métadonnées
    classify(fileName) {
        // Détection de la matière
        let bestMatch = null;
        let bestScore = 0;
        let bestMatchedKeywords = [];

        for (const [subjectKey, subject] of Object.entries(this.subjects)) {
            const { score, matchedKeywords } = this.calculateScore(fileName, subject);
            
            if (score > bestScore) {
                bestScore = score;
                bestMatch = subjectKey;
                bestMatchedKeywords = matchedKeywords;
            }
        }

        // Calcul du niveau de confiance pour la matière
        let confidence = 0;
        if (bestScore > 0) {
            confidence = Math.min(100, (bestScore / 10) * 100);
            if (bestMatchedKeywords.length >= 2) confidence = Math.min(100, confidence + 20);
        }

        // Détection du type de document
        const docType = this.detectDocumentType(fileName);

        // Détection de l'année
        const year = this.detectYear(fileName);

        // Détection du numéro
        const number = this.detectNumber(fileName);

        // Construction du titre suggéré
        let suggestedTitle = '';
        if (docType.type) {
            suggestedTitle += this.formatDocumentType(docType.type);
            if (number) suggestedTitle += ' ' + number;
        }
        if (bestMatch) {
            if (suggestedTitle) suggestedTitle += ' - ';
            suggestedTitle += this.formatSubjectName(bestMatch);
        }
        if (year) {
            suggestedTitle += ' (' + year + ')';
        }

        return {
            // Matière
            subject: bestMatch,
            subjectConfidence: Math.round(confidence),
            subjectKeywords: bestMatchedKeywords,
            subjectIcon: bestMatch ? this.subjects[bestMatch].icon : '📄',
            path: bestMatch ? this.subjects[bestMatch].path : null,
            
            // Type de document
            documentType: docType.type,
            documentTypeIcon: docType.icon,
            documentTypeConfidence: Math.round(docType.confidence),
            documentTypeKeywords: docType.matchedKeywords,
            
            // Métadonnées supplémentaires
            year: year,
            number: number,
            suggestedTitle: suggestedTitle || fileName,
            
            // Confiance globale
            confidence: Math.round((confidence + docType.confidence) / 2),
            
            // Compatibilité avec l'ancien format
            icon: bestMatch ? this.subjects[bestMatch].icon : '📄',
            matchedKeywords: [...bestMatchedKeywords, ...docType.matchedKeywords]
        };
    }

    // Retourne la liste de toutes les matières disponibles
    getAllSubjects() {
        return Object.entries(this.subjects).map(([key, value]) => ({
            key,
            name: this.formatSubjectName(key),
            icon: value.icon,
            path: value.path
        }));
    }

    // Formate le type de document pour l'affichage
    formatDocumentType(key) {
        const names = {
            'examen': 'Examen',
            'td': 'TD',
            'tp': 'TP',
            'cours': 'Cours',
            'correction': 'Correction',
            'projet': 'Projet',
            'resume': 'Résumé',
            'annale': 'Annale'
        };
        return names[key] || key;
    }

    // Formate le nom de la matière pour l'affichage
    formatSubjectName(key) {
        const names = {
            'anglais': 'Anglais',
            'bdd': 'Base de Données',
            'cef': 'CEF',
            'data-exploration': 'Data Exploration',
            'ethique': 'Éthique',
            'gestion': 'Gestion',
            'histoire-et-design': 'Histoire & Design',
            'probabilites': 'Probabilités',
            'systeme': 'Système',
            'langages': 'Langages',
            'python': 'Python',
            'ado': 'Architecture des Ordinateurs',
            'algo': 'Algorithmique',
            'creativite': 'Créativité',
            'devweb': 'Développement Web',
            'english': 'English',
            'interaction': 'Interaction',
            'java': 'Java',
            'optimisation': 'Optimisation'
        };
        return names[key] || key;
    }

    // Obtient l'icône pour un type de fichier
    getFileIcon(fileName) {
        const ext = fileName.split('.').pop().toLowerCase();
        const icons = {
            'pdf': '📕',
            'doc': '📘',
            'docx': '📘',
            'ppt': '📙',
            'pptx': '📙',
            'xls': '📗',
            'xlsx': '📗',
            'txt': '📄',
            'zip': '📦',
            'rar': '📦',
            'jpg': '🖼️',
            'jpeg': '🖼️',
            'png': '🖼️',
            'gif': '🖼️',
            'mp4': '🎥',
            'avi': '🎥',
            'py': '🐍',
            'java': '☕',
            'js': '📜',
            'html': '🌐',
            'css': '🎨'
        };
        return icons[ext] || '📄';
    }
}

// Export pour utilisation dans d'autres fichiers
if (typeof module !== 'undefined' && module.exports) {
    module.exports = DocumentClassifier;
}
